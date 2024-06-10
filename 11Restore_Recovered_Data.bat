@echo off
color 2
echo DIT Restore User Script
echo DO NOT RESTORE UNLESS THE USER HAS LOGGED ON THE COMPUTER AT LEAST ONCE!
echo.

:verify_drive
set /p drv="Enter drive letter of your external drive: "
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

:: Set the drive to C
c:

:: Copy these destinations
echo Restoring Desktop...
Xcopy "%drv%:\%id%\Desktop" "C:\users\%id%\Desktop" /E /C /I /Y /Q
echo Restoring Documents...
Xcopy "%drv%:\%id%\Documents" "C:\users\%id%\Documents" /E /C /I /Y /Q
echo Restoring Favorites...
Xcopy "%drv%:\%id%\Favorites" "C:\users\%id%\Favorites" /E /C /I /Y /Q
echo Restoring Pictures...
Xcopy "%drv%:\%id%\Pictures" "C:\users\%id%\Pictures" /E /C /I /Y /Q
echo Restoring Downloads...
Xcopy "%drv%:\%id%\Downloads" "C:\users\%id%\Downloads" /E /C /I /Y /Q
echo Searching for Outlook PSTs...
Xcopy "%drv%:\%id%\Outlook" "C:\users\%id%\Outlook" /E /C /I /Y /Q

:: Copy bookmarks from the external drive
:: Utilize echo F to tell the program we are copying and pasting a file.
echo Restoring Google Chrome bookmarks...
echo F | Xcopy "%drv%:\%id%\AppData\Local\Google\Chrome\User Data\Default\Bookmarks" "C:\users\%id%\AppData\Local\Google\Chrome\User Data\Default\Bookmarks" /C /Y /Q

echo Restoring Microsoft Edge bookmarks...
echo F | Xcopy "%drv%:\%id%\AppData\Local\Microsoft\Edge\User Data\Default\Bookmarks" "C:\users\%id%\AppData\Local\Microsoft\Edge\User Data\Default\Bookmarks" /C /Y /Q

:: Copy PST files
echo Restoring PST files...
Xcopy "%drv%:\%id%\Documents\Outlook Files\*.pst" "C:\Users\%id%\Documents\Outlook Files\" /C /Y /Q

:: Set the path for the PowerShell script on the external drive
set psScriptPath="%drv%:\Data Migration Script\import_pst.ps1"

:: Generate PowerShell script for importing PST files
echo Creating PowerShell script for PST import...
(
echo param ^(
echo     [string]$pstDirectory1,
echo     [string]$pstDirectory2
echo ^)
echo
echo # Create an Outlook application object
echo $outlook = New-Object -ComObject Outlook.Application
echo
echo # Get the namespace (MAPI)
echo $namespace = $outlook.GetNamespace("MAPI")
echo
echo # Initialize an array to hold all PST files
echo $pstFiles = @()
echo
echo # Get all PST files in both directories
echo $pstFiles += Get-ChildItem -Path $pstDirectory1 -Filter *.pst
echo $pstFiles += Get-ChildItem -Path $pstDirectory2 -Filter *.pst
echo
echo # Loop through each PST file and add it to the profile
echo foreach ($pstFile in $pstFiles) {
echo     $pstPath = $pstFile.FullName
echo     try {
echo         $namespace.AddStore($pstPath)
echo         Write-Output "PST file imported successfully: $pstPath"
echo     } catch {
echo         Write-Output "Failed to import PST file: $pstPath"
echo         Write-Output "Error: $_"
echo     }
echo }
) > %psScriptPath%


:: Determine the user's directories
set userDirectory1=C:\Users\%id%\Documents\Outlook Files
set userDirectory2=C:\Users\%id%\Outlook

:: Execute the PowerShell script, passing the directory paths as arguments
echo Importing PST files into Outlook...
PowerShell -ExecutionPolicy Bypass -File %psScriptPath% -pstDirectory1 "%userDirectory1%" -pstDirectory2 "%userDirectory2%"

echo All files have been successfully restored and PST files have been imported.

pause
