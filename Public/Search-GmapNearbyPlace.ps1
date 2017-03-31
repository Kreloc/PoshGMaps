Function Search-GmapNearbyPlace
{
    <#
    .SYNOPSIS
        This will send a text query and return an object of place information back.
    .DESCRIPTION
        This will send a text query and return an object of place information back.
        Uses the Google Places API.
    .EXAMPLE
        Search-GmapNearbyPlace -Query "Pizza in New York"

        This will send a text query of "Pizza in New York" to the Google Places textsearch API endpoint.
        The object(s) returned will have information about the places found.
    
    .EXAMPLE
        Get-GmapGeoCode -Address "123 Main St, New York, NY" | Search-GmapNearbyPlace -Query "Pizza in New York" -Radius 250 -Verbose

        First the Get-GmapGeoCode function is run for that adddress. The object returned (which has Latitude and Longitude property) is then piped to this function.
        The Latitude and Longitude parameters require a Radius parameter, which was specified as 250. Which should find matches within 250 meters. The -Verbose parameter
        is used to display the Write-Verbose messages. All of the functions in this module support the -Verbose parameter.

    .NOTES
        Requires an active Google Place API Key. This key should be set to the moduel variable `$GPlacesApiKey.
        Refer to https://developers.google.com/places/web-service/intro
    #>
    [CmdletBinding()]
    param 
    (
		[Parameter(Mandatory=$True)]            
        $Query,
		[Parameter(Mandatory=$False,
		ValueFromPipelinebyPropertyName=$true,ParameterSetName="Location")]          
        $Latitude,
		[Parameter(Mandatory=$False,
		ValueFromPipelinebyPropertyName=$true,ParameterSetName="Location")]            
        $Longitude,
		[Parameter(Mandatory=$True,ParameterSetName="Location")]            
        $Radius,        
		[Parameter(Mandatory=$False)]            
        $options         
    )
    Begin{}
    Process
    {
        If($PSCmdlet.ParameterSetName -eq "Location")
        {
            $Location = "$($Latitude),$($Longitude)"
            Write-Verbose "Using location of $Location"
            If($options)
            {
                $url = $BaseUri + 'place/textsearch/json?query=' + $Query + '&' + 'location=' + $Location + '&' + 'radius=' + $Radius + $(New-GmapQuery -ApiKey $GPlacesApiKey -options $options)
            }
            else 
            {
                $url = $BaseUri + 'place/textsearch/json?query=' + $Query  + '&' + 'location=' + $Location + '&' + 'radius=' + $Radius + $(New-GmapQuery -ApiKey $GPlacesApiKey)
            }
            Write-Verbose "Sending Url of $url"        
            $Results = Invoke-RestMethod -Uri $url # Refer to here https://developers.google.com/places/web-service/details for more info about returned properties
            If($Results.status -eq 'OK')
            {
                $Results = $Results.results # get the results from json data returned from Google API
                $Results | Format-GmapPlaceSearch  # send it to function which adds ScriptProperties and ScriptMethods, sets Default Display Set
            }
            else 
            {
                Write-Warning "Did not get succcessful return from Google API"
                $Results            
            }            
        }
        else 
        {
            If($options)
            {
                $url = $BaseUri + 'place/textsearch/json?query=' + $Query + '&' + 'radius=' + $Radius + $(New-GmapQuery -ApiKey $GPlacesApiKey -options $options)
            }
            else 
            {
                $url = $BaseUri + 'place/textsearch/json?query=' + $Query + '&' + 'radius=' + $Radius + $(New-GmapQuery -ApiKey $GPlacesApiKey)
            }
            Write-Verbose "Sending Url of $url"        
            $Results = Invoke-RestMethod -Uri $url # Refer to here https://developers.google.com/places/web-service/details for more info about returned properties
            If($Results.status -eq 'OK')
            {
                $Results = $Results.results # get the results from json data returned from Google API
                $Results | Format-GmapPlaceSearch  # send it to function which adds ScriptProperties and ScriptMethods, sets Default Display Set
            }
            else 
            {
                Write-Warning "Did not get succcessful return from Google API"
                $Results            
            }
        }

    }    
}