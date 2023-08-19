<#
.Description
This script initiates a backup of a user environment on PUB400, then download the output zip file onto the workstation.
It requires 3 parameters:
	1- The user profile on PUB400
	2- The full path to local ssh private key
	3- The target directory where to download the output file to
	4- The number of output zip files to keep in download directory
Dates: 2023/08/19 Creation
#>

param (
[string]$Pub400UserProfile=$(Throw "User profile is mandatory and must be a string: -Pub400UserProfile"),
[string]$sshKey=$(Throw "Path to ssh private key is mandatory: -sshKey"),
[string]$DownloadDirectory=$(Throw "Download directory is mandatory: -DownloadDirectory"),
[int]$ToKeep=$(Throw "Number of zip files to keep is mandatory: -ToKeep")
)

<#
Initiates environment backup with default parameters
#>

plink -batch -P 2222 -i $sshKey $Pub400UserProfile@pub400.com "system 'ENVSAV'"

<#
Download existing (normally only one created by previous step) zip file
#>

pscp -P 2222 -i $sshKey $Pub400UserProfile@pub400.com:forws/*.zip $DownloadDirectory

<#
Make sure to clean temporary objects on PUB400
#>

plink -batch -P 2222 -i $sshKey $Pub400UserProfile@pub400.com "system 'ENVSAV SAVELIBB(*NO) SAVELIB1(*NO) SAVELIB2(*NO) SAVEHOME(*NO) INCLJOBLOG(*NO) CLEANTMP(*YES)'"

<#
Remove older than the $ToKeep parameter versions
#>

$zipPath = $DownloadDirectory + "\env_backup_*.zip"
$zipCount = (Get-ChildItem $zipPath).Count
if ($ToKeep -lt $zipCount)
{
	$ToDelete = $zipCount - $ToKeep
	Get-ChildItem $zipPath  |
		Sort-Object { $_.Name -as [Version] } |
		Select-Object -First $ToDelete |
		Remove-Item
}
