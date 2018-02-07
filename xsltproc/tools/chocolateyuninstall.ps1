# IMPORTANT: Before releasing this package, copy/paste the next 2 lines into PowerShell to remove all comments from this file:
#   $f='c:\path\to\thisFile.ps1'
#   gc $f | ? {$_ -notmatch "^\s*#"} | % {$_ -replace '(^.*?)\s*?[^``]#.*','$1'} | Out-File $f+".~" -en utf8; mv -fo $f+".~" $f

# If this is an MSI, cleaning up comments is all you need.
# If this is an exe, change installerType and silentArgs
# Auto Uninstaller should be able to detect and handle registry uninstalls (if it is turned on, it is in preview for 0.9.9).

$ErrorActionPreference = 'Stop'; # stop on all errors

$packageName = 'xsltproc'
$xsltprocVersion = '1.1.28'

$winBits = 64
if ((Get-ProcessorBits 32) -or $env:ChocolateyForceX86 -eq 'true') {
  $winBits = 32
}
foreach ($binfile in 'xmlcatalog', 'xmllint', 'xsltproc' ) {
  Install-BinFile -name "$binfile" -path "$toolsDir\xsltproc-$($xsltprocVersion)-win$($winBits)\$($binfile).exe"
}
