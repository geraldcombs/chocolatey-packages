# IMPORTANT: Before releasing this package, copy/paste the next 2 lines into PowerShell to remove all comments from this file:
#   $f='c:\path\to\thisFile.ps1'
#   gc $f | ? {$_ -notmatch "^\s*#"} | % {$_ -replace '(^.*?)\s*?[^``]#.*','$1'} | Out-File $f+".~" -en utf8; mv -fo $f+".~" $f

$ErrorActionPreference = 'Stop'; # stop on all errors

$packageName        = 'docbook-bundle'
$catalogDir         = "$env:chocolateyinstall\lib\$packageName"
$docbookXmlUrl      = 'http://www.docbook.org/xml/5.0/docbook-5.0.zip'
$docbookXmlSha256   = '3dcd65e1f5d9c0c891b3be204fa2bb418ce485d32310e1ca052e81d36623208e'
$docbookXslNsUrl    = 'https://sourceforge.net/projects/docbook/files/docbook-xsl-ns/1.79.1/docbook-xsl-ns-1.79.1.zip/download'
$docbookXslNsSha256 = 'bea820a5522a161ffb077122c7018f750018e292c165ee5148ae649eea1341ec'
$docbookXslUrl      = 'https://sourceforge.net/projects/docbook/files/docbook-xsl/1.79.1/docbook-xsl-1.79.1.zip/download'
$docbookXslSha256   = '720e3158bd6d743a6a919ac470d21048244f0755ecd621d9200c1cb7134e0d48'

$docbookXmlPackageArgs = @{
  packageName   = 'docbook-xml'
  unzipLocation = $catalogDir
  url           = $docbookXmlUrl
  checksum      = $docbookXmlSha256
  checksumType  = 'sha256'
}

$docbookXslNsPackageArgs = @{
  packageName   = 'docbook-xsl-ns'
  unzipLocation = $catalogDir
  url           = $docbookXslNsUrl
  checksum      = $docbookXslNsSha256
  checksumType  = 'sha256'
}

$docbookXslPackageArgs = @{
  packageName   = 'docbook-xsl'
  unzipLocation = $catalogDir
  url           = $docbookXslUrl
  checksum      = $docbookXslSha256
  checksumType  = 'sha256'
}

## Main helper functions - these have error handling tucked into them already
## see https://github.com/chocolatey/choco/wiki/HelpersReference

Install-ChocolateyZipPackage @docbookXmlPackageArgs
Install-ChocolateyZipPackage @docbookXslNsPackageArgs
Install-ChocolateyZipPackage @docbookXslPackageArgs
