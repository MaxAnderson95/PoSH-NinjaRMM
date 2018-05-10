Function Get-NinjaDevice {

    <#

    .SYNOPSIS
        Gets a list of devices or a specific device in Ninja

    .DESCRIPTION
        Gets a list of devices or a speficic devices in Ninja, either by ID or Name.

    .PARAMETER AllDevices
        Requests all devices. This is the default parameter set

    .PARAMETER DeviceID
        Accepts one or multiple device id's to return

    .PARAMETER DeviceName
        Accepts one or multiple device names to return. This uses the "system_name" property of the device.
    
    .PARAMETER NoCache
        Requests live data from the API rather than utilizing any available cache

    .EXAMPLE
        PS C:> Get-NinjaDevice
        id                  : 1
        type                : AGENT
        sub_type            : AGENT_GENERAL
        role                : WINDOWS_WORKSTATION
        customer_id         : 1
        system_name         : SystemA

        id                  : 2
        type                : AGENT
        sub_type            : AGENT_GENERAL
        role                : WINDOWS_WORKSTATION
        customer_id         : 1
        system_name         : SystemB

        id                  : 3
        type                : AGENT
        sub_type            : AGENT_GENERAL
        role                : WINDOWS_WORKSTATION
        customer_id         : 2
        system_name         : SystemC

        .........

    .EXAMPLE
        PS C:> Get-NinjaDevice -AddDevices
        id                  : 1
        type                : AGENT
        sub_type            : AGENT_GENERAL
        role                : WINDOWS_WORKSTATION
        customer_id         : 1
        system_name         : SystemA

        id                  : 2
        type                : AGENT
        sub_type            : AGENT_GENERAL
        role                : WINDOWS_WORKSTATION
        customer_id         : 1
        system_name         : SystemB

        id                  : 3
        type                : AGENT
        sub_type            : AGENT_GENERAL
        role                : WINDOWS_WORKSTATION
        customer_id         : 2
        system_name         : SystemC

        .........

    .EXAMPLE
        PS C:> Get-NinjaDevice -Device ID 1,2
        id                  : 1
        type                : AGENT
        sub_type            : AGENT_GENERAL
        role                : WINDOWS_WORKSTATION
        customer_id         : 1
        system_name         : SystemA

        id                  : 2
        type                : AGENT
        sub_type            : AGENT_GENERAL
        role                : WINDOWS_WORKSTATION
        customer_id         : 1
        system_name         : SystemB

    .EXAMPLE
        PS C:> 1,2 | Get-NinjaDevice
        id                  : 1
        type                : AGENT
        sub_type            : AGENT_GENERAL
        role                : WINDOWS_WORKSTATION
        customer_id         : 1
        system_name         : SystemA

        id                  : 2
        type                : AGENT
        sub_type            : AGENT_GENERAL
        role                : WINDOWS_WORKSTATION
        customer_id         : 1
        system_name         : SystemB

    .EXAMPLE
        PS C:> Get-NinjaDevice -DeviceName "SystemA","SystemB"
        id                  : 1
        type                : AGENT
        sub_type            : AGENT_GENERAL
        role                : WINDOWS_WORKSTATION
        customer_id         : 1
        system_name         : SystemA

        id                  : 2
        type                : AGENT
        sub_type            : AGENT_GENERAL
        role                : WINDOWS_WORKSTATION
        customer_id         : 1
        system_name         : SystemB

    .EXAMPLE
        PS C:> "SystemA","SystemB" | Get-NinjaDevice
        id                  : 1
        type                : AGENT
        sub_type            : AGENT_GENERAL
        role                : WINDOWS_WORKSTATION
        customer_id         : 1
        system_name         : SystemA

        id                  : 2
        type                : AGENT
        sub_type            : AGENT_GENERAL
        role                : WINDOWS_WORKSTATION
        customer_id         : 1
        system_name         : SystemB

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

        #Create an empty output array
        $OutputArray = @()

    }
    
    #ForEach piped in object
    Process {
        
        #Based on which parameter set is being used, do the following
        Switch ($PSCmdlet.ParameterSetName) {
            
            "DeviceID" {

                #Loop through each DeviceID
                ForEach ($ID in $DeviceID) {
                
                #Make the request and add NoCache if the switch is specified

                    If ($NoCache) {
                    
                        $Rest = Invoke-NinjaAPIRequest -HTTPVerb GET -Resource /v1/devices/$ID -NoCache
                    
                    }

                    Else {

                        $Rest = Invoke-NinjaAPIRequest -HTTPVerb GET -Resource /v1/devices/$ID
                        
                    }

                    #Add the rest response to the output array
                    $OutputArray += $Rest

                }

            }

            "DeviceName" {

                #Loop through each DeviceName
                ForEach ($Name in $DeviceName) {

                #Make the request and add NoCache if the switch is specified
                
                    If ($NoCache) {
                    
                        $Rest = Invoke-NinjaAPIRequest -HTTPVerb GET -Resource /v1/devices -NoCache
                    
                    }

                    Else {

                        $Rest = Invoke-NinjaAPIRequest -HTTPVerb GET -Resource /v1/devices

                    }

                    #Since the API doesn't have the ability to requset data for a specific device by name, this makes a standard request, and then uses Where-Object to filter the results.
                    $Rest = $Rest | Where-Object { $_.system_name -like "*$Name*" }
                    #Add the rest response to the output array
                    $OutputArray += $Rest

                }

            }

            "AllDevices" {

            #Make the request and add NoCache if the switch is specified

                If ($NoCache) {
                
                    $Rest = Invoke-NinjaAPIRequest -HTTPVerb GET -Resource /v1/devices -NoCache
                
                }

                Else {

                    $Rest = Invoke-NinjaAPIRequest -HTTPVerb GET -Resource /v1/devices
                    
                }

                #Add the rest response to the output array
                $OutputArray += $Rest

            }
        
        }
    
    }

    End {
        
        #Output the OutputArray
        Write-Output $OutputArray

    }

}