if "%~1"=="install" (
	msiexec /i "%~dp0AspNetCoreModuleV2_x64.msi" /qn"
)

if "%~1"=="uninstall" (
	msiexec /x "%~dp0AspNetCoreModuleV2_x64.msi" /qn"
)
