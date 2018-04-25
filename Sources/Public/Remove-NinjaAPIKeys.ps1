Function Remove-NinjaApiKeys {

    PARAM (
        
        [Switch]$Force
    
    )
        
    If (!$Force) {
    
        $title = $Null
        $message = "Delete Ninja API keys from Registry?"
        
        $yes = New-Object System.Management.Automation.Host.ChoiceDescription "&Yes", "API Keys WILL be deleted from the Registry"
        $no = New-Object System.Management.Automation.Host.ChoiceDescription "&No", "API keys will NOT be deleted from the Registry"

        $options = [System.Management.Automation.Host.ChoiceDescription[]]($yes, $no)

        $result = $host.ui.PromptForChoice($title, $message, $Options, 0)

        Switch ($result) {
            0 { Remove-Item -Path "HKLM:\Software\PoSHNinjaRMM" -Force -ErrorAction SilentlyContinue }
            1 { Write-Output "Did NOT remove API keys." }
            
        }

    }

    If ($Force) {
        
        Remove-Item -Path "HKLM:\Software\PoSHNinjaRMM" -Force -ErrorAction SilentlyContinue
    
    }
    
}