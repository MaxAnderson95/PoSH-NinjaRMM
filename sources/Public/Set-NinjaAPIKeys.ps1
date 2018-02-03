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