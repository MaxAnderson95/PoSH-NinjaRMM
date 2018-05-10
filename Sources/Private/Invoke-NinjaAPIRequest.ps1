Function Invoke-NinjaAPIRequest {

    <#

    .SYNOPSIS
        Makes a request to the NinjaAPI

    .DESCRIPTION
        This function acts as the function that makes the call to the API. It accepts the HTTPVerb,
        Resource within the API, and whether or not caching is requested. It then gathers the API keys,
        makes the call to the API, deals with caching, and then returns the response object. It also deals
        with any errors that may arrise from the API call.

    .PARAMETER HTTPVerb
        The REST method that will be used in the the API call. Currently v0.1.2 of the API only accepts GET
        requests for the customers and devices resources, and GET and DELETE for the alerts resources. Becuase
        this is an internal function, there is not parameter validation.

    .PARAMETER Resource
        The API resorce that will be used in the API call. Currently v0.1.2 of the API only contains a resource
        for customers, devices, and alerts. The syntax expected is "/v1/RESOURCENAME". Consult the API documentation
        for more information.
        
    .PARAMETER NoCache
        A switch that instructs the function to not use any available cache, and to always request live data from
        the API.

    .PARAMETER BaseNinjaAPIURI
        The URI to the API enpoint. It has a default value of "https://api.ninjarmm.com". As of now this is the only 
        available endpoint that the API uses.
    
    .EXAMPLE
        PS C:> Invoke-NinjaAPIRequest -HTTPVerb "GET" -Resource "/v1/customers"

    .EXAMPLE
        PS C:> Invoke-NinjaAPIRequest -HTTPVerb "GET" -Resource "/v1/devices/123"

    .EXAMPLE
        PS C:> Invoke-NinjaAPIRequest -HTTPVerb "GET" -Resource "/v1/alerts" -NoCache

    #>

    [CmdletBinding()]

    Param (

        [String]$HTTPVerb,

        [String]$Resource,

        [Switch]$NoCache,

        [String]$BaseNinjaAPIURI = "https://api.ninjarmm.com"

    )

    #Get the API Keys
    Try {
        
        $Key = Get-NinjaAPIKeys
        Write-Debug "Using Nija API Keys: "
        Write-Debug $Key
        Write-Verbose "Using Nija API Keys: "
        Write-Verbose $Key

    } 
    
    #If there are any errors gathering the API Keys, the "Get-NinjaAPIKeys" cmdlet will output an error, and the catch block will stop the execution of the function.
    Catch {
        
        Break    
            
    }
    
    #Caching Variables
        $CacheTimeout = 10 #In Minutes
        #Since a file name cannot contain a /, this replaces the slashes with hyphens, then removes the first slash, and adds .xml to the end.
        $TranslatedCacheFileName = $Resource.replace("/","-").TrimStart("-") + ".xml"
        #Specifies the path to the cache file path.
        $CacheFilePath = "$PSScriptRoot\..\..\API_Cache\$TranslatedCacheFileName"

    
    $CacheFile = Get-ChildItem -Path $CacheFilePath -ErrorAction SilentlyContinue

    #If a cache file is found
    If ($CacheFile) {

        $CacheFileExists = $True
        
        #If the cache file is within the timeout period
        If ($CacheFile | Where-Object { $_.LastWriteTime -gt (Get-Date).AddMinutes(-$CacheTimeout) }) {

            $CacheFileStale = $False

        }

        Else { $CacheFileStale = $True }

    }

    Else { $CacheFileExists = $False }

    Write-Debug "Cache File Path If It Exists: $CacheFilePath"
    Write-Debug "`$CacheFileExists: $CacheFileExists"
    Write-Debug "`$CacheFileStale: $CacheFileStale"

    #If the Cache file doesn't exist OR it exists but it's stale OR if NoCache is specified
    If ($CacheFileExists -eq $False -or ($CacheFileExists -eq $True -and $CacheFileStale -eq $True) -or $NoCache -eq $True) {
    
        #If the Cache is stale
        If ($CacheFileStale -eq $True) {

            Write-Debug "Cache is stale. Force removing cache file for $Resource"
            Write-Verbose "Cache is stale. Force removing cache file for $Resource"
            Remove-Item -Path $CacheFilePath -Force -ErrorAction SilentlyContinue

        }
        
        #Generate a request header using the verb, resource and keys
        $Header = New-NinjaRequestHeader -HTTPVerb $HTTPVerb -Resource $Resource -AccessKeyID $Key.AccessKeyID -SecretAccessKey $Key.SecretAccessKey
        
        Try {
        
            #Call out to the API
            $Rest = Invoke-RestMethod -Method $HTTPVerb -Uri ($BaseNinjaAPIURI + $Resource) -Headers $Header
        
        }

        #If there are any errors with the API call
        Catch {

            #Takes the error message, converts it from JSON format, and selects the error property and makes a determination based on the error message
            Switch ($_.ErrorDetails.Message | ConvertFrom-JSON | Select-Object -ExpandProperty error) {
                
                "invalid_header" {

                    Throw "The request header was syntacticalyl incorrect or malformed."

                }

                "missing_header" {

                    Throw "The header is missing in the request."

                }
                
                "skewed_time" {

                    Throw "The system time is too far from current time."

                }

                "not_authenticated" {

                    Throw "Invalid API keys or the signature is not valid."

                }

                "rate_limit_exceeded" {

                    Throw "Too many requests. List API requests are rate limited to 10 requests per 10 minutes by Ninja."
                    
                }

                "too_many_requests" {

                    Throw "Too many requests. List API requests are rate limited to 10 requests per 10 minutes by Ninja."

                }

                "invalid_id" {

                    Throw "Requested entity does not exist."
                    
                }

                Default {

                    Throw "An unhandeled exception occured."
                    Throw $Error

                }

            }

        }

        Write-Warning -Message "This uses a List API and is rate limited to 10 requests per 10 minutes by Ninja"

        #Cache the data
        Write-Debug "Caching the data for $Resource to $CacheFilePath"
        Write-Verbose "Caching the data for $Resource to $CacheFilePath"
        #Take the results of the API call and cache them to an XML file in the cache path
        $Rest | Export-Clixml -Path $CacheFilePath

    }

    #If the cache file exists and it's not stale and NoCache is not specified
    If ($CacheFileExists -eq $True -and $CacheFileStale -eq $False -and $NoCache -eq $False) {

        Write-Debug "Utilizing Cached Version of API Data"
        Write-Verbose "Utilizing Cached Version of API Data"
        Write-Warning -Message "The data presented is cached and may be up to $CacheTimeout minutes old. Use the -NoCache switch to request live data from the API."

        #Import the cached version of the data
        $Rest = Import-Clixml -Path $CacheFilePath

    }
    
    #Output either the live version or the cached version
    Write-Output $Rest    

}