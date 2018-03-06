##Create PSSession
Write-Host "-----------------------------------------------------------------------------------------------------------------------"
Write-Host (Get-Date -format "MMM-dd-yyyy_HH-mm-ss")
Write-Host "Connecting via WinRM to Server "$VMNAME" using WinRM with Kerberos over SSL"
#Note: If your powershell system is on a different PKI infrastructure (differnet CAs for different domains) than the remote powershell  
#host you are running this script from may need to import the foreign CA Certiticates into the Computer Trusted Root Certitication Authorities 
#to correctly get the PSSession to work with SSL
$SESSION = New-PSSession -cn $FQDN -Credential $MYDOMAINCREDENTIAL -Authentication Kerberos -UseSSL
Write-Host $SESSION
Start-Sleep -s 1
WHILE(!$SESSION)
{
	Write-Host "PSSession Not Started. Attempting new PSSession"
	$SESSION = New-PSSession -cn $FQDN -Credential $MYDOMAINCREDENTIAL -Authentication Kerberos -UseSSL
	Start-Sleep -s 5
	
	Write-Host "PSSession Not Started. Attempting new PSSession"
	$SESSION = New-PSSession -cn $FQDN -Credential $MYDOMAINCREDENTIAL -Authentication Kerberos -UseSSL
	Start-Sleep -s 5

	Write-Host "Verify that you have installed the Trusted Certificate Authorities Root CA Certificate on this Scripting Server"
	
	Write-Host "PSSession Not Started. Attempting new PSSession"
	$SESSION = New-PSSession -cn $FQDN -Credential $MYDOMAINCREDENTIAL -Authentication Kerberos -UseSSL
	Start-Sleep -s 5

	##Attempt to Run Scheduled task for WinRM
	Write-Host "Running Scheduled Task for "$APPNAME
	schtasks.exe /RUN /S $FQDN /U $MYDOMAINUSERNAME /P $MYDOMAINUNSECUREPASSWORD /TN $APPNAME /HRESULT
	Write-Host "Waiting 30 seconds for Scheduled Task to Complete"
	Start-Sleep -s 30
	
	Write-Host "PSSession Not Started. Attempting new PSSession"
	$SESSION = New-PSSession -cn $FQDN -Credential $MYDOMAINCREDENTIAL -Authentication Kerberos -UseSSL

	#Reboot Guest Reboot VM
	Write-Host "Rebooting VM to attempt to resolve WiNRM Issues"
	Get-VM $VMNAME | Restart-VMGuest -Confirm:$false
	Write-Host "Waiting for VM to Restart"
	Start-Sleep -s 20
	
	##Wait until VM Restarts
	Do     
	{
		$VirtualMachine = Get-VM -Name $VMNAME
		$GuestHostName = $VirtualMachine.ExtensionData.Guest.Hostname
		Write-Host (Get-Date -Format o) "Waiting for VM named:" $VMNAME "to match guest named:" $GuestHostName
		Start-Sleep -s 1
	} 
	Until ($GuestHostName -eq $FQDN)
	Start-Sleep -s 10
	
	
	Start-Sleep -s 30
	$SESSIONCOUNT++
	IF($SESSIONCOUNT -eq 5)
	{
		Write-Host "VM PSSession connection has been attempted 101x's with no resolution" -foregroundcolor green
		Write-Host "Canceling all tasks" -foregroundcolor red
		Write-Host "VM Process Haulted" -foregroundcolor red
		Write-Host "VM Build Process Failed" -foregroundcolor red -background yellow
		Stop-Transcript
		Write-Host "Press any key to end session ..."
		$x = $host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown")
		disconnect-viserver * -confirm:$false
		disconnect-nsxserver * -confirm:$false
		Stop-transcript	
	}
}
Write-Output "PowerShell Session info is:"
Write-Output $SESSION
Write-Host "Connecting via WinRM to Server "$VMNAME" Completed."
Write-Host (Get-Date -format "MMM-dd-yyyy_HH-mm-ss")
Write-Host "-----------------------------------------------------------------------------------------------------------------------"
