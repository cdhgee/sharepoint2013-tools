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
  [Parameter(Mandatory=$true)]
  [string]$WebApplication,
  [Parameter(Mandatory=$true)]
  [string]$Feature
)


Function main
{
  Import-PSSnapin Microsoft.SharePoint.Powershell -ErrorAction SilentlyContinue

  $webapp = Get-SPWebApplication $webappurl

  Foreach($site in $webapp.Sites)
  {
    $feature = Get-SPFeature -Identity $Feature -Site $_ -ErrorAction SilentlyContinue
    $enabled = $feat -ne $null
    New-Object PSObject -Property @{
      Site = $_.Url
      Enabled = $enabled
    }
  }
}


main
