Function Format-GmapGeoResult
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
        $Results.PSTypeNames.Insert(0,"Gmap.GeoCode")
        # Create easier to understand properties out of result but leave original stuff intact
        Update-TypeData -TypeName "Gmap.GeoCode" -MemberType ScriptProperty -MemberName StreetNumber -Value {$(($this.address_components | Where {$_.types -contains "street_number"}).long_name)} -Force
        Update-TypeData -TypeName "Gmap.GeoCode" -MemberType ScriptProperty -MemberName Street -Value {$($this.address_components | Where {$_.types -contains "route"}).long_name} -Force
        Update-TypeData -TypeName "Gmap.GeoCode" -MemberType ScriptProperty -MemberName City -Value {$($this.address_components | Where {$_.types -contains "locality"}).long_name} -Force
        Update-TypeData -TypeName "Gmap.GeoCode" -MemberType ScriptProperty -MemberName Country -Value {$($this.address_components | Where {$_.types -contains "country"}).long_name} -Force
        Update-TypeData -TypeName "Gmap.GeoCode" -MemberType ScriptProperty -MemberName PostalCode -Value {$($this.address_components | Where {$_.types -contains "postal_code"}).long_name} -Force
        Update-TypeData -TypeName "Gmap.GeoCode" -MemberType ScriptProperty -MemberName Latitude -Value {$this.geometry.location.lat} -Force
        Update-TypeData -TypeName "Gmap.GeoCode" -MemberType ScriptProperty -MemberName Longitude -Value {$this.geometry.location.lng} -Force
        # Set a default display of the above properties, all other properites are still there just not displayed
        Update-TypeData -TypeName "Gmap.GeoCode" -DefaultDisplayPropertySet StreetNumber, Street, City, Country, PostalCode -DefaultKeyPropertySet place_id -Force
        $Results
    }
}