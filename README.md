# ancm-arm64, installer patches for ASP.NET Core module on Windows 11 ARM64 and IIS.

## Unofficial installers
IIS on ARM64 is currently capable of hosting only ARM64 NET Core apps. However, some IIS plugins like Application Request Routing and Url Rewrite are only available as x64 binaries. These installers are based upon a fix from https://github.com/lextm/ancm-arm64, making it more user-friendly to build and install.

## Build
To build the 8.0.3 installer, you need a machine with Visual Studio 2022 ARM64 and C++ workload installed. Then just clone this repo and run as admin:
```
build-8.0.3.bat
```
To build an installer for any newer or older version, just run:
```
build.bat "<url of the hosting bundle EXE>"
```
This will create a patched installer from that version unless there are some breaking changes in the next ASP.NET Hosting Bundle releases.

## Install
Install the EXE from Releases. You must first uninstall the ASP.NET Core Hosting Bundle because these installers replace it. To install it silently, run:
```
dotnet-hosting-8.0.3-win-arm64.exe /s
```

## Credits
All the research in IIS DLL loading has been done by lextm in https://github.com/lextm/ancm-arm64, thank you very much!