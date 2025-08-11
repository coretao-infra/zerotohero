#Requires -Version 5.1

# Define desired versions
$desiredVersions = @{
    VSCode = "1.85.1"
    Git    = "2.43.0"
    Python = "3.12.0"
}

# Create temp directory for downloads
$tempDir = Join-Path $env:TEMP "BoilerplateInstaller"
if (-not (Test-Path $tempDir)) {
    New-Item -ItemType Directory -Path $tempDir | Out-Null
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

# Function to install VS Code (user scope)
function Install-VSCode {
    param([string]$version)
    
    $url = "https://update.code.visualstudio.com/$version/win32-x64-user/stable"
    $installer = Join-Path $tempDir "VSCodeUserSetup-$version.exe"
    
    try {
        Write-Host "Downloading VS Code $version..."
        Invoke-WebRequest -Uri $url -OutFile $installer -ErrorAction Stop
        
        Write-Host "Installing VS Code (user scope)..."
        $process = Start-Process -FilePath $installer -ArgumentList "/verysilent /mergetasks=!runcode" -Wait -PassThru
        
        if ($process.ExitCode -ne 0) {
            throw "Installation failed with exit code $($process.ExitCode)"
        }
        
        Write-Host "VS Code installation completed successfully."
    }
    catch {
        Write-Error "Failed to install VS Code: $($_.Exception.Message)"
    }
    finally {
        if (Test-Path $installer) {
            Remove-Item $installer -Force -ErrorAction SilentlyContinue
        }
    }
}

# Function to install Git (user scope)
function Install-Git {
    param([string]$version)
    
    $url = "https://github.com/git-for-windows/git/releases/download/v$version.windows.1/Git-$version-64-bit.exe"
    $installer = Join-Path $tempDir "Git-$version-64-bit.exe"
    
    try {
        Write-Host "Downloading Git $version..."
        Invoke-WebRequest -Uri $url -OutFile $installer -ErrorAction Stop
        
        Write-Host "Installing Git (user scope)..."
        $process = Start-Process -FilePath $installer -ArgumentList "/SILENT /NORESTART /NOCANCEL /SP- /CURRENTUSER /COMPONENTS='gitlfs,assoc,assoc_sh'" -Wait -PassThru
        
        if ($process.ExitCode -ne 0) {
            throw "Installation failed with exit code $($process.ExitCode)"
        }
        
        Write-Host "Git installation completed successfully."
        
        # Refresh environment variables
        $env:PATH = [System.Environment]::GetEnvironmentVariable("PATH", "User") + ";" + [System.Environment]::GetEnvironmentVariable("PATH", "Machine")
    }
    catch {
        Write-Error "Failed to install Git: $($_.Exception.Message)"
    }
    finally {
        if (Test-Path $installer) {
            Remove-Item $installer -Force -ErrorAction SilentlyContinue
        }
    }
}

# Function to install Python (user scope)
function Install-Python {
    param([string]$version)
    
    $url = "https://www.python.org/ftp/python/$version/python-$version-amd64.exe"
    $installer = Join-Path $tempDir "python-$version-amd64.exe"
    
    try {
        Write-Host "Downloading Python $version..."
        Invoke-WebRequest -Uri $url -OutFile $installer -ErrorAction Stop
        
        Write-Host "Installing Python (user scope)..."
        $process = Start-Process -FilePath $installer -ArgumentList "/quiet InstallAllUsers=0 PrependPath=1 Include_test=0" -Wait -PassThru
        
        if ($process.ExitCode -ne 0) {
            throw "Installation failed with exit code $($process.ExitCode)"
        }
        
        Write-Host "Python installation completed successfully."
        
        # Refresh environment variables
        $env:PATH = [System.Environment]::GetEnvironmentVariable("PATH", "User") + ";" + [System.Environment]::GetEnvironmentVariable("PATH", "Machine")
    }
    catch {
        Write-Error "Failed to install Python: $($_.Exception.Message)"
    }
    finally {
        if (Test-Path $installer) {
            Remove-Item $installer -Force -ErrorAction SilentlyContinue
        }
    }
}

# Check and install VS Code
$vscodePath = "$env:LOCALAPPDATA\Programs\Microsoft VS Code\Code.exe"
if (Test-Path $vscodePath) {
    try {
        $currentVersion = (Get-Item $vscodePath).VersionInfo.ProductVersion
        $comparison = Compare-Version $currentVersion $desiredVersions.VSCode
        
        if ($comparison -lt 0) {
            Write-Host "VS Code $currentVersion installed. Updating to $($desiredVersions.VSCode)..."
            Install-VSCode -version $desiredVersions.VSCode
        }
        else {
            Write-Host "VS Code $currentVersion already installed (version meets requirement)."
        }
    }
    catch {
        Write-Warning "VS Code found but version could not be determined. Reinstalling..."
        Install-VSCode -version $desiredVersions.VSCode
    }
}
else {
    Write-Host "VS Code not found. Installing $($desiredVersions.VSCode)..."
    Install-VSCode -version $desiredVersions.VSCode
}

# Check and install Git
$gitInstalled = $false
$currentGitVersion = ""

# Check if Git command exists and works
if (Get-Command git -ErrorAction SilentlyContinue) {
    try {
        $gitOutput = git --version 2>&1
        if ($gitOutput -isnot [System.Management.Automation.ErrorRecord] -and 
            $gitOutput -match "git version (\d+\.\d+\.\d+)") {
            $currentGitVersion = $matches[1]
            $gitInstalled = $true
        }
    }
    catch {
        Write-Warning "Git command exists but failed to execute properly."
    }
}

# Alternative check for Git in common installation paths
if (-not $gitInstalled) {
    $possibleGitPaths = @(
        "$env:LOCALAPPDATA\Programs\Git\bin\git.exe"
        "$env:ProgramFiles\Git\bin\git.exe"
        "$env:ProgramFiles(x86)\Git\bin\git.exe"
    )
    
    foreach ($gitPath in $possibleGitPaths) {
        if (Test-Path $gitPath) {
            try {
                $gitOutput = & $gitPath --version 2>&1
                if ($gitOutput -match "git version (\d+\.\d+\.\d+)") {
                    $currentGitVersion = $matches[1]
                    $gitInstalled = $true
                    break
                }
            }
            catch {
                continue
            }
        }
    }
}

# Handle Git installation based on findings
if ($gitInstalled) {
    $comparison = Compare-Version $currentGitVersion $desiredVersions.Git
    
    if ($comparison -lt 0) {
        Write-Host "Git $currentGitVersion installed. Updating to $($desiredVersions.Git)..."
        Install-Git -version $desiredVersions.Git
    }
    else {
        Write-Host "Git $currentGitVersion already installed (version meets requirement)."
    }
}
else {
    Write-Host "Git not found. Installing $($desiredVersions.Git)..."
    Install-Git -version $desiredVersions.Git
}

# Check and install Python
$pythonInstalled = $false
$currentPythonVersion = ""

# First check if python command exists and works
if (Get-Command python -ErrorAction SilentlyContinue) {
    try {
        $pythonOutput = python --version 2>&1
        if ($pythonOutput -isnot [System.Management.Automation.ErrorRecord] -and 
            $pythonOutput -match "Python (\d+\.\d+\.\d+)") {
            $currentPythonVersion = $matches[1]
            $pythonInstalled = $true
        }
    }
    catch {
        Write-Warning "Python command exists but failed to execute properly."
    }
}

# Check for Python in common installation paths
if (-not $pythonInstalled) {
    $possiblePythonPaths = @(
        "$env:LOCALAPPDATA\Programs\Python\Python*\python.exe"
        "$env:APPDATA\Python\Python*\python.exe"
        "$env:ProgramFiles\Python*\python.exe"
    )
    
    foreach ($pathPattern in $possiblePythonPaths) {
        $foundPython = Get-Item $pathPattern -ErrorAction SilentlyContinue | 
        Sort-Object LastWriteTime -Descending | 
        Select-Object -First 1
        
        if ($foundPython) {
            try {
                $pythonOutput = & $foundPython.FullName --version 2>&1
                if ($pythonOutput -match "Python (\d+\.\d+\.\d+)") {
                    $currentPythonVersion = $matches[1]
                    $pythonInstalled = $true
                    break
                }
            }
            catch {
                continue
            }
        }
    }
}

# Handle Python installation based on findings
if ($pythonInstalled) {
    $comparison = Compare-Version $currentPythonVersion $desiredVersions.Python
    
    if ($comparison -lt 0) {
        Write-Host "Python $currentPythonVersion installed. Updating to $($desiredVersions.Python)..."
        Install-Python -version $desiredVersions.Python
    }
    else {
        Write-Host "Python $currentPythonVersion already installed (version meets requirement)."
    }
}
else {
    Write-Host "Python not found. Installing $($desiredVersions.Python)..."
    Install-Python -version $desiredVersions.Python
}

# Clean up and final message
try {
    Remove-Item $tempDir -Recurse -Force -ErrorAction SilentlyContinue
    Write-Host ""
    Write-Host "============================================" -ForegroundColor Green
    Write-Host "Installation completed successfully!" -ForegroundColor Green
    Write-Host "============================================" -ForegroundColor Green
    Write-Host ""
    Write-Host "Please restart your PowerShell session to ensure all environment variables are loaded properly." -ForegroundColor Yellow
}
catch {
    Write-Warning "Could not clean up temporary directory: $tempDir"
}