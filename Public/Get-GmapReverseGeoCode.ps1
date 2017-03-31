Function Get-GmapReverseGeoCode
{
    <#
    .SYNOPSIS
        This function gets address information from either $Latitude and $Longitude or froma $place_id.
    .DESCRIPTION
        This function gets address information from either $Latitude and $Longitude or froma $place_id.
        Uses the Google Places API.
    .EXAMPLE
        Get-GmapReverseGeoCode -place_id 'ChIJbb_okw9gwokRIboIwTqNnj4'
        
        This will get address information from the place_id ChIJbb_okw9gwokRIboIwTqNnj4 which is the Location
        found in the example for Get-GmapPlaceNearby using the keyword cruise.

    .EXAMPLE
        Get-GmapReverseGeoCode -Latitude '-33.8670522' -Longitude '151.1957362'

        This will get address information about a point in Syndey, Australia.

    .NOTES
        Requires an active Google Place API Key. This key should be set to the moduel variable `$GPlacesApiKey.
        Refer to https://developers.google.com/places/web-service/intro
    #>
    [CmdletBinding(DefaultParameterSetName='PlaceID')]
    param 
    (
		[Parameter(Mandatory=$True,
		ValueFromPipelinebyPropertyName=$true, ParameterSetName="Location")]            
        $Latitude,
		[Parameter(Mandatory=$True,
		ValueFromPipelinebyPropertyName=$true, ParameterSetName="Location")]            
        $Longitude,
		[Parameter(Mandatory=$True,
		ValueFromPipelinebyPropertyName=$true, ParameterSetName="PlaceID")]            
        $place_id,        
		[Parameter(Mandatory=$False)]            
        $options         
    )
    Begin{}
    Process
    {
        If($PSCmdlet.ParameterSetName -eq "Location")
        {
            $Location = "$($Latitude),$($Longitude)"
            If($options)
            {
                $url = $BaseUri + 'geocode/json?latlng=' + $Location + '&' + $(New-GmapQuery -ApiKey $GGeoCodeApiKey -options $options)
            }
            else 
            {
                $url = $BaseUri + 'geocode/json?latlng=' + $Location + $(New-GmapQuery -ApiKey $GGeoCodeApiKey)
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
        elseif ($PSCmdlet.ParameterSetName -eq "PlaceID") 
        {
            If($options)
            {
                $url = $BaseUri + 'geocode/json?place_id=' + $place_id + '&' + $(New-GmapQuery -ApiKey $GGeoCodeApiKey -options $options)
            }
            else 
            {
                $url = $BaseUri + 'geocode/json?place_id=' + $place_id + $(New-GmapQuery -ApiKey $GGeoCodeApiKey)
            }
            Write-Verbose "Sending Url of $url"        
            $Results = Invoke-RestMethod -Uri $url # Refer to https://developers.google.com/maps/documentation/geocoding/intro for info about properties returned
            If($Results.status -eq 'OK')
            {
                $Results = $Results.results # get the results from json data returned from Google API
                # $Results
                $Results | Format-GmapGeoResult # send it to function which adds ScriptProperties and ScriptMethods, sets Default Display Set
            }
            else 
            {
                Write-Warning "Did not get succcessful return from Google Geocode API endpoint" 
                $Results  
            }            
        }
    }
    End{}
}