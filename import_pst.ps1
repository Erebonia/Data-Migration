param (
    [string]$pstDirectory1,
    [string]$pstDirectory2
)

# Create an Outlook application object
$outlook = New-Object -ComObject Outlook.Application

# Get the namespace (MAPI)
$namespace = $outlook.GetNamespace("MAPI")

# Initialize an array to hold all PST files
$pstFiles = @()

# Check if the directories exist and get all PST files in both directories
if (Test-Path -Path $pstDirectory1) {
    $pstFiles1 = Get-ChildItem -Path $pstDirectory1 -Filter *.pst
    if ($pstFiles1.Count -gt 0) {
        $pstFiles += $pstFiles1
    }
} else {
    Write-Output "Directory does not exist: $pstDirectory1"
}

if (Test-Path -Path $pstDirectory2) {
    $pstFiles2 = Get-ChildItem -Path $pstDirectory2 -Filter *.pst
    if ($pstFiles2.Count -gt 0) {
        $pstFiles += $pstFiles2
    }
} else {
    Write-Output "PST does not exist: $pstDirectory2"
}

# Loop through each PST file and add it to the profile
foreach ($pstFile in $pstFiles) {
    $pstPath = $pstFile.FullName
    try {
        $namespace.AddStore($pstPath)
        Write-Output "PST file imported successfully: $pstPath"
    } catch {
        Write-Output "Failed to import PST file: $pstPath"
        Write-Output "Error: $_"
    }
}
