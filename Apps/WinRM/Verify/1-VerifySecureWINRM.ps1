##Verify WinRM Connectivity
Write-Host "Verifing Connectivity for"$APPNAME
$WINRMVERIFY = $FALSE
WHILE($WINRMVERIFY -eq $FALSE)
{
	TRY
	{
	$TESTWINRM  = test-wsman -computername $FQDN -Credential $MYDOMAINCREDENTIAL -Authentication Kerberos -port 5986 -UseSSL
		IF($TESTWINRM.ProductVendor -eq "Microsoft Corporation")
		{
			Write-Host "WinRM Connectivity Verified"
			$APPRESULTS += $APPNAME + " install: Success"
			$WINRMVERIFY = $TRUE
			
		}
	}
	CATCH
	{
	Write-Host "WinRM Is not Ready on remote host"
	}
}
Write-Host "Sleeping for 15 Seconds"
Start-Sleep -s 15
Write-Host $APPNAME" Install Process Completed"
