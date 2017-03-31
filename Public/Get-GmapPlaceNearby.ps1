Function Get-GmapPlaceNearby
{
    <#
    .SYNOPSIS
        This function finds places that are nearby the specified $Latitude and $Longitude within the search $Radius
    .DESCRIPTION
        This function finds places that are nearby the specified $Latitude and $Longitude within the search $Radius.
        Uses the Google API Places API.
    .EXAMPLE
        Get-GmapGeoCode -Address "123 Main St, New York, NY" | Get-GmapPlaceNearby -Radius 15

        This first runs the Get-GmapGeoCode on an address and the object returned will have a Latitude and Longitude property.
        That object is then piped to this function, which finds places within 15 meters.

    .EXAMPLE
        $CruiseNearby = Get-GmapGeoCode -Address "123 Main St, New York, NY" | Get-GmapPlaceNearby -Radius 100 -options '{"keyword":"cruise"}' -Verbose
        $CruiseNearby

        This first runs the Get-GmapGeoCode on an address and the object returned will have a Latitude and Longitude property.
        That object is then piped to this function, which finds places within 100 meters that match the keyword cruise.

    .NOTES
        Requires an active Google Place API Key. This key should be set to the moduel variable `$GPlacesApiKey.
        Refer to https://developers.google.com/places/web-service/intro
    #>
    [CmdletBinding()]
    param 
    (
		[Parameter(Mandatory=$True)]            
        $Radius,
		[Parameter(Mandatory=$True,
		ValueFromPipelinebyPropertyName=$true)]          
        $Latitude,
		[Parameter(Mandatory=$True,
		ValueFromPipelinebyPropertyName=$true)]            
        $Longitude,
		[Parameter(Mandatory=$False)]            
        $options         
    )
    Begin{}
    Process
    {
        $Location = "$($Latitude),$($Longitude)"
        Write-Verbose "Using location of $Location"
        If($options)
        {
            $url = $BaseUri + 'place/nearbysearch/json?location=' + $Location + '&' + 'radius=' + $Radius + '&' + $(New-GmapQuery -ApiKey $GPlacesApiKey -options $options)
        }
        else 
        {
            $url = $BaseUri + 'place/nearbysearch/json?location=' + $Location + '&' + 'radius=' + $Radius + $(New-GmapQuery -ApiKey $GPlacesApiKey)
        }
        Write-Verbose "Sending Url of $url"        
        $Results = Invoke-RestMethod -Uri $url # Refer to here https://developers.google.com/places/web-service/details for more info about returned properties
        If($Results.status -eq 'OK')
        {
            $Results = $Results.results # get the results from json data returned from Google API
            $Results | Format-GmapPlaceNearby  # send it to function which adds ScriptProperties and ScriptMethods, sets Default Display Set
        }
        else 
        {
            Write-Warning "Did not get succcessful return from Google API"
            $Results            
        }
    }    
}