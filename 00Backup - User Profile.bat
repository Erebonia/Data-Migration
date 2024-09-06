@echo off
color 0a
Title Backup Data

type "%~dp0Titles\backup.txt"
echo.
echo.
echo Saving: Desktop, Documents, Favorites, Pictures, Downloads, Edge/Chrome bookmarks, and Printers
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
    echo Invalid User ID. If this is a new computer, have them login first.
    goto verify_id
)
echo.

:: Set default drive
c:

:: Copy user data to the drive
echo Copying Signatures...
Robocopy C:\users\%id%\AppData\Local\Microsoft\Signatures %drv%:\%id%\AppData\Local\Microsoft\Signatures /MIR /R:3 /W:5
echo Copying Desktop...
Robocopy C:\users\%id%\Desktop %drv%:\%id%\Desktop /MIR /R:3 /W:5
echo Copying Documents...
Robocopy C:\users\%id%\Documents %drv%:\%id%\Documents /MIR /R:3 /W:5
echo Copying Favorites...
Robocopy C:\users\%id%\Favorites %drv%:\%id%\Favorites /MIR /R:3 /W:5
echo Copying Pictures...
Robocopy C:\users\%id%\Pictures %drv%:\%id%\Pictures /MIR /R:3 /W:5
echo Copying Downloads...
Robocopy C:\users\%id%\Downloads %drv%:\%id%\Downloads /MIR /R:3 /W:5
echo Copying Outlook PSTs...
Robocopy C:\Outlook\ %drv%:\%id%\Outlook /MIR /R:3 /W:5
Robocopy H:\Outlook\ %drv%:\%id%\Outlook /MIR /R:3 /W:5

:: Copy bookmarks from C: drive to the external drive.
echo Copying google chrome bookmarks...
Robocopy "C:\users\%id%\AppData\Local\Google\Chrome\User Data\Default" "%drv%:\%id%\AppData\Local\Google\Chrome\User Data\Default" "Bookmarks" /R:3 /W:5

echo Copying microsoft edge bookmarks...
Robocopy "C:\users\%id%\AppData\Local\Microsoft\Edge\User Data\Default" "%drv%:\%id%\AppData\Local\Microsoft\Edge\User Data\Default" "Bookmarks" /R:3 /W:5

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
echo.

echo All files have been successfully backed up.

@Pause
