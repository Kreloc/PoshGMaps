# PoshGMaps
A PowerShell Module for Google Maps APIs
#Instructions

```powershell
# One time setup
    # Download the repository
    # Unblock the zip
    # Extract the PoshGMaps folder to a module path (e.g. $env:USERPROFILE\Documents\WindowsPowerShell\Modules\)

    #Simple alternative, if you have PowerShell 5, or the PowerShellGet module:
        Install-Module PoshGMaps

# Import the module.
    Import-Module PoshGMaps    #Alternatively, Import-Module \\Path\To\PoshGMaps

# Get commands in the module
    Get-Command -Module PoshGMaps
    
# Create API Keys on Google
  # Create an API keys for the following Google APIs:
  # https://developers.google.com/places/web-service/intro
  # https://developers.google.com/maps/documentation/directions/start
  # https://developers.google.com/maps/documentation/geocoding/intro
  
# Set those API Keys in the PoshGMaps.psm1 file to the approriate variables.
