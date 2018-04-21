Function Get-NinjaCustomer {

    <#

    .SYNOPSIS
        

    .DESCRIPTION
        

    .EXAMPLE
        

    #>

    [CmdletBinding(
        
        DefaultParameterSetName='AllCustomers',
        PositionalBinding=$false,
        HelpUri = 'https://github.com/MaxAnderson95/PoSHNinjaRMM-Management'

    )]

    Param (
        
        #The Ninja Customer ID
        [Parameter(
            
            ParameterSetName='CustomerID',    
            ValueFromPipeline=$True,
            ValueFromPipelineByPropertyName=$True, 
            Position=0
            
        )]
        [ValidateNotNullOrEmpty()]
        [Alias("ID")] 
        [Int]$CustomerID,

        #Returns the customer from a list that includes this PARAM
        [Parameter(
            
            ParameterSetName='CustomerName',
            ValueFromPipeline=$True,
            ValueFromPipelineByPropertyName=$True, 
            Position=0
            
        )]
        [ValidateNotNullOrEmpty()]
        [Alias("Name")] 
        [String]$CustomerName,

        #Whether to return all customers
        [Parameter(ParameterSetName='AllCustomers')]
        [Alias("All")] 
        [switch]$AllCustomers

    )
    
    Begin {

        Write-Verbose -Message "Parameter Set name being used is $($PSCmdlet.ParameterSetName)"
        Write-Debug "Provided Parameter values are"    
        Write-Debug "CustomerID:$CustomerID"
        Write-Debug "CustomerName:$CustomerName"
        Write-Debug "All Customers: $AllCustomers"
        
        #Define the AccessKeyID and SecretAccessKeys
        Try {

            $Keys = Get-NinjaAPIKeys
            Write-Debug "Using Nija API Keys: "
            Write-Debug $Keys
        
        } 
        
        Catch {
            
            Throw $Error
        
        }
        
    }

    Process {

        Switch ($PSCmdlet.ParameterSetName) {

            "CustomerID" {
                
                Write-Warning -Message "This uses a List API and is rate limited to 10 requests per 10 minutes by Ninja"
                
                $Header = New-NinjaRequestHeader -HTTPVerb GET -Resource /v1/customers/$CustomerID -AccessKeyID $Keys.AccessKeyID -SecretAccessKey $Keys.SecretAccessKey

                Try {

                    $Rest = Invoke-RestMethod -Method GET -Uri "https://api.ninjarmm.com/v1/customers/$CustomerID" -Headers $Header
            
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
            }

            "CustomerName" {
                
                Write-Warning -Message "This uses a List API and is rate limited to 10 requests per 10 minutes by Ninja"
                
                $Header = New-NinjaRequestHeader -HTTPVerb GET -Resource /v1/customers -AccessKeyID $Keys.AccessKeyID -SecretAccessKey $Keys.SecretAccessKey

                Try {
                
                    $Rest = Invoke-RestMethod -Method GET -Uri "https://api.ninjarmm.com/v1/customers" -Headers $Header
                    $Rest = $Rest | Where-Object { $_.name -like "*$CustomerName*" }
                
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
            
            }

            "AllCustomers" {
                
                Write-Warning -Message "This uses a List API and is rate limited to 10 requests per 10 minutes by Ninja"
                
                $Header = New-NinjaRequestHeader -HTTPVerb GET -Resource /v1/customers -AccessKeyID $Keys.AccessKeyID -SecretAccessKey $Keys.SecretAccessKey

                Try {
                
                    $Rest = Invoke-RestMethod -Method GET -Uri "https://api.ninjarmm.com/v1/customers" -Headers $Header

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

            }

        }

        Write-Output $Rest

    }

    End {
        
    }

}