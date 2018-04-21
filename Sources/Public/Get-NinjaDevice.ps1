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

    Param (
        
        #Returns a device by ID
        [Parameter(
            
            ParameterSetName='DeviceID',    
            ValueFromPipeline=$True,
            ValueFromPipelineByPropertyName=$True, 
            Position=0
            
        )]
        [ValidateNotNullOrEmpty()]
        [Alias("ID")] 
        [Int]$DeviceID,

        #Returns a device by name
        [Parameter(
            
            ParameterSetName='DeviceName',
            ValueFromPipeline=$True,
            ValueFromPipelineByPropertyName=$True, 
            Position=0
            
        )]
        [ValidateNotNullOrEmpty()]
        [Alias("Name")] 
        [String]$DeviceName,

        #Returns all devices
        [Parameter(ParameterSetName='AllDevices')]
        [Alias("All")] 
        [Switch]$AllDevices
    
    )

    Begin {
        
        Write-Verbose -Message "Parameter Set name being used is $($PSCmdlet.ParameterSetName)"
        Write-Debug "Provided Parameter values are"    
        Write-Debug "DeviceID: $DeviceID"
        Write-Debug "DeviceName: $DeviceName"
        Write-Debug "All Devices: $AllDevices"

        #Define the AccessKeyID and SecretAccessKeys
        Try {
            
            $Keys = Get-NinjaAPIKeys
            Write-Debug "Using Nija API Keys: "
            Write-Debug $Keys

        } 
        
        Catch {
            
            Throw $Error
        
        }
    
        Write-Warning -Message "This uses a List API and is rate limited to 10 requests per 10 minutes by Ninja"

    }
    
    Process {
        
        Switch ($PSCmdlet.ParameterSetName) {
            
            "DeviceID" {

                $Rest = Invoke-NinjaAPIRequest -HTTPVerb GET -Resource /v1/devices/$DeviceID -AccessKeyID $Keys.AccessKeyID -SecretAccessKey $Keys.SecretAccessKey
                            
            }

            "DeviceName" {

                $Rest = Invoke-NinjaAPIRequest -HTTPVerb GET -Resource /v1/devices -AccessKeyID $Keys.AccessKeyID -SecretAccessKey $Keys.SecretAccessKey
                $Rest = $Rest | Where-Object { $_.system_name -like "*$DeviceName*" }

            }

            "AllDevices" {

                $Rest = Invoke-NinjaAPIRequest -HTTPVerb GET -Resource /v1/devices -AccessKeyID $Keys.AccessKeyID -SecretAccessKey $Keys.SecretAccessKey
                            
            }
        
        }

        Write-Output $Rest
    
    }

    End {
        
    }

}