Function Get-GmapPlaceDetails
{
    <#
    .SYNOPSIS
        This function gets information about a place_id returned by Google or provided by the person running the function.
    .DESCRIPTION
        This function gets information about a place_id returned by Google or provided by the person running the function.
        Uses the Google Places API Web Service.
    .EXAMPLE
        Get-GmapGeoCode -Address "123 Main St, New York, NY" | Get-GmapPlaceDetails
        This first runs the function Get-GmapGeoCode which the object returned will have a place_id property. That object is then piped
        to this function, to return addition details about that location from the Google Places API.

    .EXAMPLE
        $Details = Get-GmapGeoCode -Address "123 Main St, New York, NY" | Get-GmapPlaceDetails
        $Details | Format-List *
        $Details.OpenMap()

        This stores the information into a variable. Then that variable is piped to Format-List * to show the additional properites that are returned.
        Then the OpenMap() method is called from that variable which will open a Google Map in the default browser on the computer running this function.

    .NOTES
        Requires an active Google Place API Key. This key should be set to the moduel variable `$GPlacesApiKey.
        Refer to https://developers.google.com/places/web-service/intro
    #>
    [CmdletBinding()]
    param 
    (
		[Parameter(Mandatory=$False,
		ValueFromPipeline=$True, ValueFromPipelinebyPropertyName=$true)]            
        [string]$place_id,
		[Parameter(Mandatory=$False)]            
        $options         
    )
    Begin{}
    Process
    {
        If($options)
        {
            $url = $BaseUri + 'place/details/json?placeid=' + $place_id + '&' + $(New-GmapQuery -ApiKey $GPlacesApiKey -options $options)
        }
        else 
        {
            $url = $BaseUri + 'place/details/json?placeid=' + $place_id + $(New-GmapQuery -ApiKey $GPlacesApiKey)
        }
        Write-Verbose "Sending Url of $url"        
        $Results = Invoke-RestMethod -Uri $url # Refer to here https://developers.google.com/places/web-service/details for more info about returned properties
        If($Results.status -eq 'OK')
        {
            $Results = $Results.result # get the result from json data returned from Google API
            $Results | Format-GmapPlaceDetail # send it to function which adds ScriptProperties and ScriptMethods, sets Default Display Set
        }
        else 
        {
            Write-Warning "Did not get succcessful return from Google API"
            $Results            
        }
    }    
}