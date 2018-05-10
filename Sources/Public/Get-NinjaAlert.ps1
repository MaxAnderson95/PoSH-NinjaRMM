Function Get-NinjaAlert {

    <#

    .SYNOPSIS
        Gets a list of alerts or alerts after a specific alert

    .DESCRIPTION
        Gets a list of alerts or alerts that occured after a specific alert based on that alert's ID

    .PARAMETER AllAlerts
        Requests all alerts. This is the default parameter set

    .PARAMETER DeviceName
        Requests alerts for a specific device by name
    
    .PARAMETER DeviceID
        Requests alerts for a specific device by ID

    .PARAMETER CustomerName
        Requests alerts for a specific customer by name
    
    .PARAMETER CustomerID
        Requests alerts for a specific customer by ID

    .PARAMETER SinceAlertID
        Requests alerts that have occurded since (after) another specific alert by ID
    
    .PARAMETER NoCache
        Requests live data from the API rather than utilizing any available cache
    
    .EXAMPLE
        PS C:> Get-NinjaAlert
        id           : 1
        type         : CONDITION
        status       : TRIGGERED
        message      : System has not rebooted for more than 60days. Last reboot time: '2016-12-02 05:03:28'
        device       : @{id=10; system_name="DeviceJ" }

        id           : 2
        type         : CONDITION
        status       : TRIGGERED
        message      : System has not rebooted for more than 60days. Last reboot time: '2016-12-02 05:03:28'
        device       : @{id=11; system_name="DeviceK" }

        id           : 3
        type         : CONDITION
        status       : TRIGGERED
        message      : System has not rebooted for more than 60days. Last reboot time: '2016-12-02 05:03:28'
        device       : @{id=12; system_name="DeviceL" }

    .EXAMPLE
        PS C:> Get-NinjaAlert -AllAlerts
        id           : 1
        type         : CONDITION
        status       : TRIGGERED
        message      : System has not rebooted for more than 60days. Last reboot time: '2016-12-02 05:03:28'
        device       : @{id=10; system_name="DeviceJ" }

        id           : 2
        type         : CONDITION
        status       : TRIGGERED
        message      : System has not rebooted for more than 60days. Last reboot time: '2016-12-02 05:03:28'
        device       : @{id=11; system_name="DeviceK" }

        id           : 3
        type         : CONDITION
        status       : TRIGGERED
        message      : System has not rebooted for more than 60days. Last reboot time: '2016-12-02 05:03:28'
        device       : @{id=12; system_name="DeviceL" }

    .EXAMPLE
        PS C:> Get-NinjaAlert -DeviceName "DeviceJ","DeviceK"
        id           : 1
        type         : CONDITION
        status       : TRIGGERED
        message      : System has not rebooted for more than 60days. Last reboot time: '2016-12-02 05:03:28'
        device       : @{id=10; system_name="DeviceJ" }

        id           : 2
        type         : CONDITION
        status       : TRIGGERED
        message      : System has not rebooted for more than 60days. Last reboot time: '2016-12-02 05:03:28'
        device       : @{id=11; system_name="DeviceK" }

    .EXAMPLE
        PS C:> "DeviceJ","DeviceK" | Get-NinjaAlert
        id           : 1
        type         : CONDITION
        status       : TRIGGERED
        message      : System has not rebooted for more than 60days. Last reboot time: '2016-12-02 05:03:28'
        device       : @{id=10; system_name="DeviceJ" }

        id           : 2
        type         : CONDITION
        status       : TRIGGERED
        message      : System has not rebooted for more than 60days. Last reboot time: '2016-12-02 05:03:28'
        device       : @{id=11; system_name="DeviceK" }

    .EXAMPLE
        PS C:> Get-NinjaAlert -DeviceID 10,11
        id           : 1
        type         : CONDITION
        status       : TRIGGERED
        message      : System has not rebooted for more than 60days. Last reboot time: '2016-12-02 05:03:28'
        device       : @{id=10; system_name="DeviceJ" }

        id           : 2
        type         : CONDITION
        status       : TRIGGERED
        message      : System has not rebooted for more than 60days. Last reboot time: '2016-12-02 05:03:28'
        device       : @{id=11; system_name="DeviceK" }

    .EXAMPLE
        PS C:> 10,11 | Get-NinjaAlert
        id           : 1
        type         : CONDITION
        status       : TRIGGERED
        message      : System has not rebooted for more than 60days. Last reboot time: '2016-12-02 05:03:28'
        device       : @{id=10; system_name="DeviceJ" }

        id           : 2
        type         : CONDITION
        status       : TRIGGERED
        message      : System has not rebooted for more than 60days. Last reboot time: '2016-12-02 05:03:28'
        device       : @{id=11; system_name="DeviceK" }

    .EXAMPLE
        PS C:> Get-NinjaAlert -CustomerName "Painting Company", "Travel Company"
        id           : 1
        type         : CONDITION
        status       : TRIGGERED
        message      : System has not rebooted for more than 60days. Last reboot time: '2016-12-02 05:03:28'
        device       : @{id=10; system_name="DeviceJ" }

        id           : 2
        type         : CONDITION
        status       : TRIGGERED
        message      : System has not rebooted for more than 60days. Last reboot time: '2016-12-02 05:03:28'
        device       : @{id=11; system_name="DeviceK" }

    .EXAMPLE
        PS C:> "Painting Company", "Travel Company" | Get-NinjaAlert
        id           : 1
        type         : CONDITION
        status       : TRIGGERED
        message      : System has not rebooted for more than 60days. Last reboot time: '2016-12-02 05:03:28'
        device       : @{id=10; system_name="DeviceJ" }

        id           : 2
        type         : CONDITION
        status       : TRIGGERED
        message      : System has not rebooted for more than 60days. Last reboot time: '2016-12-02 05:03:28'
        device       : @{id=11; system_name="DeviceK" }

    .EXAMPLE
        PS C:> Get-NinjaAlert -CustomerID 1,2
        id           : 456
        type         : CONDITION
        status       : TRIGGERED
        message      : System has not rebooted for more than 60days. Last reboot time: '2016-12-02 05:03:28'
        device       : @{id=10; system_name="DeviceJ" }

        id           : 457
        type         : CONDITION
        status       : TRIGGERED
        message      : System has not rebooted for more than 60days. Last reboot time: '2016-12-02 05:03:28'
        device       : @{id=11; system_name="DeviceK" }

    .EXAMPLE
        PS C:> 1,2 | Get-NinjaAlert
        id           : 456
        type         : CONDITION
        status       : TRIGGERED
        message      : System has not rebooted for more than 60days. Last reboot time: '2016-12-02 05:03:28'
        device       : @{id=10; system_name="DeviceJ" }

        id           : 457
        type         : CONDITION
        status       : TRIGGERED
        message      : System has not rebooted for more than 60days. Last reboot time: '2016-12-02 05:03:28'
        device       : @{id=11; system_name="DeviceK" }

    .EXAMPLE
        PS C:> Get-NinjaAlert -SinceAlertID 3
        id           : 2
        type         : CONDITION
        status       : TRIGGERED
        message      : System has not rebooted for more than 60days. Last reboot time: '2016-12-02 05:03:28'
        device       : @{id=10; system_name="DeviceJ" }

        id           : 1
        type         : CONDITION
        status       : TRIGGERED
        message      : System has not rebooted for more than 60days. Last reboot time: '2016-12-02 05:03:28'
        device       : @{id=11; system_name="DeviceK" }

    #>

    [CmdletBinding(

        DefaultParameterSetName = 'AllAlerts',
        HelpUri = 'https://github.com/MaxAnderson95/PoSHNinjaRMM-Management'

    )]

    Param (

        #Return all alerts for a given DeviceName
        [Parameter(

            ParameterSetName='DeviceName',
            ValueFromPipeline=$True,
            ValueFromPipelineByPropertyName=$True,
            Position=0

        )]
        [Alias("Device","Name")]
        [String[]]$DeviceName,
        
        #Return all alerts for a given DeviceID
        [Parameter(

            ParameterSetName='DeviceID',
            ValueFromPipeline=$True,
            ValueFromPipelineByPropertyName=$True,
            Position=0

        )]
        [Alias("ID")]
        [Int[]]$DeviceID,

        #Return all alerts for a given CustomerName
        [Parameter(

            ParameterSetName='CustomerName',
            ValueFromPipeline=$True,
            ValueFromPipelineByPropertyName=$True,
            Position=0

        )]
        [Alias("Customer")]
        [String[]]$CustomerName,

        #Return all alerts for a given CustomerID
        [Parameter(

            ParameterSetName='CustomerID',
            ValueFromPipeline=$True,
            ValueFromPipelineByPropertyName=$True,
            Position=0

        )]
        [String[]]$CustomerID,

        #Return all alerts since specific alert ID
        [Parameter(
            
            ParameterSetName='SinceAlert',
            ValueFromPipeline=$True,
            ValueFromPipelineByPropertyName=$True, 
            Position=0
            
        )]
        [Alias("Since","SinceAlert")]
        [Int]$SinceAlertID,
    
        #Returns all alerts
        [Parameter(ParameterSetName='AllAlerts')]
        [Alias("All")]
        [Switch]$AllAlerts,

        #Whether to force the query of live API data
        [Parameter(ParameterSetName='DeviceName',Position=1)]
        [Parameter(ParameterSetName='DeviceID',Position=1)]
        [Parameter(ParameterSetName='CustomerName',Position=1)]
        [Parameter(ParameterSetName='CustomerID',Position=1)]
        [Parameter(ParameterSetName='SinceAlert',Position=1)]
        [Parameter(ParameterSetName='AllAlerts',Position=1)]
        [Switch]$NoCache

    )

    Begin {

        Write-Verbose -Message "Parameter Set name being used is $($PSCmdlet.ParameterSetName)"
        Write-Debug "Provided Parameter values are"    
        Write-Debug "DeviceID: $DeviceID"
        Write-Debug "DeviceName: $DeviceName"
        Write-Debug "All Devices: $AllDevices"
    
        #Create an empty output array
        $OutputArray = @()

    }

    #ForEach piped in object
    Process {

        #Based on which parameter set is being used, do the following
        Switch ($PSCmdlet.ParameterSetName) {

            "DeviceName" {

                #Loop through each DeviceName
                ForEach ($Name in $DeviceName) {

                #Make the request and add NoCache if the switch is specified

                    If ($NoCache) {
                    
                        $Rest = Invoke-NinjaAPIRequest -HTTPVerb GET -Resource /v1/alerts -NoCache
                    
                    }

                    Else {

                        $Rest = Invoke-NinjaAPIRequest -HTTPVerb GET -Resource /v1/alerts

                    }

                    #Since the API doesn't have the ability to requset data for a specific device by name, this makes a standard request, and then uses Where-Object to filter the results.
                    $Rest = $Rest | Where-Object { $_.device.system_name -like "*$Name*" }
                    #Add the rest response to the output array
                    $OutputArray += $Rest

                }
                
            }
            
            "DeviceID" {

                #Loop through each DeviceID
                ForEach ($ID in $DeviceID) {
                    
                #Make the request and add NoCache if the switch is specified
                    
                    If ($NoCache) {
                    
                        $Rest = Invoke-NinjaAPIRequest -HTTPVerb GET -Resource /v1/alerts -NoCache
                    
                    }

                    Else {

                        $Rest = Invoke-NinjaAPIRequest -HTTPVerb GET -Resource /v1/alerts 

                    }
                    
                    #Since the API doesn't have the ability to requset data for a specific device by ID, this makes a standard request, and then uses Where-Object to filter the results.
                    $Rest = $Rest | Where-Object { $_.device.id -eq $ID }
                    #Add the rest response to the output array
                    $OutputArray += $Rest
                
                }

            }

            "CustomerName" {

                #Loop through each CustomerName
                ForEach ($Name in $CustomerName) {

                #Make the request and add NoCache if the switch is specified

                    If ($NoCache) {
                    
                        $Rest = Invoke-NinjaAPIRequest -HTTPVerb GET -Resource /v1/alerts -NoCache
                    
                    }

                    Else {

                        $Rest = Invoke-NinjaAPIRequest -HTTPVerb GET -Resource /v1/alerts 

                    }

                    #Since the API doesn't have the ability to requset data for a specific customer by name, this makes a standard request, and then uses Where-Object to filter the results.
                    $Rest = $Rest | Where-Object { $_.customer.name -like "*$Name*" }
                    #Add the rest response to the output array
                    $OutputArray += $Rest

                }

            }

            "CustomerID" {

                #Loop through each CustomerID
                ForEach ($ID in $CustomerID) {

                #Make the request and add NoCache if the switch is specified

                    If ($NoCache) {
                    
                        $Rest = Invoke-NinjaAPIRequest -HTTPVerb GET -Resource /v1/alerts -NoCache
                    
                    }

                    Else {

                        $Rest = Invoke-NinjaAPIRequest -HTTPVerb GET -Resource /v1/alerts 

                    }
                    
                    #Since the API doesn't have the ability to requset data for a specific customer by ID, this makes a standard request, and then uses Where-Object to filter the results.
                    $Rest = $Rest | Where-Object { $_.customer.id -eq $ID }
                    #Add the rest response to the output array
                    $OutputArray += $Rest

                }

            }
            
            "SinceAlert" {

            #Make the request and add NoCache if the switch is specified
            
                If ($NoCache) {

                    $Rest = Invoke-NinjaAPIRequest -HTTPVerb GET -Resource /v1/alerts/since/$SinceAlertID -NoCache
                
                }

                Else {

                    $Rest = Invoke-NinjaAPIRequest -HTTPVerb GET -Resource /v1/alerts/since/$SinceAlertID 

                }
                
                #Add the rest response to the output array
                $OutputArray += $Rest

            }
            
            "AllAlerts" {

            #Make the request and add NoCache if the switch is specified

                If ($NoCache) {

                    $Rest = Invoke-NinjaAPIRequest -HTTPVerb GET -Resource /v1/alerts -NoCache

                }
                
                Else {
                    
                    $Rest = Invoke-NinjaAPIRequest -HTTPVerb GET -Resource /v1/alerts 
                
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