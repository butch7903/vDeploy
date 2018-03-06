###Install LogRhythm Agent
Write-Host $APPNAME" Install Process Starting"

##Initiate Install
Write-Host "-----------------------------------------------------------------------------------------------------------------------"
Write-Host (Get-Date -format "MMM-dd-yyyy_HH-mm-ss")
Write-Host "Beginning Install Process on "$APPNAME
$InstallStartTime = (Get-Date -format "MMM-dd-yyyy HH-mm-ss")
$INSTALLSTARTTIMESW = [Diagnostics.Stopwatch]::StartNew()
$OUTPUT = Invoke-Command -Session $SESSION -ScriptBlock {
	$INSTALLOUTPUT = Invoke-Command -ScriptBlock {
	Start-Process -Filepath C:\Apps\LogRhythm\LRSystemMonitor_64_7.2.2.8004.exe -ArgumentList "/s /v" /qn ADDLOCAL=System_Monitor HOST=HOSTIPHERE SERVERPORT=443 CLIENTADDRESS=0 CLIENTPORT=CLIENTPORTHERE"" -Wait
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