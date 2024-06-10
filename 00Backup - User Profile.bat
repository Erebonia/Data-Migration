@echo off
color 2
echo DIT - Backup User Script
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
    echo Invalid User ID
    goto verify_id
)
echo.

:: Set default drive
c:

:: Copy user data to the drive
echo Copying Desktop...
Xcopy C:\users\%id%\Desktop %drv%:\%id%\Desktop /E /C /I /Y /Q
echo Copying Documents...
Xcopy C:\users\%id%\Documents %drv%:\%id%\Documents /E /C /I /Y /Q 
echo Copying Favorites...
Xcopy C:\users\%id%\Favorites %drv%:\%id%\Favorites /E /C /I /Y /Q
echo Copying Pictures...
Xcopy C:\users\%id%\Pictures %drv%:\%id%\Pictures /E /C /I /Y /Q
echo Copying Downloads...
Xcopy C:\users\%id%\Downloads %drv%:\%id%\Downloads /E /C /I /Y /Q
echo Outlook PSTs
Xcopy C:\Outlook\ %drv%:\%id%\Outlook /E /C /I /Y /Q
Xcopy H:\Outlook\ %drv%:\%id%\Outlook /E /C /I /Y /Q

:: Copy bookmarks from C: drive to the external drive.
echo Copying google chrome bookmarks...
Xcopy "C:\users\%id%\AppData\Local\Google\Chrome\User Data\Default\Bookmarks" "%drv%:\%id%\AppData\Local\Google\Chrome\User Data\Default\Bookmarks\" /C /Y /Q 

echo Copying microsoft edge bookmarks...
Xcopy "C:\users\%id%\AppData\Local\Microsoft\Edge\User Data\Default\Bookmarks" "%drv%:\%id%\AppData\Local\Microsoft\Edge\User Data\Default\Bookmarks\" /C /Y /Q 

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
