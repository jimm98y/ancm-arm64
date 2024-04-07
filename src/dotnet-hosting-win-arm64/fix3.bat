cd %~dp0

if "%~1"=="install" (
msiexec /a "%~dp0AspNetCoreModuleV2_x64.msi" /qn TARGETDIR="%~dp0\msi_x64"
move /y "%ProgramFiles(x86)%\IIS\Asp.Net Core Module\V2\aspnetcorev2.dll" "%ProgramFiles(x86)%\IIS\Asp.Net Core Module\V2\aspnetcorev2.dll.bak"
copy "%~dp0\msi_x64\IIS\Asp.Net Core Module\WowOnly\aspnetcorev2.dll" "%ProgramFiles(x86)%\IIS\Asp.Net Core Module\V2\aspnetcorev2.dll"
move /y "%ProgramFiles(x86)%\IIS\Asp.Net Core Module\V2\%~2\aspnetcorev2_outofprocess.dll" "%ProgramFiles(x86)%\IIS\Asp.Net Core Module\V2\%~2\aspnetcorev2_outofprocess.dll.bak"
copy "%~dp0\msi_x64\IIS\Asp.Net Core Module\WowOnly\WowOnly\aspnetcorev2_outofprocess.dll" "%ProgramFiles(x86)%\IIS\Asp.Net Core Module\V2\%~2\aspnetcorev2_outofprocess.dll"
)

if "%~1"=="uninstall" (
	move /y "%ProgramFiles(x86)%\IIS\Asp.Net Core Module\V2\aspnetcorev2.dll.bak" "%ProgramFiles(x86)%\IIS\Asp.Net Core Module\V2\aspnetcorev2.dll"
    move /y "%ProgramFiles(x86)%\IIS\Asp.Net Core Module\V2\%~2\aspnetcorev2_outofprocess.dll.bak" "%ProgramFiles(x86)%\IIS\Asp.Net Core Module\V2\%~2\aspnetcorev2_outofprocess.dll"
)
