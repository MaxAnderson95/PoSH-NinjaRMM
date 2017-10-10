Function Get-NinjaDevice {

    <#

    .SYNOPSIS
        

    .DESCRIPTION
        

    .EXAMPLE
        

    #>

    PARAM
    (
        [Int]$DeviceID
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
        If ($DeviceID) 
        {
            $Choice = "DeviceID"
        }
        else 
        {
            $Choice = "None"
        }
    }
    

    Process
    {
        Switch ($Choice) 
        {
            "DeviceID" 
            {
                $Header = New-NinjaRequestHeader -HTTPVerb GET -Resource /v1/devices/$DeviceID -AccessKeyID $Keys.AccessKeyID -SecretAccessKey $Keys.SecretAccessKey

                $Rest = Invoke-RestMethod -Method GET -Uri "https://api.ninjarmm.com/v1/devices/$DeviceID" -Headers $Header
            }

            "None" 
            {
                $Header = New-NinjaRequestHeader -HTTPVerb GET -Resource /v1/devices -AccessKeyID $Keys.AccessKeyID -SecretAccessKey $Keys.SecretAccessKey

                $Rest = Invoke-RestMethod -Method GET -Uri "https://api.ninjarmm.com/v1/devices" -Headers $Header
            }
        }

        Write-Output $Rest
    }

    End
    {

    }

}