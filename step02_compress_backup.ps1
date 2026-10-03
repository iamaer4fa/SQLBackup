# Read the content of the file
$backupFile = Get-Content -Path "D:\SQLBackup\file.txt"
$backupFile = $backupFile.Trim()

# Compress the file using 7-Zip
$7ZipPath = "C:\Program Files\7-Zip\7z.exe"
& $7ZipPath a -t7z "$backupFile.7z" "$backupFile"

# Delete the original file
Remove-Item "$backupFile"

# Move item to OneDrive
Move-Item -Path "$backupFile.7z" -Destination "D:\OneDrive\OneDrive - STENIEL MINDANAO PACKAGING CORPORATION\backup\erpserver"

