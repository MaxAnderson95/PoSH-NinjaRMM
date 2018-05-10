Function Set-NinjaAPIKeys {

    PARAM (
        
        [Parameter(Mandatory=$True)]
        [String]$AccessKeyID,

        [Parameter(Mandatory=$True)]
        [String]$SecretAccessKey

    )

    $Keys = [PSCustomObject] @{

        "AccessKeyID" = $AccessKeyID
        "SecretAccessKey" = $SecretAccessKey

    }

    $ModulePath = Get-Module -Name PoSH-NinjaRMM | Select-Object -ExpandProperty ModuleBase
    $KeyFileName = "key.json"

    $Keys | ConvertTo-JSON | Out-File -FilePath "$ModulePath\$KeyFileName" -Force
    
}