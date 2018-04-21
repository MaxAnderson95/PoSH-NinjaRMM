Function Get-NinjaDevice {

    <#

    .SYNOPSIS
        

    .DESCRIPTION
        

    .EXAMPLE
        

    #>

    [CmdletBinding(
        
        DefaultParameterSetName='AllDevices',
        HelpUri = 'https://github.com/MaxAnderson95/PoSHNinjaRMM-Management'

    )]

    PARAM (
        
        #The Ninja Device ID
        [Parameter(
            
            ParameterSetName='DeviceID',    
            ValueFromPipeline=$True,
            ValueFromPipelineByPropertyName=$True, 
            Position=0
            
        )]
        [ValidateNotNullOrEmpty()]
        [Alias("ID")] 
        [Int]$DeviceID,

        #Returns the device from a list by name
        [Parameter(
            
            ParameterSetName='DeviceName',
            ValueFromPipeline=$True,
            ValueFromPipelineByPropertyName=$True, 
            Position=0
            
        )]
        [ValidateNotNullOrEmpty()]
        [Alias("Name")] 
        [String]$DeviceName,

        #Whether to return all devices
        [Parameter(ParameterSetName='AllDevices')]
        [Alias("All")] 
        [switch]$AllDevices
    
    )

    Begin {
        
        #Define the AccessKeyID and SecretAccessKeys
        Try {
            
            $Keys = Get-NinjaAPIKeys
        
        } 
        
        Catch {
            
            Throw $Error
        
        }
        
        #Determine if the input is CustomerID or no Customer entered (looking for list of all)
        If ($DeviceID) {
            
            $Choice = "DeviceID"
        
        }
        
        Else {
            
            $Choice = "None"
        
        }
    
    }
    

    Process {
        
        Switch ($Choice) {
            
            "DeviceID" {
                
                $Header = New-NinjaRequestHeader -HTTPVerb GET -Resource /v1/devices/$DeviceID -AccessKeyID $Keys.AccessKeyID -SecretAccessKey $Keys.SecretAccessKey

                $Rest = Invoke-RestMethod -Method GET -Uri "https://api.ninjarmm.com/v1/devices/$DeviceID" -Headers $Header
            
            }

            "None" {

                $Header = New-NinjaRequestHeader -HTTPVerb GET -Resource /v1/devices -AccessKeyID $Keys.AccessKeyID -SecretAccessKey $Keys.SecretAccessKey

                $Rest = Invoke-RestMethod -Method GET -Uri "https://api.ninjarmm.com/v1/devices" -Headers $Header
            
            }
        
        }

        Write-Output $Rest
    
    }

    End {
        
    }

}