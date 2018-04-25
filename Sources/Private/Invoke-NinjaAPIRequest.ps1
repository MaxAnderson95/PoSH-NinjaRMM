Function Invoke-NinjaAPIRequest {

    <#

    .SYNOPSIS
        

    .DESCRIPTION
        

    .EXAMPLE
        

    #>

    [CmdletBinding()]

    Param (

        [String]$HTTPVerb,

        [String]$Resource,

        [String]$AccessKeyID,

        [String]$SecretAccessKey,

        [Switch]$NoCache,

        [String]$BaseNinjaAPIURI = "https://api.ninjarmm.com"

    )

    #Caching Variables
    $CacheTimeout = 10 #In Minutes
    $TranslatedCacheFileName = $Resource.replace("/","-").TrimStart("-") + ".xml"
    $CacheFilePath = "$PSScriptRoot\..\..\API_Cache\$TranslatedCacheFileName"

    #Check if Cache File Exists and is within the Cache Timeout Period (Check if it's still valid)
    $CacheFile = Get-ChildItem -Path $CacheFilePath -ErrorAction SilentlyContinue

    If ($CacheFile) {

        $CacheFileExists = $True
        
        If ($CacheFile | Where-Object { $_.LastWriteTime -gt (Get-Date).AddMinutes(-$CacheTimeout) }) {

            $CacheFileStale = $False

        }

        Else { $CacheFileStale = $True }

    }

    Else { $CacheFileExists = $False }

    Write-Debug "Cache File Path If It Exists: $CacheFilePath"
    Write-Debug "`$CacheFileExists: $CacheFileExists"
    Write-Debug "`$CacheFileStale: $CacheFileStale"

    If ($CacheFileExists -eq $False -or ($CacheFileExists -eq $True -and $CacheFileStale -eq $True) -or $NoCache -eq $True) {
    
        If ($CacheFileStale -eq $True) {

            Write-Debug "Cache is stale. Force removing cache file for $Resource"
            Write-Verbose "Cache is stale. Force removing cache file for $Resource"
            Remove-Item -Path $CacheFilePath -Force -ErrorAction SilentlyContinue

        }
        
        Write-Warning -Message "This uses a List API and is rate limited to 10 requests per 10 minutes by Ninja"
        
        $Header = New-NinjaRequestHeader -HTTPVerb $HTTPVerb -Resource $Resource -AccessKeyID $AccessKeyID -SecretAccessKey $SecretAccessKey
        
        Try {
        
            $Rest = Invoke-RestMethod -Method $HTTPVerb -Uri ($BaseNinjaAPIURI + $Resource) -Headers $Header
        
        }

        Catch {

            Switch ($_.ErrorDetails.Message | ConvertFrom-JSON | Select-Object -ExpandProperty error) {
                
                "too_many_requests" {

                    Throw "Too many requests. List API requests are rate limited to 10 requests per 10 minutes by Ninja."

                }

                "invalid_id" {

                    Throw "Requested entity does not exist."
                    
                }

                Default {

                    Throw $_

                }

            }

        }

        #Cache the data
        Write-Debug "Caching the data for $Resource to $CacheFilePath"
        Write-Verbose "Caching the data for $Resource to $CacheFilePath"
        $Rest | Export-Clixml -Path $CacheFilePath

    }

    If ($CacheFileExists -eq $True -and $CacheFileStale -eq $False -and $NoCache -eq $False) {

        Write-Debug "Utilizing Cached Version of API Data"
        Write-Verbose "Utilizing Cached Version of API Data"
        Write-Warning -Message "The data presented is cached and may be up to $CacheTimeout minutes old. Use the -NoCache switch to request live data from the API."

        $Rest = Import-Clixml -Path $CacheFilePath

    }
    
    Write-Output $Rest    

}