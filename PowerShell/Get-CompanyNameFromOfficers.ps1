#When using /search/officers?q, it doesn't return the name of the company
#this uses the 'links' field to get that information

#$a is the output from get response items. e.g $a = $Results | Get-ResponseItems


$oData=@()
$a | foreach-object{

    $url = "https://api.companieshouse.gov.uk/$($_.links.self)"
    $c = Invoke-RestMethod -Uri $Url -Headers $AuthorisationHeader -Method Get -ContentType 'application/json'
    
    
    $oData +=[pscustomobject]@{
        Name = $c.Name
        ForeName = $c.items.name_elements.forename
        SurName = $c.items.name_elements.surname
        CompanyName = $c.items.appointed_to.company_name
        CompanyNumber = $c.items.appointed_to.company_number
        object = $c
        AppointedToObject = $c.items.appointed_to  
    }
}

$oData | where{$_.companyName -like "*searchterm*"}
