<#
  .SYNOPSIS
    Lists each site collection within the specified web application and the status of the specified feature for each.
  .PARAMETER WebApplication
    The full URL of the web application.
  .PARAMETER Feature
    The site-collection scoped feature, specified either as a feature name or GUID.
  .NOTES
    Author: David Gee
    Date: 12th December 2015
    License: GNU General Public License, Version 3
  .LINK
    License: https://github.com/cdhgee/sharepoint2013-tools/blob/master/LICENSE

#>

[CmdletBinding()]
Param(
  [Parameter(Mandatory=$True)]
  [ValidateSet("Farm","WebApplication","SiteCollection","Site")]
  [string]$Scope,
  [string]$Url,
  [string]$Feature
)


Function main
{
  Add-PSSnapin Microsoft.SharePoint.Powershell -ErrorAction SilentlyContinue

  $scopeMappings = @{
    Farm = "Farm"
    WebApplication = "WebApplication"
    SiteCollection = "Site"
    Site = "Web"
  }

  $params = @{Identity = $Feature; $scopeMappings[$Scope] = $Location; ErrorAction = "SilentlyContinue"}
  $params

  $feat = Get-SPFeature @params
  $enabled = $feat -ne $null

  New-Object PSObject -Property @{
    $Scope = $Location
    Enabled = $enabled
  }

}


main
