##Verify Install
Write-Host "-----------------------------------------------------------------------------------------------------------------------"
Write-Host (Get-Date -format "MMM-dd-yyyy_HH-mm-ss")
Write-Host "Beginning Verification Process for App "$APPNAME
$VerificationStartTime = (Get-Date -format "MMM-dd-yyyy HH-mm-ss")
$VERIFICATIONSTARTTIMESW = [Diagnostics.Stopwatch]::StartNew()
$SCOMVERIFICATION = Invoke-Command -Session $SESSION -ScriptBlock{
	$Answer = Get-WmiObject Win32_Product -Filter "Name='Microsoft Monitoring Agent'" | Select *
	If ($Answer.Name)
	{
		$VERIFICATIONVALUE = "Success"
		#Write-Host "Successful"
		#$VERIFICATIONVALUE
		RETURN $VERIFICATIONVALUE
		}Else{
		$VERIFICATIONVALUE = "Failed"
		#Write-Host "Failed"
		#$VERIFICATIONVALUE
		RETURN $VERIFICATIONVALUE
	}
}
$VERIFICATIONSTARTTIMESW.STOP()
$VerificationEndTime = (Get-Date -format "MMM-dd-yyyy HH-mm-ss")
Write-Host "Install was: " $SCOMVERIFICATION
IF($SCOMVERIFICATION -eq "Success")
{
$APPRESULTS += $APPNAME + " install: Success"
}Else{
$APPRESULTS += $APPNAME + " install: Failed"
}
Write-Host "Install Process Completed for App "$APPNAME
Write-Host (Get-Date -format "MMM-dd-yyyy_HH-mm-ss")
Write-Host "-----------------------------------------------------------------------------------------------------------------------"