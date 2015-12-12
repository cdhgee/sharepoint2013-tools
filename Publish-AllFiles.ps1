<#
  .SYNOPSIS
    Publishes multiple files in the specified SharePoint folder.
  .PARAMETER Url
    The full URL of the SharePoint site or sub-site.
  .PARAMETER Folder
    The path to the folder containing the files to publish, relative to the Url parameter.
  .PARAMETER Comment
    An optional comment to provide when checking in and publishing files.
  .PARAMETER Filter
    An optional filename filter to use when selecting which files to publish.
  .DESCRIPTION
    Publishes multiple files located in a SharePoint folder, optionally filtering by filename, and optionally providing a comment for check-in and publish. Primarily intended for use within SharePoint publishing sites.
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
  [string]$Url,
  [Parameter(Mandatory=$true)]
  [string]$Folder,
  [string]$Comment,
  [string]$Filter
)

Function main
{
  $web = Get-SPWeb $Url

  If($web -eq $null)
  {
    Write-Error "Invalid url $Url"
  }
  Else
  {
    $folder = $web.GetFolder($Folder)
    If(-not ($folder.Exists))
    {
      Write-Error "Invalid folder $Folder"
    }
    Else
    {
      Foreach($file in $folder.Files)
      {
        If($file.Name -match $Filter)
        {
          Write-Host $file.Url
          If($file.Level -ne "Published")
          {
            If($file.Level -eq "CheckOut")
            {
              $file.CheckIn($Comment, [Microsoft.SharePoint.SPCheckinType]::MajorCheckIn)
            }
            $file.Publish($Comment)
            $file.Update()
          }
        }
      }
    }


  }

}

main
