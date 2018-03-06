###Install Symantec Agent
Write-Host $APPNAME" Install Process Starting"
##Initiate Install
Write-Host "-----------------------------------------------------------------------------------------------------------------------"
Write-Host (Get-Date -format "MMM-dd-yyyy_HH-mm-ss")
Write-Host "Beginning Install Process on "$APPNAME
$InstallStartTime = (Get-Date -format "MMM-dd-yyyy HH-mm-ss")
$INSTALLSTARTTIMESW = [Diagnostics.Stopwatch]::StartNew()
$OUTPUT = Invoke-Command -Session $SESSION -ScriptBlock {
	CD C:\Apps\Symantec
	C:
	#Extract Symantec Endpoint
	.\7z.exe x "C:\Apps\Symantec\Symantec_Endpoint_Protection_14.0.1MP1_Win64-bit_Client_EN.exe" -y
	#Instaqll Symantec Endpoint
	$INSTALL = "Start-Process msiexec.exe -Wait -ArgumentList '/I Sep64.msi /qn SYMREBOOT=ReallySuppress RUNLIVEUPDATE=1 ENABLEAUTOPROTECT=1 MIGRATESETTINGS=0 ADDSTARTMENUICON=1 ADDLOCAL=Core,SAVMain,Download,Pop3Smtp,PTPMain,TruScan,DCMain,NTPMain,ITPMain,LANG1033 /quiet'"
	$INSTALLOUTPUT = Invoke-Expression $INSTALL
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
