###Install SCOM Agent
Write-Host "-----------------------------------------------------------------------------------------------------------------------"
Write-Host (Get-Date -format "MMM-dd-yyyy_HH-mm-ss")
Write-Host $APPNAME" Install Process Starting"

##Initiate Install
Write-Host "-----------------------------------------------------------------------------------------------------------------------"
Write-Host (Get-Date -format "MMM-dd-yyyy_HH-mm-ss")
Write-Host "Beginning Install Process for App"$APPNAME
$InstallStartTime = (Get-Date -format "MMM-dd-yyyy HH-mm-ss")
$INSTALLSTARTTIMESW = [Diagnostics.Stopwatch]::StartNew()
$OUTPUT = Invoke-Command -Session $SESSION -ScriptBlock {
	$INSTALLOUTPUT = Invoke-Command -ScriptBlock {Start-Process msiexec -ArgumentList "/i C:\Apps\SCOM\MOMAgent.msi /qn  USE_SETTINGS_FROM_AD=0 USE_MANUALLY_SPECIFIED_SETTINGS=1 MANAGEMENT_GROUP=SCOM_GROUP_HERE MANAGEMENT_SERVER_DNS=FQDN.SCOMSERVER.COM MANAGEMENT_SERVER_AD_NAME=FQDN.SCOMSERVER.COM ACTIONS_USE_COMPUTER_ACCOUNT=1  AcceptEndUserLicenseAgreement=1 /l*v c:\Apps\SCOM\MOMAgent_install.log" -Wait}
	RETURN $INSTALLOUTPUT
}
$INSTALLEndTime = (Get-Date -format "MMM-dd-yyyy HH-mm-ss")
Write-Host "Install Process Completed for App"$APPNAME
Write-Host (Get-Date -format "MMM-dd-yyyy_HH-mm-ss")
$INSTALLSTARTTIMESW.STOP()
Write-Host "-----------------------------------------------------------------------------------------------------------------------"
Write-Host "Listing Install Results "$OUTPUT
Write-Host (Get-Date -format "MMM-dd-yyyy_HH-mm-ss")
Write-Host "-----------------------------------------------------------------------------------------------------------------------"
