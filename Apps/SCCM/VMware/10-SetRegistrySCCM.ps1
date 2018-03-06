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
	Write-Host "Updating Registery Keys for Windows Update Policies"
	New-Item -Path HKLM:\SOFTWARE\Policies\Microsoft\Windows -Name WindowsUpdate -ErrorAction SilentlyContinue
	Set-ItemProperty -Path HKLM:\SOFTWARE\Policies\Microsoft\Windows\WindowsUpdate -Name ElevateNonAdmins -Value 0 -ErrorAction SilentlyContinue
	Set-ItemProperty -Path HKLM:\SOFTWARE\Policies\Microsoft\Windows\WindowsUpdate -Name DisableOSUpgrade -Value 1 -ErrorAction SilentlyContinue
	Write-Host "Setting SCCM Server Settings"
	Set-ItemProperty -Path HKLM:\SOFTWARE\Policies\Microsoft\Windows\WindowsUpdate -Name WUServer -Value 'http://FQDN.SCCMSERVER.COM:PORT#' -ErrorAction SilentlyContinue
	Set-ItemProperty -Path HKLM:\SOFTWARE\Policies\Microsoft\Windows\WindowsUpdate -Name WUStatusServer -Value 'http://FQDN.SCCMSERVER.COM:PORT#' -ErrorAction SilentlyContinue
	Write-Host "Setting Windows Updates Configuration Settings"
	New-Item -Path HKLM:\SOFTWARE\Policies\Microsoft\Windows\WindowsUpdate -Name AU -ErrorAction SilentlyContinue
	Set-ItemProperty -Path HKLM:\SOFTWARE\Policies\Microsoft\Windows\WindowsUpdate\AU -Name NoAutoUpdate -Value 1 -ErrorAction SilentlyContinue 
	Set-ItemProperty -Path HKLM:\SOFTWARE\Policies\Microsoft\Windows\WindowsUpdate\AU -Name IncludeRecommendedUpdates -Value 0 -ErrorAction SilentlyContinue
	Set-ItemProperty -Path HKLM:\SOFTWARE\Policies\Microsoft\Windows\WindowsUpdate\AU -Name UseWUServer -Value 1 -ErrorAction SilentlyContinue
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