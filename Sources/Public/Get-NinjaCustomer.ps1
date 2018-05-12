Function Get-NinjaCustomer {

    <#

    .SYNOPSIS
        Gets a list of customers or a specific customer in Ninja

    .DESCRIPTION
        Gets a list of customers or a speficic customer in Ninja, either by ID or Name.

    .PARAMETER AllCustomers
        Requests all customers. This is the default parameter set

    .PARAMETER CustomerID
        Accepts one or multiple customer id's to return

    .PARAMETER CustomerName
        Accepts one or multiple customer names to return

    .PARAMETER NoCache
        Requests live data from the API rather than utilizing any available cache
    
    .EXAMPLE
        PS C:> Get-NinjaCustomer
        id name                                 description
        -- ----                                 -----------
        1  Internal Infrastructure              Internal Infrastructure
        2  ABC Painting                         Painting Company
        3  123 Travel                           Travel Company
        4  XYZ Web Design                       Web Design Company

    .EXAMPLE
        PS C:> Get-NinjaCustomer -AllCustomers
        id name                                 description
        -- ----                                 -----------
        1  Internal Infrastructure              Internal Infrastructure
        2  ABC Painting                         Painting Company
        3  123 Travel                           Travel Company
        4  XYZ Web Design                       Web Design Company

    .EXAMPLE
        PS C:> Get-NinjaCustomer -CustomerID 2,3
        id name                                 description
        -- ----                                 -----------
        2  ABC Painting                         Painting Company
        3  123 Travel                           Travel Company

    .EXAMPLE
        PS C:> 2,3 | Get-NinjaCustomer
        id name                                 description
        -- ----                                 -----------
        2  ABC Painting                         Painting Company
        3  123 Travel                           Travel Company

    .EXAMPLE
        PS C:> Get-NinjaCustomer -CustomerName "123 Travel", "XYZ Web Design"
        id name                                 description
        -- ----                                 -----------
        3  123 Travel                           Travel Company
        4  XYZ Web Design                       Web Design Company

    .EXAMPLE
        PS C:> "123 Travel", "XYZ Web Design" | Get-NinjaCustomer
        id name                                 description
        -- ----                                 -----------
        3  123 Travel                           Travel Company
        4  XYZ Web Design                       Web Design Company

    #>

    [CmdletBinding(
        
        DefaultParameterSetName='AllCustomers',
        HelpUri = 'https://github.com/MaxAnderson95/PoSHNinjaRMM-Management'

    )]

    Param (
        
        #Returns a customer by ID
        [Parameter(
            
            ParameterSetName='CustomerID',    
            ValueFromPipeline=$True,
            ValueFromPipelineByPropertyName=$True, 
            Position=0
            
        )]
        [ValidateNotNullOrEmpty()]
        [Alias("ID")] 
        [Int[]]$CustomerID,

        #Returns a customer by name
        [Parameter(
            
            ParameterSetName='CustomerName',
            ValueFromPipeline=$True,
            ValueFromPipelineByPropertyName=$True, 
            Position=0
            
        )]
        [ValidateNotNullOrEmpty()]
        [Alias("Name")] 
        [String[]]$CustomerName,

        #Returns all customers
        [Parameter(ParameterSetName='AllCustomers',Position=0)]
        [Alias("All")] 
        [Switch]$AllCustomers,

        #Whether to force the query of live API data
        [Parameter(ParameterSetName='CustomerID',Position=1)]
        [Parameter(ParameterSetName='CustomerName',Position=1)]
        [Parameter(ParameterSetName='AllCustomers',Position=1)]
        [Switch]$NoCache,

        #Raw output
        [Parameter(ParameterSetName='CustomerID',Position=1)]
        [Parameter(ParameterSetName='CustomerName',Position=1)]
        [Parameter(ParameterSetName='AllCustomers',Position=1)]
        [Switch]$RawOutput

    )
    
    Begin {

        Write-Verbose -Message "Parameter Set name being used is $($PSCmdlet.ParameterSetName)"
        Write-Debug "Provided Parameter values are"    
        Write-Debug "CustomerID: $CustomerID"
        Write-Debug "CustomerName: $CustomerName"
        Write-Debug "All Customers: $AllCustomers"
        Write-Debug "NoCache: $NoCache"
        
        #Create an empty output array
        $OutputArray = @()
        
    }

    #ForEach piped in object
    Process {

        #Based on which parameter set is being used, do the following
        Switch ($PSCmdlet.ParameterSetName) {

            "CustomerID" {
                                
                #Loop through each CustomerID
                ForEach ($ID in $CustomerID) {
                    
                #Make the request and add NoCache if the switch is specified

                    If ($NoCache) {
                    
                        $Rest = Invoke-NinjaAPIRequest -HTTPVerb GET -Resource "/v1/customers/$ID" -NoCache
                    
                    }

                    Else {

                        $Rest = Invoke-NinjaAPIRequest -HTTPVerb GET -Resource "/v1/customers/$ID"

                    }

                    #Add the rest response to the output array
                    $OutputArray += $Rest

                }

            }

            "CustomerName" {
                                
                #Loop through each CustomerName
                ForEach ($Name in $CustomerName) {
                
                #Make the request and add NoCache if the switch is specified

                    If ($NoCache) {
                        
                        $Rest = Invoke-NinjaAPIRequest -HTTPVerb GET -Resource "/v1/customers" -NoCache
                    
                    }
                    
                    Else {

                        $Rest = Invoke-NinjaAPIRequest -HTTPVerb GET -Resource "/v1/customers"

                    }

                    #Since the API doesn't have the ability to requset data for a specific customer by name, this makes a standard request, and then uses Where-Object to filter the results.
                    $Rest = $Rest | Where-Object { $_.Name -like "*$Name*" }
                    #Add the rest response to the output array
                    $OutputArray += $Rest

                }
            
            }

            "AllCustomers" {
            
            #Make the request and add NoCache if the switch is specified

                If ($NoCache) {
                
                    $Rest = Invoke-NinjaAPIRequest -HTTPVerb GET -Resource "/v1/customers" -NoCache
                
                }

                Else {

                    $Rest = Invoke-NinjaAPIRequest -HTTPVerb GET -Resource "/v1/customers"

                }

                #Add the rest response to the output array
                $OutputArray += $Rest

            }

        }

    }

    End {

        If ($RawOutput) {

            Write-Output $OutputArray

        }

        Else {

            <#
            Reformat the raw output into a "cleaner looking" object. 
            The primary purpose of this is to rename the property names for the 
            purposes of pineline input into other functions
            #>

            #Create an empty aray
            $FormattedArray = @()

            ForEach ($Line in $OutputArray) {

                $Obj = [PSCustomObject] @{

                    "CustomerID" = $Line.id
                    "CustomerName" = $Line.name
                    "CustomerDescription" = $Line.description

                }
                
                $FormattedArray += $Obj

            }
            
            Write-Output $FormattedArray

        }

    }

}