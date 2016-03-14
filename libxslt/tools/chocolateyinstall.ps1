# IMPORTANT: Before releasing this package, copy/paste the next 2 lines into PowerShell to remove all comments from this file:
#   $f='c:\path\to\thisFile.ps1'
#   gc $f | ? {$_ -notmatch "^\s*#"} | % {$_ -replace '(^.*?)\s*?[^``]#.*','$1'} | Out-File $f+".~" -en utf8; mv -fo $f+".~" $f

$ErrorActionPreference = 'Stop'; # stop on all errors

$libxsltVersion = '1.1.26'
$packageName= 'libxslt' # arbitrary name for the package, used in messages
$toolsDir   = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"
$url        = "ftp://ftp.zlatkovic.com/libxml/libxslt-$($libxsltVersion).win32.zip" # download url
# The 64-bit packages in ftp://ftp.zlatkovic.com/libxml/64bit/ have different
# versions *and* file extensions. Stick with 32-bit only for now.
#$url64      = '' # 64bit URL here or remove - if installer is both, use $url
#$fileLocation = Join-Path $toolsDir 'NAME_OF_EMBEDDED_INSTALLER_FILE'
#$fileLocation = Join-Path $toolsDir 'SHARE_LOCATION_OF_INSTALLER_FILE'

$packageArgs = @{
  packageName   = $packageName
  unzipLocation = $toolsDir
  url           = $url
  checksum      = '9ed852563c6f793f59e461ae5045b03fa5acc569'
  checksumType  = 'sha1' #default is md5, can also be sha1
  #checksum64    = ''
  #checksumType64= 'md5' #default is checksumType
}

## Main helper functions - these have error handling tucked into them already
## see https://github.com/chocolatey/choco/wiki/HelpersReference

Install-ChocolateyZipPackage @packageArgs

Install-BinFile -name 'xsltproc' -path "$toolsDir\libxslt-$($libxsltVersion).win32\bin\xsltproc.exe"
