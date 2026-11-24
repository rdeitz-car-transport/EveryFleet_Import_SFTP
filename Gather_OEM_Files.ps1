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
$CurrentDate = Get-Date -Format "MM/dd/yyyy" 

# FileList will hold all the fils names from the source folder to be searched.
$FileList = Get-ChildItem -Path $SourceFilePath -File 

# Loop through the files and copy them if they have not already been sent.
foreach ($file in $FileList){
    $FileName = $file.Name
    $FileDate = Get-Date $file.LastWriteTime -Format "MM/dd/yyyy"
    
    # Check to see if the file is within the date range to be uploaded.
    if ($FileDate -eq $CurrentDate){
        $SourceFile = "$SourceFilePath\$FileName"
        Copy-Item $SourceFile -Destination $DestinationPath 
        Out-File -FilePath $SentFiles -InputObject "$FileName sent on $CurrentDate." -Append           
    } # if Last write date

} # foreach

# Upload the files to EveryFleet.
# Write-Host "Beginning Upload..."
Start-Process powershell.exe "C:\FileWatch\Script\EveryFleet_SFTP\Out-FTP-EveryFleet.ps1 $OEM" -Wait
# Write-Host "Upload Complete."

# Remove the files that have been uploaded from the C:\FileWatch\Script\EveryFleet_SFTP\$OEM\Import folder.
# LEAVE THIS DISABLED AND REPLACE IT WITH ANOTHER SCRIPT. OR, CHECK THAT THE OEM VARIABLE EXISTS BEFORE RUNNING.
# Get-ChildItem $DestinationPath -File -Recurse | Remove-Item -Force

# End Script ##################################################################
