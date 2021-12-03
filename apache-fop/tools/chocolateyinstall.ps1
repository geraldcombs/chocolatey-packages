# IMPORTANT: Before releasing this package, copy/paste the next 2 lines into PowerShell to remove all comments from this file:
#   $f='c:\path\to\thisFile.ps1'
#   gc $f | ? {$_ -notmatch "^\s*#"} | % {$_ -replace '(^.*?)\s*?[^``]#.*','$1'} | Out-File $f+".~" -en utf8; mv -fo $f+".~" $f

$ErrorActionPreference = 'Stop'; # stop on all errors

$fopVersion = '2.6'
$packageName= 'apache-fop' # arbitrary name for the package, used in messages
$toolsDir   = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"
# https://xmlgraphics.apache.org/fop/download.html
# says to download from
# https://dlcdn.apache.org/xmlgraphics/fop/binaries/
# However, that only has the latest versions.
# https://archive.apache.org/dist/xmlgraphics/fop/binaries/
# seems to have a complete set of versions.
$url        = "https://archive.apache.org/dist/xmlgraphics/fop/binaries/fop-$($fopVersion)-bin.zip" # download url
#$url64      = '' # 64bit URL here or remove - if installer is both, use $url
#$fileLocation = Join-Path $toolsDir 'NAME_OF_EMBEDDED_INSTALLER_FILE'
#$fileLocation = Join-Path $toolsDir 'SHARE_LOCATION_OF_INSTALLER_FILE'

$packageArgs = @{
  packageName   = $packageName
  unzipLocation = $toolsDir
  url           = $url
  checksum      = 'e9ba855954ff9e65d27627ce5d8bc0ae03fb8904b97418e61aa42ca1d0360bf72df4a4e0e3c73f5b63a72f2ba7475c258db031269d8b6ffadb5abc1ab73907e2'
  checksumType  = 'sha512'
  #checksum64    = ''
  #checksumType64= 'md5' #default is checksumType
}

## Main helper functions - these have error handling tucked into them already
## see https://github.com/chocolatey/choco/wiki/HelpersReference

Install-ChocolateyZipPackage @packageArgs

Install-BinFile -name 'fop' -path "$toolsDir\fop-$($fopVersion)\fop\fop.bat"
