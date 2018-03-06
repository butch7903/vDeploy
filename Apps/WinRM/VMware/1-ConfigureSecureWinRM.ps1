##Configure Secure WinRM
Write-Host "-----------------------------------------------------------------------------------------------------------------------"
Write-Host (Get-Date -format "MMM-dd-yyyy_HH-mm-ss")
Write-Host $APPNAME" Install Process Starting"
##Check if WinRM is configured, if so, skip this
$WinRM_Results = test-wsman -ComputerName $FQDN -Authentication Kerberos -Port 5986 -UseSSL -ErrorAction SilentlyContinue
IF(!$WinRM_Results)
{
	##Create Scheduled Task
	#Note - This requires the Windows Firewall rules for Remote Scheduled Tasks Management Firewall rules be enabled prior. Either via GPO or via set in the Windows Template.
	$TR = "C:\Windows\System32\WindowsPowerShell\v1.0\PowerShell.exe -ExecutionPolicy ByPass -File " +'"'+$INSTALLERDESTINATION+'\'+'1-ConfigureSSLSecureWinRM_Local.ps1'+'"'
	schtasks.exe /CREATE /S $FQDN /U $MYDOMAINUSERNAME /P $MYDOMAINUNSECUREPASSWORD /TN $APPNAME /TR $TR /RU "NT AUTHORITY\SYSTEM" /RL HIGHEST /SC ONSTART
	Write-Host "Creating Scheduled Task via Windows Task Scheduler for "$APPNAME" Completed"
	Write-Host "-----------------------------------------------------------------------------------------------------------------------"
	Write-Host (Get-Date -format "MMM-dd-yyyy_HH-mm-ss")
	#Run the Scheduled Task - Enable WinRM
	Write-Host "Running Scheduled Task for "$APPNAME
	schtasks.exe /RUN /S $FQDN /U $MYDOMAINUSERNAME /P $MYDOMAINUNSECUREPASSWORD /TN $APPNAME /HRESULT
	Write-Host "Running Scheduled Task for "$APPNAME" Completed"
	Write-Host "Waiting 15 seconds before proceeding"
	Start-Sleep -Seconds 15
}
Write-Host $APPNAME" Install Process Completed"
Write-Host (Get-Date -format "MMM-dd-yyyy_HH-mm-ss")
Write-Host "-----------------------------------------------------------------------------------------------------------------------"