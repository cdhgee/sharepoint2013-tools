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
  [Parameter(ParameterSetName="WebApplication")]
  [string]$IncludeCentralAdministration=$false,
  [Parameter(ParameterSetName="SiteCollection", Mandatory=$true)]
  [string]$WebApplication,
  [Parameter(ParameterSetName="Site", Mandatory=$true)]
  [string]$SiteCollection,
  [Parameter(ParameterSetName="Farm",Mandatory=$true)]
  [Parameter(ParameterSetName="WebApplication", Mandatory=$true)]
  [Parameter(ParameterSetName="SiteCollection", Mandatory=$true)]
  [Parameter(ParameterSetName="Site", Mandatory=$true)]
  [string]$Feature
)

Function Get-FeatureStatus
{
  [CmdletBinding()]
  Param(
    [BalidateSet("Farm","WebApplication","SiteCollection","Site")]
    $Scope,
    $Location
  )

  $scopeMappings = @{
    Farm = "Farm"
    WebApplication = "WebApplication"
    SiteCollection = "Site"
    Site = "Web"
  }

  $params = @{Identity = $Feature; $scopeMappings[$Scope] = $Location; ErrorAction = SilentlyContinue}

  $feat = Get-SPFeature @params
  $enabled = $feat -ne $null
  New-Object PSObject -Property @{
    $Scope = $ScopeLocation
    Enabled = $enabled
  }
}

Function Get-FarmFeatures
{
  Get-FeatureStatus -Scope Farm -Location $True
}

Function Get-WebApplicationFeatures
{
  $webapps = Get-SPWebApplication -IncludeCentralAdministration:$IncludeCentralAdministration

  Foreach($webapp in $webapps)
  {
    Get-FeatureStatus -Scope WebApplication -Location $webapp
  }
}

Function Get-SiteCollectionFeatures
{
  $webapp = Get-SPWebApplication $WebApplication

  Foreach($site in $webapp.Sites)
  {
    Get-FeatureStatus -Scope SiteCollection -Location $_
  }
}

Function Get-SiteFeatures
{
  $sitecoll = Get-SPSiteCollection $SiteCollection

  Foreach($web in $sitecoll.AllWebs)
  {
    Get-FeatureStatus -Scope SiteCollection -Location $web
  }
}

Function main
{
  Import-PSSnapin Microsoft.SharePoint.Powershell -ErrorAction SilentlyContinue

  Switch($PSCmdlet.ParameterSetName)
  {
    "Farm"
    {
      Get-FarmFeatures
    }
    "WebApplication"
    {
      Get-WebApplicationFeatures
    }
    "SiteCollection"
    {
      Get-SiteCollectionFeatures
    }
    "Site"
    {
      Get-SiteFeatures
    }
  }
}


main
