Function Get-NinjaAPIKeys {

    PARAM
    (

    )

    Begin
    {

    }

    Process
    {
        $AccessKeyID = Get-ItemProperty -Path "HKLM:\SOFTWARE\PoSHNinjaRMM\" -Name "AccessKeyID" -ErrorAction SilentlyContinue | Select-Object -ExpandProperty AccessKeyID
        $SecretAccessKey = Get-ItemProperty -Path "HKLM:\SOFTWARE\PoSHNinjaRMM\" -Name "SecretAccessKey" -ErrorAction SilentlyContinue | Select-Object -ExpandProperty SecretAccessKey
    }

    End
    {
        If ($AccessKeyID -eq $Null -or $SecretAccessKey -eq $Null) 
        {
            Write-Error "The Ninja API keys not set in registry, use Set-NinjaKeys to set them"
        }
        
        Else 
        {
            Write-Output @{"AccessKeyID" = $AccessKeyID; "SecretAccessKey" = $SecretAccessKey}
        }
    }

}

Function Set-NinjaAPIKeys {

    PARAM
    (
        [Parameter(Mandatory=$True)]
        [String]$AccessKeyID,

        [Parameter(Mandatory=$True)]
        [String]$SecretAccessKey
    )

    Begin
    {
        
    }

    Process
    {
        New-Item -Path "HKLM:\SOFTWARE\" -Name "PoSHNinjaRMM" -Force
        New-ItemProperty -Path "HKLM:\SOFTWARE\PoSHNinjaRMM" -Name "AccessKeyID" -Value $AccessKeyID -Force
        New-ItemProperty -Path "HKLM:\SOFTWARE\PoSHNinjaRMM" -Name "SecretAccessKey" -Value $SecretAccessKey -Force
    }

    End
    {

    }

}

Function Remove-NinjaApiKeys {

    PARAM
    (
        [Switch]$Force
    )

    Begin
    {
        
    }

    Process
    {
        If (!$Force) 
        {
        
            $title = $Null
            $message = "Delete Ninja API keys from Registry?"
            
            $yes = New-Object System.Management.Automation.Host.ChoiceDescription "&Yes", "API Keys WILL be deleted from the Registry"
            $no = New-Object System.Management.Automation.Host.ChoiceDescription "&No", "API keys will NOT be deleted from the Registry"

            $options = [System.Management.Automation.Host.ChoiceDescription[]]($yes, $no)

            $result = $host.ui.PromptForChoice($title, $message, $Options, 0)

            Switch ($result)
                {
                    0 { Remove-Item -Path "HKLM:\Software\PoSHNinjaRMM" -Force -ErrorAction SilentlyContinue }
                    1 { Write-Output "Did NOT remove API keys." }
                }
        }

        If ($Force) 
        {
            Remove-Item -Path "HKLM:\Software\PoSHNinjaRMM" -Force -ErrorAction SilentlyContinue
        }
    }

    End
    {

    }

}