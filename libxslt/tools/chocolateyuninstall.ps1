# IMPORTANT: Before releasing this package, copy/paste the next 2 lines into PowerShell to remove all comments from this file:
#   $f='c:\path\to\thisFile.ps1'
#   gc $f | ? {$_ -notmatch "^\s*#"} | % {$_ -replace '(^.*?)\s*?[^``]#.*','$1'} | Out-File $f+".~" -en utf8; mv -fo $f+".~" $f

# If this is an MSI, cleaning up comments is all you need.
# If this is an exe, change installerType and silentArgs
# Auto Uninstaller should be able to detect and handle registry uninstalls (if it is turned on, it is in preview for 0.9.9).

$ErrorActionPreference = 'Stop'; # stop on all errors

$packageName = 'libxslt'

Uninstall-BinFile -name 'xsltproc' -path $toolsDir\libxslt-1.1.26.win32\bin\xsltproc.exe
