Function New-AuthorisationHeader
{
    [cmdletbinding()]
    param
    (
        [Parameter(Mandatory)]
        [string]$ApiKey
    )
    Write-Verbose "Creating authorisation header..."
    $authVal = "Basic " + [System.Convert]::ToBase64String([System.Text.Encoding]::UTF8.GetBytes($apikey))
    $header = @{
        "Authorization"=$authVal
    }
    return $header    
}