###############################################################################
# Script : Out-FTP-EveryFleet.ps1
# Purpose: To upload gathered files to the EveryFleet FTP site.
# Author : Bob Deitz
# Created: 11/25/2026
###############################################################################

# Type in the OEM name at the command line when running this script.
param(
    [Parameter(Mandatory)]
    [ValidateNotNullOrEmpty()]
    [string]$OEM
)

$FTPScript = "C:\FileWatch\Script\EveryFleet_SFTP\$OEM\OUT-$OEM.txt"
$SFTPLog = "C:\FileWatch\Script\EveryFleet_SFTP\$OEM\SFTP.log"
& "C:\FileWatch\Script\WinSCP.COM" /script="$FTPScript" /log="$SFTPLog" /loglevel=1
