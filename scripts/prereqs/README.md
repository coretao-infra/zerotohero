# 🛠️ Manual Setup Guide (WinGet Edition)

This guide walks you through the process of installation and configuration of essential development tools required for Zero To Hero Session.

| Tool               | Target Version | WinGet Package ID            |
| ------------------ | -------------- | ---------------------------- |
| Visual Studio Code | `1.85.1`       | `Microsoft.VisualStudioCode` |
| Git for Windows    | `2.43.0`       | `Git.Git`                    |
| Python (3.12)      | `3.12.0`       | `Python.Python.3.12`         |

---

## Prerequisites

1. **Windows 10 21H2 / Windows 11** or later.
2. **PowerShell 5.1** (default on Windows) or **PowerShell 7+**.
3. **Internet connectivity** to download packages.

---

## 1. Ensure WinGet Is Available

WinGet ships with the **App Installer** package from the Microsoft Store.

```powershell
winget --version
```

• **If a version number appears**, proceed to the next step.

• **If the command is not recognized**:

1. Open the Microsoft Store → search for **_App Installer_** and click *Get* **OR**<br>
2. Download the latest bundle directly:

   ```powershell
   Invoke-WebRequest -Uri "https://aka.ms/getwinget" -OutFile "$env:TEMP\AppInstaller.msixbundle"
   Add-AppxPackage -Path "$env:TEMP\AppInstaller.msixbundle"
   ```

3. Close & reopen PowerShell, then re-run `winget --version` to verify.

> 📝 **Tip:** After installing App Installer you may need to sign out/in once for WinGet to be added to your PATH.

---

## 2. Update WinGet Sources (Optional but Recommended)

```powershell
winget source update
```

---

## 3. Install / Upgrade Tools

All commands below install **silently** and **only for your user account** (`--scope user`). If the tool is already present, WinGet will either skip or upgrade it depending on the version.

### 3.1 Visual Studio Code `1.85.1`

```powershell
# Check current installation (if any)
winget list --id Microsoft.VisualStudioCode --exact

# Install or upgrade
winget install --id Microsoft.VisualStudioCode --exact \ \
              --version 1.85.1 --scope user --silent \ \
              --accept-package-agreements --accept-source-agreements
```

### 3.2 Git for Windows `2.43.0`

```powershell
winget list --id Git.Git --exact

winget install --id Git.Git --exact --version 2.43.0 --scope user --silent \
              --accept-package-agreements --accept-source-agreements
```

### 3.3 Python `3.12.0`

```powershell
winget list --id Python.Python.3.12 --exact

winget install --id Python.Python.3.12 --exact --version 3.12.0 --scope user --silent \
              --accept-package-agreements --accept-source-agreements
```

---

## 4. Verify Installations

After each install you can confirm versions:

```powershell
# VS Code
& "$env:LOCALAPPDATA\Programs\Microsoft VS Code\Code.exe" --version

# Git
git --version   # should print 2.43.0

# Python
python --version  # should print 3.12.0
```

---

## 5. Refresh Environment Variables

Sometimes new installations are not picked up in the current shell session. Refresh your `PATH` quickly:

```powershell
$env:PATH = [System.Environment]::GetEnvironmentVariable('PATH','User') + ';' + \
            [System.Environment]::GetEnvironmentVariable('PATH','Machine')
```

Or simply **close and reopen** your terminal / VS Code window.

---

## 6. (Optional) Updating Later

To update any tool later, just run:

```powershell
winget upgrade --id <PackageID> --exact --silent --scope user \
               --accept-package-agreements --accept-source-agreements
```

Example for Git:

```powershell
winget upgrade --id Git.Git --exact --silent --scope user \
               --accept-package-agreements --accept-source-agreements
```

---

## 7. Finished!

You now have:

* Visual Studio Code `1.85.1`
* Git for Windows `2.43.0`
* Python `3.12.0`

installed **for your user account only**, exactly as the automated script would have done.

Happy coding! 🎉
