Function Get-NinjaAlert {

    <#

    .SYNOPSIS
        

    .DESCRIPTION
        

    .EXAMPLE
        

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

            "DeviceName" {

                ForEach ($Name in $DeviceName) {

                    If ($NoCache) {
                    
                        $Rest = Invoke-NinjaAPIRequest -HTTPVerb GET -Resource /v1/alerts -AccessKeyID $Keys.AccessKeyID -SecretAccessKey $Keys.SecretAccessKey -NoCache
                    
                    }

                    Else {

                        $Rest = Invoke-NinjaAPIRequest -HTTPVerb GET -Resource /v1/alerts -AccessKeyID $Keys.AccessKeyID -SecretAccessKey $Keys.SecretAccessKey

                    }

                    $Rest = $Rest | Where-Object { $_.device.system_name -like "*$Name*" }
                    $OutputArray += $Rest

                }
                
            }
            
            "DeviceID" {

                ForEach ($ID in $DeviceID) {
                    
                    If ($NoCache) {
                    
                        $Rest = Invoke-NinjaAPIRequest -HTTPVerb GET -Resource /v1/alerts -AccessKeyID $Keys.AccessKeyID -SecretAccessKey $Keys.SecretAccessKey -NoCache
                    
                    }

                    Else {

                        $Rest = Invoke-NinjaAPIRequest -HTTPVerb GET -Resource /v1/alerts -AccessKeyID $Keys.AccessKeyID -SecretAccessKey $Keys.SecretAccessKey

                    }
                    
                    $Rest = $Rest | Where-Object { $_.device.id -eq $ID }
                    $OutputArray += $Rest
                
                }

            }

            "CustomerName" {

                ForEach ($Name in $CustomerName) {

                    If ($NoCache) {
                    
                        $Rest = Invoke-NinjaAPIRequest -HTTPVerb GET -Resource /v1/alerts -AccessKeyID $Keys.AccessKeyID -SecretAccessKey $Keys.SecretAccessKey -NoCache
                    
                    }

                    Else {

                        $Rest = Invoke-NinjaAPIRequest -HTTPVerb GET -Resource /v1/alerts -AccessKeyID $Keys.AccessKeyID -SecretAccessKey $Keys.SecretAccessKey

                    }

                    $Rest = $Rest | Where-Object { $_.customer.name -like "*$Name*" }
                    $OutputArray += $Rest

                }

            }

            "CustomerID" {

                ForEach ($ID in $CustomerID) {

                    If ($NoCache) {
                    
                        $Rest = Invoke-NinjaAPIRequest -HTTPVerb GET -Resource /v1/alerts -AccessKeyID $Keys.AccessKeyID -SecretAccessKey $Keys.SecretAccessKey -NoCache
                    
                    }

                    Else {

                        $Rest = Invoke-NinjaAPIRequest -HTTPVerb GET -Resource /v1/alerts -AccessKeyID $Keys.AccessKeyID -SecretAccessKey $Keys.SecretAccessKey

                    }

                    $Rest = $Rest | Where-Object { $_.customer.id -eq $ID }
                    $OutputArray += $Rest

                }

            }
            
            "SinceAlert" {

                If ($NoCache) {

                    $Rest = Invoke-NinjaAPIRequest -HTTPVerb GET -Resource /v1/alerts/since/$SinceAlertID -AccessKeyID $Keys.AccessKeyID -SecretAccessKey $Keys.SecretAccessKey -NoCache
                
                }

                Else {

                    $Rest = Invoke-NinjaAPIRequest -HTTPVerb GET -Resource /v1/alerts/since/$SinceAlertID -AccessKeyID $Keys.AccessKeyID -SecretAccessKey $Keys.SecretAccessKey

                }

                $OutputArray += $Rest

            }
            
            "AllAlerts" {

                If ($NoCache) {

                    $Rest = Invoke-NinjaAPIRequest -HTTPVerb GET -Resource /v1/alerts -AccessKeyID $Keys.AccessKeyID -SecretAccessKey $Keys.SecretAccessKey -NoCache

                }
                
                Else {
                    
                    $Rest = Invoke-NinjaAPIRequest -HTTPVerb GET -Resource /v1/alerts -AccessKeyID $Keys.AccessKeyID -SecretAccessKey $Keys.SecretAccessKey
                
                }
                
                $OutputArray += $Rest

            }

        }

    }

    End {

        Write-Output $OutputArray

    }

}