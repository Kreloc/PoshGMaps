#region variables used in Module Functions
$script:GGeoCodeApiKey = "YOUR_APIKEY"
$script:GPlacesApiKey = "YOUR_APIKEY"
$script:GDirectionsApiKey = "YOUR_APIKEY"
$script:BaseURI = "https://maps.googleapis.com/maps/api/"
#endregion variables used in Module Functions
If($script:GGeoCodeApiKey -eq "YOUR_APIKEY" -or $script:GPlacesApiKey -eq "YOUR_APIKEY" -or $script:GDirectionsApiKey -eq "YOUR_APIKEY")
{
   Write-Host "Refer to the Google API documentation for creating API Keys needed for this module. Refere to these sites`n
https://developers.google.com/places/web-service/intro `n
https://developers.google.com/maps/documentation/directions/start `n
https://developers.google.com/maps/documentation/geocoding/intro `n
"
}
If($script:GGeoCodeApiKey -eq "YOUR_APIKEY")
{
    $script:GGeoCodeApiKey = Read-Host "Please enter your Google GeoCode API Key. To not get this message every time the module is imported,`n set the `$script:GGeoCodeApiKey to your key in the PoshGMaps.psm1 file"
}
If($script:GPlacesApiKey -eq "YOUR_APIKEY")
{
    $script:GPlacesApiKey = Read-Host "Please enter your Google Places API Key. To not get this message every time the module is imported,`n set the `$script:GPlacesApiKey to your key in the PoshGMaps.psm1 file"
}
If($script:GDirectionsApiKey -eq "YOUR_APIKEY")
{
    $script:GDirectionsApiKey = Read-Host "Please enter your Google Directions API Key. To not get this message every time the module is imported,`n set the `$script:GDirectionsApiKey to your key in the PoshGMaps.psm1 file"
}
#Get public and private function definition files.
    $Public  = @( Get-ChildItem -Path $PSScriptRoot\Public\*.ps1 -ErrorAction SilentlyContinue )
    $Private = @( Get-ChildItem -Path $PSScriptRoot\Private\*.ps1 -ErrorAction SilentlyContinue )

#Dot source the files
    Foreach($import in @($Public + $Private))
    {
        Try
        {
            . $import.fullname
        }
        Catch
        {
            Write-Error -Message "Failed to import function $($import.fullname): $_"
        }
    }

# Here I might...
    # Read in or create an initial config file and variable
    # Export Public functions ($Public.BaseName) for WIP modules
    # Set variables visible to the module and its functions only

Export-ModuleMember -Function $Public.Basename