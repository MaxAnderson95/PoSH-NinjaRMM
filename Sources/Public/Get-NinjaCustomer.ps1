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
                
                $Rest = Invoke-NinjaAPIRequest -HTTPVerb GET -Resource "/v1/customers/$CustomerID" -AccessKeyID $Keys.AccessKeyID -SecretAccessKey $Keys.SecretAccessKey

            }

            "CustomerName" {
                
                Write-Warning -Message "This uses a List API and is rate limited to 10 requests per 10 minutes by Ninja"
                
                $Rest = Invoke-NinjaAPIRequest -HTTPVerb GET -Resource "/v1/customers" -AccessKeyID $Keys.AccessKeyID -SecretAccessKey $Keys.SecretAccessKey
                $Rest = $Rest | Where-Object { $_.Name -like "*$CustomerName*" }
            
            }

            "AllCustomers" {
                
                Write-Warning -Message "This uses a List API and is rate limited to 10 requests per 10 minutes by Ninja"
                
                $Rest = Invoke-NinjaAPIRequest -HTTPVerb GET -Resource "/v1/customers" -AccessKeyID $Keys.AccessKeyID -SecretAccessKey $Keys.SecretAccessKey

            }

        }

        Write-Output $Rest

    }

    End {
        
    }

}