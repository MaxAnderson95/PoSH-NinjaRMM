Function Clear-NinjaAPICache {

    <#

    .SYNOPSIS
        Clears the Ninja API Cache

    .DESCRIPTION
        Clears the Ninja API Cache from the "API_Cache" directory in the root of the module. It ensurs that the
        .gitignore file is not delted. 

    .EXAMPLE
        PS C:> Clear-NinjaAPICache

    #>

    $CacheDir = "$PSScriptRoot\..\..\API_Cache"

    Remove-Item -Path "$CacheDir\*" -Exclude .gitignore -Force

}