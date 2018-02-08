# IMPORTANT: Before releasing this package, copy/paste the next 2 lines into PowerShell to remove all comments from this file:
#   $f='c:\path\to\thisFile.ps1'
#   gc $f | ? {$_ -notmatch "^\s*#"} | % {$_ -replace '(^.*?)\s*?[^``]#.*','$1'} | Out-File $f+".~" -en utf8; mv -fo $f+".~" $f

$ErrorActionPreference = 'Stop'; # stop on all errors

$xsltprocVersion = '1.1.28'
$bundleVersion = "1"

$packageName= 'xsltproc' # arbitrary name for the package, used in messages
$toolsDir   = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"
# The canonical URL is ftp://ftp.zlatkovic.com/libxml/64bit/, however:
# Chocolatey may not support FTP
# The "packages" are a kit of disparate parts that you have to assemble
# yourself.
$url32        = "https://github.com/geraldcombs/chocolatey-packages/releases/download/xsltproc-1.1.28.1/xsltproc-1.1.28-1-win32.zip"
$sha256sum32  = "b16cc1614ceb42d277f8765dbfb0661e17172af1d008e1a343dced63d910fa6f"
$url64        = "https://github.com/geraldcombs/chocolatey-packages/releases/download/xsltproc-1.1.28.1/xsltproc-1.1.28-1-win64.zip"
$sha256sum64  = "1b2dc264c0994a2c62842921ca2d97da960cf3a609a337ede4e0d32855ffd837"

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

$winBits = 64
if ((Get-ProcessorBits 32) -or $env:ChocolateyForceX86 -eq 'true') {
  $winBits = 32
}
$xsltprocPath = "$toolsDir\xsltproc-$($xsltprocVersion)-$($bundleVersion)-win$($winBits)\xsltproc"
New-Item "$xsltprocPath.exe.ignore" -type file -force | Out-Null

Install-BinFile -name "xsltproc" -path "$xsltprocPath.bat"
