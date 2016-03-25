#
# bundle-xsltproc - Create a .zip archive containing xsltproc.exe
#
# Copyright 2016 Gerald Combs <gerald@wireshark.org>
#
# Based on tools\win-setup.ps1 from Wireshark
# Wireshark - Network traffic analyzer
# By Gerald Combs <gerald@wireshark.org>
# Copyright 1998 Gerald Combs
#

#requires -version 2

<#
.SYNOPSIS
Prepare a Windows development environment for building Wireshark.

.DESCRIPTION
This script downloads and extracts third-party libraries required to compile
Wireshark.

.PARAMETER Destination
Specifies the destination directory for the text files. The path must
contain the pattern "wireshark-*-libs".

.PARAMETER Platform
Target platform. One of "win64" or "win32".

.PARAMETER VSVersion
Visual Studio version. Must be the numeric version (e.g. "12", "11"),
not the year.

.PARAMETER Force
Download each library even if exists on the local system.

.INPUTS
-Destination Destination directory.
-Platform Target platform.
-VSVersion Visual Studio version.
-Force Force fresh downloads.

.OUTPUTS
A set of libraries required to compile Wireshark on Windows, along with
their compressed archives.
A date stamp (current-tag.txt)

.EXAMPLE
C:\PS> .\tools\win-setup.ps1 -Destination C:\wireshark-master-64-libs -Platform win64
#>

Param(
    [Parameter(Mandatory=$true, Position=0)]
    [ValidateScript({$_ -like "*work*"})]
    [String]
    $WorkDir
)

# Variables

# We create and delete files and directories. Bail out at the first sign of
# trouble instead of trying to catch exceptions everywhere.
$ErrorActionPreference = "Stop"

# 32-bit URLs

$XsltprocWin32Ver = "1.1.28"

$MingwrtWin32Ver = "mingwrt-5.2.0"
$IconvWin32Ver = "iconv-1.14"
$ZlibWin32Ver = "zlib-1.2.8"
$Libxml2Win32Ver = "libxml2-2.9.3"
$LibxsltWin32Ver = "libxslt-$XsltprocWin32Ver"

$Win32Archives = @(
    "$MingwrtWin32Ver-win32-x86.7z";
    "$IconvWin32Ver-win32-x86.7z";
    "$ZlibWin32Ver-win32-x86.7z";
    "$Libxml2Win32Ver-win32-x86.7z";
    "$LibxsltWin32Ver-win32-x86.7z";
)

# 64-bit URLs

$XsltprocWin64Ver = "1.1.28"

$MingwrtWin64Ver = "mingwrt-5.2.0"
$IconvWin64Ver = "iconv-1.14"
$ZlibWin64Ver = "zlib-1.2.8"
$Libxml2Win64Ver = "libxml2-2.9.3"
$LibxsltWin64Ver = "libxslt-$XsltprocWin64Ver"

$Win64Archives = @(
    "$MingwrtWin64Ver-win32-x86_64.7z";
    "$IconvWin64Ver-win32-x86_64.7z";
    "$ZlibWin64Ver-win32-x86_64.7z";
    "$Libxml2Win64Ver-win32-x86_64.7z";
    "$LibxsltWin64Ver-win32-x86_64.7z";
)

[Uri] $DownloadPrefix = "ftp://ftp.zlatkovic.com/pub/libxml/64bit"
$Global:SevenZip = "7-zip-not-found"

# Functions

function DownloadFile($fileName, [Uri] $fileUrl = $null) {
    if ([string]::IsNullOrEmpty($fileUrl)) {
        $fileUrl = "$DownloadPrefix/$fileName"
    }
    $destinationFile = "$fileName"
    if ((Test-Path $destinationFile -PathType 'Leaf') -and -not ($Force)) {
        Write-Output "$destinationFile already there; not retrieving."
        return
    }

    $proxy = [System.Net.WebRequest]::GetSystemWebProxy()
    $proxy.Credentials = [System.Net.CredentialCache]::DefaultCredentials

    Write-Output "Downloading $fileUrl into $WorkDir"
    $webClient = New-Object System.Net.WebClient
    $webClient.proxy = $proxy
    $webClient.DownloadFile($fileUrl, "$WorkDir\$destinationFile")
}

# Find 7-Zip, downloading it if necessary.
# If we ever add NuGet support we might be able to use
# https://github.com/thoemmi/7Zip4Powershell
function Bootstrap7Zip() {
    $searchExes = @("7z.exe", "7za.exe")
    $binDir = "$WorkDir\bin"

    # First, check $env:Path.
    foreach ($exe in $searchExes) {
        if (Get-Command $exe -ErrorAction SilentlyContinue)  {
            $Global:SevenZip = "$exe"
            Write-Output "Found 7-zip on the path"
            return
        }
    }

    # Next, look in a few likely places.
    $searchDirs = @(
        "${env:ProgramFiles}\7-Zip"
        "${env:ProgramFiles(x86)}\7-Zip"
        "${env:ProgramW6432}\7-Zip"
        "${env:ChocolateyInstall}\bin"
        "${env:ChocolateyInstall}\tools"
        "$binDir"
    )

    foreach ($dir in $searchDirs) {
        if ($dir -ne $null -and (Test-Path $dir -PathType 'Container')) {
            foreach ($exe in $searchExes) {
                if (Test-Path "$dir\$exe" -PathType 'Leaf') {
                    $Global:SevenZip = "$dir\$exe"
                    Write-Output "Found 7-zip at $dir\$exe"
                    return
                }
            }
        }
    }

    # Finally, download a copy from anonsvn.
    if ( -not (Test-Path $binDir -PathType 'Container') ) {
        New-Item -ItemType 'Container' "$binDir" > $null
    }

    Write-Output "Unable to find 7-zip, retrieving from anonsvn into $binDir\7za.exe"
    [Uri] $bbUrl = "https://anonsvn.wireshark.org/wireshark-win32-libs/trunk/bin/7za.exe"
    DownloadFile "bin\7za.exe" "$bbUrl"

    $Global:SevenZip = "$binDir\7za.exe"
}

function DownloadArchive($fileName, $subDir) {
    DownloadFile $fileName
    # $shell = New-Object -com shell.application
    $archiveFile = "$WorkDir\$fileName"
    $archiveDir = "$WorkDir\$subDir"
    if ($subDir -and -not (Test-Path $archiveDir -PathType 'Container')) {
        New-Item -ItemType Directory -Path $archiveDir > $null
    }
    $activity = "Extracting into $($archiveDir)"
    Write-Progress -Activity "$activity" -Status "Running 7z x $archiveFile ..."
    & "$SevenZip" x "-o$archiveDir" -y "$archiveFile" 2>&1 |
        Set-Variable -Name SevenZOut
    $bbStatus = $LASTEXITCODE
    Write-Progress -Activity "$activity" -Status "Done" -Completed
    if ($bbStatus > 0) {
        Write-Output $SevenZOut
        exit 1
    }
}

# On with the show

Bootstrap7Zip

$OutDir32 = "xsltproc-$XsltprocWin32Ver-win32"
$OutDir64 = "xsltproc-$XsltprocWin64Ver-win64"

# Make sure $WorkDir exists and do our work there.
if ( -not (Test-Path $WorkDir -PathType 'Container') ) {
    New-Item -ItemType 'Container' "$WorkDir" > $null
}

# CMake's file TO_NATIVE_PATH passive-aggressively omits the drive letter.
Set-Location "$WorkDir"
$WorkDir = $(Get-Item -Path ".\")
Write-Output "Working in $WorkDir"

foreach ($subdir in "win32extract", "win64extract" ) {
    if (Test-Path $subdir -PathType 'Container') {
        Remove-Item -Force -Recurse $subdir
    }
    New-Item -ItemType 'Container' "$subdir" > $null
}

foreach ($subdir in "$OutDir32", "$OutDir64" ) {
    if (Test-Path $subdir -PathType 'Container') {
        Remove-Item -Force -Recurse $subdir
    }
    if (Test-Path "$subdir.zip") {
        Remove-Item -Force "$subdir.zip"
    }
}

# Download and extract archives
foreach ($item in $Win32Archives) {
    DownloadArchive $item "win32extract"
}

foreach ($item in $Win64Archives) {
    DownloadArchive $item "win64extract"
}

Move-Item win32extract\bin "$OutDir32"
& "$SevenZip" a -tzip "$OutDir32.zip" "$OutDir32"

Move-Item win64extract\bin "$OutDir64"
& "$SevenZip" a -tzip "$OutDir64.zip" "$OutDir64"

