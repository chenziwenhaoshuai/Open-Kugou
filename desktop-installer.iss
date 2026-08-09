#define AppName "Open-Kugou"
#define AppVersion "1.6.0"
#define AppExeName "Open-Kugou.exe"
[Setup]
AppId={{3D23C1A6-5FC2-4B5A-9D9C-6A8EA8F3A4A1}
AppName={#AppName}
AppVersion={#AppVersion}
DefaultDirName={autopf}\Open-Kugou
DefaultGroupName={#AppName}
OutputDir=dist-desktop-final
OutputBaseFilename=Open-Kugou-Setup-{#AppVersion}-final4
Compression=lzma2
SolidCompression=yes
WizardStyle=modern
ArchitecturesInstallIn64BitMode=x64
PrivilegesRequired=admin
LicenseFile=LICENSE
[Files]
Source: "desktop-app-source\Open-Kugou-win32-x64\*"; DestDir: "{app}"; Flags: ignoreversion recursesubdirs createallsubdirs
[Icons]
Name: "{group}\{#AppName}"; Filename: "{app}\{#AppExeName}"
Name: "{commondesktop}\{#AppName}"; Filename: "{app}\{#AppExeName}"
[Run]
Filename: "{app}\{#AppExeName}"; Description: "Start {#AppName}"; Flags: postinstall nowait skipifsilent
