<# :
 powershell /nologo /noprofile /command ^
  "&{[ScriptBlock]::Create((cat """%~f0""") -join [Char[]]10).Invoke(@(&{$args}%*))}"
 exit /b
#>

param (
    [string]$dotnetHostingUrl = "https://download.visualstudio.microsoft.com/download/pr/20598243-c38f-4538-b2aa-af33bc232f80/ea9b2ca232f59a6fdc84b7a31da88464/dotnet-hosting-8.0.3-win.exe"
)

$installationPath = & "${Env:ProgramFiles(x86)}\Microsoft Visual Studio\Installer\vswhere.exe" -latest -products * -property installationPath -requires "Microsoft.VisualStudio.Component.VC.Tools.x86.x64"
if ($installationPath -and (test-path "$installationPath\Common7\Tools\vsdevcmd.bat")) {
  & "${env:COMSPEC}" /s /c "`"$installationPath\Common7\Tools\vsdevcmd.bat`" -host_arch=x64 -arch=arm64 -no_logo && set" | foreach-object {
    $name, $value = $_ -split '=', 2
    set-content env:\"$name" $value
  }
}

Remove-Item -Recurse -Force "./temp"

mkdir temp
mkdir temp/obj
mkdir temp/bin
cl /c /Fotemp\obj\aspnetcorev2_arm64.obj empty.cpp
cl /c /arm64EC /Fotemp\obj\aspnetcorev2_x64.obj empty.cpp
link /lib /machine:arm64 /def:aspnetcorev2_arm64.def /out:temp\obj\aspnetcorev2_arm64.lib
link /lib /machine:x64 /def:aspnetcorev2_x64.def /out:temp\obj\aspnetcorev2_x64.lib
link /dll /noentry /machine:arm64x /defArm64Native:aspnetcorev2_arm64.def /def:aspnetcorev2_x64.def temp\obj\aspnetcorev2_arm64.obj temp\obj\aspnetcorev2_x64.obj /out:temp\bin\aspnetcorev2.dll temp\obj\aspnetcorev2_arm64.lib temp\obj\aspnetcorev2_x64.lib
cl /c /Fotemp\obj\aspnetcorev2_outofprocess_arm64.obj empty.cpp
cl /c /arm64EC /Fotemp\obj\aspnetcorev2_outofprocess_x64.obj empty.cpp
link /lib /machine:arm64 /def:aspnetcorev2_outofprocess_arm64.def /out:temp\obj\aspnetcorev2_outofprocess_arm64.lib
link /lib /machine:x64 /def:aspnetcorev2_outofprocess_x64.def /out:temp\obj\aspnetcorev2_outofprocess_x64.lib
link /dll /noentry /machine:arm64x /defArm64Native:aspnetcorev2_outofprocess_arm64.def /def:aspnetcorev2_outofprocess_x64.def temp\obj\aspnetcorev2_outofprocess_arm64.obj temp\obj\aspnetcorev2_outofprocess_x64.obj /out:temp\bin\aspnetcorev2_outofprocess.dll temp\obj\aspnetcorev2_outofprocess_arm64.lib temp\obj\aspnetcorev2_outofprocess_x64.lib

$wixDark = "${Env:ProgramFiles(x86)}\WiX Toolset v3.14\bin\dark.exe"
if (-not(Test-Path "$wixDark" -PathType Leaf)) {
   $ProgressPreference = 'SilentlyContinue'
   Invoke-WebRequest -Uri "https://github.com/wixtoolset/wix3/releases/download/wix3141rtm/wix314.exe" -OutFile "./temp/wix314.exe"
   $ProgressPreference = 'Continue'
   Start-Process -FilePath "./temp/wix314.exe" -ArgumentList "/s" -Wait
}

$dotnetVersion = ($dotnetHostingUrl -split "/" | Select-Object -Last 1) -split "-" | Select-Object -Last 2 | Select-Object -First 1
$dotnetMajorVersion = $dotnetVersion -split "\." | Select-Object -First 1
$dotnetHostingPath = "./temp/dotnet-hosting-$dotnetVersion-win.exe"
if (-not(Test-Path "$dotnetHostingPath" -PathType Leaf)) {
   $ProgressPreference = 'SilentlyContinue'
   Invoke-WebRequest -Uri "$dotnetHostingUrl" -OutFile "./temp/dotnet-hosting-$dotnetVersion-win.exe"
   $ProgressPreference = 'Continue'
}

Start-Process -FilePath "$wixDark" -ArgumentList "$dotnetHostingPath -x .\temp\msi" -Wait
Start-Process -FilePath "msiexec" -ArgumentList "/a `"$pwd\temp\msi\AttachedContainer\AspNetCoreModuleV2_x64.msi`" /qn TARGETDIR=`"$pwd\temp\msi_x64`"" -Wait

$aspnetcoreDir = ".\temp\msi_x64\IIS\Asp.Net Core Module\V2"
$aspnetcoreVersion = (Get-ChildItem "$aspnetcoreDir" -Directory | Select-Object -First 1).Name

dotnet build "./DotnetHostingARM64EC/DotnetHostingARM64EC.wixproj" -c Release -p:Platform=ARM64 -p:AspNetVersion="$aspnetcoreVersion"
dotnet build "./dotnet-hosting-win-arm64/dotnet-hosting-win-arm64.wixproj" -c Release -p:Platform=ARM64 -p:AspNetVersion="$aspnetcoreVersion" -p:NetVersion="$dotnetVersion" -p:NetMajorVersion="$dotnetMajorVersion"

Copy-Item -Path "./dotnet-hosting-win-arm64/bin/ARM64/Release/dotnet-hosting-win-arm64.exe" -Destination "./dotnet-hosting-$dotnetVersion-win-arm64.exe" -Force
