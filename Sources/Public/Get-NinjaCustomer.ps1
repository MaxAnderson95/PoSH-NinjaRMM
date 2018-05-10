Function Get-NinjaCustomer {

    <#

    .SYNOPSIS
        

    .DESCRIPTION
        

    .EXAMPLE
        

    #>

    [CmdletBinding(
        
        DefaultParameterSetName='AllCustomers',
        HelpUri = 'https://github.com/MaxAnderson95/PoSHNinjaRMM-Management'

    )]

    Param (
        
        #Returns a customer by ID
        [Parameter(
            
            ParameterSetName='CustomerID',    
            ValueFromPipeline=$True,
            ValueFromPipelineByPropertyName=$True, 
            Position=0
            
        )]
        [ValidateNotNullOrEmpty()]
        [Alias("ID")] 
        [Int[]]$CustomerID,

        #Returns a customer by name
        [Parameter(
            
            ParameterSetName='CustomerName',
            ValueFromPipeline=$True,
            ValueFromPipelineByPropertyName=$True, 
            Position=0
            
        )]
        [ValidateNotNullOrEmpty()]
        [Alias("Name")] 
        [String[]]$CustomerName,

        #Returns all customers
        [Parameter(ParameterSetName='AllCustomers',Position=0)]
        [Alias("All")] 
        [Switch]$AllCustomers,

        #Whether to force the query of live API data
        [Parameter(ParameterSetName='CustomerID',Position=1)]
        [Parameter(ParameterSetName='CustomerName',Position=1)]
        [Parameter(ParameterSetName='AllCustomers',Position=1)]
        [Switch]$NoCache

    )
    
    Begin {

        Write-Verbose -Message "Parameter Set name being used is $($PSCmdlet.ParameterSetName)"
        Write-Debug "Provided Parameter values are"    
        Write-Debug "CustomerID: $CustomerID"
        Write-Debug "CustomerName: $CustomerName"
        Write-Debug "All Customers: $AllCustomers"
        Write-Debug "NoCache: $NoCache"
        
        #Define the AccessKeyID and SecretAccessKeys
        Try {

            $Keys = Get-NinjaAPIKeys
            Write-Debug "Using Nija API Keys: "
            Write-Debug $Keys
        
        } 
        
        Catch {
            
            Break
        
        }

        #Create an empty output array
        $OutputArray = @()
        
    }

    Process {

        Switch ($PSCmdlet.ParameterSetName) {

            "CustomerID" {
                                
                ForEach ($ID in $CustomerID) {
                    
                    If ($NoCache) {
                    
                        $Rest = Invoke-NinjaAPIRequest -HTTPVerb GET -Resource "/v1/customers/$ID" -AccessKeyID $Keys.AccessKeyID -SecretAccessKey $Keys.SecretAccessKey -NoCache
                    
                    }

                    Else {

                        $Rest = Invoke-NinjaAPIRequest -HTTPVerb GET -Resource "/v1/customers/$ID" -AccessKeyID $Keys.AccessKeyID -SecretAccessKey $Keys.SecretAccessKey

                    }

                    $OutputArray += $Rest

                }

            }

            "CustomerName" {
                                
                ForEach ($Name in $CustomerName) {
                
                    If ($NoCache) {
                        
                        $Rest = Invoke-NinjaAPIRequest -HTTPVerb GET -Resource "/v1/customers" -AccessKeyID $Keys.AccessKeyID -SecretAccessKey $Keys.SecretAccessKey -NoCache
                    
                    }
                    
                    Else {

                        $Rest = Invoke-NinjaAPIRequest -HTTPVerb GET -Resource "/v1/customers" -AccessKeyID $Keys.AccessKeyID -SecretAccessKey $Keys.SecretAccessKey

                    }

                    $Rest = $Rest | Where-Object { $_.Name -like "*$Name*" }
                    $OutputArray += $Rest

                }
            
            }

            "AllCustomers" {
                                
                If ($NoCache) {
                
                    $Rest = Invoke-NinjaAPIRequest -HTTPVerb GET -Resource "/v1/customers" -AccessKeyID $Keys.AccessKeyID -SecretAccessKey $Keys.SecretAccessKey -NoCache
                
                }

                Else {

                    $Rest = Invoke-NinjaAPIRequest -HTTPVerb GET -Resource "/v1/customers" -AccessKeyID $Keys.AccessKeyID -SecretAccessKey $Keys.SecretAccessKey

                }

                $OutputArray += $Rest

            }

        }

    }

    End {
        
        Write-Output $OutputArray

    }

}