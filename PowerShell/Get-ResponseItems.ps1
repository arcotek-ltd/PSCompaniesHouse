Function Get-ResponseItems
{
    [cmdletbinding()]
    param
    (
        [Parameter(ValueFromPipeline=$true,ValueFromPipelineByPropertyName=$true)]
        [Object]$Response
        
    )
    Begin
    {
        $oData = @()
        $PageCount = 0
    }
    Process
    {
        $TotalPages = $Response.response.total_results / $Response.response.items_per_page
        $PageCount ++
        $RecordCount = 0
        foreach($record in $Response.Response.Items)
        {
            $RecordCount ++
            #$company = $oResult.items
            $oAddress = $record.address
    
            $oData += [pscustomobject]@{
                Page = "$PageCount/" + $([math]::Ceiling($TotalPages))
                Index = (($pageCount * $Response.response.items_per_page) + $RecordCount) - $Response.response.items_per_page
                #Record = $RecordCount
                #ItemsPerPage = $Response.ItemsPerPage
                CompanyName = $record.title
                CompanyType = $record.company_type
                CompanyNumber = $record.company_number
                CompanyStatus = $record.company_status
                Date = $record.date_of_creation
                Premises = $oAddress.premises
                AddressL1 = $oAddress.address_line_1
                AddressL2 = $oAddress.address_line_2
                Locality = $oAddress.locality
                County = $oAddress.Region
                PostCode = $oAddress.postal_code
                Country = $oAddress.country
            }
        }
    }
    end
    {
        $oData
    }
 }