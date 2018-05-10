Function Remove-NinjaApiKeys {

    PARAM (
        
        [Switch]$Force
    
    )

    $ModulePath = Get-Module -Name PoSH-NinjaRMM | Select-Object -ExpandProperty ModuleBase
    $KeyFileName = "key.json"
        
    If (!$Force) {
    
        $title = $Null
        $message = "Delete Ninja API keys from Registry?"
        
        $yes = New-Object System.Management.Automation.Host.ChoiceDescription "&Yes", "API Keys WILL be deleted from the Registry"
        $no = New-Object System.Management.Automation.Host.ChoiceDescription "&No", "API keys will NOT be deleted from the Registry"

        $options = [System.Management.Automation.Host.ChoiceDescription[]]($yes, $no)

        $result = $host.ui.PromptForChoice($title, $message, $Options, 0)

        Switch ($result) {
            0 { Remove-Item -Path "$ModulePath\$KeyFileName" -Force }
            1 { Write-Output "API Keys not removed." }
            
        }

    }

    If ($Force) {
        
        Remove-Item -Path "$ModulePath\$KeyFileName" -Force
    
    }
    
}