# IMPORTANT: Before releasing this package, copy/paste the next 2 lines into PowerShell to remove all comments from this file:
#   $f='c:\path\to\thisFile.ps1'
#   gc $f | ? {$_ -notmatch "^\s*#"} | % {$_ -replace '(^.*?)\s*?[^``]#.*','$1'} | Out-File $f+".~" -en utf8; mv -fo $f+".~" $f

$ErrorActionPreference = 'Stop'; # stop on all errors

$packageName        = 'docbook-bundle'
$catalogDir         = "$env:chocolateyinstall\lib\$packageName"
$docbookXmlUrl      = 'https://www.docbook.org/xml/5.0/docbook-5.0.zip'
$docbookXmlSha256   = '3dcd65e1f5d9c0c891b3be204fa2bb418ce485d32310e1ca052e81d36623208e'
$docbookXslNoNsUrl  = 'https://github.com/docbook/xslt10-stylesheets/releases/download/release%2F1.79.2/docbook-xsl-nons-1.79.2.zip'
$docbookXslNoNsSha256 = 'ba41126fbf4021e38952f3074dc87cdf1e50f3981280c7a619f88acf31456822'
$docbookXslUrl      = 'https://github.com/docbook/xslt10-stylesheets/releases/download/release%2F1.79.2/docbook-xsl-1.79.2.zip'
$docbookXslSha256   = '853dce096f5b32fe0b157d8018d8fecf92022e9c79b5947a98b365679c7e31d7'

$docbookXmlPackageArgs = @{
  packageName   = 'docbook-xml'
  unzipLocation = $catalogDir
  url           = $docbookXmlUrl
  checksum      = $docbookXmlSha256
  checksumType  = 'sha256'
}

$docbookXslNoNsPackageArgs = @{
  packageName   = 'docbook-xsl-nons'
  unzipLocation = $catalogDir
  url           = $docbookXslNoNsUrl
  checksum      = $docbookXslNoNsSha256
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
Install-ChocolateyZipPackage @docbookXslNoNsPackageArgs
Install-ChocolateyZipPackage @docbookXslPackageArgs
