# SQL Server Backup Automation

This project contains a simple backup workflow for SQL Server databases that:

- creates a timestamped `.bak` backup file
- writes the backup path to a text file
- compresses the backup with 7-Zip
- removes the original backup file
- moves the compressed archive to OneDrive

This is a lightweight, practical setup suited for scheduled or manual SQL backups on a Windows server.

## Files

- [step01_sqlbackup.tsql](step01_sqlbackup.tsql) — creates a SQL Server backup file with a timestamped name and records the backup path into `D:\SQLBackup\file.txt`
- [step02_compress_backup.ps1](step02_compress_backup.ps1) — reads the backup file path, compresses it with 7-Zip, deletes the original, and moves the archive to OneDrive

## How it works

### 1) SQL backup step
The T-SQL script:

- sets the backup destination folder to `D:\SQLBackup\`
- creates a filename using the current date and time
- backs up the database `dbname_new`
- writes the full backup file path into `D:\SQLBackup\file.txt`

Example generated filename:

- `dbname_new_20261003_153045.bak`

### 2) Compression step
The PowerShell script:

- reads the path from `D:\SQLBackup\file.txt`
- trims whitespace
- runs 7-Zip using:
  - `C:\Program Files\7-Zip\7z.exe`
- creates a `.7z` archive
- removes the original `.bak` file
- moves the archive into OneDrive backup storage

## Prerequisites

Before using the scripts, make sure the following are available:

- Microsoft SQL Server with access to run T-SQL commands
- SQL Server permissions to run `BACKUP DATABASE`
- `xp_cmdshell` enabled if you plan to use the command execution inside SQL Server
- 7-Zip installed at `C:\Program Files\7-Zip\7z.exe`
- Windows file system access to:
  - `D:\SQLBackup\`
  - `D:\OneDrive\OneDrive_Org\backup\erpserver`

## Usage

### Step 1: Run the SQL backup script
Execute [step01_sqlbackup.tsql](step01_sqlbackup.tsql) in SQL Server Management Studio or another SQL client.

This generates a file such as:

- `D:\SQLBackup\dbname_new_20261003_153045.bak`

and writes the path to:

- `D:\SQLBackup\file.txt`

### Step 2: Run the compression script
Execute [compress_backup.ps1](compress_backup.ps1) from PowerShell.

This will:

1. read the path from the text file
2. compress the backup with 7-Zip
3. delete the original `.bak`
4. move the final `.7z` file to OneDrive

## Customization points

You may want to adjust the following for your environment:

- database name: `dbname_new`
- backup folder: `D:\SQLBackup\`
- 7-Zip installation path
- OneDrive destination folder
- backup filename prefix or timestamp format

## Security and operational notes

- Keep the backup folder on a drive with enough free space.
- Use a schedule or SQL Agent job if you need automatic backups.
- Ensure the SQL service account and your PowerShell execution context have write access to the target folders.
- Validate the backup files regularly by restoring them to confirm integrity.

## Example output flow

```text
SQL backup created:
D:\SQLBackup\dbname_new_20261003_153045.bak

Stored to file:
D:\SQLBackup\file.txt

Compressed archive created:
D:\OneDrive\OneDrive_Org\backup\erpserver\dbname_new_20261003_153045.7z
```

## Notes

This is a practical, low-complexity backup process intended for local or small-office SQL Server environments. It is easy to modify for different databases, naming conventions, or backup storage locations.
This can be easily expanded with more complex workflows.
