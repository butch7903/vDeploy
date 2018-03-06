##Check CAs for Pulse for new Certs
certutil.exe -pulse

##Wipe WinRM Listener Settings
##Wipe must be done to resolve issues with Citrix
Write-Host -ForegroundColor Yellow "Deleting old HTTP WinRM config"
winrm delete winrm/config/Listener?Address=*+Transport=HTTP
Write-Host -ForegroundColor Yellow "Deleting old HTTPS WinRM config"
winrm delete winrm/config/Listener?Address=*+Transport=HTTPS

##Requesting certs from Certificate Servers
Write-Host "Updating Certificates"
Start-Process certutil -ArgumentList -pulse -verb RunAs -Wait
Write-Host "Verifying Certificates"
Start-Process certutil -ArgumentList -pulse -verb RunAs -Wait
Write-Host "List WinRM Certificate"
Get-ChildItem Cert:\LocalMachine\My | 
	% {
	$_ | Select `
		Thumbprint,
		@{N="Template";E={($_.Extensions | 
			?{$_.oid.Friendlyname -match "Certificate Template Information"}).Format(0) `
				-replace "(.+)?=(.+)\((.+)?", '$2'}},
		@{N="Subject";E={$_.SubjectName.name}}
	} | Where Template -eq "WinRM"

function Transform-Certificate {
[CmdletBinding()]
    param(
 [Parameter(Mandatory = $true, ValueFromPipeline = $true, ValueFromPipelineByPropertyName = $true)]
 [Security.Cryptography.X509Certificates.X509Certificate2]$cert
 )
    process {
        $temp = $cert.Extensions | ?{$_.Oid.Value -eq "1.3.6.1.4.1.311.20.2"}
 if (!$temp) {
            $temp = $cert.Extensions | ?{$_.Oid.Value -eq "1.3.6.1.4.1.311.21.7"}
 }
        $cert | Add-Member -Name Template -MemberType NoteProperty -Value $temp.Format(1) -PassThru
 }
}

$certThumbprint = get-childitem cert:\localmachine\my | Transform-Certificate |  where {$_.Template.contains("WinRM")} | select-object -expandproperty "Thumbprint"
new-item WSMan:\localhost\Listener -Transport HTTPS -Address * -CertificateThumbprint $certThumbprint -force

##Set Client Trusted Hosts
##DMZ or other domain than speedycash.ict usage only. 
##If a server is on the same domain as the server starting the PSRemoting session, this is not needed. 
##This is also not needed if there is a 2-way trust between the domains.
Set-Item -Path "WSMan:\localhost\Client\TrustedHosts" -Value "HAMPC01.hamker.local" -Confirm:$false -FORCE

##Set Service Encryption(false prevents no encryption)
Set-Item -Path "WSMan:\localhost\Service\AllowUnencrypted" -Value $false 
##Set Service Authentication Support
Set-Item -Path "WSMan:\localhost\Service\Auth\Basic" -Value $false 
Set-Item -Path "WSMan:\localhost\Service\Auth\Kerberos" -Value $true
Set-Item -Path "WSMan:\localhost\Service\Auth\Negotiate" -Value $true
Set-Item -Path "WSMan:\localhost\Service\Auth\Certificate" -Value $true
Set-Item -Path "WSMan:\localhost\Service\Auth\CredSSP" -Value $false 
##Set Service Hardening Level
Set-Item -Path "WSMan:\localhost\Service\Auth\CbtHardeninglevel" -Value STRICT 
##Set Service Default Ports
Set-Item -Path "WSMan:\localhost\Service\DefaultPorts\HTTP" -Value 5985
Set-Item -Path "WSMan:\localhost\Service\DefaultPorts\HTTPS" -Value 5986
##Set Service IPv4 Filter
Set-Item -Path "WSMan:\localhost\Service\IPv4Filter" -Value * ## This will be updated after testing is completed per whatever requirements Mitch/IT Security specify for final requirements
##Set Service IPv6 Filter
Set-Item -Path "WSMan:\localhost\Service\IPv6Filter" -Value ""
##Set Service Compatibility Mode HTTP/S Listeners
Set-Item -Path "WSMan:\localhost\Service\EnableCompatibilityHttpListener" -Value $false
Set-Item -Path "WSMan:\localhost\Service\EnableCompatibilityHttpsListener" -Value $false
##Set Service Certificate Thumb Print
#Needed for certian servers that have issues with setting Thumbprint automatically.
Set-Item -Path "WSMan:\localhost\Service\CertificateThumbprint" -Value $certThumbprint
##Set Service AllowRemoteAccess
Set-Item -Path "WSMan:\localhost\Service\AllowRemoteAccess" -Value $true

##Set Permissions for PSRemoting (removes Network Account so that remote powershell sessions will function properly)
$Settings = Get-PSSessionConfiguration -Name "Microsoft.PowerShell" | Select Permission,SecurityDescriptorSddl
$Settings
If ($Settings -ne "O:NSG:BAD:P(A;;GA;;;BA)(A;;GA;;;RM)S:P(AU;FA;GA;;;WD)(AU;SA;GXGW;;;WD)")
{
Set-PSSessionConfiguration -Name "Microsoft.PowerShell" -SecurityDescriptorSddl "O:NSG:BAD:P(A;;GA;;;BA)(A;;GA;;;RM)S:P(AU;FA;GA;;;WD)(AU;SA;GXGW;;;WD)" -Confirm:$false
}
##To set permissions manually and capture Sddl, run below command and copy sddl for usuage
##Set-PSSessionConfiguration -Name "Microsoft.PowerShell" -ShowSecurityDescriptorUI ##Make Modification
##Run Script to get updated Sddl
##Get-PSSessionConfiguration -Name "Microsoft.PowerShell" | Select Permission,SecurityDescriptorSddl
##Bad Permissions (Sddl) are O:NSG:BAD:P(D;;GA;;;NU)(A;;GA;;;BA)(A;;GA;;;RM)S:P(AU;FA;GA;;;WD)(AU;SA;GXGW;;;WD)

#######HELPFUL COMMANDS##########
Write-Host "Getting Full WinRM Config"
winrm get winrm/config
Write-Host "Getting Listener WinRM Config"
winrm e winrm/config/listener
##Clear Client Trusted Hosts List
#Clear-Item -Path WSMan:\localhost\Client\TrustedHosts –Force
##List Client Trusted Hosts
#Get-Item WSMan:\localhost\Client\TrustedHosts
##Set Trusted Hosts
## Example: Set-Item WSMan:\localhost\Client\TrustedHosts -Value "192.168.140.*,machine*,*"

##Restart/Start WinRM Service to Activate SSL
Restart-Service WinRM
##Start WinRM if it was not started
Start-Service WinRM
##Verify Service is Running
Get-Service WinRM

##Create Firewall Rules to Allow WinRM for SSL
New-NetFirewallRule -DisplayName "Windows Remote Management (HTTPS-In)" -Direction Inbound –LocalPort 5986 -Protocol TCP -Action Allow -Confirm:$false