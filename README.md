# PowerShell NinjaRMM Management Module
This module is a collection of cmdlets that allow you to query and manage your NinjaRMM environment with PowerShell.

## Cmdlets
### List of available cmdlets
* `Get-NinjaCustomer`
* `Get-NinjaDevice`
* `Get-NinjaAPIKeys`
* `Set-NinjaAPIKeys`
* `Remove-NinjaAPIKeys`
* `Get-NinjaTimeStamp`
* `New-NinjaAuthorization`
* `New-NinjaRequestHeader`

### List of planned cmdlets
The cmdlets planned are based on what is currently available in the API
* `Get-NinjaAlert`
* `Delete-NinjaAlert`

### Potential future cmdlets
These future hopefulls are dependent upon the NinjaAPI (which is in beta) releasing additional capabilities
* `New-NinjaCustomer`
* `Remove-NinjaCustomer`
* `New-NinjaNMSDevice`
* `Remove-NinjaNMSDevice`
* `Generate-NinjaInstaller`
* `Remove-NinjaDevice`
* `New-NinjaUser`
* `Remove-NinjaUser`

## Getting Started
### Download and Import the Module Files
1. Clone this repository or download it to a location on your machine. Ensure that the "Sources" directory is included.
![](https://i.imgur.com/P9gcvmi.png)
1. Import the module into your session or your custom script by running "Import-Module .\PoSHNinjaRMM.ps1"
![](https://i.imgur.com/mx48YJx.png)

### Generate and Import the API Key
1. Log into the [Ninja Portal](https://login.ninjarmm.com)
1. Click on "Configuration on the left-hand side.                                                                        
![](https://i.imgur.com/MDs4LuV.png)
1. Choose "Integrations" from the top right-hand corder.                                                               
![](https://i.imgur.com/XDhouJm.png)
1. Then click "Generate API Key"
1. Enter a description for the key, then copy the "Access Key ID" (The Public Key) and the "Secret Access Key" (The Private Key, keep this safe and do not share it).
![](https://i.imgur.com/9itYe9D.png)
1. Run the cmdlet "Set-NinjaAPIKeys -AccessKeyID [Your access key] -SecretAccessKey [Secret access key]" This will program the keys into a local registry entry.
![](https://i.imgur.com/O1aO0hh.png)
1. You can verify that the keys have been saved in the registry by running "Get-NinjaAPIKeys". If the keys appear, then you're now able to run management cmdlets and they will automatically use these keys. If you'd like to remove the keys, please use "Remove-NinjaAPIKeys".
