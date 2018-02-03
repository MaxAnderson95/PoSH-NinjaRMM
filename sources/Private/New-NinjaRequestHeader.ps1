Function New-NinjaRequestHeader {

    PARAM
    (
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

    Begin
    {

    }

    Process
    {
        #Generate a Date Stamp
        $Date = Get-NinjaTimeStamp
        
        #Generate the String by concatenating the inputs together
        $StringToSign = $HTTPVerb + "`n" + $ContentMD5 + "`n" + $ContentType + "`n" + $Date + "`n" + $Resource

        $Authorization = New-NinjaAuthroization -StringToSign $StringToSign -AccessKeyID $AccessKeyID -SecretAccessKey $SecretAccessKey

        $Header = @{"Authorization" = $Authorization; "Date" = $Date}

        Write-Output $Header
    }

    End
    {

    }

}