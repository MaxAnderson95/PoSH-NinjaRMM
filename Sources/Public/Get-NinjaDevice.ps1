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
            ValueFromPipelineByPropertyName=$True, 
            Position=0
            
        )]
        [ValidateNotNullOrEmpty()]
        [Alias("ID")] 
        [Int[]]$DeviceID,

        #Returns a device by name
        [Parameter(
            
            ParameterSetName='DeviceName',
            ValueFromPipelineByPropertyName=$True, 
            Position=0
            
        )]
        [ValidateNotNullOrEmpty()]
        [Alias("Name")] 
        [String[]]$DeviceName,

        #Returns all devices for a customer by customer ID
        [Parameter(

            ParameterSetName='CustomerID',
            ValueFromPipelineByPropertyName=$True,
            Position=0

        )]
        [String[]]$CustomerID,

        #Returns all devices for a customer by customer name
        [Parameter(

            ParameterSetName='CustomerName',
            ValueFromPipelineByPropertyName=$True,
            Position=0

        )]
        [String[]]$CustomerName,

        #Returns all devices
        [Parameter(ParameterSetName='AllDevices')]
        [Alias("All")] 
        [Switch]$AllDevices,

        #Whether to force the query of live API data
        [Parameter(ParameterSetName='DeviceID',Position=1)]
        [Parameter(ParameterSetName='DeviceName',Position=1)]
        [Parameter(ParameterSetName='CustomerID',Position=1)]
        [Parameter(ParameterSetName='AllDevices',Position=1)]
        [Switch]$NoCache,

        #Raw output
        [Parameter(ParameterSetName='DeviceID',Position=1)]
        [Parameter(ParameterSetName='DeviceName',Position=1)]
        [Parameter(ParameterSetName='CustomerID',Position=1)]
        [Parameter(ParameterSetName='AllDevices',Position=1)]
        [Switch]$RawOutput
    
    )

    Begin {

        #Create an empty output array
        $OutputArray = @()

    }
    
    #ForEach piped in object
    Process {
        
        Write-Verbose "Parameter Set name being used is $($PSCmdlet.ParameterSetName)"
        Write-Debug "Parameter Set name being used is $($PSCmdlet.ParameterSetName)"
        Write-Debug "Provided Parameter values are"    
        Write-Debug "DeviceID: $DeviceID"
        Write-Debug "DeviceName: $DeviceName"
        Write-Debug "CustomerID: $CustomerID"
        Write-Debug "All Devices: $AllDevices"
        Write-Debug "NoCache: $NoCache"

        #Based on which parameter set is being used, do the following
        Switch ($PSCmdlet.ParameterSetName) {
            
            "DeviceID" {

                Write-Debug "Switch selection is DeviceID"

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

                Write-Debug "Switch selection is DeviceName"

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

            "CustomerID" {

                Write-Debug "Switch selection is CustomerID"

                #Loop through each CustomerID
                ForEach ($ID in $CustomerID) {

                #Make the request and add NoCache if the switch is specified
                    
                    If ($NoCache) {

                        $Rest = Invoke-NinjaAPIRequest -HTTPVerb GET -Resource /v1/devices -NoCache

                    }

                    Else {

                        $Rest = Invoke-NinjaAPIRequest -HTTPVerb GET -Resource /v1/devices

                    }

                    #Since the API doesn't have the ability to requset data for a specific device by customer ID, this makes a standard request, and then uses Where-Object to filter the results.
                    $Rest = $Rest | Where-Object { $_.customer_id -eq $ID }
                    #Add the rest response to the output array
                    $OutputArray += $Rest

                }

            }

            "CustomerName" {

                Write-Debug "Switch selection is CustomerName"

                #Loop through each CustomerName
                ForEach ($Name in $CustomerName) {

                #Make the request and add NoCache if the switch is specified
                    
                    If ($NoCache) {

                        $Rest = Invoke-NinjaAPIRequest -HTTPVerb GET -Resource /v1/devices -NoCache

                    }

                    Else {

                        $Rest = Invoke-NinjaAPIRequest -HTTPVerb GET -Resource /v1/devices

                    }

                    #Since the API doesn't have the ability to requset data for a specific device by customer name, this makes a standard request, and then uses Where-Object to filter the results.
                    
                    <# Becuase the returned device object does not have a customer name property, only a customer ID property
                    we must get the customerID from the name using Get-NinjaCustomer, then filter by that ID.#>
                    
                    $ID = (Get-NinjaCustomer -CustomerName $Name).CustomerID
                    
                    $Rest = $Rest | Where-Object { $_.customer_id -eq $ID }
                    #Add the rest response to the output array
                    $OutputArray += $Rest

                }

            }


            "AllDevices" {

                Write-Debug "Switch selection is AllDevices"

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
        
        If ($RawOutput) {

            Write-Output $OutputArray

        } 
        
        Else {
        
            <#
            Reformat the raw output into a "cleaner looking" object. 
            The primary purpose of this is to rename the property names for the 
            purposes of pineline input into other functions
            #>

            #Create an empty aray
            $FormattedArray = @()

            ForEach ($Line in $OutputArray) {

                $Obj = [PSCustomObject] @{

                    "DeviceID"         = $Line.id
                    "DeviceType"       = $Line.type
                    "DeviceSubType"    = $Line.sub_type
                    "DeviceRole"       = $Line.role
                    "CustomerID"       = $Line.customer_id
                    "ParentDeviceID"   = $Line.parent_device_id
                    "DisplayName"      = $Line.display_name
                    "DNSName"          = $Line.dns_name
                    "SystemName"       = $Line.system_name
                    "NetBIOSName"      = $Line.netbios_name
                    "LastOnline"       = [DateTime]::ParseExact($Line.last_online, 'ddd, dd MMM yyyy H:mm:ss GMT', $null)
                    "LastUpdate"       = [DateTime]::ParseExact($Line.last_update, 'ddd, dd MMM yyyy H:mm:ss GMT', $null)
                    "IPAddresses"      = $Line.ip_addresses
                    "MACAddresses"     = $Line.mac_addresses
                    "PublicIPAddress"  = $Line.public_ip_addr
                    "NinjaURL"         = $Line.ninja_url
                    "RemoteControlURL" = $Line.remote_control_url
                    "LastLoggedInUser" = $Line.last_logged_in_user
                    "System"           = [PsCustomObject] @{
                        "Manufacturer"      = $Line.system.manufacturer
                        "Name"              = $Line.system.name
                        "Model"             = $Line.system.model
                        "DNSHostName"       = $Line.system.dns_host_name
                        "BIOSSerialNumber"  = $Line.system.bios_serial_number
                        "Domain"            = $Line.system.domain
                    }
                    "OS"               = [PsCustomObject] @{
                        "Manufacturer"      = $Line.os.manufacturer
                        "Name"              = $Line.os.name
                        "OSArchitecture"    = $Line.os.os_architecture
                        "LastBootTime"      = [DateTime]::ParseExact($Line.os.last_boot_time, 'ddd, dd MMM yyyy H:mm:ss GMT', $null)
                        "BuildNumber"       = $Line.os.build_number
                        "ReleaseID"         = $Line.os.releaseid
                    }
                    "Memory"           = [PsCustomObject] @{
                        "Capacity"          = $Line.memory.capacity
                    }
                    "Processor"        = [PsCustomObject] @{
                        "Architecture"      = $Line.processor.architecture
                        "CurrentClockSpeed" = $Line.processor.current_clock_speed
                        "MaxClockSpeed"     = $Line.processor.max_clock_speed
                        "Name"              = $Line.processor.name
                        "Cores"             = $Line.processor.num_cores
                        "LogicalCores"      = $Line.processor.num_logical_cores
                    }
                    "Disks"            = $(
                        
                        ForEach ($Disk in $Line.disks) {

                                [PsCustomObject] @{

                                    "Name"         = $Disk.name
                                    "Type"         = $Disk.type
                                    "FileSystem"   = $Disk.file_system
                                    "SerialNumber" = $Disk.serial_number
                                    "VolumeLabel"  = $Disk.volume_label
                                    "Capacity"     = $Disk.capacity
                                    "FreeSpace"    = $Disk.free_space

                                }

                            }

                        )

                    "Software"         = $(

                        ForEach ($Product in $Line.software) {

                            [PsCustomObject] @{

                                "Name"        = $Product.name
                                "Publisher"   = $Product.publisher
                                "Version"     = $Product.version
                                "InstallDate" = [DateTime]::ParseExact($Product.install_date, 'yyyyMMdd', $null)
                                "Size"        = $Product.size

                            }

                        }

                    )

                }
                
                $FormattedArray += $Obj

            }
            
            Write-Output $FormattedArray

        }

    }

}