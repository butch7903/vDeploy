Write-Host "Configuration Starting for Type "$VMTYPE
$InstallStartTime = (Get-Date -format "MMM-dd-yyyy HH-mm-ss")
$INSTALLSTARTTIMESW = [Diagnostics.Stopwatch]::StartNew()

##Start PowerShell Script on Remote Host
Write-Host "Starting PowerShell Script on Remote Host "$FQDN
Invoke-Command -Session $SESSION -ScriptBlock {
	#Import VMType Answer File
	Write-Host "Importing VMTYPE Answer File"
	$FQDN = "$env:computername.$env:userdnsdomain"
	$VMTYPEFILE = "C:\Apps\HDConfig\"+$FQDN+"_VMType.txt"
	$VMTYPE = Get-Content $VMTYPEFILE
	Write-Host "VM Type is "$VMTYPE

	#Import VMHDTYLELIST File
	Write-Host "Importing VM Hard Disk Type List and Setting Variables"
	#Importing VM HD Type List CSV
	TRY
	{
		$VMTYPELIST = Import-CSV "C:\Apps\HDConfig\VMHDTypeList.CSV"
	}
	CATCH
	{
		Write-Warning "Hard Drive Config File Not found"
		BREAK
	}
	##Update Hard Drive Configuration based on Selected Hard Disk Configuration
	$VMTYPELIST = $VMTYPELIST.Where({$_.Name -eq $VMTYPE})
	##Set Variables for Modification
	$DriveCount = $VMTYPELIST.DriveCount
	$ControllerCount = $VMTYPELIST.ControllerCount
	$DVDLetter = $VMTYPELIST.DVDLetter
	$Drive0 = [System.Convert]::ToBoolean($VMTYPELIST.Drive0)
	$Drive0Letter = $VMTYPELIST.Drive0Letter
	$Drive0Name = $VMTYPELIST.Drive0Name
	$Drive0Minimum = $VMTYPELIST.Drive0Minimum
	$Drive0Size = $Drive0Minimum
	$Drive0Persistence = $VMTYPELIST.Drive0Persistence
	$Drive0StorageFormat= $VMTYPELIST.Drive0StorageFormat
	$Drive0Controller = $VMTYPELIST.Drive0Controller
	$Drive0FileSystem = $VMTYPELIST.Drive0FileSystem
	$Drive0AllocationUnitSize = $VMTYPELIST.Drive0AllocationUnitSize
	$Drive1 = [System.Convert]::ToBoolean($VMTYPELIST.Drive1)
	$Drive1Letter = $VMTYPELIST.Drive1Letter
	$Drive1Name = $VMTYPELIST.Drive1Name
	$Drive1Minimum = $VMTYPELIST.Drive1Minimum
	$Drive1Size = $Drive1Minimum
	$Drive1Persistence = $VMTYPELIST.Drive1Persistence
	$Drive1StorageFormat= $VMTYPELIST.Drive1StorageFormat
	$Drive1Controller = $VMTYPELIST.Drive1Controller
	$Drive1ControllerScsiID = $VMTYPELIST.Drive1ControllerScsiID
	$Drive1FileSystem = $VMTYPELIST.Drive1FileSystem
	$Drive1AllocationUnitSize = $VMTYPELIST.Drive1AllocationUnitSize
	$Drive2 = [System.Convert]::ToBoolean($VMTYPELIST.Drive2)
	$Drive2Letter = $VMTYPELIST.Drive2Letter
	$Drive2Name = $VMTYPELIST.Drive2Name
	$Drive2Minimum = $VMTYPELIST.Drive2Minimum
	$Drive2Size = $Drive2Minimum
	$Drive2Persistence = $VMTYPELIST.Drive2Persistence
	$Drive2StorageFormat = $VMTYPELIST.Drive2StorageFormat
	$Drive2Controller = $VMTYPELIST.Drive2Controller
	$Drive2ControllerScsiID = $VMTYPELIST.Drive2ControllerScsiID
	$Drive2FileSystem = $VMTYPELIST.Drive2FileSystem
	$Drive2AllocationUnitSize = $VMTYPELIST.Drive2AllocationUnitSize
	$Drive3 = [System.Convert]::ToBoolean($VMTYPELIST.Drive3)
	$Drive3Letter = $VMTYPELIST.Drive3Letter
	$Drive3Name = $VMTYPELIST.Drive3Name
	$Drive3Minimum = $VMTYPELIST.Drive3Minimum
	$Drive3Size = $Drive3Minimum
	$Drive3Persistence = $VMTYPELIST.Drive3Persistence
	$Drive3StorageFormat = $VMTYPELIST.Drive3StorageFormat
	$Drive3Controller = $VMTYPELIST.Drive3Controller
	$Drive3ControllerScsiID = $VMTYPELIST.Drive3ControllerScsiID
	$Drive3FileSystem = $VMTYPELIST.Drive3FileSystem
	$Drive3AllocationUnitSize = $VMTYPELIST.Drive3AllocationUnitSize
	$Drive4 = [System.Convert]::ToBoolean($VMTYPELIST.Drive4)
	$Drive4Letter = $VMTYPELIST.Drive4Letter
	$Drive4Name = $VMTYPELIST.Drive4Name
	$Drive4Minimum = $VMTYPELIST.Drive4Minimum
	$Drive4Size = $Drive4Minimum
	$Drive4Persistence = $VMTYPELIST.Drive4Persistence
	$Drive4StorageFormat = $VMTYPELIST.Drive4StorageFormat
	$Drive4Controller = $VMTYPELIST.Drive4Controller
	$Drive4ControllerScsiID = $VMTYPELIST.Drive4ControllerScsiID
	$Drive4FileSystem = $VMTYPELIST.Drive4FileSystem
	$Drive4AllocationUnitSize = $VMTYPELIST.Drive4AllocationUnitSize
	$Drive5 = [System.Convert]::ToBoolean($VMTYPELIST.Drive5)
	$Drive5Letter = $VMTYPELIST.Drive5Letter
	$Drive5Name = $VMTYPELIST.Drive5Name
	$Drive5Minimum = $VMTYPELIST.Drive5Minimum
	$Drive5Size = $Drive5Minimum
	$Drive5Persistence = $VMTYPELIST.Drive5Persistence
	$Drive5StorageFormat = $VMTYPELIST.Drive5StorageFormat
	$Drive5Controller = $VMTYPELIST.Drive5Controller
	$Drive5ControllerScsiID = $VMTYPELIST.Drive5ControllerScsiID
	$Drive5FileSystem = $VMTYPELIST.Drive5FileSystem
	$Drive5AllocationUnitSize = $VMTYPELIST.Drive5AllocationUnitSize
	Write-Host "Importing VM Hard Disk Type List and Setting Variables Completed"

	##Rescan Disks
	"rescan" | diskpart
	Invoke-Command -ScriptBlock {
		##Resize OS Drive if there is new free space
		Write-Host "Extending "$Drive0Letter" Drive if Needed"
		$MaxSize = (Get-PartitionSupportedSize -DriveLetter $Drive0Letter).sizeMax
		Resize-Partition -DriveLetter $Drive0Letter -Size $MaxSize -ErrorAction SilentlyContinue
		
		##Name OS Drive
		Write-Host "Setting Label on Drive "$Drive0Letter
		Set-Volume -DriveLetter $Drive0Letter -NewFileSystemLabel $Drive0Name

		##Change Drive letter on DVD to Match CSV
		Write-Host "Setting DVD Drive Letter to "$DVDLetter
		Get-WmiObject -Class Win32_volume -Filter "DriveType = 5" |Set-WmiInstance -Arguments @{DriveLetter=$DVDLetter+':'} 
		
		##Create Hard Disk 1
		IF($Drive1 -eq $TRUE){
			##Initialize-Disk Hard disk
			Write-Host "Initializing Disk "$Drive1Letter
			Initialize-Disk 1 -PartitionStyle GPT
			##Format New Hard Disk
			$Partition = New-Partition -DiskNumber 1 –AssignDriveLetter –UseMaximumSize
			$DriveLetter = $Partition.driveletter
			Write-Host "Formatting Drive "$Drive1Name
			Format-Volume -DriveLetter $DriveLetter -NewFileSystemLabel $Drive1Name -FileSystem $Drive1FileSystem -AllocationUnitSize $Drive1AllocationUnitSize -Confirm:$false
			$DriveLetter = [string]$DriveLetter + ":"
			Write-Host "Updating Drive "$Drive1Name" to match drive letter "$Drive1Letter
			$NewLetter = $Drive1Letter + ':'
			$DRIVE = Get-WmiObject -Class Win32_volume -Filter "DriveLetter = '$DriveLetter'" 
			Set-WmiInstance -InputObject $DRIVE -Arguments @{DriveLetter=$NewLetter}
		}
		##Create Hard Disk 2
		IF($Drive2 -eq $TRUE){
			##Initialize-Disk Hard disk
			Write-Host "Initializing Disk "$Drive2Letter
			Initialize-Disk 2 -PartitionStyle GPT
			##Format New Hard Disk
			$Partition = New-Partition -DiskNumber 2 –AssignDriveLetter –UseMaximumSize
			$DriveLetter = $Partition.driveletter 
			Write-Host "Formatting Drive "$Drive2Name
			Format-Volume -DriveLetter $DriveLetter -NewFileSystemLabel $Drive2Name -FileSystem $Drive2FileSystem -AllocationUnitSize $Drive2AllocationUnitSize -Confirm:$false
			$DriveLetter = [string]$DriveLetter + ":"
			Write-Host "Updating Drive "$Drive2Name" to match drive letter "$Drive2Letter
			$NewLetter = $Drive2Letter + ':'
			$DRIVE = Get-WmiObject -Class Win32_volume -Filter "DriveLetter = '$DriveLetter'" 
			Set-WmiInstance -InputObject $DRIVE -Arguments @{DriveLetter=$NewLetter}
		}
		##Create Hard Disk 3
		IF($Drive3 -eq $TRUE){
			##Initialize-Disk Hard disk
			Write-Host "Initializing Disk "$Drive3Letter
			Initialize-Disk 3 -PartitionStyle GPT
			##Format New Hard Disk
			$Partition = New-Partition -DiskNumber 3 –AssignDriveLetter –UseMaximumSize
			$DriveLetter = $Partition.driveletter 
			Write-Host "Formatting Drive "$Drive3Name
			Format-Volume -DriveLetter $DriveLetter -NewFileSystemLabel $Drive3Name -FileSystem $Drive3FileSystem -AllocationUnitSize $Drive3AllocationUnitSize -Confirm:$false
			$DriveLetter = [string]$DriveLetter + ":"
			Write-Host "Updating Drive "$Drive3Name" to match drive letter "$Drive3Letter
			$NewLetter = $Drive3Letter + ':'
			$DRIVE = Get-WmiObject -Class Win32_volume -Filter "DriveLetter = '$DriveLetter'" 
			Set-WmiInstance -InputObject $DRIVE -Arguments @{DriveLetter=$NewLetter}
		}
		##Create Hard Disk 4
		IF($Drive4 -eq $TRUE){
			##Initialize-Disk Hard disk
			Write-Host "Initializing Disk "$Drive4Letter
			Initialize-Disk 4 -PartitionStyle GPT
			##Format New Hard Disk
			$Partition = New-Partition -DiskNumber 4 –AssignDriveLetter –UseMaximumSize
			$DriveLetter = $Partition.driveletter
			Write-Host "Formatting Drive "$Drive4Name
			Format-Volume -DriveLetter $DriveLetter -NewFileSystemLabel $Drive4Name -FileSystem $Drive4FileSystem -AllocationUnitSize $Drive4AllocationUnitSize -Confirm:$false
			$DriveLetter = [string]$DriveLetter + ":"
			Write-Host "Updating Drive "$Drive4Name" to match drive letter "$Drive4Letter
			$NewLetter = $Drive4Letter + ':'
			$DRIVE = Get-WmiObject -Class Win32_volume -Filter "DriveLetter = '$DriveLetter'" 
			Set-WmiInstance -InputObject $DRIVE -Arguments @{DriveLetter=$NewLetter}
		}
		##Create Hard Disk 5
		IF($Drive5 -eq $TRUE){
			##Initialize-Disk Hard disk
			Write-Host "Initializing Disk "$Drive5Letter
			Initialize-Disk 5 -PartitionStyle GPT
			##Format New Hard Disk
			$Partition = New-Partition -DiskNumber 5 –AssignDriveLetter –UseMaximumSize
			$DriveLetter = $Partition.driveletter
			Write-Host "Formatting Drive "$Drive5Name
			Format-Volume -DriveLetter $DriveLetter -NewFileSystemLabel $Drive5Name -FileSystem $Drive5FileSystem -AllocationUnitSize $Drive5AllocationUnitSize -Confirm:$false
			$DriveLetter = [string]$DriveLetter + ":"
			Write-Host "Updating Drive "$Drive5Name" to match drive letter "$Drive5Letter
			$NewLetter = $Drive5Letter + ':'
			$DRIVE = Get-WmiObject -Class Win32_volume -Filter "DriveLetter = '$DriveLetter'" 
			Set-WmiInstance -InputObject $DRIVE -Arguments @{DriveLetter=$NewLetter}
		}
		##Create Hard Disk 6
		IF($Drive6 -eq $TRUE){
			##Initialize-Disk Hard disk
			Write-Host "Initializing Disk "$Drive6Letter
			Initialize-Disk 6 -PartitionStyle GPT
			##Format New Hard Disk
			$Partition = New-Partition -DiskNumber 6 –AssignDriveLetter –UseMaximumSize
			$DriveLetter = $Partition.driveletter
			Write-Host "Formatting Drive "$Drive6Name
			Format-Volume -DriveLetter $DriveLetter -NewFileSystemLabel $Drive6Name -FileSystem $Drive6FileSystem -AllocationUnitSize $Drive6AllocationUnitSize -Confirm:$false
			$DriveLetter = [string]$DriveLetter + ":"
			Write-Host "Updating Drive "$Drive6Name" to match drive letter "$Drive6Letter
			$NewLetter = $Drive6Letter + ':'
			$DRIVE = Get-WmiObject -Class Win32_volume -Filter "DriveLetter = '$DriveLetter'" 
			Set-WmiInstance -InputObject $DRIVE -Arguments @{DriveLetter=$NewLetter}
		}
			##Create Hard Disk 7
		IF($Drive7 -eq $TRUE){
			##Initialize-Disk Hard disk
			Write-Host "Initializing Disk "$Drive7Letter
			Initialize-Disk 7 -PartitionStyle GPT
			##Format New Hard Disk
			$Partition = New-Partition -DiskNumber 7 –AssignDriveLetter –UseMaximumSize
			$DriveLetter = $Partition.driveletter
			Write-Host "Formatting Drive "$Drive7Name
			Format-Volume -DriveLetter $DriveLetter -NewFileSystemLabel $Drive7Name -FileSystem $Drive7FileSystem -AllocationUnitSize $Drive7AllocationUnitSize -Confirm:$false
			$DriveLetter = [string]$DriveLetter + ":"
			Write-Host "Updating Drive "$Drive7Name" to match drive letter "$Drive7Letter
			$NewLetter = $Drive7Letter + ':'
			$DRIVE = Get-WmiObject -Class Win32_volume -Filter "DriveLetter = '$DriveLetter'" 
			Set-WmiInstance -InputObject $DRIVE -Arguments @{DriveLetter=$NewLetter}
		}
		##Create Hard Disk 8
		IF($Drive8 -eq $TRUE){
			##Initialize-Disk Hard disk
			Write-Host "Initializing Disk "$Drive8Letter
			Initialize-Disk 8 -PartitionStyle GPT
			##Format New Hard Disk
			$Partition = New-Partition -DiskNumber 8 –AssignDriveLetter –UseMaximumSize
			$DriveLetter = $Partition.driveletter
			Write-Host "Formatting Drive "$Drive8Name
			Format-Volume -DriveLetter $DriveLetter -NewFileSystemLabel $Drive8Name -FileSystem $Drive8FileSystem -AllocationUnitSize $Drive8AllocationUnitSize -Confirm:$false
			$DriveLetter = [string]$DriveLetter + ":"
			Write-Host "Updating Drive "$Drive8Name" to match drive letter "$Drive8Letter
			$NewLetter = $Drive8Letter + ':'
			$DRIVE = Get-WmiObject -Class Win32_volume -Filter "DriveLetter = '$DriveLetter'" 
			Set-WmiInstance -InputObject $DRIVE -Arguments @{DriveLetter=$NewLetter}
		}
			##Create Hard Disk 9
		IF($Drive9 -eq $TRUE){
			##Initialize-Disk Hard disk
			Write-Host "Initializing Disk "$Drive9Letter
			Initialize-Disk 9 -PartitionStyle GPT
			##Format New Hard Disk
			$Partition = New-Partition -DiskNumber 9 –AssignDriveLetter –UseMaximumSize
			$DriveLetter = $Partition.driveletter
			Write-Host "Formatting Drive "$Drive9Name
			Format-Volume -DriveLetter $DriveLetter -NewFileSystemLabel $Drive9Name -FileSystem $Drive9FileSystem -AllocationUnitSize $Drive9AllocationUnitSize -Confirm:$false
			$DriveLetter = [string]$DriveLetter + ":"
			Write-Host "Updating Drive "$Drive9Name" to match drive letter "$Drive9Letter
			$NewLetter = $Drive9Letter + ':'
			$DRIVE = Get-WmiObject -Class Win32_volume -Filter "DriveLetter = '$DriveLetter'" 
			Set-WmiInstance -InputObject $DRIVE -Arguments @{DriveLetter=$NewLetter}
		}
	}
}
$INSTALLEndTime = (Get-Date -format "MMM-dd-yyyy HH-mm-ss")
Write-Host "Configuration Process Completed for VM Type "$VMTYPE
Write-Host (Get-Date -format "MMM-dd-yyyy_HH-mm-ss")
$INSTALLSTARTTIMESW.STOP()
Write-Host "-----------------------------------------------------------------------------------------------------------------------"