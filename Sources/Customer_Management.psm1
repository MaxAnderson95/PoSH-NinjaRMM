Function Get-NinjaCustomer {

    <#

    .SYNOPSIS
        

    .DESCRIPTION
        

    .EXAMPLE
        

    #>

    PARAM
    (
        [Parameter]
        [Int]$CustomerID,

        [Parameter]
        [String]$CustomerName
    )

    Begin
    {
        #Define the AccessKeyID and SecretAccessKeys
        Try 
        {
            $Keys = Get-NinjaAPIKeys
        } 
        
        Catch 
        {
            Throw $Error
        }
        
        #Determine if the input is CustomerID or no Customer entered (looking for list of all)
        If ($CustomerID) 
        {
            $Choice = "CustomerID"
        }

        If ($CustomerName)
        {
            $Choice = "CustomerName"
        }
        
        else 
        {
            $Choice = "None"
        }
    }
    

    Process
    {
        Switch ($Choice) {
            "CustomerID" 
            {
                $Header = New-NinjaRequestHeader -HTTPVerb GET -Resource /v1/customers/$CustomerID -AccessKeyID $Keys.AccessKeyID -SecretAccessKey $Keys.SecretAccessKey

                $Rest = Invoke-RestMethod -Method GET -Uri "https://api.ninjarmm.com/v1/customers/$CustomerID" -Headers $Header
            }

            "CustomerName"
            {
                
            }

            "None" 
            {
                $Header = New-NinjaRequestHeader -HTTPVerb GET -Resource /v1/customers -AccessKeyID $Keys.AccessKeyID -SecretAccessKey $Keys.SecretAccessKey

                $Rest = Invoke-RestMethod -Method GET -Uri "https://api.ninjarmm.com/v1/customers" -Headers $Header
            }

        }

        Write-Output $Rest
    }

    End
    {

    }

}