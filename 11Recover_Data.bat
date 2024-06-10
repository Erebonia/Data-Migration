@echo off
color 2
echo DIT - Data Recovery Tool
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

:: Copy user data to the drive
echo Copying Desktop...
Xcopy %rcv%:\users\%id%\Desktop %drv%:\%id%\Desktop /E /C /I /Y /Q
echo Copying Documents...
Xcopy %rcv%:\users\%id%\Documents %drv%:\%id%\Documents /E /C /I /Y /Q 
echo Copying Favorites...
Xcopy %rcv%:\users\%id%\Favorites %drv%:\%id%\Favorites /E /C /I /Y /Q
echo Copying Pictures...
Xcopy %rcv%:\users\%id%\Pictures %drv%:\%id%\Pictures /E /C /I /Y /Q
echo Copying Downloads...
Xcopy %rcv%:\users\%id%\Downloads %drv%:\%id%\Downloads /E /C /I /Y /Q
echo Outlook PSTs
Xcopy C:\Outlook\ %drv%:\%id%\Outlook /E /C /I /Y /Q
Xcopy H:\Outlook\ %drv%:\%id%\Outlook /E /C /I /Y /Q

:: Copy bookmarks from C: drive to the external drive.
echo Copying google chrome bookmarks...
Xcopy "%rcv%:\users\%id%\AppData\Local\Google\Chrome\User Data\Default\Bookmarks" "%drv%:\%id%\AppData\Local\Google\Chrome\User Data\Default\Bookmarks\" /C /Y /Q 

echo Copying microsoft edge bookmarks...
Xcopy "%rcv%:\users\%id%\AppData\Local\Microsoft\Edge\User Data\Default\Bookmarks" "%drv%:\%id%\AppData\Local\Microsoft\Edge\User Data\Default\Bookmarks\" /C /Y /Q 

echo.

echo All files have been successfully backed up.

@Pause
