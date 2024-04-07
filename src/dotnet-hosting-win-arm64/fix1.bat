if "%~1"=="install" (
    move "%ProgramFiles%\IIS\Asp.Net Core Module\V2\aspnetcorev2.dll" "%ProgramFiles%\IIS\Asp.Net Core Module\V2\aspnetcorev2_x64.dll"
    move "%ProgramFiles%\IIS\Asp.Net Core Module\V2\%~2\aspnetcorev2_outofprocess.dll" "%windir%\system32\inetsrv\aspnetcorev2_outofprocess_x64.dll"
)