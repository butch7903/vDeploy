#Set Variables
$ServiceAccount = "HAMKER.local\svc_sqlserviceaccount"

#Set Service Account to be able to Logon as A Service
Function Set-LogonAsService{
param($accountToAdd)
#written by Ingo Karstein, http://blog.karstein-consulting.com
#  v1.0, 01/03/2014
## <--- Configure here
if( [string]::IsNullOrEmpty($accountToAdd) ) {
	Write-Host "no account specified"
	exit
}
## ---> End of Config
$sidstr = $null
try {
	$ntprincipal = new-object System.Security.Principal.NTAccount "$accountToAdd"
	$sid = $ntprincipal.Translate([System.Security.Principal.SecurityIdentifier])
	$sidstr = $sid.Value.ToString()
} catch {
	$sidstr = $null
}
Write-Host "Account: $($accountToAdd)" -ForegroundColor DarkCyan
if( [string]::IsNullOrEmpty($sidstr) ) {
	Write-Host "Account not found!" -ForegroundColor Red
	exit -1
}
Write-Host "Account SID: $($sidstr)" -ForegroundColor DarkCyan
$tmp = [System.IO.Path]::GetTempFileName()
Write-Host "Export current Local Security Policy" -ForegroundColor DarkCyan
secedit.exe /export /cfg "$($tmp)" 
$c = Get-Content -Path $tmp 
$currentSetting = ""
foreach($s in $c) {
	if( $s -like "SeServiceLogonRight*") {
		$x = $s.split("=",[System.StringSplitOptions]::RemoveEmptyEntries)
		$currentSetting = $x[1].Trim()
	}
}
if( $currentSetting -notlike "*$($sidstr)*" ) {
	Write-Host "Modify Setting ""Logon as a Service""" -ForegroundColor DarkCyan
	if( [string]::IsNullOrEmpty($currentSetting) ) {
		$currentSetting = "*$($sidstr)"
	} else {
		$currentSetting = "*$($sidstr),$($currentSetting)"
	}
	Write-Host "$currentSetting"
	$outfile = @"
[Unicode]
Unicode=yes
[Version]
signature="`$CHICAGO`$"
Revision=1
[Privilege Rights]
SeServiceLogonRight = $($currentSetting)
"@
	$tmp2 = [System.IO.Path]::GetTempFileName()
	Write-Host "Import new settings to Local Security Policy" -ForegroundColor DarkCyan
	$outfile | Set-Content -Path $tmp2 -Encoding Unicode -Force
	#notepad.exe $tmp2
	Push-Location (Split-Path $tmp2)
	try {
		secedit.exe /configure /db "secedit.sdb" /cfg "$($tmp2)" /areas USER_RIGHTS 
		#write-host "secedit.exe /configure /db ""secedit.sdb"" /cfg ""$($tmp2)"" /areas USER_RIGHTS "
	} finally {	
		Pop-Location
	}
} else {
	Write-Host "NO ACTIONS REQUIRED! Account already in ""Logon as a Service""" -ForegroundColor DarkCyan
}
Write-Host "Done." -ForegroundColor DarkCyan
}

#Call Set-LogonAsService
Set-LogonAsService $ServiceAccount

##Get Current Path
CD C:\Apps\Scripts\SQL
C:
$pwd = pwd

##Set ISO Variables
$Windows2008R2ISO = "C:\Apps\ISOs\\Windows 2008 R2\SW_DVD5_Windows_Svr_DC_EE_SE_Web_2008_R2_64Bit_English_w_SP1_MLF_X17-22580.ISO"
$Windows2012ISO = "C:\Apps\ISOs\\Windows 2012\SW_DVD5_Win_Svr_Std_and_DataCtr_2012_64Bit_English_Core_MLF_X18-27588.ISO"
$Windows2012R2ISO = "C:\Apps\ISOs\\Windows 2012 R2\SW_DVD9_Windows_Svr_Std_and_DataCtr_2012_R2_64Bit_English_-4_MLF_X19-82891.ISO"
$Windows2016ISO = "C:\Apps\ISOs\\Windows 2016\SW_DVD9_Win_Svr_STD_Core_and_DataCtr_Core_2016_64Bit_English_-3_MLF_X21-30350.ISO"
$SQL2016ISO = "C:\Apps\ISOs\SQL Server 2016\SW_DVD9_NTRL_SQL_Svr_Ent_Core_2016w_SP1_64Bit_English_OEM_VL_X21-22132.ISO"
$PowerShellModulesISO = "C:\Apps\ISOs\PowerShell_Modules\PowerShell_Modules.iso"
$SQLMGMTSTUDIOISO = "C:\Apps\ISOs\SQL Server 2016\SQL_SSMS.iso"

##Set Variables for SQL Install
$ServiceAccount = "$env:userdnsdomain\SVC_"+$env:computername
Write-Host "Service Account will be"$ServiceAccount

##Get Date Info for naming of snapshot variable
$LOGDATE = Get-Date -format "MMM-dd-yyyy_HH-mm"
##Specify Log File Info
$LOGFILENAME = "Log_" + $LOGDATE + ".txt"
#Create Log Folder
$LogFolder = $pwd.path+"\Log"
If (Test-Path $LogFolder){
	Write-Host "Log Directory Created. Continuing..."
}
Else{
	New-Item $LogFolder -type directory
}
#Specify Log File
$LOGFILE = $pwd.path+"\Log\"+$LOGFILENAME

##Starting Logging
Start-Transcript -path $LOGFILE -Append
Write-Host "-----------------------------------------------------------------------------------------------------------------------"
Write-Host (Get-Date -format "MMM-dd-yyyy_HH-mm-ss")
Write-Host "Script Logging Started"
Write-Host (Get-Date -format "MMM-dd-yyyy_HH-mm-ss")
Write-Host "-----------------------------------------------------------------------------------------------------------------------"

##Set Service Account as local Administrator
Write-Host "-----------------------------------------------------------------------------------------------------------------------"
Write-Host (Get-Date -format "MMM-dd-yyyy_HH-mm-ss")
Write-Host "Placing Service Account in local Administrators group"
##Requires PowerShell 5.1 or higher
Add-LocalGroupMember -Group "Administrators" -Member $ServiceAccount
Write-Host "Placing Service Account in local Administrators group Completed"
Write-Host "Verify Accounts in Local Computer Group"
##Requires PowerShell 5.1 or higher
Get-LocalGroupMember -Group "Administrators"
Write-Host "Verify Accounts in Local Computer Group Completed"
Write-Host (Get-Date -format "MMM-dd-yyyy_HH-mm-ss")
Write-Host "-----------------------------------------------------------------------------------------------------------------------"

##Rescan Disks
Write-Host "-----------------------------------------------------------------------------------------------------------------------"
Write-Host (Get-Date -format "MMM-dd-yyyy_HH-mm-ss")
Write-Host "Rescanning Hard disks"
'rescan' | diskpart
Write-Host "Rescanning Hard disks Completed"
Write-Host (Get-Date -format "MMM-dd-yyyy_HH-mm-ss")
Write-Host "-----------------------------------------------------------------------------------------------------------------------"

###Configure Drives and Volume Settings
Write-Host "-----------------------------------------------------------------------------------------------------------------------"
Write-Host (Get-Date -format "MMM-dd-yyyy_HH-mm-ss")
Invoke-Command -ScriptBlock{
Write-Host "Configuring Local Drives"
##Change Drive letter on DVD to E
Get-WmiObject -Class Win32_volume -Filter "DriveLetter = 'd:'" |Set-WmiInstance -Arguments @{DriveLetter='E:'}
##Configure Hard Disks
##Disk 0
##Default Size 60GB
##Drive Letter C
##Resize C Drive if there is new free space
$MaxSize = (Get-PartitionSupportedSize -DriveLetter C).sizeMax
Resize-Partition -DriveLetter C -Size $MaxSize
Set-Volume -DriveLetter C -NewFileSystemLabel OS
##Disk 1
##Default Size 40GB
##Drive Letter D
Initialize-Disk 1 -PartitionStyle GPT
$part1 = New-Partition -DiskNumber 1 –AssignDriveLetter –UseMaximumSize
$D = $part1.driveletter 
Format-Volume -DriveLetter $D -FileSystem NTFS -NewFileSystemLabel "Program Files" -Confirm:$false
$D = [string]$D + ":"
Get-WmiObject -Class Win32_volume -Filter "DriveLetter = '$D'" |Set-WmiInstance -Arguments @{DriveLetter='D:'}
##Disk 2
##Default Size 20GB
##Drive Letter T
Initialize-Disk 2 -PartitionStyle GPT
$part2 = New-Partition -DiskNumber 2 –AssignDriveLetter  –UseMaximumSize
$T = $part2.driveletter
Format-Volume -DriveLetter $part2.driveletter -FileSystem NTFS -AllocationUnitSize 65536 -NewFileSystemLabel "TempDB" -Confirm:$false
$T = [string]$T + ":"
Get-WmiObject -Class Win32_volume -Filter "DriveLetter = '$T'" |Set-WmiInstance -Arguments @{DriveLetter='T:'}
##Disk 3
##Default Size 10GB
##Drive Letter U
Initialize-Disk 3 -PartitionStyle GPT
$part3 = New-Partition -DiskNumber 3 –AssignDriveLetter –UseMaximumSize
$U = $part3.driveletter
Format-Volume -DriveLetter $U -FileSystem NTFS -AllocationUnitSize 65536 -NewFileSystemLabel "TempDB Log" -Confirm:$false
$U = [string]$U + ":"
Get-WmiObject -Class Win32_volume -Filter "DriveLetter = '$U'" |Set-WmiInstance -Arguments @{DriveLetter='U:'}
##Disk 4
##Default Size 4GB
##DriveLetter M
Initialize-Disk 4 -PartitionStyle GPT
$part4 = New-Partition -DiskNumber 4 –AssignDriveLetter –UseMaximumSize
$M = $part4.driveletter
Format-Volume -DriveLetter $M -FileSystem NTFS -AllocationUnitSize 65536 -NewFileSystemLabel "MiscDB" -Confirm:$false
$M = [string]$M + ":"
Get-WmiObject -Class Win32_volume -Filter "DriveLetter = '$M'" |Set-WmiInstance -Arguments @{DriveLetter='M:'}
##Disk 5
##Default Size 1GB
##DriveLetter L
Initialize-Disk 5 -PartitionStyle GPT
$part5 = New-Partition -DiskNumber 5 –AssignDriveLetter –UseMaximumSize
$L = $part5.driveletter
Format-Volume -DriveLetter $L -FileSystem NTFS -AllocationUnitSize 65536 -NewFileSystemLabel "Logs" -Confirm:$false 
$L = [string]$L + ":"
Get-WmiObject -Class Win32_volume -Filter "DriveLetter = '$L'" |Set-WmiInstance -Arguments @{DriveLetter='L:'}
Write-Host "Configuring Local Drives Completed"
}
Write-Host (Get-Date -format "MMM-dd-yyyy_HH-mm-ss")
Write-Host "-----------------------------------------------------------------------------------------------------------------------"

###Setting up for SQL Install
##Create Directories
Write-Host "-----------------------------------------------------------------------------------------------------------------------"
Write-Host (Get-Date -format "MMM-dd-yyyy_HH-mm-ss")
Write-Host "Creating SQL Server Directories"
New-Item -ItemType directory -Path D:\Scripts
New-Item -ItemType directory -Path D:\Installers
New-Item -ItemType directory -Path L:\SQL
New-Item -ItemType directory -Path L:\SQL\Logs
New-Item -ItemType directory -Path M:\SQL
New-Item -ItemType directory -Path M:\SQL\Data
New-Item -ItemType directory -Path T:\SQL
New-Item -ItemType directory -Path T:\SQL\Data
New-Item -ItemType directory -Path U:\SQL
New-Item -ItemType directory -Path U:\SQL\Logs
New-Item -ItemType directory -Path "D:\Program Files (x86)"
New-Item -ItemType directory -Path "D:\Program Files (x86)\Microsoft SQL Server"
New-Item -ItemType directory -Path "D:\Program Files (x86)\Microsoft SQL Server\DReplayClient"
New-Item -ItemType directory -Path "D:\Program Files (x86)\Microsoft SQL Server\DReplayClient\WorkingDir"
New-Item -ItemType directory -Path "D:\Program Files (x86)\Microsoft SQL Server\DReplayClient\ResultDir"
Write-Host "Creating SQL Server Directories Completed"
Write-Host (Get-Date -format "MMM-dd-yyyy_HH-mm-ss")
Write-Host "-----------------------------------------------------------------------------------------------------------------------"

##Set Windows Firewall Rules
Write-Host "-----------------------------------------------------------------------------------------------------------------------"
Write-Host (Get-Date -format "MMM-dd-yyyy_HH-mm-ss")
Write-Host "Creating SQL Server Firewall Rules"
netsh advfirewall firewall add rule name="SQL Instances" dir=in action=allow protocol=TCP localport=1433;
Write-Host "Creating SQL Server Firewall Rules Completed"
Write-Host (Get-Date -format "MMM-dd-yyyy_HH-mm-ss")
Write-Host "-----------------------------------------------------------------------------------------------------------------------"

##Installing Pre-requirements for SQL
Write-Host "Installing Windows Pre-requirements to installing SQL Server"
Write-Host "-----------------------------------------------------------------------------------------------------------------------"
Write-Host (Get-Date -format "MMM-dd-yyyy_HH-mm-ss")
###Install required apps prior to SQL Install
##Install .Net 3.5
Import-Module ServerManager;
# Get Windows Server Version
$WindowsVersion = [environment]::OSVersion.Version
# Add .NET 3.5 to Windows Server 2008R2 and earlier
If (($WindowsVersion.Major -eq 6) -And ($WindowsVersion.Minor -lt 2)) { 
$mountResult = Mount-DiskImage $Windows2008R2ISO -PassThru
$ISO = $mountResult | Get-Volume | Select DriveLetter
$ISO = $ISO.DriveLetter
##Set Explict Drive path for Source Install
$ISO = $ISO + ":\Sources\SxS"
##Install .Net 3.5
Install-WindowsFeature -Name AS-Net-Framework -Source $ISO -Confirm:$false
##Verify Install
Get-WindowsFeature -Name AS-Net-Framework
##Unmount ISO Image
$mountResult | Dismount-DiskImage 
##Clear Variable Contents for future use
$mountResult = "";
}
# Add .NET 3.5 to Windows Server 2012 and 2012R2
If (($WindowsVersion.Major -eq 6) -And ($WindowsVersion.Minor -ge 0)) { 
$mountResult = Mount-DiskImage $Windows2012ISO -PassThru
$ISO = $mountResult | Get-Volume | Select DriveLetter
$ISO = $ISO.DriveLetter
##Set Explict Drive path for Source Install
$ISO = $ISO + ":\Sources\SxS"
}
If (($WindowsVersion.Major -eq 6) -And ($WindowsVersion.Minor -ge 2)) { 
$mountResult = Mount-DiskImage $Windows2012R2ISO -PassThru
$ISO = $mountResult | Get-Volume | Select DriveLetter
$ISO = $ISO.DriveLetter
##Set Explict Drive path for Source Install
$ISO = $ISO + ":\Sources\SxS"
}
If (($WindowsVersion.Major -eq 6) -And ($WindowsVersion.Minor -ge 2)) { 
##Install .NET 3.5
Install-WindowsFeature -Name Net-Framework-Core -Source $ISO -Confirm:$false
##Verify Install
Get-WindowsFeature -Name Net-Framework-Core
##Unmount ISO Image
$mountResult | Dismount-DiskImage 
##Clear Variable Contents for future use
$mountResult = "";
}
# Add .NET 3.5/4.6 to Windows Server 2016
If ($WindowsVersion.Major -eq 10) {
##Mount Windows ISO
$mountResult = Mount-DiskImage $Windows2016ISO -PassThru
$ISO = $mountResult | Get-Volume | Select DriveLetter
$ISO = $ISO.DriveLetter
##Set Explict Drive path for Source Install
$ISO = $ISO + ":\Sources\SxS"
##Install .NET 3.5
Install-WindowsFeature -Name NET-Framework-Core -Source $ISO -Confirm:$false
##Verify Install
Get-WindowsFeature -Name Net-Framework-Core
##Unmount ISO Image
$mountResult | Dismount-DiskImage 
##Clear Variable Contents for future use
$mountResult = ""
;
}
If ($WindowsVersion.Major -eq 10) { 
##Install .Net 4.6
Add-WindowsFeature Net-Framework-45-Core
##Verify Install
Get-WindowsFeature -Name Net-Framework-45-Core;
}
Write-Host "Installing Windows Pre-requirements to installing SQL Server Completed"
Write-Host (Get-Date -format "MMM-dd-yyyy_HH-mm-ss")
Write-Host "-----------------------------------------------------------------------------------------------------------------------"

## SQL Service Account Password Generation
Write-Host "-----------------------------------------------------------------------------------------------------------------------"
Write-Host (Get-Date -format "MMM-dd-yyyy_HH-mm-ss")
Write-Host "Importing Service Account Password from AES Encrypted files"
$KeyFile = $pwd.path+"\"+"AES.key"
$SQLPasswordFile = $pwd.path+"\"+"SQLPassword.txt"
If (Test-Path $SQLPasswordFile){
Write-Host "SQL Service Account Password File Exists"
Write-Host "Continuing"
}
Else{
Write-Host "SQL Service Account Password File Not Found"
Write-Host "Stopping Script and Exiting"
Start-Sleep -Seconds 10
BREAK
}
$Key = Get-Content $KeyFile
$SecureSQLPassword = Get-Content $SQLPasswordFile | ConvertTo-SecureString -Key $Key
$UnsecureSQLPassword = (New-Object PSCredential "user",$SecureSQLPassword).GetNetworkCredential().Password
Write-Host "Importing Service Account Password from AES Encrypted files Completed"
Write-Host (Get-Date -format "MMM-dd-yyyy_HH-mm-ss")
Write-Host "-----------------------------------------------------------------------------------------------------------------------"

###Install SQL Server
Write-Host "-----------------------------------------------------------------------------------------------------------------------"
Write-Host (Get-Date -format "MMM-dd-yyyy_HH-mm-ss")
Write-Host "SQL Server Install Process Starting"
###Starting install of SQL 
##Mount SQL Installer ISO
$mountResult = Mount-DiskImage $SQL2016ISO -PassThru
$ISO = $mountResult | Get-Volume | Select DriveLetter
$ISO = $ISO.DriveLetter
$SQLInstaller = $ISO + ":\" + $SQLInstaller
WRITE-HOST "SQL Installer ISO Mounted"

##Setting Install Commands
##Starting Install
#References https://docs.microsoft.com/en-us/sql/database-engine/install-windows/install-sql-server-using-a-configuration-file
#References https://docs.microsoft.com/en-us/sql/database-engine/install-windows/install-sql-server-from-the-command-prompt
CD $SQLInstaller
$SQLInstallCommandArray = './setup.exe -ArgumentList
/MediaLayout="Full"  
/SaPwd=$UnsecureSQLPassword
/CLTSVCPASSWORD=$UnsecureSQLPassword 
/CTLRSVCPASSWORD=$UnsecureSQLPassword 
/SQLSVCPASSWORD=$UnsecureSQLPassword 
/AGTSVCPASSWORD=$UnsecureSQLPassword 
/ASSVCPASSWORD=$UnsecureSQLPassword 
/ISSVCPASSWORD=$UnsecureSQLPassword 
/RSSVCPASSWORD=$UnsecureSQLPassword 
#Specifies a Setup work flow, like INSTALL, UNINSTALL, or UPGRADE. This is a required parameter. 
/ACTION="Install" 
#Production Key
/PID="TBR8B-BXC4Y-298NV-PYTBY-G3BCP" 
#Specifies that SQL Server Setup should not display the privacy statement when ran from the
/SUPPRESSPRIVACYSTATEMENTNOTICE="True"
#By specifying this parameter and accepting Microsoft R Open and Microsoft R Server terms, you acknowledge that you have read and understood the terms of use.
/IACCEPTSQLSERVERLICENSETERMS 
##Added for Silent Install - Per Russ Hamker
/IACCEPTROPENLICENSETERMS 
#Use the /ENU parameter to install the English version of SQL Server on your localized Windows operating system. 
/ENU="True" 
#Setup will not display any user interface. - Modified to True Per Russ Hamker for command line install.
/QUIET="True" 
#Setup will display progress only, without any user interaction. 
/QUIETSIMPLE="False" 
#Parameter that controls the user interface behavior. Valid values are Normal for the full UI,AutoAdvance for a simplied UI, and EnableUIOnServerCore for bypassing Server Core setup GUI block. Commented out per Russ Hamker for command line install.
#/UIMODE="AutoAdvance" 
#Specify whether SQL Server Setup should discover and include product updates. The valid values are True and False or 1 and 0. By default SQL Server Setup will include updates that are found. 
/UpdateEnabled="True" 
#If this parameter is provided, then this computer will use Microsoft Update to check for updates. 
/USEMICROSOFTUPDATE="False" 
#Specifies features to install, uninstall, or upgrade. The list of top-level features include SQL, AS, RS, IS, MDS, and Tools. The SQL feature will install the Database Engine, Replication, Full-Text, and Data Quality Services (DQS) server. The Tools feature will install shared components. 
/FEATURES="SQLENGINE,REPLICATION,ADVANCEDANALYTICS,FULLTEXT,DQ,AS,RS,SQL_SHARED_MR,RS_SHP,RS_SHPWFE,DQC,CONN,IS,BC,SDK,BOL,DREPLAY_CTLR,DREPLAY_CLT,SNAC_SDK,MDS" 
#Specify the location where SQL Server Setup will obtain product updates. The valid values are "MU" to search Microsoft Update, a valid folder path, a relative path such as .\MyUpdates or a UNC share. By default SQL Server Setup will search Microsoft Update or a Windows Update service through the Window Server Update Services. 
/UpdateSource="MU" 
#Displays the command line parameters usage 
/HELP="False" 
#Specifies that the detailed Setup log should be piped to the console. 
/INDICATEPROGRESS="True" 
#Specifies that Setup should install into WOW64. This command line argument is not supported on an IA64 or a 32-bit system. 
/X86="False" 
#Specify a default or named instance. MSSQLSERVER is the default instance for non-Express editions and SQLExpress for Express editions. This parameter is required when installing the SQL Server Database Engine (SQL), Analysis Services (AS), or Reporting Services (RS). 
/INSTANCENAME="MSSQLSERVER" 
#Specify the root installation directory for shared components.  This directory remains unchanged after shared components are already installed. 
/INSTALLSHAREDDIR="D:\Program Files\Microsoft SQL Server" 
#Specify the root installation directory for the WOW64 shared components.  This directory remains unchanged after WOW64 shared components are already installed. 
/INSTALLSHAREDWOWDIR="D:\Program Files (x86)\Microsoft SQL Server" 
#Specify the Instance ID for the SQL Server features you have specified. SQL Server directory structure, registry structure, and service names will incorporate the instance ID of the SQL Server instance. 
/INSTANCEID="MSSQLSERVER" 
#The account used by the Distributed Replay Client service. 
/CLTSVCACCOUNT=$ServiceAccount 
#The result directory for the Distributed Replay Client service. 
/CLTRESULTDIR="D:\Program Files (x86)\Microsoft SQL Server\DReplayClient\ResultDir" 
#The startup type for the Distributed Replay Client service. 
/CLTSTARTUPTYPE="Manual" 
#The working directory for the Distributed Replay Client service. 
/CLTWORKINGDIR="D:\Program Files (x86)\Microsoft SQL Server\DReplayClient\WorkingDir" 
#The account used by the Distributed Replay Controller service. 
/CTLRSVCACCOUNT=$ServiceAccount 
#The computer name that the client communicates with for the Distributed Replay Controller service. 
/CLTCTLRNAME="DEV_REPLAY" 
#The startup type for the Distributed Replay Controller service. 
/CTLRSTARTUPTYPE="Manual" 
#The Windows account(s) used to grant permission to the Distributed Replay Controller service. 
/CTLRUSERS="SPEEDYCASH\kschreiber_dom" 
#Specifies which mode report server is installed in.  
#Default value: “FilesOnly”  
/RSINSTALLMODE="DefaultNativeMode" 
#Specifies which mode report server is installed in.  
#Default value: “SharePointFilesOnlyMode” 
/RSSHPINSTALLMODE="SharePointFilesOnlyMode" 
#TelemetryUserNameConfigDescription 
/SQLTELSVCACCT="NT Service\SQLTELEMETRY" 
#TelemetryStartupConfigDescription 
/SQLTELSVCSTARTUPTYPE="Automatic" 
#ASTelemetryStartupConfigDescription 
/ASTELSVCSTARTUPTYPE="Automatic" 
#ASTelemetryUserNameConfigDescription 
/ASTELSVCACCT="NT Service\SSASTELEMETRY" 
#TelemetryStartupConfigDescription 
/ISTELSVCSTARTUPTYPE="Automatic" 
#TelemetryUserNameConfigDescription 
/ISTELSVCACCT="NT Service\SSISTELEMETRY130" 
#Specify the installation directory. 
/INSTANCEDIR="D:\Program Files\Microsoft SQL Server" 
#Agent account name 
/AGTSVCACCOUNT=$ServiceAccount 
#Auto-start service after installation.  
/AGTSVCSTARTUPTYPE="Automatic" 
#Startup type for Integration Services. 
/ISSVCSTARTUPTYPE="Manual" 
#Account for Integration Services: Domain\User or system account. 
/ISSVCACCOUNT=$ServiceAccount 
#The name of the account that the Analysis Services service runs under. 
/ASSVCACCOUNT=$ServiceAccount 
#Controls the service startup type setting after the service has been created. 
/ASSVCSTARTUPTYPE="Manual" 
#The collation to be used by Analysis Services. 
/ASCOLLATION="Latin1_General_CI_AS" 
#The location for the Analysis Services data files. 
/ASDATADIR="D:\Program Files\Microsoft SQL Server\MSAS13.MSSQLSERVER\OLAP\Data" 
#The location for the Analysis Services log files. 
/ASLOGDIR="D:\Program Files\Microsoft SQL Server\MSAS13.MSSQLSERVER\OLAP\Log" 
#The location for the Analysis Services backup files. 
/ASBACKUPDIR="D:\Program Files\Microsoft SQL Server\MSAS13.MSSQLSERVER\OLAP\Backup" 
#The location for the Analysis Services temporary files. 
/ASTEMPDIR="D:\Program Files\Microsoft SQL Server\MSAS13.MSSQLSERVER\OLAP\Temp" 
#The location for the Analysis Services configuration files. 
/ASCONFIGDIR="D:\Program Files\Microsoft SQL Server\MSAS13.MSSQLSERVER\OLAP\Config" 
#Specifies whether or not the MSOLAP provider is allowed to run in process. 
/ASPROVIDERMSOLAP="1" 
#Specifies the list of administrator accounts that need to be provisioned. 
/ASSYSADMINACCOUNTS="SPEEDYCASH\USA SQL Services" "SPEEDYCASH\SQL Admins" $ServiceAccount
#Specifies the server mode of the Analysis Services instance. Valid values are MULTIDIMENSIONAL and TABULAR. The default value is MULTIDIMENSIONAL. 
/ASSERVERMODE="MULTIDIMENSIONAL" 
#CM brick TCP communication port 
/COMMFABRICPORT="0" 
#How matrix will use private networks 
/COMMFABRICNETWORKLEVEL="0" 
#How inter brick communication will be protected 
/COMMFABRICENCRYPTION="0" 
#TCP port used by the CM brick 
/MATRIXCMBRICKCOMMPORT="0" 
#Startup type for the SQL Server service. 
/SQLSVCSTARTUPTYPE="Automatic" 
#Level to enable FILESTREAM feature at (0, 1, 2 or 3). 
/FILESTREAMLEVEL="0" 
#Set to "1" to enable RANU for SQL Server Express. 
/ENABLERANU="False" 
#Specifies a Windows collation or an SQL collation to use for the Database Engine. 
/SQLCOLLATION="SQL_Latin1_General_CP1_CI_AS" 
#Account for SQL Server service: Domain\User or system account. 
/SQLSVCACCOUNT=$ServiceAccount 
#Set to "True" to enable instant file initialization for SQL Server service. If enabled, Setup will grant Perform Volume Maintenance Task privilege to the Database Engine Service SID. This may lead to information disclosure as it could allow deleted content to be accessed by an unauthorized principal. 
/SQLSVCINSTANTFILEINIT="True" 
#Windows account(s) to provision as SQL Server system administrators. 
/SQLSYSADMINACCOUNTS="SPEEDYCASH\USA SQL Services" "SPEEDYCASH\SQL Admins" $ServiceAccount 
#The default is Windows Authentication. Use "SQL" for Mixed Mode Authentication. 
/SECURITYMODE="SQL" 
#The number of Database Engine TempDB files. 
/SQLTEMPDBFILECOUNT="2" 
#Specifies the initial size of a Database Engine TempDB data file in MB. 
/SQLTEMPDBFILESIZE="1024" 
#Specifies the automatic growth increment of each Database Engine TempDB data file in MB. 
/SQLTEMPDBFILEGROWTH="256" 
#Specifies the initial size of the Database Engine TempDB log file in MB. 
/SQLTEMPDBLOGFILESIZE="1024" 
#Specifies the automatic growth increment of the Database Engine TempDB log file in MB. 
/SQLTEMPDBLOGFILEGROWTH="256" 
#The Database Engine root data directory. 
/INSTALLSQLDATADIR="D:" 
#Default directory for the Database Engine user databases. 
/SQLUSERDBDIR="M:\SQL\Data" 
#Default directory for the Database Engine user database logs. 
/SQLUSERDBLOGDIR="L:\SQL\Logs" 
#Directories for Database Engine TempDB files. 
/SQLTEMPDBDIR="T:\SQL\Data" 
#Directory for the Database Engine TempDB log files. 
/SQLTEMPDBLOGDIR="U:\SQL\Logs" 
#Provision current user as a Database Engine system administrator for %SQL_PRODUCT_SHORT_NAME% Express. 
/ADDCURRENTUSERASSQLADMIN="False" 
#Specify 0 to disable or 1 to enable the TCP/IP protocol. 
/TCPENABLED="1" 
#Specify 0 to disable or 1 to enable the Named Pipes protocol. 
/NPENABLED="0" 
#Startup type for Browser Service. 
/BROWSERSVCSTARTUPTYPE="Disabled" 
#Specifies which account the report server NT service should execute under.  When omitted or when the value is empty string, the default built-in account for the current operating system.
#The username part of RSSVCACCOUNT is a maximum of 20 characters long and
#The domain part of RSSVCACCOUNT is a maximum of 254 characters long. 
/RSSVCACCOUNT=$ServiceAccount 
#Specifies how the startup mode of the report server NT service.  When 
#Manual - Service startup is manual mode (default).
#Automatic - Service startup is automatic mode.
#Disabled - Service is disabled 
/RSSVCSTARTUPTYPE="Manual" 
#Add description of input argument EXTSVCACCOUNT 
/EXTSVCACCOUNT="NT Service\MSSQLLaunchpad" 
#Add description of input argument FTSVCACCOUNT 
/FTSVCACCOUNT="NT Service\MSSQLFDLauncher"
#Specify Offline Location for SQL R Services Cache. Reference: https://docs.microsoft.com/en-us/sql/advanced-analytics/r/installing-ml-components-without-internet-access
/MRCACHEDIRECTORY="$pwd"
'.Split("`n`r") -replace "`#.*", "$([char]0)" -replace "#.*" -replace "$([char]0)", "#" -replace "^\s*" -replace "\s*$" -replace "#", "" |
    ?{ $_; } 
##Combine Array to single line
$SQLInstallCommand=""
FOREACH ($LINE in $SQLInstallCommandArray)
{
$SQLInstallCommand+=" " + $LINE
}
$SQLInstallCommand = [string]$SQLInstallCommand
##List Install Commands
$SQLInstallCommand
##Running Install Commands
Invoke-Expression $SQLInstallCommand
WRITE-HOST "SQL Server Installation Completed" -ForegroundColor Green
Write-Host "SQL 2016 Installer Logs can be found @ C:\Program Files\Microsoft SQL Server\130\Setup Bootstrap\Log"
##Unmount SQL Installer ISO
CD C:\
$mountResult | Dismount-DiskImage 
WRITE-HOST "SQL Installer ISO Unmounted" -ForegroundColor Green
Write-Host "SQL Server Install Process Completed"
Write-Host (Get-Date -format "MMM-dd-yyyy_HH-mm-ss")
Write-Host "-----------------------------------------------------------------------------------------------------------------------"

###Installing SQL Management Studio
Write-Host "-----------------------------------------------------------------------------------------------------------------------"
Write-Host (Get-Date -format "MMM-dd-yyyy_HH-mm-ss")
Write-Host "SQL Server Management Studio Install Process Starting"
Invoke-Command -ScriptBlock {
##Mount SQL Management Studio ISO
##Note: Install SQL Management Studio After SQL Server is installed. SQL Server sets default settings that if SQL Management Studio is installed first, it will follow, that DBA Team does not want.
$mountResult = Mount-DiskImage $SQLMGMTSTUDIOISO -PassThru
$ISO = $mountResult | Get-Volume | Select DriveLetter
$ISO = $ISO.DriveLetter
$SQLInstaller = $ISO + ":\"
CD $SQLInstaller
$FileName = Get-Childitem $SQLInstaller | Select Name
$FileName = $FileName.name
$SQLInstaller = $SQLInstaller + $FileName 
$ArgumentList = "/Install /Quiet /Norestart"
WRITE-HOST "SQL Management Studio ISO Mounted" -ForegroundColor Green
##Install SQL Management Studio
Start-Process -Wait -FilePath $SQLInstaller -ArgumentList $ArgumentList
WRITE-HOST "SQL Management Studio Installation Completed" -ForegroundColor Green
##Unmount SQL Installer ISO
CD C:\
$mountResult | Dismount-DiskImage 
WRITE-HOST "SQL Management Studio ISO Unmounted" -ForegroundColor Green
Write-Host "SQL Server Management Studio Install Process Completed"
}
Write-Host (Get-Date -format "MMM-dd-yyyy_HH-mm-ss")
Write-Host "-----------------------------------------------------------------------------------------------------------------------"

###Installing SQL PowerShell Module
Write-Host "-----------------------------------------------------------------------------------------------------------------------"
Write-Host (Get-Date -format "MMM-dd-yyyy_HH-mm-ss")
Write-Host "SQL Server PowerShell Module Install Process Started"
Invoke-Command -ScriptBlock {
##Mount PowerShell Modules ISO
$mountResult = Mount-DiskImage $PowerShellModulesISO -PassThru
$ISO = $mountResult | Get-Volume | Select DriveLetter
$ISO = $ISO.DriveLetter
$SQLPowerShellLocation = $ISO + ":\SQL\*"
WRITE-HOST "PowerShell Module ISO Mounted"
##Copying PowerShell Files to Proper location
COPY-ITEM $SQLPowerShellLocation $Env:ProgramFiles\WindowsPowerShell\Modules -recurse
##Installing SQL PowerShell Module
Get-InstalledModule -Name SQLServer | Select *
##Unmount PowerShell Modules ISO
$mountResult | Dismount-DiskImage 
WRITE-HOST "SQL Installer ISO Unmounted" -ForegroundColor Green
Write-Host "SQL Server PowerShell Module Install Process Completed"
}
Write-Host (Get-Date -format "MMM-dd-yyyy_HH-mm-ss")
Write-Host "-----------------------------------------------------------------------------------------------------------------------"

###Set PSGallery as authorized to install future PowerShell Modules
#Write-Host "-----------------------------------------------------------------------------------------------------------------------"
#Write-Host (Get-Date -format "MMM-dd-yyyy_HH-mm-ss")
#Set-PSRepository -Name PSGallery -InstallationPolicy Trusted
##Set in Templates instead
#Write-Host (Get-Date -format "MMM-dd-yyyy_HH-mm-ss")
#Write-Host "-----------------------------------------------------------------------------------------------------------------------"

###Loading SQL PowerShell Module
##Import SQL 2016 PowerShell Module
Write-Host "-----------------------------------------------------------------------------------------------------------------------"
Write-Host (Get-Date -format "MMM-dd-yyyy_HH-mm-ss")
Write-Host "Importing SQL Server PowerShell Module"
Import-Module -Name Sqlserver -DisableNameChecking
Write-Host "Importing SQL Server PowerShell Module Completed"
Write-Host "Listing SQL Server PowerShell Module Information"
Get-Module -Name Sqlserver | Select *
Write-Host (Get-Date -format "MMM-dd-yyyy_HH-mm-ss")
Write-Host "-----------------------------------------------------------------------------------------------------------------------"

###Setting SQL Settings
<#
Write-Host "-----------------------------------------------------------------------------------------------------------------------"
Write-Host (Get-Date -format "MMM-dd-yyyy_HH-mm-ss")
##Configure SQL Server Management Objects (SMO)
#Setting SQL Memory Settings
$SQLMem = new-object
('Microsoft.SqlServer.Management.Smo.Server') $SQLServer
$SQLMem.Configuration.MaxServerMemory.ConfigValue = 20480;
$SQLMem.Configuration.MinServerMemory.ConfigValue = 10240;
$SQLMem.Configuration.NetworkPacketSize.ConfigValue = 1500;
$SQLMem.Configuration.OptimizeAdhocWorkloads.ConfigValue = 1;
$SQLMem.Alter();
Write-Host (Get-Date -format "MMM-dd-yyyy_HH-mm-ss")
Write-Host "-----------------------------------------------------------------------------------------------------------------------"
#>

##Examples
<#
##Execute SQL Query (single line)
Invoke-Sqlcmd -ServerInstance $SQLServer -Query "CREATE DATABASE [Mgmt];";

##Execute SQL Query (multi-line ‘here’ string)
$query = @"
EXEC sys.sp_configure N'contained database
authentication', N'1'
GO
RECONFIGURE WITH OVERRIDE;
"@;
Invoke-Sqlcmd -ServerInstance $SQLServer
-Query $query;

##Execute SQL Script File
Invoke-Sqlcmd -ServerInstance $SQLServer -InputFile
"$ScriptPath\Alerts_Triggers.sql";

##Execute Multiple SQL Script Files In Order
$ScriptList = Get-Content InstallOrder.txt;
$ScriptList | %{
$currScript = $_;
Invoke-Sqlcmd -ServerInstance $SQLServer
-InputFile $currScript;
}

##Execute PowerShell Script File
./PowerShellScript.ps1 -Parameter1 "Value" -Parameter2 $variable;
#>

##Stop Logging
Write-Host "-----------------------------------------------------------------------------------------------------------------------"
Write-Host (Get-Date -format "MMM-dd-yyyy_HH-mm-ss")
Write-Host "All Processes Completed"
Write-Host "Stopping Transcript"
Write-Host (Get-Date -format "MMM-dd-yyyy_HH-mm-ss")
Write-Host "-----------------------------------------------------------------------------------------------------------------------"
Stop-Transcript
# SIG # Begin signature block
# MIIOpQYJKoZIhvcNAQcCoIIOljCCDpICAQExCzAJBgUrDgMCGgUAMGkGCisGAQQB
# gjcCAQSgWzBZMDQGCisGAQQBgjcCAR4wJgIDAQAABBAfzDtgWUsITrck0sYpfvNR
# AgEAAgEAAgEAAgEAAgEAMCEwCQYFKw4DAhoFAAQUe+2F2f8jCye9UUGsw8xb44WD
# HAugggwEMIIFJTCCBA2gAwIBAgITEgAAAAjF4sFBZTvYUwAAAAAACDANBgkqhkiG
# 9w0BAQsFADAjMSEwHwYDVQQDExhpY3RjZXJ0MDEuc3BlZWR5Y2FzaC5pY3QwHhcN
# MTUxMTEyMjE0MDMyWhcNMjAxMTEyMjE1MDMyWjBTMRMwEQYKCZImiZPyLGQBGRYD
# aWN0MRowGAYKCZImiZPyLGQBGRYKU3BlZWR5Q2FzaDEgMB4GA1UEAxMXU3BlZWR5
# Q2FzaC1JQ1RDRVJUMDItQ0EwggEiMA0GCSqGSIb3DQEBAQUAA4IBDwAwggEKAoIB
# AQDCEZ88BxloxJk2VgBV7yvqAfLzdAoaQB9p5YveRJK7KgEsqw8uqJAKhZjIrJd5
# 0V4xyTSjPrgO0x5xsLJbNG414pNwLYPk7BaHRbl4MDu69AE1R3hgInOf08gGsRFP
# 0LLZmW1COVnRPcwcQSrjGWzy3x1YvKdPZ5ulQNs0p5x6R30eV7oUuOQd5TCMaKdl
# LqlYX9qCFEoPrFPomQ0zzxL2Jmj+ubzd9mdbUXnGocDNvURJPF3x3pdDROgDNfho
# WH/V1qVa5u5ldJWwMabifn6hN/CIkL1MLSDGCcmermPvgG1ZNJOCcxfbBowWSBUR
# zVS1rOUGMWqUNjvkH8qj0VNnAgMBAAGjggIgMIICHDASBgkrBgEEAYI3FQEEBQID
# AgACMCMGCSsGAQQBgjcVAgQWBBRLQg56Xef0xf8XfLaUCpyZKllPmTAdBgNVHQ4E
# FgQUkDSd6YBUU+fpVg7mkKZNOVn/NL0wGQYJKwYBBAGCNxQCBAweCgBTAHUAYgBD
# AEEwCwYDVR0PBAQDAgGGMA8GA1UdEwEB/wQFMAMBAf8wHwYDVR0jBBgwFoAUF23J
# XbRI1zBbOEwDRXrODfa5FQ0wgecGA1UdHwSB3zCB3DCB2aCB1qCB04ZJZmlsZTov
# Ly8vSUNUQ0VSVDAxLnNwZWVkeWNhc2guaWN0L0NlcnRFbnJvbGwvaWN0Y2VydDAx
# LnNwZWVkeWNhc2guaWN0LmNybIZCaHR0cDovL2ljdGNlcnQwMi5zcGVlZHljYXNo
# LmljdC9jcmxkcC9pY3RjZXJ0MDEuc3BlZWR5Y2FzaC5pY3QuY3JshkJodHRwOi8v
# aWN0Y2VydDAzLnNwZWVkeWNhc2guaWN0L2NybGRwL2ljdGNlcnQwMS5zcGVlZHlj
# YXNoLmljdC5jcmwwfgYIKwYBBQUHAQEEcjBwMG4GCCsGAQUFBzAChmJmaWxlOi8v
# Ly9JQ1RDRVJUMDEuc3BlZWR5Y2FzaC5pY3QvQ2VydEVucm9sbC9JQ1RDRVJUMDEu
# c3BlZWR5Y2FzaC5pY3RfaWN0Y2VydDAxLnNwZWVkeWNhc2guaWN0LmNydDANBgkq
# hkiG9w0BAQsFAAOCAQEAsKy9mNQE9oybq/iTxgV9x+IGLtXgIug88oCzmM78O/OW
# JNyoUVOFAyzSLqvXKkawrB1xCCBTauw2TOctM2Rkfo2E8ZU79k1ArG2CH0WFLGW2
# XQsPUB8eleeFNnGrUK6b8N+8wYhpnnY4BhSpsG1Fugsfgc8YjJdW2ZYyyiqMPAoF
# /lNLRrXc/zD7Wj/Gv/vUcSByozMLhOD8oTnvm2r/KkugEgwJ/7Sq+GsbiX25WWcH
# 7S68XtK78ZukSR10oul4jiTq9M1fdsLdmZNnAub4ncweiNH5nKFzF1ui5WbWQsj7
# NGFcKzbLI/IwVelf91ZhDYVx+NEDZlo3IJVG1xNU/TCCBtcwggW/oAMCAQICExIA
# AK7pUxFhIKzPf+AAAgAArukwDQYJKoZIhvcNAQELBQAwUzETMBEGCgmSJomT8ixk
# ARkWA2ljdDEaMBgGCgmSJomT8ixkARkWClNwZWVkeUNhc2gxIDAeBgNVBAMTF1Nw
# ZWVkeUNhc2gtSUNUQ0VSVDAyLUNBMB4XDTE3MDMwODIwNTUxMVoXDTE5MDMwODIx
# MDUxMVowbTETMBEGCgmSJomT8ixkARkWA2ljdDEaMBgGCgmSJomT8ixkARkWClNw
# ZWVkeUNhc2gxJDAiBgNVBAsTG0VuaGFuY2VkIFByaXZpbGVnZSBBY2NvdW50czEU
# MBIGA1UEAwwLcmhhbWtlcl9kb20wggEiMA0GCSqGSIb3DQEBAQUAA4IBDwAwggEK
# AoIBAQDskjviVjsy7/JREgQGZ75+SvynSc6UprWA7JXECNW1P7twAVgxQ6Z1++lI
# CJmakaqil1wthmABLy2Rhsd+u5fEeKZUfSSfps3MkfHHfADutxtMl8haxT95ZJI5
# 1WVP3JbkuCSfv38JD9IYS8VwccF9X1RbM8O+/Y3SmXAMj1xSD7l8VY4Wc7hApkjI
# bDzXLguQmIdU+6MVVtBcyL6msmMCQbrmnRwiptGfXAL4THWOxDul4TFgjGKSeNHg
# vaqgCuyJOQTMIiJnqcbEhc8pecvOuRUTs2+jl8qx8kz54Sn2A95zHu+X+rbAUpVe
# HGcddesDx3frPTlcJZqJ22kF7TEZAgMBAAGjggOIMIIDhDALBgNVHQ8EBAMCB4Aw
# OwYJKwYBBAGCNxUHBC4wLAYkKwYBBAGCNxUIhoGcYoOc9G3tlyOE07lilrBxGofJ
# 7R2CuaccAgFkAgEFMB0GA1UdDgQWBBT5lXMAk0sxnnt2mUKV5SIBaz/OCzAfBgNV
# HSMEGDAWgBSQNJ3pgFRT5+lWDuaQpk05Wf80vTCCAVcGA1UdHwSCAU4wggFKMIIB
# RqCCAUKgggE+hoHGbGRhcDovLy9DTj1TcGVlZHlDYXNoLUlDVENFUlQwMi1DQSgy
# KSxDTj1JQ1RDRVJUMDIsQ049Q0RQLENOPVB1YmxpYyUyMEtleSUyMFNlcnZpY2Vz
# LENOPVNlcnZpY2VzLENOPUNvbmZpZ3VyYXRpb24sREM9U3BlZWR5Q2FzaCxEQz1p
# Y3Q/Y2VydGlmaWNhdGVSZXZvY2F0aW9uTGlzdD9iYXNlP29iamVjdENsYXNzPWNS
# TERpc3RyaWJ1dGlvblBvaW50hkRodHRwOi8vaWN0Y2VydDAzLnNwZWVkeWNhc2gu
# aWN0L2NybGRwL1NwZWVkeUNhc2gtSUNUQ0VSVDAyLUNBKDIpLmNybIYtaHR0cDov
# L2ljdGNlcnQwMi5zcGVlZHljYXNoLmljdC9jcmxkcC8oMikuY3JsMIIBMgYIKwYB
# BQUHAQEEggEkMIIBIDCBuQYIKwYBBQUHMAKGgaxsZGFwOi8vL0NOPVNwZWVkeUNh
# c2gtSUNUQ0VSVDAyLUNBLENOPUFJQSxDTj1QdWJsaWMlMjBLZXklMjBTZXJ2aWNl
# cyxDTj1TZXJ2aWNlcyxDTj1Db25maWd1cmF0aW9uLERDPVNwZWVkeUNhc2gsREM9
# aWN0P2NBQ2VydGlmaWNhdGU/YmFzZT9vYmplY3RDbGFzcz1jZXJ0aWZpY2F0aW9u
# QXV0aG9yaXR5MDAGCCsGAQUFBzABhiRodHRwOi8vaWN0Y2VydDAyLnNwZWVkeWNh
# c2guaWN0L29jc3AwMAYIKwYBBQUHMAGGJGh0dHA6Ly9pY3RjZXJ0MDMuc3BlZWR5
# Y2FzaC5pY3Qvb2NzcDATBgNVHSUEDDAKBggrBgEFBQcDAzAbBgkrBgEEAYI3FQoE
# DjAMMAoGCCsGAQUFBwMDMDUGA1UdEQQuMCygKgYKKwYBBAGCNxQCA6AcDBpyaGFt
# a2VyX2RvbUBTcGVlZHlDYXNoLmljdDANBgkqhkiG9w0BAQsFAAOCAQEAdKauh6t0
# Q3mAtuNlrhty1an1MCVVaRbIKNTAUfSdzYUrqiCla0ybeCfsqtoRQoWwm5F0ynwf
# E4Jxko871TPGar9mNG24R93advdJ4M08yceB4AU1CklSP6lpL4+vjw2ZulVAy97G
# etFXATf2wwoJSZhNcCgfBxj67tgQh9s8YMxoISxfcDNzlw/zPA3GvzvAWB4ZXW77
# Jf+2oyoymhRcRC2gvrwEnQzQIGNg+RuFRNL6FKsV80kLV12+hTkOlwAmeFoz6dkS
# uuQVdpraoiSBaBlTzKfRYwm9WtkfBPQQddA4IFiyekqdh2llnAhyRyJIoHs7Pm39
# AjGy/5hZ41nM9jGCAgswggIHAgEBMGowUzETMBEGCgmSJomT8ixkARkWA2ljdDEa
# MBgGCgmSJomT8ixkARkWClNwZWVkeUNhc2gxIDAeBgNVBAMTF1NwZWVkeUNhc2gt
# SUNUQ0VSVDAyLUNBAhMSAACu6VMRYSCsz3/gAAIAAK7pMAkGBSsOAwIaBQCgeDAY
# BgorBgEEAYI3AgEMMQowCKACgAChAoAAMBkGCSqGSIb3DQEJAzEMBgorBgEEAYI3
# AgEEMBwGCisGAQQBgjcCAQsxDjAMBgorBgEEAYI3AgEVMCMGCSqGSIb3DQEJBDEW
# BBRcCgGy6N1b5Vt07zYDXo0dL4Xo/DANBgkqhkiG9w0BAQEFAASCAQAWpF7Ma/rZ
# 4fpz0xUtHJEsL9oYqJOmb76cqSXtXYWg5M9UE/l0MEEmuaMLBsYpnD95C0udD3Y3
# fqFvGBLpT8T6Utw+H8ddhETun7lWD2h4t9TL7Gh+Ljon6lBBiUeyedZ36XK+dhqP
# z56fYr/17Q6ryfiiLBWfA23C3DsVk3euEAnptyVTDl4QpGs+b0VDHvuzBGwWQTAq
# Pmtyrrq0YyK/VNoRxEsMgu/kcpe3KvFZ2mPvZphhuSAK6B0mGaLs1eyhZfoRtiN9
# m4WoCqm70/QlppKZProrY4zUg8c2fbyVBBXiXOv2zRnV6hRgm9x7weq67A3Vabx0
# mvC5t+pJWMAB
# SIG # End signature block
