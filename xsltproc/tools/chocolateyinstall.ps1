# IMPORTANT: Before releasing this package, copy/paste the next 2 lines into PowerShell to remove all comments from this file:
#   $f='c:\path\to\thisFile.ps1'
#   gc $f | ? {$_ -notmatch "^\s*#"} | % {$_ -replace '(^.*?)\s*?[^``]#.*','$1'} | Out-File $f+".~" -en utf8; mv -fo $f+".~" $f

$ErrorActionPreference = 'Stop'; # stop on all errors

$packageName        = 'xsltproc'
$toolsDir           = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"
$unzipDir           = "$toolsDir\..\dist"

# MinGW Runtime

$mingwrt32Url       = 'http://xmlsoft.org/sources/win32/64bit/mingwrt-5.2.0-win32-x86.7z'
$mingwrt32Sha256    = '19ec3a9087632fe3a75b885c5c3a8e4f58e7edb31e9ea905651e5ce2fdf86cd0'
$mingwrt64Url       = 'http://xmlsoft.org/sources/win32/64bit/mingwrt-5.2.0-win32-x86_64.7z'
$mingwrt64Sha256    = 'b3645b70813b78eb17a7989fd4316a1f53ea8e0991fbcf34e201f9ea71f44d6c'

$mingwrtPackageArgs = @{
  packageName     = "$packageName-mingwrt"
  unzipLocation   = $unzipDir
  url             = $mingwrt32Url
  checksum        = $mingwrt32Sha256
  checksumType    = 'sha256'
  url64bit        = $mingwrt64Url
  checksum64      = $mingwrt64Sha256
  checksumType64  = 'sha256'
}

# Iconv

$iconv32Url         = 'http://xmlsoft.org/sources/win32/64bit/iconv-1.14-win32-x86.7z'
$iconv32Sha256      = '8e8483c3314f9ab44422873a41b0b1048c5a89682d977538e1a16b7114801135'
$iconv64Url         = 'http://xmlsoft.org/sources/win32/64bit/iconv-1.14-win32-x86_64.7z'
$iconv64Sha256      = '789ff211527bdeb80003b39b67c57742c23286db33c1b3d1622f52fc67612f60'

$iconvPackageArgs = @{
  packageName     = "$packageName-iconv"
  unzipLocation   = $unzipDir
  url             = $iconv32Url
  checksum        = $iconv32Sha256
  checksumType    = 'sha256'
  url64bit        = $iconv64Url
  checksum64      = $iconv64Sha256
  checksumType64  = 'sha256'
}

# Zlib

$zlib32Url         = 'http://xmlsoft.org/sources/win32/64bit/zlib-1.2.8-win32-x86.7z'
$zlib32Sha256      = 'e50f54d82bbb8c413e3337bdccf8d795f69affd17a813a0b44cedd899af8fc62'
$zlib64Url         = 'http://xmlsoft.org/sources/win32/64bit/zlib-1.2.8-win32-x86_64.7z'
$zlib64Sha256      = '2a0112800cdd0e0c699552fb751701102bdeb509f12c800bb0a4cb4c58f40cc5'

$zlibPackageArgs = @{
  packageName     = "$packageName-zlib"
  unzipLocation   = $unzipDir
  url             = $zlib32Url
  checksum        = $zlib32Sha256
  checksumType    = 'sha256'
  url64bit        = $zlib64Url
  checksum64      = $zlib64Sha256
  checksumType64  = 'sha256'
}

# Libxml2

$libxml32Url        = 'http://xmlsoft.org/sources/win32/64bit/libxml2-2.9.3-win32-x86.7z'
$libxml32Sha256     = '67e986d9da6af91ee3665b28c323a94cb344451b6fc3ba725b7c975bdef16960'
$libxml64Url        = 'http://xmlsoft.org/sources/win32/64bit/libxml2-2.9.3-win32-x86_64.7z'
$libxml64Sha256     = '727eac03f7b65b167aa975b5b83f89cabc6654a4031ae3810a59b5d9901627f8'

$libxmlPackageArgs = @{
  packageName     = "$packageName-libxml"
  unzipLocation   = $unzipDir
  url             = $libxml32Url
  checksum        = $libxml32Sha256
  checksumType    = 'sha256'
  url64bit        = $libxml64Url
  checksum64      = $libxml64Sha256
  checksumType64  = 'sha256'
}

# Libxslt

$libxslt32Url       = 'http://xmlsoft.org/sources/win32/64bit/libxslt-1.1.28-win32-x86.7z'
$libxslt32Sha256    = 'da98864a7f610536c855215e2bea5ff1b5e5da30d37459b9a2d62dd753ead79f'
$libxslt64Url       = 'http://xmlsoft.org/sources/win32/64bit/libxslt-1.1.28-win32-x86_64.7z'
$libxslt64Sha256    = 'b12f7b04c6867cae11585791a82babf3e455bbb1fddd26734e4f5f51652e671e'

$libxsltPackageArgs = @{
  packageName     = "$packageName-libxslt"
  unzipLocation   = $unzipDir
  url             = $libxslt32Url
  checksum        = $libxslt32Sha256
  checksumType    = 'sha256'
  url64bit        = $libxslt64Url
  checksum64      = $libxslt64Sha256
  checksumType64  = 'sha256'
}

Install-ChocolateyZipPackage @mingwrtPackageArgs
Install-ChocolateyZipPackage @iconvPackageArgs
Install-ChocolateyZipPackage @zlibPackageArgs
Install-ChocolateyZipPackage @libxmlPackageArgs
Install-ChocolateyZipPackage @libxsltPackageArgs

New-Item "$unzipDir\bin\iconv.exe.ignore" -type file -force | Out-Null
New-Item "$unzipDir\bin\xsltproc.exe.ignore" -type file -force | Out-Null
Install-BinFile -name "xsltproc" -path "$toolsDir\xsltproc.bat"
