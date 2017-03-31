Function New-GmapQuery
{
    [CmdletBinding()]
    param 
    (
		[Parameter(Mandatory=$True,
		ValueFromPipeline=$True, ValueFromPipelinebyPropertyName=$true)]            
        [string]$ApiKey,
		[Parameter(Mandatory=$False)]            
        $options         
    )
    Begin{}
    Process
    {
        If($options)
        {
            try 
            {
            $jsonObj = $options | ConvertFrom-Json -ErrorAction Stop
            }
            catch 
            {
                throw "Please enter a Here-String or json file as input for `$options"
            }
            $optionsQuery = ''
            $Properties = $jsonObj |
            Get-Member |
            Where-Object {$_.MemberType -like "NoteProperty"} |
            Select-Object -ExpandProperty Name
            ForEach($property in $Properties)
            {
                $optionsQuery = $optionsQuery + "&" + $property + "=" + $jsonObj.$($property)
            }
            # Remove leadinng & , add in actual function instead
            $Options = $optionsQuery.TrimStart("&")
            $KeyString = $options + '&key=' + $ApiKey
        }
        else 
        {
            $KeyString = '&key=' + $ApiKey            

        }
        $KeyString # return the keystring
    } 
    End{}
}