@echo off

for /f %%a in ('wmic path win32_localtime get dayofweek /format:list ^| findstr "="') do (set %%a)
echo Tag: %dayofweek%

set BACKUPDIR=%USERPROFILE%\Desktop\Firefox-Backup
echo Backup-Verzeichnis: %BACKUPDIR%
mkdir %BACKUPDIR%

set FILETOZIP=%APPDATA%\Mozilla\Firefox
set TEMPDIR=%TEMP%\firefox-backup

echo Quellverzeichnis: %FILETOZIP%

tasklist /fi "imagename eq firefox.exe" | find /i "firefox.exe" > nul

IF NOT errorlevel==1 (
    echo Firefox ist aktiv. Bitte erst beenden.
    pause
    exit 1
) ELSE (
    echo Backup beginnt..
    rem rmdir %TEMPDIR%
    mkdir %TEMPDIR%
    echo Sammle Dateien..
    robocopy.exe %FILETOZIP% %TEMPDIR% /mir /XD storage /NFL /NDL
    echo Komprimiere Dateien..
    powershell Compress-Archive -Path %TEMPDIR% -DestinationPath %BACKUPDIR%\firefox-backup-day-%dayofweek%.zip -Force

    rem powershell Compress-Archive -Path %FILETOZIP% -DestinationPath %BACKUPDIR%\firefox-backup-day-%dayofweek%.zip -Force
    echo Backup abgeschlossen.
    pause
    exit 0

)
