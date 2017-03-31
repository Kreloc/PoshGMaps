Function Format-GmapPlaceNearby
{
    [CmdletBinding()]
    param 
    (
		[Parameter(Mandatory=$False,
		ValueFromPipeline=$True)]            
        $Results
    )
    Process
    { 
            $Results.PSTypeNames.Insert(0,"Gmap.NearbyPlace")
            # Create easier to understand properties out of result but leave original stuff intact
            # Update-TypeData -TypeName "Gmap.NearbyPlace" -MemberType ScriptProperty -MemberName Address -Value {$this.formatted_address} -Force
            # Create a method to open the Google Map address returned
            # Update-TypeData -TypeName "Gmap.NearbyPlace" -MemberType ScriptMethod -MemberName OpenMap -Value {Start-Process "$($this.url)"} -Force # Should open in default browser
            # Set a default display of the above properties, all other properites are still there just not displayed
            Update-TypeData -TypeName "Gmap.NearbyPlace" -DefaultDisplayPropertySet name, vicinity, place_id -DefaultKeyPropertySet place_id -Force
            $Results
    }    
}