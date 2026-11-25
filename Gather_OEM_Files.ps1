###############################################################################
# Script : Gather_OEM_Files.ps1
# Purpose: To copy files received from OEM's and upload them to EveryFleet.
#          This script will then make a call to the Out-FTP-EveryFleet.ps1 
#          script to do the actual upload of the data to EveryFleet.
# Author : Bob Deitz
# Created: 11/24/2026
###############################################################################

# Type in the OEM name at the command line when running this script.
param(
    [Parameter(Mandatory)]
    [ValidateNotNullOrEmpty()]
    [string]$OEM
)

# Begin Script ################################################################

# Text file to hold a list of files that have been sent to Every Fleet.
$SentFiles = "C:\FileWatch\Script\EveryFleet_SFTP\$OEM\SentFiles.txt"

# Archive location where the files are sourced from.
$SourceFilePath = "C:\FileWatch\Archive\$OEM\Incoming"

# Destination where the files will be sent prior to upload to EveryFleet.
$DestinationPath = "C:\FileWatch\Script\EveryFleet_SFTP\$OEM\Import"

# Using today's date to screen for files that are ready for upload.
$tempDate = (Get-Date).AddDays(-1)
$Yesterday = Get-Date $tempDate -Format "MM/dd/yyyy" 
$TodaysDate = Get-Date -Format "MM/dd/yyyy"

# FileList will hold all the fils names from the source folder to be searched.
Write-Host "Getting file list to upload..."
$FileList = Get-ChildItem -Path $SourceFilePath -File 

# Loop through the files and copy them if they have not already been sent.
Write-Host "Stepping through the list of files to determine which ones to upload..."
foreach ($file in $FileList){
    $FileName = $file.Name
    $FileDate = Get-Date $file.LastWriteTime -Format "MM/dd/yyyy"
    
    # Check to see if the file is within the date range to be uploaded.
    if ($FileDate -eq $Yesterday){
        $SourceFile = "$SourceFilePath\$FileName"
        Copy-Item $SourceFile -Destination $DestinationPath 
        Out-File -FilePath $SentFiles -InputObject "$FileName sent on $TodaysDate." -Append           
    } # if Last write date

} # foreach

# Upload the files to EveryFleet.
# Write-Host "Beginning Upload..."
Write-Host "Uploading files..."
Start-Process powershell.exe "C:\FileWatch\Script\EveryFleet_SFTP\Out-FTP-EveryFleet.ps1 $OEM" -Wait
# Write-Host "Upload Complete."

# Remove the files that have been uploaded from the C:\FileWatch\Script\EveryFleet_SFTP\$OEM\Import folder.
# LEAVE THIS DISABLED AND REPLACE IT WITH ANOTHER SCRIPT. OR, CHECK THAT THE OEM VARIABLE EXISTS BEFORE RUNNING.
Write-Host "Cleaning up file list..."
Get-ChildItem $DestinationPath -File | Remove-Item -Force

Write-Host "Script complete."
# End Script ##################################################################
