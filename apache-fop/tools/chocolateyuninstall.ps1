# IMPORTANT: Before releasing this package, copy/paste the next 2 lines into PowerShell to remove all comments from this file:
#   $f='c:\path\to\thisFile.ps1'
#   gc $f | ? {$_ -notmatch "^\s*#"} | % {$_ -replace '(^.*?)\s*?[^``]#.*','$1'} | Out-File $f+".~" -en utf8; mv -fo $f+".~" $f

# If this is an MSI, cleaning up comments is all you need.
# If this is an exe, change installerType and silentArgs
# Auto Uninstaller should be able to detect and handle registry uninstalls (if it is turned on, it is in preview for 0.9.9).

Uninstall-BinFile -name 'fop' -path $toolsDir/apache-fop/tools/fop-2.1/fop.bat

## OTHER HELPERS
## https://github.com/chocolatey/choco/wiki/HelpersReference
#Uninstall-ChocolateyZipPackage
#Uninstall-BinFile # Only needed if you added one in the installer script, choco will remove the ones it added automatically.
#remove any shortcuts you added
