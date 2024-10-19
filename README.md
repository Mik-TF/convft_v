<h1>ConvFT: File-Text Conversion Tool</h1>

<h2>Table of Contents</h2>

- [Introduction](#introduction)
- [Features](#features)
- [Installation](#installation)
  - [Prerequisites](#prerequisites)
  - [Cloning the Repository](#cloning-the-repository)
  - [Using the Makefile](#using-the-makefile)
  - [Manual Installation](#manual-installation)
- [Usage](#usage)
  - [Options:](#options)
  - [Examples:](#examples)
- [How It Works](#how-it-works)
  - [File to Text (ft)](#file-to-text-ft)
  - [Text to File (tf)](#text-to-file-tf)
- [Notes](#notes)
- [Uninstallation](#uninstallation)
- [Repository](#repository)
- [License](#license)

---

## Introduction

ConvFT is a simple CLI tool for converting between file structures and single text file representations. It's ideal for backup, sharing, and reconstructing complex directory hierarchies.

## Features

- Convert file structures to a single text file
- Reconstruct file structures from a text file
- Easy installation and uninstallation
- Colorful and informative CLI output

## Installation

### Prerequisites

- [V programming language](https://vlang.io/) (latest version) installed on your system
- Makefile (optional)

### Cloning the Repository

First, clone the repository and navigate to the project directory:

```
git clone https://github.com/Mik-TF/convft_v.git
cd convft_v
```

### Using the Makefile

ConvFT comes with a Makefile that simplifies the build and installation process. Here are the available commands:

1. To build and install ConvFT:
   ```
   make build
   ```
   This command formats the source code, compiles the program, and installs it system-wide.

2. To rebuild and reinstall ConvFT:
   ```
   make rebuild
   ```
   This command uninstalls the existing version, formats the source code, recompiles the program, and installs the new version.

3. To uninstall ConvFT:
   ```
   make delete
   ```
   This command removes ConvFT from your system.

> Note: The Makefile commands require sudo privileges as they involve system-wide installation.

### Manual Installation

To install ConvFT system-wide manually, run the following commands:

```
v fmt -w convft.v
v -o convft .
sudo ./convft install
```

These commands format the source code, compile the program, and install it system-wide.

## Usage

```
convft [OPTION]
```

### Options:

- `ft`: Convert files to text
- `tf`: Convert text to files
- `install`: Install ConvFT (requires sudo)
- `uninstall`: Uninstall ConvFT (requires sudo)
- `help`: Display help message

### Examples:

```
convft ft              # Convert current directory to 'all_files_text.txt'
convft tf              # Reconstruct files from 'all_files_text.txt'
sudo convft install    # Install ConvFT system-wide
sudo convft uninstall  # Remove ConvFT from the system
```

## How It Works

### File to Text (ft)
This option scans the current directory and its subdirectories, creating a single text file (`all_files_text.txt`) that contains the content of all files along with their relative paths.

### Text to File (tf)
This option reads the `all_files_text.txt` file and reconstructs the original file structure, creating directories and files as needed.

## Notes

- The script ignores itself and the output file during the conversion process.
- When reconstructing files, it only creates files in the current directory or its subdirectories for safety.

## Uninstallation

To remove ConvFT from your system, you can either use the Makefile:

```
make delete
```

Or run the uninstall command directly:

```
sudo convft uninstall
```

## Repository

For more information, updates, and to contribute, visit the [ConvFT GitHub repository](https://github.com/Mik-TF/convft_v).

## License

This work is under the [Apache 2.0 license](./LICENSE).