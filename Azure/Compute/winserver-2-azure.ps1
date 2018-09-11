#Remove the WinHTTP proxy
    netsh winhttp reset proxy
#Set the disk SAN policy to Onlineall
    diskpart /s diskpart.txt
#Set Coordinated Universal Time (UTC) time for Windows and the startup type of the Windows Time (w32time)
    Set-ItemProperty -Path 'HKLM:\SYSTEM\CurrentControlSet\Control\TimeZoneInformation' -name "RealTimeIsUniversal" 1 -Type DWord
    Set-Service -Name w32time -StartupType Automatic
#Set the power profile to the High Performance
    powercfg /setactive SCHEME_MIN
#Check the Windows services
    Set-Service -Name bfe -StartupType Automatic
    Set-Service -Name dhcp -StartupType Automatic
    Set-Service -Name dnscache -StartupType Automatic
    Set-Service -Name IKEEXT -StartupType Automatic
    Set-Service -Name iphlpsvc -StartupType Automatic
    Set-Service -Name netlogon -StartupType Manual
    Set-Service -Name netman -StartupType Manual
    Set-Service -Name nsi -StartupType Automatic
    Set-Service -Name termService -StartupType Manual
    Set-Service -Name MpsSvc -StartupType Automatic
    Set-Service -Name RemoteRegistry -StartupType Automatic
#Update Remote Desktop registry setting
    Set-ItemProperty -Path 'HKLM:\SYSTEM\CurrentControlSet\Control\Terminal Server' -name "fDenyTSConnections" -Value 0 -Type DWord
    Set-ItemProperty -Path 'HKLM:\SOFTWARE\Policies\Microsoft\Windows NT\Terminal Services' -name "fDenyTSConnections" -Value 0 -Type DWord
    Set-ItemProperty -Path 'HKLM:\SYSTEM\CurrentControlSet\Control\Terminal Server\Winstations\RDP-Tcp' -name "PortNumber" 3389 -Type DWord
    Set-ItemProperty -Path 'HKLM:\SYSTEM\CurrentControlSet\Control\Terminal Server\Winstations\RDP-Tcp' -name "LanAdapter" 0 -Type DWord
    Set-ItemProperty -Path 'HKLM:\SYSTEM\CurrentControlSet\Control\Terminal Server\WinStations\RDP-Tcp' -name "UserAuthentication" 1 -Type DWord
    Set-ItemProperty -Path 'HKLM:\SYSTEM\CurrentControlSet\Control\Terminal Server\WinStations\RDP-Tcp' -name "SecurityLayer" 1 -Type DWord
    Set-ItemProperty -Path 'HKLM:\SYSTEM\CurrentControlSet\Control\Terminal Server\WinStations\RDP-Tcp' -name "fAllowSecProtocolNegotiation" 1 -Type DWord
    Set-ItemProperty -Path 'HKLM:\SOFTWARE\Policies\Microsoft\Windows NT\Terminal Services' -name "KeepAliveEnable" 1 -Type DWord
    Set-ItemProperty -Path 'HKLM:\SOFTWARE\Policies\Microsoft\Windows NT\Terminal Services' -name "KeepAliveInterval" 1 -Type DWord
    Set-ItemProperty -Path 'HKLM:\SYSTEM\CurrentControlSet\Control\Terminal Server\Winstations\RDP-Tcp' -name "KeepAliveTimeout" 1 -Type DWord
    Set-ItemProperty -Path 'HKLM:\SOFTWARE\Policies\Microsoft\Windows NT\Terminal Services' -name "fDisableAutoReconnect" 0 -Type DWord
    Set-ItemProperty -Path 'HKLM:\SYSTEM\CurrentControlSet\Control\Terminal Server\Winstations\RDP-Tcp' -name "fInheritReconnectSame" 1 -Type DWord
    Set-ItemProperty -Path 'HKLM:\SYSTEM\CurrentControlSet\Control\Terminal Server\Winstations\RDP-Tcp' -name "fReconnectSame" 0 -Type DWord
    Set-ItemProperty -Path 'HKLM:\SYSTEM\CurrentControlSet\Control\Terminal Server\Winstations\RDP-Tcp' -name "MaxInstanceCount" 4294967295 -Type DWord
    Remove-ItemProperty -Path 'HKLM:\SYSTEM\CurrentControlSet\Control\Terminal Server\WinStations\RDP-Tcp' -name "SSLCertificateSHA1Hash"
#Configure Windows Firewall rules
    Set-ItemProperty -Path 'HKLM:\SYSTEM\CurrentControlSet\services\SharedAccess\Parameters\FirewallPolicy\DomainProfile' -name "EnableFirewall" -Value 1 -Type DWord
    Set-ItemProperty -Path 'HKLM:\SYSTEM\CurrentControlSet\services\SharedAccess\Parameters\FirewallPolicy\PublicProfile' -name "EnableFirewall" -Value 1 -Type DWord
    Set-ItemProperty -Path 'HKLM:\SYSTEM\CurrentControlSet\services\SharedAccess\Parameters\FirewallPolicy\Standardprofile' -name "EnableFirewall" -Value 1 -Type DWord
    Enable-PSRemoting -force
    netsh advfirewall firewall set rule dir=in name="Windows Remote Management (HTTP-In)" new enable=yes
    netsh advfirewall firewall set rule dir=in name="Windows Remote Management (HTTP-In)" new enable=yes
    netsh advfirewall firewall set rule group="Remote Desktop" new enable=yes
    netsh advfirewall firewall set rule dir=in name="File and Printer Sharing (Echo Request - ICMPv4-In)" new enable=yes
#Setup Boot Proprieties
    cmd.exe /c "bcdedit /set {bootmgr} integrityservices enable"
    cmd.exe /c "bcdedit /set {default} device partition=C:"
    cmd.exe /c "bcdedit /set {default} integrityservices enable"
    cmd.exe /c "bcdedit /set {default} recoveryenabled Off"
    cmd.exe /c "bcdedit /set {default} osdevice partition=C:"
    cmd.exe /c "bcdedit /set {default} bootstatuspolicy IgnoreAllFailures"
    #Enable Serial Console Feature
    cmd.exe /c "bcdedit /set {bootmgr} displaybootmenu yes"
    cmd.exe /c "bcdedit /set {bootmgr} timeout 10"
    cmd.exe /c "bcdedit /set {bootmgr} bootems yes"
    cmd.exe /c "bcdedit /ems {current} ON"
    cmd.exe /c "bcdedit /emssettings EMSPORT:1 EMSBAUDRATE:115200"
#Setup the Guest OS to collect a kernel dump on an OS crash event
    REG ADD "HKLM\SYSTEM\CurrentControlSet\Control\CrashControl" /v DumpFile /t REG_EXPAND_SZ /d "%SystemRoot%\MEMORY.DMP" /f
    REG ADD "HKLM\SYSTEM\CurrentControlSet\Control\CrashControl" /v CrashDumpEnabled /t REG_DWORD /d 2 /f
    REG ADD "HKLM\SYSTEM\CurrentControlSet\Control\CrashControl" /v NMICrashDump /t REG_DWORD /d 1 /f
#Setup the Guest OS to collect user mode dumps on a service crash event
    mkdir c:\Crashdumps
    REG ADD "HKLM\SOFTWARE\Microsoft\Windows\Windows Error Reporting" /v DumpFolder /t REG_EXPAND_SZ /d "c:\CrashDumps" /f
    REG ADD "HKLM\SOFTWARE\Microsoft\Windows\Windows Error Reporting" /v CrashCount /t REG_DWORD /d 10 /f
    REG ADD "HKLM\SOFTWARE\Microsoft\Windows\Windows Error Reporting" /v DumpType /t REG_DWORD /d 2 /f
    Set-Content config WerSvc start= demand
    exit
#Verify that the Windows Management Instrumentations repository is consistent
    winmgmt /verifyrepository >> repository.txt
#Verify VM is healthy, secure, and accessible with RDP
    Chkdsk /f
#Reboot
    Shutdown -r /t 0