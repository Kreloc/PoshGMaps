Function Get-GmapGeoCode
{
    <#
    .SYNOPSIS
        This function returns information abobut an Address given to the Address parameter.
    .DESCRIPTION
        This function returns information abobut an Address given to the Address parameter. Uses the Google Geocode API.
        Object returned will be formatted and have a default property display. All other proerties are still present.
    
    .EXAMPLE
        Get-GmapGeoCode -Address "123 Main St, New York, NY"

        Will return information from the Google GeoCode API about the address 123 Main St, New York, NY
    
    .EXAMPLE
        $YourAddress = Read-Host "Enter your address"
        Get-GmapGeoCode -Address $YourAddress
        
        This will prompt for your address and then query the Google Geocode API for information about it.

    .NOTES
        Requires an active Google GeoCode API key. This key should be set in the module variable `$GGeoCodeApiKey
    #>
    [CmdletBinding()]
    param 
    (
		[Parameter(Mandatory=$True,
		ValueFromPipeline=$True, ValueFromPipelinebyPropertyName=$true)]            
        [string]$Address,
		[Parameter(Mandatory=$False)]            
        $options         
    )
    Begin{}
    Process
    {
        $Address = $Address -replace ' ','+'
        If($options)
        {
            $url = $BaseUri + 'geocode/json?address=' + $Address + '&' + $(New-GmapQuery -ApiKey $GGeoCodeApiKey -options $options)
        }
        else 
        {
            $url = $BaseUri + 'geocode/json?address=' + $Address + $(New-GmapQuery -ApiKey $GGeoCodeApiKey)
        }
        Write-Verbose "Sending Url of $url"        
        $Results = Invoke-RestMethod -Uri $url # Refer to https://developers.google.com/maps/documentation/geocoding/intro for info about properties returned
        If($Results.status -eq 'OK')
        {
            $Results = $Results.results # get the results from json data returned from Google API
            $Results | Format-GmapGeoResult # send it to function which adds ScriptProperties and ScriptMethods, sets Default Display Set
        }
        else 
        {
            Write-Warning "Did not get succcessful return from Google Geocode API endpoint" 
            $Results  
        }
    }
    End{}
}