# IMPORTANT: Before releasing this package, copy/paste the next 2 lines into PowerShell to remove all comments from this file:
#   $f='c:\path\to\thisFile.ps1'
#   gc $f | ? {$_ -notmatch "^\s*#"} | % {$_ -replace '(^.*?)\s*?[^``]#.*','$1'} | Out-File $f+".~" -en utf8; mv -fo $f+".~" $f

$ErrorActionPreference = 'Stop'; # stop on all errors

$xsltprocVersion = '1.1.28'
$packageName= 'xsltproc' # arbitrary name for the package, used in messages
$toolsDir   = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"
# The canonical URL is ftp://ftp.zlatkovic.com/libxml/64bit/, however:
# Chocolatey may not support FTP
# The "packages" are a kit of disparate parts that you have to assemble
# yourself.
$url32        = "https://cdn.rawgit.com/geraldcombs/chocolatey-packages/xsltproc-1.1.28/xsltproc-1.1.28-win32.zip"
$sha256sum32  = "eedb8f0195c25772abbb9a26264faf90052bb4ba935c6be95bd382c306e6ada8"
$url64        = "https://cdn.rawgit.com/geraldcombs/chocolatey-packages/xsltproc-1.1.28/xsltproc-1.1.28-win64.zip"
$sha256sum64  = "01c98a679c259ab4593074b96b3882921ce6bcdaaf7511912c59b9627a3563a8"

$packageArgs = @{
  packageName     = $packageName
  unzipLocation   = $toolsDir
  url             = $url32
  checksum        = $sha256sum32
  checksumType    = 'sha256'
  url64bit        = $url64
  checksum64      = $sha256sum64
  checksumType64  = 'sha256'
}

## Main helper functions - these have error handling tucked into them already
## see https://github.com/chocolatey/choco/wiki/HelpersReference

Install-ChocolateyZipPackage @packageArgs

if ((Get-ProcessorBits 32) -or $env:ChocolateyForceX86 -eq 'true') {
  Install-BinFile -name 'xsltproc' -path "$toolsDir\xsltproc-$($xsltprocVersion)-win32\xsltproc.exe"
} else {
  Install-BinFile -name 'xsltproc' -path "$toolsDir\xsltproc-$($xsltprocVersion)-win64\xsltproc.exe"
}
