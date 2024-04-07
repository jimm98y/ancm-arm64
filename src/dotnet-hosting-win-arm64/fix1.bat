cd %~dp0

if "%~1"=="install" (
    move /y "%ProgramFiles%\IIS\Asp.Net Core Module\V2\aspnetcorev2.dll" "%ProgramFiles%\IIS\Asp.Net Core Module\V2\aspnetcorev2_x64.dll"
    move /y "%ProgramFiles%\IIS\Asp.Net Core Module\V2\%~2\aspnetcorev2_outofprocess.dll" "%windir%\system32\inetsrv\aspnetcorev2_outofprocess_x64.dll"
)

if "%~1"=="uninstall" (
	move /y "%ProgramFiles%\IIS\Asp.Net Core Module\V2\aspnetcorev2_x64.dll" "%ProgramFiles%\IIS\Asp.Net Core Module\V2\aspnetcorev2.dll"
    move /y "%windir%\system32\inetsrv\aspnetcorev2_outofprocess_x64.dll" "%ProgramFiles%\IIS\Asp.Net Core Module\V2\%~2\aspnetcorev2_outofprocess.dll"
)