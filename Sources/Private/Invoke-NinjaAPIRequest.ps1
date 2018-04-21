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

        [String]$BaseNinjaAPIURI = "https://api.ninjarmm.com"

    )

    $Header = New-NinjaRequestHeader -HTTPVerb $HTTPVerb -Resource $Resource -AccessKeyID $AccessKeyID -SecretAccessKey $SecretAccessKey
    
    Try {
    
        $Rest = Invoke-RestMethod -Method $HTTPVerb -Uri ($BaseNinjaAPIURI + $Resource) -Headers $Header
    
    }

    Catch {

        Switch ($_.ErrorDetails.Message | ConvertFrom-JSON | Select-Object -ExpandProperty error_code) {
            
            2 {

                Throw "Request header missing or malformed."

            }

            5 {

                Throw "Unable to authenticate to the API. There is an issue with the validity of the API keys."

            }
            
            6 {

                Throw "Too many requests. List API requests are rate limited to 10 requests per 10 minutes by Ninja."

            }

            Default {

                Throw $_

            }

        }

    }
    
    Write-Output $Rest

}