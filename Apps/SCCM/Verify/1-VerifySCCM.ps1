##Verify Install
Write-Host "-----------------------------------------------------------------------------------------------------------------------"
Write-Host (Get-Date -format "MMM-dd-yyyy_HH-mm-ss")
Write-Host "Beginning Verification Process for App "$APPNAME
$VerificationStartTime = (Get-Date -format "MMM-dd-yyyy HH-mm-ss")
$VERIFICATIONSTARTTIMESW = [Diagnostics.Stopwatch]::StartNew()
$SCCMVERIFICATION = Invoke-Command -Session $SESSION -ScriptBlock{
	$Answer = Get-Service -name 'sms agent host' | Select *
	If ($Answer.Status -eq "Running")
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
Write-Host "Install was: " $SCCMVERIFICATION
IF($SCCMVERIFICATION -eq "Success")
{
$APPRESULTS += $APPNAME + " install: Success"
}Else{
$APPRESULTS += $APPNAME + " install: Failed"
}
Write-Host "Install Process Completed for App "$APPNAME
Write-Host (Get-Date -format "MMM-dd-yyyy_HH-mm-ss")
Write-Host "-----------------------------------------------------------------------------------------------------------------------"