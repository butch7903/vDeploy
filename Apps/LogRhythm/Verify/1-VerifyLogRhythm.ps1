Write-Host "Beginning Verification Process for App"$APPNAME
$VerificationStartTime = (Get-Date -format "MMM-dd-yyyy HH-mm-ss")
$VERIFICATIONSTARTTIMESW = [Diagnostics.Stopwatch]::StartNew()
$LOGRHYTHMVERIFICATION = Invoke-Command -Session $SESSION -ScriptBlock{
	$Answer = Get-WmiObject Win32_Product -Filter "Name='LogRhythm System Monitor Service'" | Select *
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
#Write-Host "Install was: " $VERIFICATION.VERIFICATIONVALUE
Write-Host "Install was: " $LOGRHYTHMVERIFICATION
IF($LOGRHYTHMVERIFICATION -eq "Success")
{
$APPRESULTS += $APPNAME + " install: Success"
}Else{
$APPRESULTS += $APPNAME + " install: Failed"
}
#Write-Host "Install was: " $VERIFICATIONVALUE
Write-Host "Install Process Completed for App"$APPNAME
