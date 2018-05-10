Function Get-NinjaAPIKeys {

    $ModulePath = Get-Module -Name PoSH-NinjaRMM | Select-Object -ExpandProperty ModuleBase
    $KeyFileName = "key.json"
    
    $Key = Get-Content "$ModulePath\$KeyFileName" -ErrorAction SilentlyContinue | ConvertFrom-JSON -ErrorAction SilentlyContinue
    

    If ($Key.AccessKeyID -eq $Null -or $Key.SecretAccessKey -eq $Null) {
        
        Write-Error "The Ninja API keys not set in registry, use Set-NinjaAPIKeys to set them"
    
    }
        
    Else {
        
        Write-Output $Key
    
    }

}