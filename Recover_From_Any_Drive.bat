@echo off
color 0a
Title Backup Data

type "%~dp0Titles\backup.txt"
echo.
echo.
echo Saving: Desktop, Documents, Favorites, Pictures, Downloads, Edge/Chrome bookmarks, Outlook PSTs
echo.

::verify_recovery
set /p rcv="Enter the drive letter we are recovering data from: "

:verify_drive
set /p drv="Enter Drive Letter you want to save this data: "

if not exist %drv%:\ (
    echo Invalid drive letter
    goto verify_drive
)

:verify_id
set /p id="Enter User ID: "
if not exist %rcv%:\users\%id% (
    echo Invalid User ID
    goto verify_id
)
echo.

:: Set default drive
%rcv%:

:: Copy user data to the drive using Robocopy
echo Copying Desktop...
Robocopy %rcv%:\users\%id%\Desktop %drv%:\%id%\Desktop /E /Z /R:3 /W:5 /MT
echo Copying Documents...
Robocopy %rcv%:\users\%id%\Documents %drv%:\%id%\Documents /E /Z /R:3 /W:5 /MT
echo Copying Favorites...
Robocopy %rcv%:\users\%id%\Favorites %drv%:\%id%\Favorites /E /Z /R:3 /W:5 /MT
echo Copying Pictures...
Robocopy %rcv%:\users\%id%\Pictures %drv%:\%id%\Pictures /E /Z /R:3 /W:5 /MT
echo Copying Downloads...
Robocopy %rcv%:\users\%id%\Downloads %drv%:\%id%\Downloads /E /Z /R:3 /W:5 /MT
echo Copying Outlook PSTs...
Robocopy C:\Outlook %drv%:\%id%\Outlook /E /Z /R:3 /W:5 /MT
Robocopy H:\Outlook %drv%:\%id%\Outlook /E /Z /R:3 /W:5 /MT

:: Copy bookmarks from C: drive to the external drive using Robocopy.
echo Copying google chrome bookmarks...
Robocopy "%rcv%:\users\%id%\AppData\Local\Google\Chrome\User Data\Default" "%drv%:\%id%\AppData\Local\Google\Chrome\User Data\Default" "Bookmarks" /Z /R:3 /W:5 /MT

echo Copying microsoft edge bookmarks...
Robocopy "%rcv%:\users\%id%\AppData\Local\Microsoft\Edge\User Data\Default" "%drv%:\%id%\AppData\Local\Microsoft\Edge\User Data\Default" "Bookmarks" /Z /R:3 /W:5 /MT

echo.

echo All files have been successfully backed up.

@Pause
