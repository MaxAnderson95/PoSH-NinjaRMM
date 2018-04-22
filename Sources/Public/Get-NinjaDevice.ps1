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
        [Int[]]$DeviceID,

        #Returns a device by name
        [Parameter(
            
            ParameterSetName='DeviceName',
            ValueFromPipeline=$True,
            ValueFromPipelineByPropertyName=$True, 
            Position=0
            
        )]
        [ValidateNotNullOrEmpty()]
        [Alias("Name")] 
        [String[]]$DeviceName,

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
    
        #Create an empty output array
        $OutputArray = @()

    }
    
    Process {
        
        Switch ($PSCmdlet.ParameterSetName) {
            
            "DeviceID" {

                ForEach ($ID in $DeviceID) {
                
                    $Rest = Invoke-NinjaAPIRequest -HTTPVerb GET -Resource /v1/devices/$ID -AccessKeyID $Keys.AccessKeyID -SecretAccessKey $Keys.SecretAccessKey
                    $OutputArray += $Rest

                }

            }

            "DeviceName" {

                ForEach ($Name in $DeviceName) {

                    $Rest = Invoke-NinjaAPIRequest -HTTPVerb GET -Resource /v1/devices -AccessKeyID $Keys.AccessKeyID -SecretAccessKey $Keys.SecretAccessKey
                    $Rest = $Rest | Where-Object { $_.system_name -like "*$Name*" }
                    $OutputArray += $Rest

                }
            }

            "AllDevices" {

                $Rest = Invoke-NinjaAPIRequest -HTTPVerb GET -Resource /v1/devices -AccessKeyID $Keys.AccessKeyID -SecretAccessKey $Keys.SecretAccessKey
                $OutputArray += $Rest

            }
        
        }
    
    }

    End {
        
        Write-Output $OutputArray

    }

}