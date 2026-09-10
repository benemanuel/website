@echo off
powershell -NoProfile -ExecutionPolicy Bypass -File "%~dp0check_before_deploy.ps1"
if errorlevel 1 (
    echo.
    echo Deploy aborted due to issues above.
    exit /b 1
)

echo Y|plink -i A:\misc\kamatera.ppk   avi@plausible.geulah.org.il /home/avi/update_website.sh
