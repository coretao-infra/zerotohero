# 01_Foundations CLI-101

Welcome to **CLI-101: Foundations of Command Line Interfaces** — your first step into the powerful world of command-line tools and scripting! This 100-level course is designed for beginners who want to build a solid understanding of how command-line interfaces (CLIs) work, with a focus on **PowerShell** and an introduction to **Bash**.

Whether you're preparing for system administration, automation, or just want to level up your technical skills, mastering the CLI is essential. This course will help you become comfortable navigating file systems, managing files and processes, and writing simple scripts—all from the command line.

---

## 🎯 What You'll Learn

By the end of this course, you will be able to:

- Understand the role and importance of the command line in computing.
- Navigate file systems using PowerShell and Bash.
- Perform common file and directory operations (create, move, copy, delete).
- Work with command syntax, flags, and arguments.
- Use built-in help systems (`Get-Help`, `man`, `--help`).
- Manage processes and services.
- Redirect input/output and pipe commands together.
- Write and execute basic scripts in PowerShell and Bash.
- Compare and contrast PowerShell and Bash environments.

---

## 🧰 Tools & Technologies

- **PowerShell** (Windows, macOS, Linux) – Object-oriented shell and scripting language.
- **Bash** (Unix-like systems, including Linux and macOS) – The standard shell for most Linux distributions.
- Terminal/Console applications (Windows Terminal, Terminal.app, GNOME Terminal, etc.)

> 💡 No prior experience required! We'll guide you through installation and setup.

---

## 📁 Folder Structure

```
01_Foundations CLI-101/
│
├── 01_Introduction/               # What is a CLI? Why use it?
├── 02_Navigation/                 # pwd, cd, ls, Get-Location, Set-Location
├── 03_File_Operations/            # mkdir, touch, cp, mv, rm, New-Item, Copy-Item
├── 04_Command_Help/               # Get-Help, man, --help, examples
├── 05_Piping_and_Redirection/     # |, >, >>, Out-File, Tee-Object
├── 06_Scripting_Basics/           # Writing .ps1 and .sh scripts
├── 07_Environment_Variables/      # $env:VAR, printenv, $PROFILE
├── 08_Practice_Exercises/         # Hands-on labs and challenges
└── README.md                      # You are here!
```

Each folder contains hands-on exercises, code examples, and cheat sheets.

---

## 🚀 Getting Started

### For Windows Users
- PowerShell is preinstalled (Windows 7+).
- Open **PowerShell** from Start Menu or use **Windows Terminal** (recommended).

### For macOS and Linux Users
- Bash is your default shell.
- Install PowerShell:  
  ```bash
  # macOS (using Homebrew)
  brew install --cask powershell

  # Ubuntu/Debian
  sudo apt install -y powershell
  ```

### Launching the Shell
- **PowerShell**: Run `pwsh` or `powershell`
- **Bash**: Open Terminal (default on macOS/Linux)

---

## 📚 Resources & References

- [Microsoft Learn: PowerShell Documentation](https://learn.microsoft.com/en-us/powershell/)
- [The Linux Command Line (TLCL) – Free Book](https://linuxcommand.org/tlcl.php)
- [ExplainShell.com](https://www.explainshell.com) – Break down complex commands
- [PowerShell Gallery](https://www.powershellgallery.com) – Modules and scripts

---

## 🛠️ Practice, Practice, Practice!

The best way to learn the CLI is by doing. Each section includes:
- Step-by-step tutorials
- Real-world examples
- Challenges with solutions

> 💡 Pro Tip: Try typing commands manually instead of copying — muscle memory matters!

---

## 🤝 Feedback & Contributions

This course is part of an open educational series. Found an error? Want to add a lab?  
We welcome contributions! Please open an issue or submit a pull request.

---

## 📌 Next Steps

After completing **CLI-101**, continue your journey with:
- **02_Automation PS-201**: PowerShell Scripting & Automation
- **03_Administration Bash-201**: Linux System Administration with Bash

---

📘 **Ready to take control of your computer? Open your terminal and type your first command!**  
`Write-Host "Hello, CLI World!"`  
or  
`echo "Hello, CLI World!"`

Let the journey begin! 💻✨



## **📚 Learning Path**  
### **1️⃣ Introduction to CLI**  
- What is a command-line interface?  
- Differences between **PowerShell** (Windows) and **Bash** (Linux/macOS).  
- Opening a terminal:  
  - Windows: `Win + X` → PowerShell  
  - macOS/Linux: `Terminal` or `Ctrl+Alt+T`  

### **2️⃣ Basic Commands**  
| **Task**               | **PowerShell**         | **Bash**               |  
|------------------------|------------------------|------------------------|  
| List files             | `Get-ChildItem` (`gci`)| `ls`                   |  
| Change directory       | `Set-Location` (`cd`)  | `cd`                   |  
| Create a file          | `New-Item file.txt`    | `touch file.txt`       |  
| Read file content      | `Get-Content file.txt` | `cat file.txt`         |  
| Delete a file          | `Remove-Item file.txt` | `rm file.txt`          |  

### **3️⃣ File System Navigation**  
- **Relative vs. absolute paths** (`./folder` vs. `/home/user/folder`).  
- **Wildcards**: `*` (e.g., `ls *.txt`).  

### **4️⃣ Scripting Basics**  
- **PowerShell**:  
  ```powershell
  # HelloWorld.ps1
  Write-Host "Hello, PowerShell!"
  ```
  Run with: `.\HelloWorld.ps1`.  

- **Bash**:  
  ```bash
  #!/bin/bash
  echo "Hello, Bash!"
  ```
  Run with: `chmod +x script.sh && ./script.sh`.  

---

## **🔧 Exercises**  
1. Navigate to a folder and list all `.txt` files.  
2. Create a script that greets the user by name.  
3. Pipe commands (e.g., `Get-Content log.txt | Select-String "error"`).  

---

## **🚀 Next Steps**  
- Explore **environment variables** (`$env:PATH` / `echo $PATH`).  
- Learn **aliases** (`New-Alias` / `alias`).  
- Dive into **conditionals** and **loops**.  

---

## **📌 Resources**  
- [PowerShell Docs](https://docs.microsoft.com/en-us/powershell/)  
- [Bash Guide](https://linuxconfig.org/bash-scripting-tutorial-for-beginners)  
- [Interactive CLI Practice](https://cmdchallenge.com/)  

---

## **💬 How to Contribute**  
Found a typo or have an improvement? Submit a **PR** or open an **issue**!  

**Happy scripting!** 🎉  

---  

### **Preview:**  
![CLI-101 Preview](https://via.placeholder.com/600x200?text=PowerShell+%26+Bash+Cheat+Sheet)  

*(Replace the placeholder with an actual screenshot of your CLI examples if desired.)*  

---  

This keeps it **modular, hands-on, and beginner-focused** while allowing scalability (e.g., adding advanced exercises later). Would you like to include **quizzes** or a **troubleshooting section**?