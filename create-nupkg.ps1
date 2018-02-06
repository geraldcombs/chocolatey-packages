# Steps required to create a .nupkg

# - Make sure we've committed our changes.
# - Strip comments from tools\*.ps1 as per Chocoloatey requirements.
# - Create the package.
# - Restore tools\*.ps1

git diff-index --quiet HEAD > $Null 2>&1
if (-not $LastExitCode) {
    Write-Error "Please commit your changes to git first."
}

# Expanded from the comment at the top of chocolateyinstall.ps1.
Get-Childitem tools\*.ps1 |
Foreach-Object {
    $stripfile = $_
    Get-Content $stripfile |
    ? {
        $_ -notmatch "^\s*#"
    } |
    % {
        $_ -replace '(^.*?)\s*?[^``]#.*','$1'
    } |
    Out-File $stripfile+".~" -en utf8; mv -fo $stripfile+".~" $stripfile
}

cpack

git checkout -- tools\