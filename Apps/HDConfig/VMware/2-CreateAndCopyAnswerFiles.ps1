Write-Host "-----------------------------------------------------------------------------------------------------------------------"
Write-Host (Get-Date -format "MMM-dd-yyyy_HH-mm-ss")
Write-Host "Copying Configuration files to Local PC"

#Create Answer File
Write-Host "Creating VMTYPE Answser File"
$EXPORTFILE = $SOURCEINSTALLLOCATION+"\"+$FQDN+"_VMTYPE.txt"
$VMTYPE | Out-File -FilePath $EXPORTFILE -Encoding ascii -Confirm:$false

#Copy Anwser File to Local PC
Write-Host "Copy VMType File to Local PC"
Copy-VMGuestFile -Source $EXPORTFILE -Destination $INSTALLERDESTINATION -VM $VMNAME -LocalToGuest -GuestCredential $MYDOMAINCREDENTIAL -FORCE -Confirm:$false

#Copy VMHDTypeList File to Local PC
Write-Host "Copying VMHDTypeList.csv to Local PC"
$VMHDTYPELISTFILE = $pwd.path +"\VMHDTypeList.csv"
Copy-VMGuestFile -Source $VMHDTYPELISTFILE -Destination $INSTALLERDESTINATION -VM $VMNAME -LocalToGuest -GuestCredential $MYDOMAINCREDENTIAL -FORCE -Confirm:$false

#delete temp answer file
Write-Host "Delete Answer file form local PS Server"
Remove-Item $EXPORTFILE -Confirm:$False

Write-Host (Get-Date -format "MMM-dd-yyyy_HH-mm-ss")
Write-Host "-----------------------------------------------------------------------------------------------------------------------"
