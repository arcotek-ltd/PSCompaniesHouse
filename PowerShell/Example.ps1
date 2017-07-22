
$searchTerm = "amazon"
$apiKey = "yourapikeyhere"
$ServiceUri = "https://api.companieshouse.gov.uk"

$AuthorisationHeader = New-AuthorisationHeader -ApiKey $apiKey -Verbose

$Results = Get-Response `
        -ServiceUri $ServiceUri `
        -SearchTerm $searchTerm `
        -ItemsPerPage 100 `
        -StartIndex 0 `
        -AuthorisationHeader $AuthorisationHeader `
        -AllRecords `
        -Verbose

$Results | Get-ResponseItems -Verbose

