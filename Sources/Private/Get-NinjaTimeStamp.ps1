Function Get-NinjaTimeStamp {

    <#

    .SYNOPSIS
        Creates a timestamp for NinajRMM API requests

    .DESCRIPTION
        Creates an RFC 2616 compliant timestamp that is used in the NinjaRMM API requests

    .EXAMPLE
        PS C:> Get-NinjaTimeStamp
        Wed, 12 Apr 2017 13:52:36 GMT

    #>
        
    $Date = Get-Date -date $(Get-Date).ToUniversalTime() -Format r
    
    Write-Output $Date

}