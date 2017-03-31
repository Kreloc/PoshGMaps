Function Get-GmapDirections
{
    <#
    .SYNOPSIS
        This function gets directions from the address provided to the Start parameter to the address provided to the End parameter.
    .DESCRIPTION
        This function gets directions from the address provided to the Start parameter to the address provided to the End parameter.
        Uses the Google Maps Directions API. 
    .EXAMPLE
        Get-GmapDirections -Start "123 Main St, New York, NY" -End "Domino's Pizza, 14909 Northern Blvd, NY"
        Will return an object of the results from the Google Directions API. This will be formatted to display only certain properties.

    .EXAMPLE
        $Directions = Get-GmapDirections -Start "123 Main St, New York, NY" -End "Domino's Pizza, 14909 Northern Blvd, NY"
        $Directions.CreateDirectionFile()
        Invoke-Item "$HOME\Documents\directions.html"

        This will get the directions between those two addresses and store it in a variable.
        Then the CreateDirectionFile method is called on that variable to create a barebones HTML file that has the directions from Google.

    .EXAMPLE
        $Directions = Get-GmapDirections -Start "123 Main St, New York, NY" -End "Domino's Pizza, 14909 Northern Blvd, NY" -options '{"mode":"transit"}'
        $Directions

        This will get the directions using the Travel Mode of Transit that is specified using the options paramater. All of the functions in this module
        support the options parameter, which take json as input, and set each of them to parameters for the actual Google API query.

    .EXAMPLE
        $Directions = Get-GmapDirections -Start "123 Main St, New York, NY" -End "Domino's Pizza, 14909 Northern Blvd, NY" -options '{"mode":"bicycling","units":"metric"}'
        $Directions

        This will get the directions using the Travel Mode of bicycling that is specified using the options paramater. All of the functions in this module
        support the options parameter, which take json as input, and set each of them to parameters for the actual Google API query. The added option is
        to return units in metric. This is to demonstrate how to send mutliple items to the options parameter.  

    .NOTES
        Requires an active Google Directions API Key. Should be set in the module file for variable `$GDirectionsApiKey.
        Refer to https://developers.google.com/maps/documentation/directions/start
    #>
    [CmdletBinding()]
    param 
    (
		[Parameter(Mandatory=$False,
		ValueFromPipeline=$True, ValueFromPipelinebyPropertyName=$true)]            
        [string]$Start,
		[Parameter(Mandatory=$False,
		ValueFromPipeline=$True, ValueFromPipelinebyPropertyName=$true)]            
        [string]$End,        
		[Parameter(Mandatory=$False)]            
        $options         
    )
    Begin{}
    Process
    {
        If($options)
        {
            $url = $BaseUri + 'directions/json?origin=' + $Start + '&destination=' + $End + '&' + $(New-GmapQuery -ApiKey $GDirectionsApiKey -options $options)
        }
        else 
        {
            $url = $BaseUri + 'directions/json?origin=' + $Start + '&destination=' + $End + $(New-GmapQuery -ApiKey $GDirectionsApiKey)
        }
        Write-Verbose "Sending Url of $url"        
        $Results = Invoke-RestMethod -Uri $url # Refer to here https://developers.google.com/maps/documentation/directions/start for more info about returned properties
        If($Results.status -eq 'OK')
        {
            $Results = $Results.routes
            $Results | Format-GmapDirection  # send it to function which adds ScriptProperties and ScriptMethods, sets Default Display Set
        }
        else 
        {
            Write-Warning "Did not get succcessful return from Google API"
            $Results            
        }
    }     
}