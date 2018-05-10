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
        
    #Uses Get-Date recursively within Get-Date so that the formatting can be applied and so that the time can be converted to UTC.
    $Date = Get-Date -date $(Get-Date).ToUniversalTime() -Format r
    
    #Outputs the Date String
    Write-Output $Date

}