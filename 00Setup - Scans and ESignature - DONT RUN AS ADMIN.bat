@echo off
color 2

:: Run checkcert in a new window
start "" "\\ditfp1\helpdesk\!SHORTCUTS!\checkCert.bat"

:: Run Image retriever in a new window
start "Success!" "\\Ditfp1\helpdesk\PaperPort\CCHSCAN1\ImageRetrieverFix5.cmd"

echo.
echo Successfully setup scanning and digital e-signature.
echo.

@Pause