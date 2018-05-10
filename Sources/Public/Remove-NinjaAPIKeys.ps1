Function Remove-NinjaAPIKeys {

    <#
    
        .SYNOPSIS
            Removes the Ninja API Keys stored in the system

        .DESCRIPTION
            Removes the key.json file located in the root of the module folder. This function will ensure that the user wants to remove the file by default.
            You can specify -Force if you wish to bypass this additional confirmation.

        .PARAMETER Force
            Bypasses the addtional confirmation that ensures the user wishes to delete the keys.

        .EXAMPLE
            PS C:> Remove-NinjaAPIKeys
    
    #>
    
    PARAM (
        
        [Switch]$Force
    
    )

    #Specifies the location of the module in the system
    $ModulePath = Get-Module -Name PoSH-NinjaRMM | Select-Object -ExpandProperty ModuleBase
    #Specified the name of the key file
    $KeyFileName = "key.json"
        
    #If the force switch is not specified
    If (!$Force) {
    
        #Generate the confirmation prompt
        $title = $Null
        $message = "Delete Ninja API keys from Registry?"
        
        $yes = New-Object System.Management.Automation.Host.ChoiceDescription "&Yes", "API Keys WILL be deleted from the Registry"
        $no = New-Object System.Management.Automation.Host.ChoiceDescription "&No", "API keys will NOT be deleted from the Registry"

        $options = [System.Management.Automation.Host.ChoiceDescription[]]($yes, $no)

        #Gather the result
        $result = $host.ui.PromptForChoice($title, $message, $Options, 0)

        #Based on the restult, either delete the file or don't
        Switch ($result) {
            0 { Remove-Item -Path "$ModulePath\$KeyFileName" -Force }
            1 { Write-Output "API Keys not removed." }
            
        }

    }

    #If the force switch is specified, remove the file without a confirmation
    If ($Force) {
        
        Remove-Item -Path "$ModulePath\$KeyFileName" -Force
    
    }
    
}