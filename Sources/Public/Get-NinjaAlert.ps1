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
        [Switch]$AllAlerts

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

            "DeviceName" {

                ForEach ($Name in $DeviceName) {

                    $Rest = Invoke-NinjaAPIRequest -HTTPVerb GET -Resource /v1/alerts -AccessKeyID $Keys.AccessKeyID -SecretAccessKey $Keys.SecretAccessKey
                    $Rest = $Rest | Where-Object { $_.device.system_name -like "*$Name*" }
                    $OutputArray += $Rest

                }
                
            }
            
            "DeviceID" {

                ForEach ($ID in $DeviceID) {
                    
                    $Rest = Invoke-NinjaAPIRequest -HTTPVerb GET -Resource /v1/alerts -AccessKeyID $Keys.AccessKeyID -SecretAccessKey $Keys.SecretAccessKey
                    $Rest = $Rest | Where-Object { $_.device.id -eq $ID }
                    $OutputArray += $Rest
                
                }

            }

            "CustomerName" {

                ForEach ($Name in $CustomerName) {

                    $Rest = Invoke-NinjaAPIRequest -HTTPVerb GET -Resource /v1/alerts -AccessKeyID $Keys.AccessKeyID -SecretAccessKey $Keys.SecretAccessKey
                    $Rest = $Rest | Where-Object { $_.customer.name -like "*$Name*" }
                    $OutputArray += $Rest

                }

            }

            "CustomerID" {

                ForEach ($ID in $CustomerID) {

                    $Rest = Invoke-NinjaAPIRequest -HTTPVerb GET -Resource /v1/alerts -AccessKeyID $Keys.AccessKeyID -SecretAccessKey $Keys.SecretAccessKey
                    $Rest = $Rest | Where-Object { $_.customer.id -eq $ID }
                    $OutputArray += $Rest

                }

            }
            
            "SinceAlert" {

                $Rest = Invoke-NinjaAPIRequest -HTTPVerb GET -Resource /v1/alerts/since/$SinceAlertID -AccessKeyID $Keys.AccessKeyID -SecretAccessKey $Keys.SecretAccessKey
                $OutputArray += $Rest

            }
            
            "AllAlerts" {

                $Rest = Invoke-NinjaAPIRequest -HTTPVerb GET -Resource /v1/alerts -AccessKeyID $Keys.AccessKeyID -SecretAccessKey $Keys.SecretAccessKey
                $OutputArray += $Rest

            }

        }

    }

    End {

        Write-Output $OutputArray

    }

}