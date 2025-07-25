# 🛠️ Data Migration Toolkit

![images](https://github.com/Erebonia/Data-Migration/assets/52137104/f6fc75c6-52ec-424b-8579-b70fa26f9023)

As a Software Engineer supporting IT infrastructure, I developed this toolkit to streamline and standardize **user profile migration**, **printer configuration backup**, and **recovery workflows** across Windows environments. These scripts are designed for use in technician workstations and was integrated into Claytonic another project of mine that is a centralized GUI app for IT automation.

---

## 🧠 Overview

This repository contains a collection of production-tested `.bat` and PowerShell scripts used in:

- End-user data migration between devices
- Printer backup and restoration
- PST archive recovery for Outlook
- Cross-drive data recovery from non-standard drive letters

All scripts were written for **Windows IT support environments**, particularly during hardware refreshes, OS reinstalls, and workstation replacements.

---

## 🚀 Features

### 🔁 User Profile Migration
- `00Backup - User Profile.bat`  
  Archives key folders from the user profile (Desktop, Documents, AppData, etc.)

- `00Restore - User Profile.bat`  
  Restores user data to a freshly imaged system using standardized paths

### 🖨️ Printer Configuration
- `22backup_printers.bat`  
  Exports all installed printers and port settings to file

- `22restore_printers.bat`  
  Reinstalls printers using previously exported data

### 🧾 Outlook PST Importing
- `import_pst.ps1`  
  PowerShell script that scans for `.pst` archives and automates import into Outlook

### 💽 Drive-Agnostic Recovery
- `Recover_From_Any_Drive.bat`  
  Locates backup data on external drives regardless of assigned drive letter

- `Restore_From_Any_Drive.bat`  
  Reinstalls files and settings from non-C:\ sources, useful after OS reinstallations

---

## 📂 Included Documentation

| File                                      | Purpose                                 |
|-------------------------------------------|-----------------------------------------|
| `Guide - Data Migration.docx`             | Step-by-step instructions for profile migration |
| `Guide - Data Recovery.docx`              | Guide for technicians performing file recovery |
| `Guide - Printer Backup and Restore.docx` | Printer-specific workflow documentation  |

---

## ⚙️ Usage

These scripts are intended to be run with **elevated privileges** on Windows 10/11. Some scripts assume the presence of a backup share or removable storage device.

- Double-click `.bat` scripts from technician desktop or launch via GUI frontend (e.g., Claytonic)
- PowerShell script requires execution policy that allows scripting (`RemoteSigned` or `Unrestricted`)

---

## 🔐 Security Practices

- Uses safe path expansions and environment variables (e.g., `%USERPROFILE%`)
- Avoids destructive actions — all scripts copy data, never delete
- Designed to be auditable and readable by Level 1–2 IT staff

---

## 👨‍💻 About This Project

This toolkit was developed as part of a larger initiative to consolidate and automate common IT technician workflows. It was later integrated into **Claytonic**, a custom C# Windows Forms application serving as a centralized launcher for support operations.

---

## 📄 License

This project is shared for educational and reference purposes.  
Attribution is appreciated; no warranties are provided.


