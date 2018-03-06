Write-Host "Creating Addtional Hard Drives for VM"
##Import CSV for Answer File
TRY
{
	$VMTYPELIST = Import-CSV VMHDTypeList.CSV
}
CATCH
{
	Write-Warning "Hard Drive Config File Not found"
	BREAK
}
##Update List based on Selected Hard Disk Configuration
$VMTYPELIST = $VMTYPELIST.Where({$_.Name -eq $VMTYPE})
##Import Variables for Modification
$DVDLetter = $VMTYPELIST.DVDLetter
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
$Drive1 = $VMTYPELIST.Drive1
$Drive1Letter = $VMTYPELIST.Drive1Letter
$Drive1Name = $VMTYPELIST.Drive1Name
$Drive1Minimum = $VMTYPELIST.Drive1Minimum
$Drive1Size = $Drive1Minimum
$Drive1Persistence = $VMTYPELIST.Drive1Persistence
$Drive1StorageFormat= $VMTYPELIST.Drive1StorageFormat
$Drive1Controller = $VMTYPELIST.Drive1Controller
$Drive1FileSystem = $VMTYPELIST.Drive1FileSystem
$Drive1AllocationUnitSize = $VMTYPELIST.Drive1AllocationUnitSize
$Drive2 = [System.Convert]::ToBoolean($VMTYPELIST.Drive2)
$Drive2Letter = $VMTYPELIST.Drive2Letter
$Drive2Name = $VMTYPELIST.Drive2Name
$Drive2Minimum = $VMTYPELIST.Drive2Minimum
$Drive2Size = $Drive2Minimum
$Drive2Persistence = $VMTYPELIST.Drive2Persistence
$Drive2StorageFormat= $VMTYPELIST.Drive2StorageFormat
$Drive2Controller = $VMTYPELIST.Drive2Controller
$Drive2FileSystem = $VMTYPELIST.Drive2FileSystem
$Drive2AllocationUnitSize = $VMTYPELIST.Drive2AllocationUnitSize
$Drive3 = [System.Convert]::ToBoolean($VMTYPELIST.Drive3)
$Drive3Letter = $VMTYPELIST.Drive3Letter
$Drive3Name = $VMTYPELIST.Drive3Name
$Drive3Minimum = $VMTYPELIST.Drive3Minimum
$Drive3Size = $Drive3Minimum
$Drive3Persistence = $VMTYPELIST.Drive3Persistence
$Drive3StorageFormat= $VMTYPELIST.Drive3StorageFormat
$Drive3Controller = $VMTYPELIST.Drive3Controller
$Drive3FileSystem = $VMTYPELIST.Drive3FileSystem
$Drive3AllocationUnitSize = $VMTYPELIST.Drive3AllocationUnitSize
$Drive4 = [System.Convert]::ToBoolean($VMTYPELIST.Drive4)
$Drive4Letter = $VMTYPELIST.Drive4Letter
$Drive4Name = $VMTYPELIST.Drive4Name
$Drive4Minimum = $VMTYPELIST.Drive4Minimum
$Drive4Size = $Drive4Minimum
$Drive4Persistence = $VMTYPELIST.Drive4Persistence
$Drive4StorageFormat= $VMTYPELIST.Drive4StorageFormat
$Drive4Controller = $VMTYPELIST.Drive4Controller
$Drive4FileSystem = $VMTYPELIST.Drive4FileSystem
$Drive4AllocationUnitSize = $VMTYPELIST.Drive4AllocationUnitSize
$Drive5 = [System.Convert]::ToBoolean($VMTYPELIST.Drive5)
$Drive5Letter = $VMTYPELIST.Drive5Letter
$Drive5Name = $VMTYPELIST.Drive5Name
$Drive5Minimum = $VMTYPELIST.Drive5Minimum
$Drive5Size = $Drive5Minimum
$Drive5Persistence = $VMTYPELIST.Drive5Persistence
$Drive5StorageFormat= $VMTYPELIST.Drive5StorageFormat
$Drive5Controller = $VMTYPELIST.Drive5Controller
$Drive5FileSystem = $VMTYPELIST.Drive5FileSystem
$Drive5AllocationUnitSize = $VMTYPELIST.Drive5AllocationUnitSize

Write-Host "Configuring VM for Hard Drive Type "$VMTYPE
#Note: Drives Start at 0 and go up
##Expand Hard Disk 0 (If Needed)
$NEWDISK0 = Get-HardDisk -VM $VMNAME -Name "Hard disk 1" | Set-HardDisk -CapacityGB $Drive0Size -Confirm:$false
##Create Hard Disk 1
IF($Drive1 -eq $TRUE){
$NEWDISK1 = Get-VM -NAME $VMNAME | New-HardDisk -CapacityGB $Drive1Size -Persistence $Drive1Persistence -StorageFormat $Drive1StorageFormat
##Set SCSI Controller
$CONTROLLER = Get-ScsiController -Name "SCSI Controller "+$Drive1Controller -VM $VMNAME
Get-HardDisk -VM $VMNAME -Name "Hard disk 2" | Set-HardDisk -Controller $CONTROLLER -Confirm:$false
## Set SCSI Controller ID on New Hard Disk
#Reference: https://communities.vmware.com/thread/421110
$strVMToUpdate = $VMNAME
$vmToUpdate = Get-VM $strVMToUpdate
$hdskToChange = Get-HardDisk -VM $vmToUpdate -Name "Hard disk 2"
$spec = New-Object VMware.Vim.VirtualMachineConfigSpec
$spec.deviceChange = New-Object VMware.Vim.VirtualDeviceConfigSpec
$spec.deviceChange[0].operation = "edit"
$spec.deviceChange[0].device = $hdskToChange.ExtensionData
$spec.deviceChange[0].device.unitNumber = $Drive1Controller
$vmToUpdate.ExtensionData.ReconfigVM_Task($spec)
Start-Sleep -s 3
}
##Create Hard Disk 2
IF($Drive2 -eq $TRUE){
$NEWDISK2 = Get-VM -NAME $VMNAME | New-HardDisk -CapacityGB $Drive2Size -Persistence $Drive2Persistence -StorageFormat $Drive2StorageFormat
##Set SCSI Controller
$CONTROLLER = Get-ScsiController -Name "SCSI Controller "+$Drive2Controller -VM $VMNAME
Get-HardDisk -VM $VMNAME -Name "Hard disk 3" | Set-HardDisk -Controller $CONTROLLER -Confirm:$false
## Set SCSI Controller ID on New Hard Disk
#Reference: https://communities.vmware.com/thread/421110
$strVMToUpdate = $VMNAME
$vmToUpdate = Get-VM $strVMToUpdate
$hdskToChange = Get-HardDisk -VM $vmToUpdate -Name "Hard disk 3"
$spec = New-Object VMware.Vim.VirtualMachineConfigSpec
$spec.deviceChange = New-Object VMware.Vim.VirtualDeviceConfigSpec
$spec.deviceChange[0].operation = "edit"
$spec.deviceChange[0].device = $hdskToChange.ExtensionData
$spec.deviceChange[0].device.unitNumber = $Drive2Controller
$vmToUpdate.ExtensionData.ReconfigVM_Task($spec)
Start-Sleep -s 3
}
##Create Hard Disk 3
IF($Drive3 -eq $TRUE){
$NEWDISK3 = Get-VM -NAME $VMNAME | New-HardDisk -CapacityGB $Drive3Size -Persistence $Drive3Persistence -StorageFormat $Drive3StorageFormat
##Set SCSI Controller
$CONTROLLER = Get-ScsiController -Name "SCSI Controller "+$Drive3Controller -VM $VMNAME
Get-HardDisk -VM $VMNAME -Name "Hard disk 4" | Set-HardDisk -Controller $CONTROLLER -Confirm:$false
## Set SCSI Controller ID on New Hard Disk
#Reference: https://communities.vmware.com/thread/421110
$strVMToUpdate = $VMNAME
$vmToUpdate = Get-VM $strVMToUpdate
$hdskToChange = Get-HardDisk -VM $vmToUpdate -Name "Hard disk 4"
$spec = New-Object VMware.Vim.VirtualMachineConfigSpec
$spec.deviceChange = New-Object VMware.Vim.VirtualDeviceConfigSpec
$spec.deviceChange[0].operation = "edit"
$spec.deviceChange[0].device = $hdskToChange.ExtensionData
$spec.deviceChange[0].device.unitNumber = $Drive3Controller
$vmToUpdate.ExtensionData.ReconfigVM_Task($spec)
Start-Sleep -s 3
}
##Create Hard Disk 4
IF($Drive4 -eq $TRUE){
$NEWDISK4 = Get-VM -NAME $VMNAME | New-HardDisk -CapacityGB $Drive4Size -Persistence $Drive4Persistence -StorageFormat $Drive4StorageFormat
##Set SCSI Controller
$CONTROLLER = Get-ScsiController -Name "SCSI Controller "+$Drive4Controller -VM $VMNAME
Get-HardDisk -VM $VMNAME -Name "Hard disk 5" | Set-HardDisk -Controller $CONTROLLER -Confirm:$false
## Set SCSI Controller ID on New Hard Disk
#Reference: https://communities.vmware.com/thread/421110
$strVMToUpdate = $VMNAME
$vmToUpdate = Get-VM $strVMToUpdate
$hdskToChange = Get-HardDisk -VM $vmToUpdate -Name "Hard disk 5"
$spec = New-Object VMware.Vim.VirtualMachineConfigSpec
$spec.deviceChange = New-Object VMware.Vim.VirtualDeviceConfigSpec
$spec.deviceChange[0].operation = "edit"
$spec.deviceChange[0].device = $hdskToChange.ExtensionData
$spec.deviceChange[0].device.unitNumber = $Drive4Controller
$vmToUpdate.ExtensionData.ReconfigVM_Task($spec)
Start-Sleep -s 3
}
##Create Hard Disk 5
IF($Drive5 -eq $TRUE){
$NEWDISK5 = Get-VM -NAME $VMNAME | New-HardDisk -CapacityGB $Drive5Size -Persistence $Drive5Persistence -StorageFormat $Drive5StorageFormat
##Set SCSI Controller
$CONTROLLER = Get-ScsiController -Name "SCSI Controller "+$Drive5Controller -VM $VMNAME
Get-HardDisk -VM $VMNAME -Name "Hard disk 6" | Set-HardDisk -Controller $CONTROLLER -Confirm:$false
## Set SCSI Controller ID on New Hard Disk
#Reference: https://communities.vmware.com/thread/421110
$strVMToUpdate = $VMNAME
$vmToUpdate = Get-VM $strVMToUpdate
$hdskToChange = Get-HardDisk -VM $vmToUpdate -Name "Hard disk 6"
$spec = New-Object VMware.Vim.VirtualMachineConfigSpec
$spec.deviceChange = New-Object VMware.Vim.VirtualDeviceConfigSpec
$spec.deviceChange[0].operation = "edit"
$spec.deviceChange[0].device = $hdskToChange.ExtensionData
$spec.deviceChange[0].device.unitNumber = $Drive5Controller
$vmToUpdate.ExtensionData.ReconfigVM_Task($spec)
Start-Sleep -s 3
}
Write-Host "Creating Addtional Hard Drives for VM Completed"