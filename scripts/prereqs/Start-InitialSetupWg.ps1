#Requires -Version 5.1

# Define desired versions and WinGet package IDs
$desiredVersions = @{
    VSCode = "1.85.1"
    Git    = "2.43.0"
    Python = "3.12.0"
}

$wingetPackages = @{
    VSCode = "Microsoft.VisualStudioCode"
    Git    = "Git.Git"
    Python = "Python.Python.3.12"
}

# Function to check if WinGet is available
function Test-WinGetAvailable {
    try {
        $wingetVersion = winget --version 2>$null
        if ($wingetVersion) {
            Write-Host "WinGet is available: $wingetVersion" -ForegroundColor Green
            return $true
        }
    }
    catch {
        Write-Warning "WinGet is not available or not functioning properly."
        return $false
    }
    return $false
}

# Function to install WinGet if not available
function Install-WinGet {
    Write-Host "Installing WinGet..." -ForegroundColor Yellow
    
    try {
        # Download and install App Installer (which includes WinGet)
        $appInstallerUrl = "https://aka.ms/getwinget"
        $tempPath = Join-Path $env:TEMP "Microsoft.DesktopAppInstaller_8wekyb3d8bbwe.msixbundle"
        
        Write-Host "Downloading App Installer..."
        Invoke-WebRequest -Uri $appInstallerUrl -OutFile $tempPath -UseBasicParsing
        
        Write-Host "Installing App Installer..."
        Add-AppxPackage -Path $tempPath -ErrorAction Stop
        
        # Clean up
        Remove-Item $tempPath -Force -ErrorAction SilentlyContinue
        
        Write-Host "WinGet installed successfully!" -ForegroundColor Green
        return $true
    }
    catch {
        Write-Error "Failed to install WinGet: $($_.Exception.Message)"
        Write-Host "Please install WinGet manually from the Microsoft Store or visit: https://aka.ms/getwinget" -ForegroundColor Yellow
        return $false
    }
}

# Function to compare versions
function Compare-Version {
    param(
        [string]$current,
        [string]$desired
    )
    
    try {
        # Handle cases where version might have extra components (like build numbers)
        $currentParts = $current -split '\.' | Select-Object -First 3
        $desiredParts = $desired -split '\.' | Select-Object -First 3
        
        # Pad with zeros if needed
        while ($currentParts.Count -lt 3) { $currentParts += "0" }
        while ($desiredParts.Count -lt 3) { $desiredParts += "0" }
        
        $currentVersion = [version]($currentParts -join '.')
        $desiredVersion = [version]($desiredParts -join '.')
        
        if ($currentVersion -lt $desiredVersion) { return -1 }
        elseif ($currentVersion -gt $desiredVersion) { return 1 }
        else { return 0 }
    }
    catch {
        Write-Warning "Invalid version format comparing '$current' with '$desired'. Assuming update needed."
        return -1
    }
}

# Function to get installed package info from WinGet
function Get-WinGetPackageInfo {
    param([string]$packageId)
    
    try {
        $result = winget list --id $packageId --exact --accept-source-agreements 2>$null
        if ($LASTEXITCODE -eq 0 -and $result) {
            # Parse the output to extract version
            $lines = $result -split "`n"
            foreach ($line in $lines) {
                if ($line -match $packageId -and $line -match "(\d+\.\d+\.\d+)") {
                    return @{
                        Installed = $true
                        Version   = $matches[1]
                    }
                }
            }
        }
    }
    catch {
        Write-Verbose "Error checking package $packageId`: $($_.Exception.Message)"
    }
    
    return @{
        Installed = $false
        Version   = ""
    }
}

# Function to install package using WinGet
function Install-WinGetPackage {
    param(
        [string]$packageId,
        [string]$packageName,
        [string]$version = $null
    )
    
    try {
        Write-Host "Installing $packageName using WinGet..." -ForegroundColor Yellow
        
        $arguments = @("install", "--id", $packageId, "--exact", "--silent", "--accept-source-agreements", "--accept-package-agreements", "--scope", "user")
        
        if ($version) {
            $arguments += "--version"
            $arguments += $version
        }
        
        $process = Start-Process -FilePath "winget" -ArgumentList $arguments -Wait -PassThru -NoNewWindow
        
        if ($process.ExitCode -eq 0) {
            Write-Host "$packageName installation completed successfully!" -ForegroundColor Green
            return $true
        }
        else {
            Write-Warning "$packageName installation failed with exit code: $($process.ExitCode)"
            return $false
        }
    }
    catch {
        Write-Error "Failed to install $packageName`: $($_.Exception.Message)"
        return $false
    }
}

# Function to upgrade package using WinGet
function Update-WinGetPackage {
    param(
        [string]$packageId,
        [string]$packageName,
        [string]$version = $null
    )
    
    try {
        Write-Host "Updating $packageName using WinGet..." -ForegroundColor Yellow
        
        $arguments = @("upgrade", "--id", $packageId, "--exact", "--silent", "--accept-source-agreements", "--accept-package-agreements")
        
        if ($version) {
            $arguments += "--version"
            $arguments += $version
        }
        
        $process = Start-Process -FilePath "winget" -ArgumentList $arguments -Wait -PassThru -NoNewWindow
        
        if ($process.ExitCode -eq 0) {
            Write-Host "$packageName update completed successfully!" -ForegroundColor Green
            return $true
        }
        else {
            Write-Warning "$packageName update failed with exit code: $($process.ExitCode)"
            return $false
        }
    }
    catch {
        Write-Error "Failed to update $packageName`: $($_.Exception.Message)"
        return $false
    }
}

# Main script execution starts here
Write-Host "============================================" -ForegroundColor Cyan
Write-Host "Development Tools Installer (WinGet Edition)" -ForegroundColor Cyan
Write-Host "============================================" -ForegroundColor Cyan
Write-Host ""

# Check if WinGet is available
if (-not (Test-WinGetAvailable)) {
    Write-Host "WinGet is required but not available. Attempting to install..." -ForegroundColor Yellow
    if (-not (Install-WinGet)) {
        Write-Error "Cannot proceed without WinGet. Please install it manually and try again."
        exit 1
    }
    
    # Wait a moment for WinGet to be ready
    Start-Sleep -Seconds 3
    
    if (-not (Test-WinGetAvailable)) {
        Write-Error "WinGet installation completed but still not accessible. Please restart your session and try again."
        exit 1
    }
}

# Check and install/update VS Code
Write-Host "Checking VS Code..." -ForegroundColor Cyan
$vscodeInfo = Get-WinGetPackageInfo -packageId $wingetPackages.VSCode

if ($vscodeInfo.Installed) {
    $comparison = Compare-Version $vscodeInfo.Version $desiredVersions.VSCode
    
    if ($comparison -lt 0) {
        Write-Host "VS Code $($vscodeInfo.Version) installed. Updating to $($desiredVersions.VSCode)..."
        Update-WinGetPackage -packageId $wingetPackages.VSCode -packageName "VS Code" -version $desiredVersions.VSCode
    }
    else {
        Write-Host "VS Code $($vscodeInfo.Version) already installed (version meets requirement)." -ForegroundColor Green
    }
}
else {
    Write-Host "VS Code not found. Installing $($desiredVersions.VSCode)..."
    Install-WinGetPackage -packageId $wingetPackages.VSCode -packageName "VS Code" -version $desiredVersions.VSCode
}

# Check and install/update Git
Write-Host "`nChecking Git..." -ForegroundColor Cyan
$gitInfo = Get-WinGetPackageInfo -packageId $wingetPackages.Git

if ($gitInfo.Installed) {
    $comparison = Compare-Version $gitInfo.Version $desiredVersions.Git
    
    if ($comparison -lt 0) {
        Write-Host "Git $($gitInfo.Version) installed. Updating to $($desiredVersions.Git)..."
        Update-WinGetPackage -packageId $wingetPackages.Git -packageName "Git" -version $desiredVersions.Git
    }
    else {
        Write-Host "Git $($gitInfo.Version) already installed (version meets requirement)." -ForegroundColor Green
    }
}
else {
    Write-Host "Git not found. Installing $($desiredVersions.Git)..."
    Install-WinGetPackage -packageId $wingetPackages.Git -packageName "Git" -version $desiredVersions.Git
}

# Check and install/update Python
Write-Host "`nChecking Python..." -ForegroundColor Cyan
$pythonInfo = Get-WinGetPackageInfo -packageId $wingetPackages.Python

if ($pythonInfo.Installed) {
    $comparison = Compare-Version $pythonInfo.Version $desiredVersions.Python
    
    if ($comparison -lt 0) {
        Write-Host "Python $($pythonInfo.Version) installed. Updating to $($desiredVersions.Python)..."
        Update-WinGetPackage -packageId $wingetPackages.Python -packageName "Python" -version $desiredVersions.Python
    }
    else {
        Write-Host "Python $($pythonInfo.Version) already installed (version meets requirement)." -ForegroundColor Green
    }
}
else {
    Write-Host "Python not found. Installing $($desiredVersions.Python)..."
    Install-WinGetPackage -packageId $wingetPackages.Python -packageName "Python" -version $desiredVersions.Python
}

# Final message
Write-Host ""
Write-Host "============================================" -ForegroundColor Green
Write-Host "Installation completed successfully!" -ForegroundColor Green
Write-Host "============================================" -ForegroundColor Green
Write-Host ""
Write-Host "Summary of installed tools:" -ForegroundColor Cyan
Write-Host "- VS Code: $($desiredVersions.VSCode)" -ForegroundColor White
Write-Host "- Git: $($desiredVersions.Git)" -ForegroundColor White
Write-Host "- Python: $($desiredVersions.Python)" -ForegroundColor White
Write-Host ""
Write-Host "Please restart your PowerShell session to ensure all environment variables are loaded properly." -ForegroundColor Yellow
Write-Host "You may also need to restart VS Code if it was already running." -ForegroundColor Yellow
