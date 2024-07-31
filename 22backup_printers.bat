@echo off
color 2

echo.
echo !!! RUN AS ADMINISTRATOR !!! !!! RUN AS ADMINISTRATOR !!! !!! RUN AS ADMINISTRATOR !!!
echo.

:verify_drive
set /p drv="Enter Drive Letter you want to save this data: "

if not exist %drv%:\ (
    echo Invalid drive letter
    goto verify_drive
)

:verify_id
set /p id="Enter User ID: "
if not exist C:\users\%id% (
    echo Invalid User ID
    goto verify_id
)
echo.

:: Set default drive
c:

:: Export print management printers
echo Exporting print management printers...
if not exist %drv%:\%id%\printers (
    mkdir %drv%:\%id%\printers
)
c:\windows\system32\spool\tools\PrintBrm.exe -b -f %drv%:\%id%\printers\PrinterExport.printerExport -O FORCE
if %errorlevel% neq 0 (
    echo Failed to export printers.
    exit /b 1
)

echo Printer export completed.

@Pause
