# Set execution policy to bypass if needed (Remove Comment)
#powershell -ep bypass

# WebClient object 
$WebClient = New-Object System.Net.WebClient

# Define download URL path
$Win11UpgradeURL = "https://go.microsoft.com/fwlink/?linkid=2171764"
$UpgradePath = "$env:TEMP\Windows11InstallationAssistant.exe"

# Downloading the file
try {
    $WebClient.DownloadFile($Win11UpgradeURL, $UpgradePath)
    Write-Host "Download completed successfully."
} catch {
    Write-Host "Error downloading file: $_"
    exit 1
}

# Starting the upgrade process
try {
    Start-Process -FilePath $UpgradePath -ArgumentList "/Install /MinimizeToTaskbar /QuietInstall /SkipEULA"
    Write-Host "Upgrade process started successfully."
} catch {
    Write-Host "Error starting process: $_"
    exit 1
}

# Partial Cleanup (.old file cleanup not added in case we need to revert - remove after 1 week or two?)
if (Test-Path $UpgradePath) {
    try {
        Remove-Item $UpgradePath -Force
        Write-Host "Installer removed successfully."
    } catch {
        Write-Host "Error removing the installer: $_"
    }
}