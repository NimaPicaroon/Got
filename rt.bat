@echo off

ipconfig /flushdns

>nul 2>&1 "%SYSTEMROOT%\system32\cacls.exe" "%SYSTEMROOT%\system32\config\system"

if '%errorlevel%' NEQ '0' (
    echo Barname Ro Be Sorate Run As Administrator Baz Konid...
    goto UACPrompt
) else ( goto :gotAdmin )

:UACPrompt
    echo Set UAC = CreateObject^("Shell.Application"^) > "%temp%\getadmin.vbs"
    echo UAC.ShellExecute "%~s0", "", "", "runas", 1 >> "%temp%\getadmin.vbs"
    "%temp%\getadmin.vbs"
    exit /B

:gotAdmin
    if exist "%temp%\getadmin.vbs" ( del "%temp%\getadmin.vbs" )
    pushd "%CD%"
    CD /D "%~dp0"

:MainMenu
cls
echo In Script Tavasote Alparo Tahie SHode.
echo Dar Surati Ke Moshkel Edame Dar Bud.
echo Be DisCord Bande Moraje'e Konid.
echo DisCord:  https://discord.gg/JUZRjpSM 
echo Donate:)  https://reymit.ir/alparo
echo ________________________
echo Yeki Az Config Haye Zir Ro TesT konid.
echo 1. Nasb Config Shomare1 Electro/Radar
echo 2. Nasb Config Shomare2 Electro/Shekan
echo 3. Nasb Config Shomare3 Yadam Nist :)
echo 4. Nasb Config Shomare4 Inam yadam Nist :))
echo 5. Hazf Config Ha Va Bargasht Be Halate Adi
set /p choice="Entekhab Konid 1-5: "

if "%choice%"=="1" (
    call :InstallHostEntries
)   else if "%choice%"=="2" (
    call :InstallHostEntries2
)   else if "%choice%"=="3" (
    call :InstallHostEntries3
)   else if "%choice%"=="4" (
    call :InstallHostEntries4
)   else if "%choice%"=="5" (
    call :UninstallHostEntries
) else (
    echo Entekhab Shoma Eshtebah Mibashad, Lotfan Yeki Az A'dad Ro Entekhab Konid 1-5.
    pause
    exit
)




:InstallHostEntries1
findstr /V /C:"metrics.fivem.net" /C:"registry-internal.fivem.net" /C:"status.fivem.net" /C:"synapse.fivem.net" /C:"status.cfx.re" /C:"users.cfx.re" /C:"content.cfx.re" /C:"sentry.fivem.net" /C:"runtime.fivem.net" /C:"lambda.fivem.net" /C:"changelogs-live.fivem.net" /C:"servers-frontend.fivem.net" /C:"cnl-hb-live.fivem.net" /C:"policy-live.fivem.net" %windir%\System32\drivers\etc\hosts > %temp%\hosts.tmp
move /Y %temp%\hosts.tmp %windir%\System32\drivers\etc\hosts
echo Adding entries to host file...
echo 78.157.42.100		metrics.fivem.net >> %windir%\System32\drivers\etc\hosts
echo 78.157.42.100		registry-internal.fivem.net >> %windir%\System32\drivers\etc\hosts
echo 78.157.42.100		status.fivem.net >> %windir%\System32\drivers\etc\hosts
echo 78.157.42.100		synapse.fivem.net >> %windir%\System32\drivers\etc\hosts
echo 78.157.42.100		status.cfx.re >> %windir%\System32\drivers\etc\hosts
echo 206.71.149.106		users.cfx.re >> %windir%\System32\drivers\etc\hosts
echo 78.157.42.100		content.cfx.re >> %windir%\System32\drivers\etc\hosts
echo 206.71.149.106		sentry.fivem.net >> %windir%\System32\drivers\etc\hosts
echo 78.157.42.100		runtime.fivem.net >> %windir%\System32\drivers\etc\hosts
echo 206.71.149.106		lambda.fivem.net >> %windir%\System32\drivers\etc\hosts
echo 78.157.42.100		changelogs-live.fivem.net >> %windir%\System32\drivers\etc\hosts
echo 78.157.42.100		servers-frontend.fivem.net >> %windir%\System32\drivers\etc\hosts
echo 206.71.149.106		cnl-hb-live.fivem.net >> %windir%\System32\drivers\etc\hosts
echo 206.71.149.106		policy-live.fivem.net >> %windir%\System32\drivers\etc\hosts
echo Ba Movafaghiyat Nasb Shod.
pause
exit


:InstallHostEntries2
findstr /V /C:"metrics.fivem.net" /C:"registry-internal.fivem.net" /C:"status.fivem.net" /C:"synapse.fivem.net" /C:"status.cfx.re" /C:"users.cfx.re" /C:"content.cfx.re" /C:"sentry.fivem.net" /C:"runtime.fivem.net" /C:"lambda.fivem.net" /C:"changelogs-live.fivem.net" /C:"servers-frontend.fivem.net" /C:"cnl-hb-live.fivem.net" /C:"policy-live.fivem.net" %windir%\System32\drivers\etc\hosts > %temp%\hosts.tmp
move /Y %temp%\hosts.tmp %windir%\System32\drivers\etc\hosts
echo Adding entries to host file...
echo 78.157.42.100		metrics.fivem.net >> %windir%\System32\drivers\etc\hosts
echo 78.157.42.100		registry-internal.fivem.net >> %windir%\System32\drivers\etc\hosts
echo 78.157.42.100		status.fivem.net >> %windir%\System32\drivers\etc\hosts
echo 78.157.42.100		synapse.fivem.net >> %windir%\System32\drivers\etc\hosts
echo 78.157.42.100		status.cfx.re >> %windir%\System32\drivers\etc\hosts
echo 50.7.87.85			users.cfx.re >> %windir%\System32\drivers\etc\hosts
echo 78.157.42.100		content.cfx.re >> %windir%\System32\drivers\etc\hosts
echo 50.7.87.85			sentry.fivem.net >> %windir%\System32\drivers\etc\hosts
echo 78.157.42.100		runtime.fivem.net >> %windir%\System32\drivers\etc\hosts
echo 50.7.87.85			lambda.fivem.net >> %windir%\System32\drivers\etc\hosts
echo 78.157.42.100		changelogs-live.fivem.net >> %windir%\System32\drivers\etc\hosts
echo 78.157.42.100		servers-frontend.fivem.net >> %windir%\System32\drivers\etc\hosts
echo 50.7.87.85			cnl-hb-live.fivem.net >> %windir%\System32\drivers\etc\hosts
echo 50.7.87.85			policy-live.fivem.net >> %windir%\System32\drivers\etc\hosts
echo Ba Movafaghiyat Nasb Shod.
pause
exit




:InstallHostEntries3
findstr /V /C:"metrics.fivem.net" /C:"registry-internal.fivem.net" /C:"status.fivem.net" /C:"synapse.fivem.net" /C:"status.cfx.re" /C:"users.cfx.re" /C:"content.cfx.re" /C:"sentry.fivem.net" /C:"runtime.fivem.net" /C:"lambda.fivem.net" /C:"changelogs-live.fivem.net" /C:"servers-frontend.fivem.net" /C:"cnl-hb-live.fivem.net" /C:"policy-live.fivem.net" %windir%\System32\drivers\etc\hosts > %temp%\hosts.tmp
move /Y %temp%\hosts.tmp %windir%\System32\drivers\etc\hosts
echo Adding entries to host file...
echo 10.202.10.10		metrics.fivem.net >> %windir%\System32\drivers\etc\hosts
echo 10.202.10.10		registry-internal.fivem.net >> %windir%\System32\drivers\etc\hosts
echo 10.202.10.10		status.fivem.net >> %windir%\System32\drivers\etc\hosts
echo 10.202.10.10		synapse.fivem.net >> %windir%\System32\drivers\etc\hosts
echo 10.202.10.10		status.cfx.re >> %windir%\System32\drivers\etc\hosts
echo 208.67.222.222		users.cfx.re >> %windir%\System32\drivers\etc\hosts
echo 10.202.10.10		content.cfx.re >> %windir%\System32\drivers\etc\hosts
echo 208.67.222.222		sentry.fivem.net >> %windir%\System32\drivers\etc\hosts
echo 10.202.10.10		runtime.fivem.net >> %windir%\System32\drivers\etc\hosts
echo 208.67.222.222		lambda.fivem.net >> %windir%\System32\drivers\etc\hosts
echo 10.202.10.10		changelogs-live.fivem.net >> %windir%\System32\drivers\etc\hosts
echo 10.202.10.10		servers-frontend.fivem.net >> %windir%\System32\drivers\etc\hosts
echo 208.67.222.222		cnl-hb-live.fivem.net >> %windir%\System32\drivers\etc\hosts
echo 208.67.222.222		policy-live.fivem.net >> %windir%\System32\drivers\etc\hosts
echo Ba Movafaghiyat Nasb Shod.
pause
exit


:InstallHostEntries4
findstr /V /C:"metrics.fivem.net" /C:"registry-internal.fivem.net" /C:"status.fivem.net" /C:"synapse.fivem.net" /C:"status.cfx.re" /C:"users.cfx.re" /C:"content.cfx.re" /C:"sentry.fivem.net" /C:"runtime.fivem.net" /C:"lambda.fivem.net" /C:"changelogs-live.fivem.net" /C:"servers-frontend.fivem.net" /C:"cnl-hb-live.fivem.net" /C:"policy-live.fivem.net" %windir%\System32\drivers\etc\hosts > %temp%\hosts.tmp
move /Y %temp%\hosts.tmp %windir%\System32\drivers\etc\hosts
echo Adding entries to host file...
echo 78.157.42.100		metrics.fivem.net >> %windir%\System32\drivers\etc\hosts
echo 78.157.42.100		registry-internal.fivem.net >> %windir%\System32\drivers\etc\hosts
echo 78.157.42.100		status.fivem.net >> %windir%\System32\drivers\etc\hosts
echo 78.157.42.100		synapse.fivem.net >> %windir%\System32\drivers\etc\hosts
echo 78.157.42.100		status.cfx.re >> %windir%\System32\drivers\etc\hosts
echo 10.202.10.10		users.cfx.re >> %windir%\System32\drivers\etc\hosts
echo 78.157.42.100		content.cfx.re >> %windir%\System32\drivers\etc\hosts
echo 10.202.10.10		sentry.fivem.net >> %windir%\System32\drivers\etc\hosts
echo 78.157.42.100		runtime.fivem.net >> %windir%\System32\drivers\etc\hosts
echo 10.202.10.10		lambda.fivem.net >> %windir%\System32\drivers\etc\hosts
echo 78.157.42.100		changelogs-live.fivem.net >> %windir%\System32\drivers\etc\hosts
echo 78.157.42.100		servers-frontend.fivem.net >> %windir%\System32\drivers\etc\hosts
echo 10.202.10.10		cnl-hb-live.fivem.net >> %windir%\System32\drivers\etc\hosts
echo 10.202.10.10		policy-live.fivem.net >> %windir%\System32\drivers\etc\hosts
echo Ba Movafaghiyat Nasb Shod.
pause
exit



:UninstallHostEntries
echo Removing entries from host file...
findstr /V /C:"metrics.fivem.net" /C:"registry-internal.fivem.net" /C:"status.fivem.net" /C:"synapse.fivem.net" /C:"status.cfx.re" /C:"users.cfx.re" /C:"content.cfx.re" /C:"sentry.fivem.net" /C:"runtime.fivem.net" /C:"lambda.fivem.net" /C:"changelogs-live.fivem.net" /C:"servers-frontend.fivem.net" /C:"cnl-hb-live.fivem.net" /C:"policy-live.fivem.net" %windir%\System32\drivers\etc\hosts > %temp%\hosts.tmp
move /Y %temp%\hosts.tmp %windir%\System32\drivers\etc\hosts
echo Ba Movafaghiyat Hazf Nasb Shod.
pause
exit

:MainMenu2
cls
echo Script Ejra Shod.
echo Lotfan Barnameye Morede Nazar Ro Mojadad Baz Konid.
echo ________________________
break

