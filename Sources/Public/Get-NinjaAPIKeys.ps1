Function Get-NinjaAPIKeys {

    $AccessKeyID = Get-ItemProperty -Path "HKLM:\SOFTWARE\PoSHNinjaRMM\" -Name "AccessKeyID" -ErrorAction SilentlyContinue | Select-Object -ExpandProperty AccessKeyID
    $SecretAccessKey = Get-ItemProperty -Path "HKLM:\SOFTWARE\PoSHNinjaRMM\" -Name "SecretAccessKey" -ErrorAction SilentlyContinue | Select-Object -ExpandProperty SecretAccessKey
    

    If ($AccessKeyID -eq $Null -or $SecretAccessKey -eq $Null) {
        
        Write-Error "The Ninja API keys not set in registry, use Set-NinjaAPIKeys to set them"
    
    }
        
    Else {
        
        Write-Output @{"AccessKeyID" = $AccessKeyID; "SecretAccessKey" = $SecretAccessKey}
    
    }

}