Function Format-GmapDirection
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
        $Results.PSTypeNames.Insert(0,"Gmap.Direction")
        # Create easier to understand properties out of result but leave original stuff intact
        Update-TypeData -TypeName "Gmap.Direction" -MemberType ScriptProperty -MemberName Duration -Value {$this.legs.duration.text} -Force
        Update-TypeData -TypeName "Gmap.Direction" -MemberType ScriptProperty -MemberName Distance -Value {$this.legs.distance.text} -Force
        Update-TypeData -TypeName "Gmap.Direction" -MemberType ScriptProperty -MemberName StartAddress -Value {$this.legs.start_address} -Force
        Update-TypeData -TypeName "Gmap.Direction" -MemberType ScriptProperty -MemberName EndAddress -Value {$this.legs.end_address} -Force
        Update-TypeData -TypeName "Gmap.Direction" -MemberType ScriptProperty -MemberName TravelMode -Value {$(($this.legs.steps[0]).travel_mode)} -Force
        # create html page of steps using method
        Update-TypeData -TypeName "Gmap.Direction" -MemberType ScriptMethod -MemberName CreateDirectionFile -Value {
                                                                                                                        $EndHTML = @()
                                                                                                                        $EndHTML += '<html><body class="drive">'
                                                                                                                        $DirectionTestFormat.legs.steps | ForEach-Object {
                                                                                                                            $EndHTML += $_.html_instructions
                                                                                                                        }
                                                                                                                        $EndHTML += '</body></html>'
                                                                                                                        $EndHTML | Out-File "$HOME\Documents\directions.html"
                                                                                                                    } -Force
        # Set a default display of the above properties, all other properites are still there just not displayed
        Update-TypeData -TypeName "Gmap.Direction" -DefaultDisplayPropertySet Duration, Distance, StartAddress, EndAddress, TravelMode -DefaultKeyPropertySet place_id -Force
        $Results
    }     
}