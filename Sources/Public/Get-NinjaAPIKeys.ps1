Function Get-NinjaAPIKeys {

    <#
    
        .SYNOPSIS
            Gets the Ninja API Keys stored in the system
        
        .DESCRIPTION
            Gets the Ninja API Keys stored in the key.json file located in the root of the module folder

        .EXAMPLE
            PS C:> Get-NinjaAPIKeys
            AccessKeyID          SecretAccessKey
            -----------          ---------------
            1234                 567890

    #>

    #Specifies the location of the module in the system
    $ModulePath = Get-Module -Name PoSH-NinjaRMM | Select-Object -ExpandProperty ModuleBase
    #Specified the name of the key file
    $KeyFileName = "key.json"
    
    #Gather's the key and converts it from JSON format into an object. Silences any errors.
    $Key = Get-Content "$ModulePath\$KeyFileName" -ErrorAction SilentlyContinue | ConvertFrom-JSON -ErrorAction SilentlyContinue
    

    #If either value is null an error is generated.
    If ($Key.AccessKeyID -eq $Null -or $Key.SecretAccessKey -eq $Null) {
        
        Write-Error "The Ninja API keys not set in registry, use Set-NinjaAPIKeys to set them"
    
    }
     
    #If the key exists, the key object is outputted to the screen
    Else {
        
        Write-Output $Key
    
    }

}