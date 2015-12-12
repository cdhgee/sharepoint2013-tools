<#
  .SYNOPSIS
    Disables SharePoint designer and other related settings for the specified web application.
  .PARAMETER WebApplication
    The full URL of the SharePoint web application.
  .DESCRIPTION
    Disables SharePoint designer, as well as the following related SPD settings: managing site URL structure, detaching pages from the site definition, and customizing master pages and layout pages.
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
  [string]$WebApplication
)

Function main
{

  $wa = Get-WebApplication $WebApplication

  If($wa -ne $null)
  {
    Foreach($site in $wa.Sites)
    {
      $site.AllowDesigner = $false
      $site.ShowURLStructure = $false
      $site.AllowRevertFromTemplate = $false
      $site.AllowMasterPageEditing = $false
      Set-SPSite -Identity $site
    }
  }
  Else
  {
    Write-Error "Invalid web application URL $WebApplication"
  }

}

main
