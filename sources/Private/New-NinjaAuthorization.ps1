Function New-NinjaAuthroization {

    <#

    .SYNOPSIS
        Generates the HMACSHA1 Signature for the API Request

    .DESCRIPTION
        Takes the requested portion of the API request as a string and the public and private keys and uses HMACSHA1 to generate a signature and then generates an Authorization to use in the HTTP request.

    .EXAMPLE
        PS C:> $String = "GET`n`n`nSun, 01 May 2016 06:51:10 GMT`n/v1/customers"
        PS C:> $AccessKeyID = "TF4STGMDR4H7AEXAMPLE"
        PS C:> $SecretAccessKey = "eh14c4ngchhu6283he03j6o7ar2fcuca0example"
        PS C:> New-NinajAuthroization -StringToSign $String -AccessKeyID $AccessKeyID -SecretAccessKey $SecretAccessKey
        NJ TF4STGMDR4H7AEXAMPLE:rEZWuXR0X1wX3autLTHIl2zX98I=

    #>

    PARAM
    (
        [Parameter(Position=0,Mandatory=$True)]
        [String]$StringToSign,

        [Parameter(Position=1,Mandatory=$True)]
        [String]$AccessKeyID,

        [Parameter(Position=2,Mandatory=$True)]
        [String]$SecretAccessKey
    )

    Begin
    {

    }

    Process
    {
        #Convert the String To Sign to a Base64 String
        $StringToSignBase64 = [Convert]::ToBase64String([Text.Encoding]::UTF8.GetBytes($StringToSign))

        #Generate HMACSHA1 Hash
        $HMACSHA = New-Object System.Security.Cryptography.HMACSHA1
        $HMACSHA.Key = [Text.Encoding]::ASCII.GetBytes($SecretAccessKey)
        $Signature = $HMACSHA.ComputeHash([Text.Encoding]::UTF8.GetBytes($StringToSignBase64))
        $Signature = [Convert]::ToBase64String($Signature)

        #Generate the Authorization string
        $Authorization = "NJ $AccessKeyID`:$Signature"

        #Output it
        Write-Output $Authorization
    }

    End
    {

    }

}