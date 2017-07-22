Function Get-Response
{
    [cmdletbinding()]
    param
    (
        [string]$ServiceUri,
        [string]$SearchTerm,
        [switch]$AllRecords,
        [int32]$ItemsPerPage,
        [int32]$StartIndex,
        [object]$AuthorisationHeader
    )
        
    $Url = $ServiceUri + "/search?q=$searchTerm"

    $oInitialResponse = Invoke-RestMethod -Uri $Url -Headers $AuthorisationHeader -Method Get -ContentType 'application/json' 

    Write-Verbose "Building URI..."

    if($ItemsPerPage)
    {
        $url = $url + "&items_per_page=$ItemsPerPage"    
    }

    If($StartIndex)
    {
        $url = $url + "&start_index=$StartIndex"
    }
    
    Write-Verbose "URI to be parsed: $url"

    $TotalResults = $oInitialResponse.total_results

    if($PSBoundParameters.ContainsKey('AllRecords'))
    {
        if($TotalResults -gt $ItemsPerPage)
        {
            Write-Verbose "There are a total of $TotalResults results found. Maximum per page is $ItemsPerPage. Pagination will occurre across $($TotalResults / $ItemsPerPage) pages."
            $oAllPageResponses = @()
            $RecordCount = 0
            For($i = 0; $i -le $TotalResults; $i += $ItemsPerPage)
            {
                #$i
                Try
                {
                    $oResponse = Invoke-RestMethod -Uri ($serviceUri + "/search?q=$searchTerm&items_per_page=$ItemsPerPage&start_index=$i") -Headers $AuthorisationHeader -Method Get -ContentType 'application/json' -ErrorAction Stop
                
                    $oAllPageResponses += [pscustomobject]@{
                        Response = $oResponse
                        Page = $PageCount
                        ItemsPerPage = $ItemsPerPage    
                    }
                }
                Catch
                {
                    if($error[0] -notlike "*Request Range Not Satisfiable*")
                    {
                        Write-Error $error[0]
                    }
                }
            }

            $oAllPageResponses
        }
        else
        {
            Write-Verbose "There are a total of $TotalResults results found. Maximum per page is $ItemsPerPage." 
            Try
            {
                $oResponse = Invoke-RestMethod -Uri $Url -Headers $AuthorisationHeader -Method Get -ContentType 'application/json' #-ErrorAction Stop
                $oResponse = [pscustomobject]@{Response = $oResponse ; Page = 1;ItemsPerPage = $ItemsPerPage}
                $oResponse
            }
            Catch
            {
                if($error[0] -notlike "*Request Range Not Satisfiable*")
                {
                    Write-Error $error[0]
                }
            }
        }
    }
    else
    {
        $oResponse = Invoke-RestMethod -Uri $Url -Headers $AuthorisationHeader -Method Get -ContentType 'application/json' #-ErrorAction Stop
        $oResponse = [pscustomobject]@{Response = $oResponse ; Page = 1;ItemsPerPage = $ItemsPerPage}
        $oResponse
    }
    
}





