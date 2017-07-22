# PSCompaniesHouse
An example of using Companies House' REST API to search records with PowerShell

## Getting Started

These scripts were written as a learning exercise more than anything else, however, I do use it to pull and then search data out of Companies House as their web-based search is pathetic and there's no record of VAT numbers, so I do a cross-reference using post code that may or maynot yield results. Anyway, on to the script.

The script is fairly agnostic and therefore should work with most REST APIs with minimal addaption.

The files should be wrapped into a module, but they can be opened in PowerShell ISE and run individually so they are loaded into memory.

### Prerequisites

You'll need an API key. You can get this by registering at: https://developer.companieshouse.gov.uk/api/docs/.

Then, register an application here: https://developer.companieshouse.gov.uk/developer/applications/register

An API key will be generated for your application. Keep it handy as you'll need it later.

## Functions

The script consists of three function. New-AuthorisationHeader, Get-Response and Get-ResponseItems.

### New-AuthorisationHeader

This is where you feed in your API Key. It converts it to a type PowerShell likes and returns a hashtable that is used in the request' header.

It only takes one parameter, apiKey.

### Get-Response

This is the main function that iterates through the results, returning an object for each page of records.

The API limits you to a results set of 100 items per page. So if your search returns more than 100 items, you'll need to iterate over the additional pages. This is handled by Get-Response -AllRecords.
If you want to know why the API' developers did this, read [here](http://forum.aws.chdev.org/t/why-is-filing-history-limited-to-100-items-per-page/131/3).

**Parameters**

* -ServiceUri *The base uri of the service. In this case https://api.companieshouse.gov.uk*
* -SearchTerm *What you are looking for. Could be company name or company number. For example "jcb" or "136890".*
* -AllRecords *A switch. If supplied, it will return all records that meet the search term.*
* -ItemsPerPage *The number of records that will be returned per page. This API has a maximum of 100.*
* -StartIndex *Use to target a particular record. For example if you set -ItemsPerPage to 3 and wanted the fourth record, set start index to 3. (Zero indexed).*
* -AuthorisationHeader *Pass in the object from New-AuthorisationHeader.* 

### Get-ResponseItems

This function takes the output of Get-Response and returns a PSCustomObject, containing the items, broken down into the following fields:
* Page - When multiple pages are returned (+ 100 results), useful to know where you are in the dataset.
* Index - The record number.
* CompanyName
* CompanyType
* CompanyNumber
* CompanyStatus
* Date
* Premises
* AddressL1
* AddressL2
* Locality
* County
* PostCode
* Country

### Examples

1) Declare variables:
```
$searchTerm = "amazon" #Searching for all records for 'amazon'
$apiKey = "yourapikey" #API key for your application (see Prerequisites).
$ServiceUri = "https://api.companieshouse.gov.uk" #Base URI for this service.
```

2) Now build the Authorisation Header and save it into a variable ($AuthorisationHeader):
```
$AuthorisationHeader = New-AuthorisationHeader -ApiKey $apiKey -Verbose
```
3) Get the records and save it into a variable ($Results):
```
$Results = Get-Response `
    -ServiceUri $ServiceUri `
	-SearchTerm $searchTerm `
	-ItemsPerPage 100 `
	-StartIndex 0 `
	-AuthorisationHeader $AuthorisationHeader `
	-Verbose `
	-AllRecords
```
In this example, I am returning all records, making as few requests as possible, by setting ItemsPerPage to 100 (the maximum allowed).
As I want all records, the StartIndex is set to 0.

4) Now, process the results into something useful by piping $Results into Get-ResponseItems.
```
$Results | Get-ResponseItems -Verbose
```

## Contributing

Please feel free to educate me.

