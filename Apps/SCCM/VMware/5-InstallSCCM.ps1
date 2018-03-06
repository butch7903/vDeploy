###Install SCCM Agent
Write-Host $APPNAME" Install Process Starting"

##Initiate Install
Write-Host "-----------------------------------------------------------------------------------------------------------------------"
Write-Host (Get-Date -format "MMM-dd-yyyy_HH-mm-ss")
Write-Host "Beginning Install Process on "$APPNAME
$InstallStartTime = (Get-Date -format "MMM-dd-yyyy HH-mm-ss")
$INSTALLSTARTTIMESW = [Diagnostics.Stopwatch]::StartNew()
$OUTPUT = Invoke-Command -Session $SESSION -ScriptBlock {
	$INSTALLOUTPUT = Invoke-Command -ScriptBlock {
	Start-Process -Filepath C:\Apps\SCCM\ccmsetup.exe -ArgumentList "smssitecode=ict fsp=FQDN.SCCMSERVER.COM smsslp=FQDN.SCCMSERVER.COM" -Wait
	Start-Sleep -Seconds 90
	}
	RETURN $INSTALLOUTPUT
}
$INSTALLEndTime = (Get-Date -format "MMM-dd-yyyy HH-mm-ss")
Write-Host "Install Process Completed for "$APPNAME
Write-Host (Get-Date -format "MMM-dd-yyyy_HH-mm-ss")
$INSTALLSTARTTIMESW.STOP()
Write-Host "-----------------------------------------------------------------------------------------------------------------------"
Write-Host "Listing Install Results "$OUTPUT
Write-Host (Get-Date -format "MMM-dd-yyyy_HH-mm-ss")
Write-Host "-----------------------------------------------------------------------------------------------------------------------"