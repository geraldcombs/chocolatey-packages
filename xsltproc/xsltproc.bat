@if "%DEBUG%" == "" @echo off

rem xsltproc wrapper script for Chocolatey.
rem SPDX-license-identifier: MIT

rem Set a sensible default for XML_CATALOG_FILES.

if not defined XML_CATALOG_FILES (
    set XML_CATALOG_FILES=%ChocolateyInstall%\lib\docbook-bundle\catalog.xml
)

rem On with the show.

"%~dp0"\xsltproc.exe %*