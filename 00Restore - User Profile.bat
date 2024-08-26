@echo off
color 2
echo DIT Restore User Script
echo DO NOT RESTORE UNLESS THE USER HAS LOGGED ON THE COMPUTER AT LEAST ONCE!
echo.
echo !!! RUN AS ADMINISTRATOR !!! !!! RUN AS ADMINISTRATOR !!! !!! RUN AS ADMINISTRATOR !!!
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

:: Restore user data
echo Restoring signatures...
Robocopy "%drv%:\%id%\AppData\Local\Microsoft\Signatures" "C:\users\%id%\AppData\Local\Microsoft\Signatures" /MIR /R:3 /W:5
echo Restoring Desktop...
Robocopy "%drv%:\%id%\Desktop" "C:\users\%id%\Desktop" /MIR /R:3 /W:5
echo Restoring Documents...
Robocopy "%drv%:\%id%\Documents" "C:\users\%id%\Documents" /MIR /R:3 /W:5
echo Restoring Favorites...
Robocopy "%drv%:\%id%\Favorites" "C:\users\%id%\Favorites" /MIR /R:3 /W:5
echo Restoring Pictures...
Robocopy "%drv%:\%id%\Pictures" "C:\users\%id%\Pictures" /MIR /R:3 /W:5
echo Restoring Downloads...
Robocopy "%drv%:\%id%\Downloads" "C:\users\%id%\Downloads" /MIR /R:3 /W:5
echo Restoring Outlook data...
Robocopy "%drv%:\%id%\Outlook" "C:\users\%id%\Outlook" /MIR /R:3 /W:5

:: Restore bookmarks
echo Restoring Google Chrome bookmarks...
Robocopy "%drv%:\%id%\AppData\Local\Google\Chrome\User Data\Default" "C:\users\%id%\AppData\Local\Google\Chrome\User Data\Default" "Bookmarks" /R:3 /W:5

echo Restoring Microsoft Edge bookmarks...
Robocopy "%drv%:\%id%\AppData\Local\Microsoft\Edge\User Data\Default" "C:\users\%id%\AppData\Local\Microsoft\Edge\User Data\Default" "Bookmarks" /R:3 /W:5

:: Import print management printers
echo Importing print management printers...
c:\windows\system32\spool\tools\PrintBrm.exe -r -f %drv%:\%id%\printers\PrinterExport.printerExport -O FORCE
if %errorlevel% neq 0 (
    echo Failed to import printers.
    exit /b 1
)
echo Printer import completed.

:: Copy PST files (if they are stored separately)
echo Restoring PST files...
Robocopy "%drv%:\%id%\Documents\Outlook Files" "C:\Users\%id%\Documents\Outlook Files" *.pst /R:3 /W:5

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
