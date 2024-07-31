@echo off
color 2

echo.
echo !!! RUN AS ADMINISTRATOR !!! !!! RUN AS ADMINISTRATOR !!! !!! RUN AS ADMINISTRATOR !!!
echo.

:verify_drive
set /p drv="Enter drive letter of your external drive: "
if not exist %drv%:\ (
    echo Invalid drive letter.
    goto verify_drive
)

:verify_id
set /p id="Enter User ID: "
if not exist "C:\users\%id%" (
    echo Invalid User ID.
    goto verify_id
)

:: Set the drive to C
c:

:: Import print management printers
echo Importing print management printers...
c:\windows\system32\spool\tools\PrintBrm.exe -r -f %drv%:\%id%\printers\PrinterExport.printerExport -O FORCE
if %errorlevel% neq 0 (
    echo Failed to import printers.
    exit /b 1
)
echo Printer import completed.

pause
