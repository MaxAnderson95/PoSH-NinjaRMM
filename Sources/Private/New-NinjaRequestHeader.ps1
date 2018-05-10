Function New-NinjaRequestHeader {

    <#

    .SYNOPSIS
        Creates the required header for the HTTPS rest call

    .DESCRIPTION
        Creates a header that is required for the HTTPS rest call. It passes a hash table with the authorization
        created by "New-NinjaAuthorization" and the date created by "Get-NinjaTimeStamp".

    .PARAMETER HTTPVerb
        The REST method that will be used in the the API call. Currently v0.1.2 of the API only accepts GET
        requests for the customers and devices resources, and GET and DELETE for the alerts resources. Becuase
        this is an internal function, there is not parameter validation.
    
    .PARAMETER ContentMD5
        An untizilized parameter that is not currently needed in v0.1.2 of the API

    .PARAMETER ContentType
        An untizilized parameter that is not currently needed in v0.1.2 of the API

    .PARAMETER Resource
        The API resorce that will be used in the API call. Currently v0.1.2 of the API only contains a resource
        for customers, devices, and alerts. The syntax expected is "/v1/RESOURCENAME". Consult the API documentation
        for more information.
    
    .PARAMETER AccessKeyID
        The public portion of the API key.

    .PARAMETER SecretAccessKey
        The private portion of the API key.

    .EXAMPLE
        PS C:> New-NinjaRequestHeader -HTTPVerb "GET" -Resource "/v1/customers" -AccessKeyID "1234" -SecretAccessKey "567890"
        Name                           Value
        ----                           -----
        Date                           Thu, 10 May 2018 21:50:50 GMT
        Authorization                  NJ 1234:fDs1lMmxPMPeQ1AlqTv0LsOWcvk=
                
    #>
    
    PARAM (
        
        [Parameter(Mandatory=$True)]
        [string]$HTTPVerb,

        [Parameter]
        [string]$ContentMD5,

        [Parameter]
        [string]$ContentType,

        [Parameter(Mandatory=$True)]
        [string]$Resource,

        [Parameter(Mandatory=$True)]
        [String]$AccessKeyID,

        [Parameter(Mandatory=$True)]
        [String]$SecretAccessKey
    
    )
        
    #Generate a Date Stamp
    $Date = Get-NinjaTimeStamp
    
    #Generate the String by concatenating the inputs together with line breaks
    $StringToSign = $HTTPVerb + "`n" + $ContentMD5 + "`n" + $ContentType + "`n" + $Date + "`n" + $Resource

    #Generate the autorization string
    $Authorization = New-NinjaAuthroization -StringToSign $StringToSign -AccessKeyID $AccessKeyID -SecretAccessKey $SecretAccessKey

    #Create the header hash table
    $Header = @{"Authorization" = $Authorization; "Date" = $Date}

    #Output the header hash table
    Write-Output $Header

}