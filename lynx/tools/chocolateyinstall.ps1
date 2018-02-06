# IMPORTANT: Before releasing this package, copy/paste the next 2 lines into PowerShell to remove all comments from this file:
#   $f='c:\path\to\thisFile.ps1'
#   gc $f | ? {$_ -notmatch "^\s*#"} | % {$_ -replace '(^.*?)\s*?[^``]#.*','$1'} | Out-File $f+".~" -en utf8; mv -fo $f+".~" $f

$ErrorActionPreference = 'Stop'; # stop on all errors

$lynxVersion = '2.8.8'
$packageName= 'lynx-sl-stable' # arbitrary name for the package, used in messages
$toolsDir    = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"
# Which is the preferred mirror? There are many listed at
# http://www.apache.org/dyn/closer.cgi/xmlgraphics/fop
$url32        = "https://invisible-island.net/datafiles/release/lynx-sl-setup.exe" # download url
$sha256sum32  = "f0772ba3e6d1d7b24492ed20017a143d2b846f52981fd8e9a2173adf73441bde"
#$url64      = '' # 64bit URL here or remove - if installer is both, use $url
#$fileLocation = Join-Path $toolsDir 'NAME_OF_EMBEDDED_INSTALLER_FILE'
#$fileLocation = Join-Path $toolsDir 'SHARE_LOCATION_OF_INSTALLER_FILE'

## Main helper functions - these have error handling tucked into them already
## see https://github.com/chocolatey/choco/wiki/HelpersReference

$packageArgs = @{
  packageName            = $packageName
  fileType               = 'EXE'
  url	                   = $url32
  checksum               = $sha256sum32
  checksumType           = 'sha256'
  #silentArgs             = '/S /quicklaunchicon=no'
  validExitCodes         = @(0)
  registryUninstallerKey = $packageName
}

Install-ChocolateyPackage @packageArgs
