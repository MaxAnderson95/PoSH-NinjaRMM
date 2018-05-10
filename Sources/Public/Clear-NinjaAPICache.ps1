Function Clear-NinjaAPICache {

    <#

    .SYNOPSIS
        

    .DESCRIPTION
        

    .EXAMPLE
        

    #>

    $CacheDir = "$PSScriptRoot\..\..\API_Cache"

    Remove-Item -Path "$CacheDir\*" -Exclude .gitignore -Force

}