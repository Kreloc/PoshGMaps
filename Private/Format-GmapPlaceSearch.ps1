Function Format-GmapPlaceSearch
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
        $Results.PSTypeNames.Insert(0,"Gmap.PlaceSearch")
        # Create easier to understand properties out of result but leave original stuff intact
        Update-TypeData -TypeName "Gmap.PlaceSearch" -MemberType ScriptProperty -MemberName Address -Value {$this.formatted_address} -Force
        Update-TypeData -TypeName "Gmap.PlaceSearch" -MemberType ScriptProperty -MemberName Open -Value {If($this.opening_hours.open_now){"Open"}elseif($this.opening_hours.open_now -eq $False){"Closed"}else{"Hours Not Found"}} -Force
        # Set a default display of the above properties, all other properites are still there just not displayed
        Update-TypeData -TypeName "Gmap.PlaceSearch" -DefaultDisplayPropertySet Address, name, price_level, rating, Open -DefaultKeyPropertySet place_id -Force
        $Results
    }    
}