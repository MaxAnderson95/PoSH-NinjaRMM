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
        [Switch]$AllDevices,

        #Whether to force the query of live API data
        [Parameter(ParameterSetName='DeviceID',Position=1)]
        [Parameter(ParameterSetName='DeviceName',Position=1)]
        [Parameter(ParameterSetName='AllDevices',Position=1)]
        [Switch]$NoCache
    
    )

    Begin {
        
        Write-Verbose -Message "Parameter Set name being used is $($PSCmdlet.ParameterSetName)"
        Write-Debug "Parameter Set name being used is $($PSCmdlet.ParameterSetName)"
        Write-Debug "Provided Parameter values are"    
        Write-Debug "DeviceID: $DeviceID"
        Write-Debug "DeviceName: $DeviceName"
        Write-Debug "All Devices: $AllDevices"
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
            
            "DeviceID" {

                ForEach ($ID in $DeviceID) {
                    
                    If ($NoCache) {
                    
                        $Rest = Invoke-NinjaAPIRequest -HTTPVerb GET -Resource /v1/devices/$ID -NoCache
                    
                    }

                    Else {

                        $Rest = Invoke-NinjaAPIRequest -HTTPVerb GET -Resource /v1/devices/$ID
                        
                    }

                    $OutputArray += $Rest

                }

            }

            "DeviceName" {

                ForEach ($Name in $DeviceName) {

                    If ($NoCache) {
                    
                        $Rest = Invoke-NinjaAPIRequest -HTTPVerb GET -Resource /v1/devices -NoCache
                    
                    }

                    Else {

                        $Rest = Invoke-NinjaAPIRequest -HTTPVerb GET -Resource /v1/devices

                    }

                    $Rest = $Rest | Where-Object { $_.system_name -like "*$Name*" }
                    $OutputArray += $Rest

                }

            }

            "AllDevices" {

                If ($NoCache) {
                
                    $Rest = Invoke-NinjaAPIRequest -HTTPVerb GET -Resource /v1/devices -NoCache
                
                }

                Else {

                    $Rest = Invoke-NinjaAPIRequest -HTTPVerb GET -Resource /v1/devices
                    
                }

                $OutputArray += $Rest

            }
        
        }
    
    }

    End {
        
        Write-Output $OutputArray

    }

}