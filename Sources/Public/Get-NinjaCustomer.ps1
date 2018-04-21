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
        [Parameter(ParameterSetName='AllCustomers')]
        [Alias("All")] 
        [Switch]$AllCustomers

    )
    
    Begin {

        Write-Verbose -Message "Parameter Set name being used is $($PSCmdlet.ParameterSetName)"
        Write-Debug "Provided Parameter values are"    
        Write-Debug "CustomerID: $CustomerID"
        Write-Debug "CustomerName: $CustomerName"
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

        #Create an empty output array
        $OutputArray = @()

        Write-Warning -Message "This uses a List API and is rate limited to 10 requests per 10 minutes by Ninja"
        
    }

    Process {

        Switch ($PSCmdlet.ParameterSetName) {

            "CustomerID" {
                                
                ForEach ($ID in $CustomerID) {
                    
                    $Rest = Invoke-NinjaAPIRequest -HTTPVerb GET -Resource "/v1/customers/$ID" -AccessKeyID $Keys.AccessKeyID -SecretAccessKey $Keys.SecretAccessKey
                    $OutputArray += $Rest

                }

            }

            "CustomerName" {
                                
                ForEach ($ID in $CustomerName) {
                
                    $Rest = Invoke-NinjaAPIRequest -HTTPVerb GET -Resource "/v1/customers" -AccessKeyID $Keys.AccessKeyID -SecretAccessKey $Keys.SecretAccessKey
                    $Rest = $Rest | Where-Object { $_.Name -like "*$ID*" }
                    $OutputArray += $Rest

                }
            
            }

            "AllCustomers" {
                                
                $Rest = Invoke-NinjaAPIRequest -HTTPVerb GET -Resource "/v1/customers" -AccessKeyID $Keys.AccessKeyID -SecretAccessKey $Keys.SecretAccessKey
                $OutputArray += $Rest

            }

        }

    }

    End {
        
        Write-Output $OutputArray

    }

}