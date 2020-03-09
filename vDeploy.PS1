<#
    .NOTES
	===========================================================================
	Created by:		Russell Hamker
	Date:			March 9, 2020
	Version:		3.0
	Twitter:		@butch7903
	GitHub:			https://github.com/butch7903
	===========================================================================

	.SYNOPSIS
		This script automates the full server build process for any virtual machine. It also automates the configuration
		of the Windows operating system and installs basic applications for standard business processes.

	.DESCRIPTION
		Use this script to build a virtual machine from a template. This script presents the user with full GUI fill in the blank style
		access to easily present how to deploy a virtual machine, do complex VM pre-poweron configuration, and install apps. This has been 
		designed with a zero trust model so that users only have access to network services based on NSX Security Tags if NSX is available.

	.NOTES
		

	.TROUBLESHOOTING
		
#>

##Document Start Time
$STARTTIME = Get-Date -format "MMM-dd-yyyy HH-mm-ss"
$STARTTIMESW = [Diagnostics.Stopwatch]::StartNew()

##Set PowerShell Window Settings
$pshost = get-host
$pswindow = $pshost.ui.rawui
$newsize = $pswindow.buffersize
$newsize.height = 30000
$newsize.width = 130
$pswindow.buffersize = $newsize
$newsize = $pswindow.windowsize
$newsize.height = (get-host).UI.RawUI.MaxWindowSize.Height
$newsize.width = 130
$pswindow.windowtitle = "vDeploy"
$pswindow.windowsize = $newsize

##Maximize Current PowerShell Window
function Show-Process($Process, [Switch]$Maximize)
{
<#
	.NOTES
	Reference http://community.idera.com/powershell/powertips/b/tips/posts/bringing-window-in-the-foreground
#>
  $sig = '
    [DllImport("user32.dll")] public static extern bool ShowWindowAsync(IntPtr hWnd, int nCmdShow);
    [DllImport("user32.dll")] public static extern int SetForegroundWindow(IntPtr hwnd);
  '
  
  if ($Maximize) { $Mode = 3 } else { $Mode = 4 }
  $type = Add-Type -MemberDefinition $sig -Name WindowAPI -PassThru
  $hwnd = $process.MainWindowHandle
  $null = $type::ShowWindowAsync($hwnd, $Mode)
  $null = $type::SetForegroundWindow($hwnd) 
}
Show-Process -Process (Get-Process -id $pid) -Maximize

##Check if Modules are installed, if so load them, else install them
if (Get-InstalledModule -Name VMware.PowerCLI -MinimumVersion 6.5.3.6870460) {
	Write-Host "-----------------------------------------------------------------------------------------------------------------------"
	Write-Host "PowerShell Module VMware PowerCLI required minimum version was found previously installed"
	Write-Host "Importing PowerShell Module VMware PowerCLI"
	Import-Module -Name VMware.PowerCLI
	Write-Host "Importing PowerShell Module VMware PowerCLI Completed"
	Write-Host "-----------------------------------------------------------------------------------------------------------------------"
	#CLEAR
} else {
	Write-Host "-----------------------------------------------------------------------------------------------------------------------"
	Write-Host "PowerShell Module VMware PowerCLI does not exist"
	Write-Host "Setting Micrsoft PowerShell Gallery as a Trusted Repository"
	Set-PSRepository -Name PSGallery -InstallationPolicy Trusted
	Write-Host "Verifying that NuGet is at minimum version 2.8.5.201 to proceed with update"
	Install-PackageProvider -Name NuGet -MinimumVersion 2.8.5.201 -Force -Confirm:$false
	Write-Host "Uninstalling any older versions of the VMware PowerCLI Module"
	Get-Module VMware.PowerCLI | Uninstall-Module -Force
	Write-Host "Installing Newest version of VMware PowerCLI PowerShell Module"
	Install-Module -Name VMware.PowerCLI -Scope AllUsers
	Write-Host "Creating a Desktop shortcut to the VMware PowerCLI Module"
	$AppLocation = "C:\Windows\System32\WindowsPowerShell\v1.0\powershell.exe"
	$Arguments = '-noe -c "Import-Module VMware.PowerCLI"'
	$WshShell = New-Object -ComObject WScript.Shell
	$Shortcut = $WshShell.CreateShortcut("$Home\Desktop\VMware PowerCLI.lnk")
	$Shortcut.TargetPath = $AppLocation
	$Shortcut.Arguments = $Arguments
	$ShortCut.Hotkey = "CTRL+SHIFT+V"
	$Shortcut.IconLocation = "%SystemRoot%\System32\WindowsPowerShell\v1.0\powershell.exe,1"
	$Shortcut.Description ="Launch VMware PowerCLI"
	$Shortcut.WorkingDirectory ="C:\"
	$Shortcut.Save()
	Write-Host "Shortcut Created"
	Write-Host "You may use the CTRL+SHIFT+V method to open VMware PowerCLI"
	Write-Host "Importing PowerShell Module VMware PowerCLI"
	Import-Module -Name VMware.PowerCLI
	Write-Host "PowerShell Module VMware PowerCLI Loaded"
	Write-Host "-----------------------------------------------------------------------------------------------------------------------"
	#Clear
}
#Needed Computer Account creation, modifications, and Service Account creation
<#if (Get-Module -ListAvailable -Name ActiveDirectory) {
#>
	Write-Host "-----------------------------------------------------------------------------------------------------------------------"
	Write-Host "Importing PowerShell Module ActiveDirectory"
	Import-Module -Name ActiveDirectory
	Write-Host "Importing PowerShell Module Active Directory Completed"
	Write-Host "-----------------------------------------------------------------------------------------------------------------------"
	#CLEAR
<#
} else {
	Write-Host "-----------------------------------------------------------------------------------------------------------------------"
	Write-Host "PowerShell Module Active Directory does not exist"
	#requires -RunAsAdministrator
	# Is the OS Windows 10?
	If ((Get-CimInstance Win32_OperatingSystem).Caption -like "*Windows 10*")
	# Is the RSAT already installed?
	If (Get-HotFix -Id KB2693643 -ErrorAction SilentlyContinue)
	# Is this x86 or x64 CPU?
	If ((Get-CimInstance Win32_ComputerSystem).SystemType -like "x64*")
	# Download the hotfix for RSAT install
	$WebClient = New-Object System.Net.WebClient
	$WebClient.DownloadFile($URL,$Destination)
	$WebClient.Dispose()
	# Install the hotfix. No native PowerShell way that I could find.
	# wusa.exe returns immediately. Loop until install complete.
	wusa.exe $Destination /quiet /norestart /log:$home\Documents\RSAT.log
	do {
		Write-Host "." -NoNewline
		Start-Sleep -Seconds 3
	} until (Get-HotFix -Id KB2693643 -ErrorAction SilentlyContinue)
	# Double-check that the role is enabled after install.
	If ((Get-WindowsOptionalFeature -Online -FeatureName `
		RSATClient-Roles-AD-Powershell -ErrorAction SilentlyContinue).State `
		-eq 'Enabled') {
		Write-Verbose '---RSAT AD PowerShell already enabled'
	} Else {
		Enable-WindowsOptionalFeature -Online -FeatureName `
			 RSATClient-Roles-AD-Powershell
	}
	# Install the help
	Update-Help -Module ActiveDirectory -Verbose -Force
	# Optionally verify the install.
	dir (Join-Path -Path $HOME -ChildPath Downloads\*msu)
	Get-HotFix -Id KB2693643
	Get-Help Get-ADDomain
	Get-ADDomain
	Write-Host "Importing PowerShell Module Active Directory"
	Import-Module -Name ActiveDirectory
	Write-Host "Importing PowerShell Module Active Directory Completed"
	Write-Host "-----------------------------------------------------------------------------------------------------------------------"
	#CLEAR
}
#>
#Needed NSX Settings
if (Get-Module -ListAvailable -Name PowerNSX) {
	Write-Host "-----------------------------------------------------------------------------------------------------------------------"
	Write-Host "Importing PowerShell Module PowerNSX"
	Import-Module -Name PowerNSX
	Write-Host "Importing PowerShell Module PowerNSX Completed"
	Write-Host "-----------------------------------------------------------------------------------------------------------------------"
	#CLEAR
} else {
	Write-Host "-----------------------------------------------------------------------------------------------------------------------"
	Write-Host "PowerShell Module PowerNSX does not exist"
	Write-Host "Setting Micrsoft PowerShell Gallery as a Trusted Repository"
	Set-PSRepository -Name PSGallery -InstallationPolicy Trusted
	Write-Host "Verifying that NuGet is at minimum version 2.8.5.201 to proceed with update"
	Install-PackageProvider -Name NuGet -MinimumVersion 2.8.5.201 -Force -Confirm:$false
	Write-Host "Installing New version of PowerNSX"
	Install-Module -Name PowerNSX -Scope AllUsers
	Write-Host "Importing PowerShell Module PowerNSX"
	Import-Module -Name PowerNSX
	Write-Host "Importing PowerShell Module PowerNSX Completed"
	Write-Host "-----------------------------------------------------------------------------------------------------------------------"
	#CLEAR
}

##Set Variables
##Get Current Path
$pwd = pwd
##If answerfile exists, Import it for use or create one.
$AnswerFile = $pwd.path+"\"+"AnswerFile.csv"
If (Test-Path $AnswerFile){
	##Import File
	Write-Host "Answer file found, importing answer file"$AnswerFile
	$Answer = Import-Csv $AnswerFile
	ForEach($Line in $Answer)
	{
		$VERSION = $Line.Version
		Write-Host "Version specified in file is:"$VERSION
		$SUBVERSION = $Line.SubVersion
		Write-Host "SubVersion specified in file is:"$SUBVERSION
		$VCENTER = $Line.vCenter
		Write-Host "vCenter specified in file is:"$VCENTER
		$NSXMANAGER = $Line.NSXManager
		Write-Host "Location Type is:"$NSXMANGER
		$SMTPSERVER = $Line.SMTPSERVER
		Write-Host "SMTP Server will be: "$SMTPSERVER
		$SMTPPORT = $Line.SMTPPORT
		Write-Host "SMTP Server Port will be: "$SMTPPORT
		$SMTPENABLESSL = $Line.SMTPENABLESSL
		Write-Host "SMTP Server SSL Status will be: "$SMTPENABLESSL
		$SMTPREQUIRECREDENTIALS = $Line.SMTPRequireCredentials
		Write-Host "SMTP Server Requires Credentials: "$SMTPREQUIRECREDENTIALS
		$MSGFROM = $Line.MsgFrom
		Write-Host "Emails will be sent from: "$MSGFROM
		$MSGTO = $Line.MsgTo
		Write-Host "Emails will be sent to: "$MSGTO
		$VMSYSPREPTIMEOUT = $Line.VMSysPrepTime
		Write-Host "VM SysPrep Timeout will be: "$VMSYSPREPTIMEOUT" Seconds"
		Write-Host "Continuing..."
		Start-Sleep -Seconds 2
	}
}
Else {
$Answers_List = @()
$Answers="" | Select Version,SubVersion,vCenter,NSXManager,SMTPServer,SMTPPort,SMTPEnableSSL,SMTPRequireCredentials,MsgFrom,MsgTo,VMSysPrepTime
Write-Host "Answer file NOT found. Please input information to continue."
$Version = "2"
$Answers.Version = $Version
$SubVersion = "0"
$Answers.SubVersion = $SubVersion
[System.Reflection.Assembly]::LoadWithPartialName('Microsoft.VisualBasic') | Out-Null
$vCenter = [Microsoft.VisualBasic.Interaction]::InputBox("Input vCenter FQDN or IP
Example: vcsa.contso.com or 10.1.1.1
", "vCenter")
$Answers.vCenter = $vCenter

$NSXMANAGER = [Microsoft.VisualBasic.Interaction]::InputBox("Input NSX Manager FQDN or IP
Example: vcsa.contso.com or 10.1.1.1
Note: Leave Blank if you do not have NSX
", "NSX Manager")
$Answers.NSXManager = $NSXMANAGER

$SMTPSERVER = [Microsoft.VisualBasic.Interaction]::InputBox("Type in a SMTP Server IP or FQDN for Email Reporting:
Example: smtp.contso.com 10.1.1.1
Note: Leave Blank if you do not want to use
", "SMTP Server")
$Answers.SMTPSERVER = $SMTPSERVER

$SMTPPORT_OPTIONS = @("25","587","465","2525")
WHILE($SMTPPORT -eq $NULL)
{
	$SMTPPORT = $SMTPPORT_OPTIONS | Out-GridView -Title 'What SMTP Server Port is required?' -OutputMode Single
	$Answers.SMTPPORT = $SMTPPORT
}

$SMTPENABLESSL_OPTIONS = @("True","False")
WHILE($SMTPENABLESSL -eq $NULL)
{
	$SMTPENABLESSL = $SMTPENABLESSL_OPTIONS | Out-GridView -Title 'Does SMTP Server require SSL?' -OutputMode Single
	$Answers.SMTPENABLESSL = $SMTPENABLESSL
}

$SMTPREQUIRECREDENTIALS_OPTIONS = @("Yes","No")
WHILE($SMTPREQUIRECREDENTIALS -eq $NULL)
{
	$SMTPREQUIRECREDENTIALS = $SMTPREQUIRECREDENTIALS_OPTIONS | Out-GridView -Title 'Does SMTP Server require Credentials?' -OutputMode Single
	$Answers.SMTPREQUIRECREDENTIALS = $SMTPREQUIRECREDENTIALS
}

$MSGFROM = [Microsoft.VisualBasic.Interaction]::InputBox("Type in the from Email From Address
Example: PowerCLI@domain.com
Note: Leave Blank if you do not want to use
Note2: If you are using public email like GMAIL, 
use the actual email address of the account you are using to send via SMTP with.
", "Email From")
$Answers.MsgFrom = $MSGFROM

$MSGTO = [Microsoft.VisualBasic.Interaction]::InputBox("Type in the list of Email Addresses to Send the Report to
Example: user@domain.com 
Note: For multiple emails do comma seperated: test@test.com,test2@test.com
Note2: Leave Blank if you do not want to use
", "Email To")
$Answers.MsgTo = $MSGTO
$MSGTO = $MSGTO -split ","

$VMSYSPREPTIMEOUT = [Microsoft.VisualBasic.Interaction]::InputBox("Type in the time in seconds to wait for SysPrep to Complete on a VM
Example: 1200  (1200 seconds / 60 = 20 Minutes)
Note: This is an average and is used to make sure that the VM Build process stops of SysPrep is not successful
Recommendation: Average time in seconds + 600 (10 minutes)", "SysPrep Timeout")
$Answers.VMSysPrepTime = $VMSYSPREPTIMEOUT

$Answers_List += $Answers
$Answers_List | Format-Table -AutoSize
Write-Host "Exporting Information to File"$AnswerFile
$Answers_List | Export-CSV -NoTypeInformation $AnswerFile
}

##Create Secure AES Keys for User and Password Management
$KeyFile = $pwd.path+"\"+"AES.key"
If (Test-Path $KeyFile){
Write-Host "AES File Exists"
$Key = Get-Content $KeyFile
Write-Host "Continuing..."
}
Else {
$Key = New-Object Byte[] 16   # You can use 16, 24, or 32 for AES
[Security.Cryptography.RNGCryptoServiceProvider]::Create().GetBytes($Key)
$Key | out-file $KeyFile
}

##Create Secure XML Credential File for vCenter/NSX Access
$MgrCreds = $pwd.path+"\"+"svc_account_Creds.xml"
If (Test-Path $MgrCreds){
Write-Host "svc_account_Creds.xml file found"
Write-Host "Continuing..."
$ImportObject = Import-Clixml $MgrCreds
$SecureString = ConvertTo-SecureString -String $ImportObject.Password -Key $Key
$MyCredential = New-Object System.Management.Automation.PSCredential($ImportObject.UserName, $SecureString)
}
Else {
$newPScreds = Get-Credential -message "Enter vCenter and NSX manager admin creds here:"
$exportObject = New-Object psobject -Property @{
    UserName = $newPScreds.UserName
    Password = ConvertFrom-SecureString -SecureString $newPScreds.Password -Key $Key
}

$exportObject | Export-Clixml $MgrCreds
$MyCredential = $newPScreds
}

IF($SMTPREQUIRECREDENTIALS -eq "Yes")
{
	##Create Secure XML Credential File for SMTP Server
	$SMTPCreds = $pwd.path+"\"+"SMTPServer_Creds.xml"
	If (Test-Path $SMTPCreds){
	Write-Host "SMTPServer_Creds.xml file found"
	Write-Host "Continuing..."
	$ImportObject = Import-Clixml $SMTPCreds
	$SecureString = ConvertTo-SecureString -String $ImportObject.Password -Key $Key
	$SMTPCREDENTIAL = New-Object System.Management.Automation.PSCredential($ImportObject.UserName, $SecureString)
	}
	Else {
	$SMTPPScreds = Get-Credential -message "Enter SMTP Server Creds here:"
	$exportObject = New-Object psobject -Property @{
		UserName = $SMTPPScreds.UserName
		Password = ConvertFrom-SecureString -SecureString $SMTPPScreds.Password -Key $Key
	}

	$exportObject | Export-Clixml $SMTPCreds
	$SMTPCREDENTIAL = $SMTPPScreds
	}
}

##Get Date Info for naming of snapshot variable
$LOGDATE = Get-Date -format "MMM-dd-yyyy_HH-mm"
##Specify Log File Info
$LOGFILENAME = "Log_" + $LOGDATE + ".txt"
#Create Log Folder
$LogFolder = $pwd.path+"\Log"
If (Test-Path $LogFolder){
	Write-Host "Log Directory Created. Continuing..."
}
Else{
	New-Item $LogFolder -type directory
}
#Specify Log File
$LOGFILE = $pwd.path+"\Log\"+$LOGFILENAME

#Create VM Build Log Folder
$LogBuildsFolder = $pwd.path+"\Log\Builds"
If (Test-Path $LogBuildsFolder){
	Write-Host "Log Directory Created. Continuing..."
}
Else{
	New-Item $LogBuildsFolder -type directory
}

##Create Function Get-FolderByPath
##Reference http://www.lucd.info/2012/05/18/folder-by-path/
##Thank you LUCD!
function Get-FolderByPath{
  <# .SYNOPSIS Retrieve folders by giving a path .DESCRIPTION The function will retrieve a folder by it's path. The path can contain any type of leave (folder or datacenter). .NOTES Author: Luc Dekens .PARAMETER Path The path to the folder. This is a required parameter. .PARAMETER Path The path to the folder. This is a required parameter. .PARAMETER Separator The character that is used to separate the leaves in the path. The default is '/' .EXAMPLE PS> Get-FolderByPath -Path "Folder1/Datacenter/Folder2"
.EXAMPLE
  PS> Get-FolderByPath -Path "Folder1>Folder2" -Separator '>'
#>
 
  param(
  [CmdletBinding()]
  [parameter(Mandatory = $true)]
  [System.String[]]${Path},
  [char]${Separator} = '/'
  )
 
  process{
    if((Get-PowerCLIConfiguration).DefaultVIServerMode -eq "Multiple"){
      $vcs = $defaultVIServers
    }
    else{
      $vcs = $defaultVIServers[0]
    }
 
    foreach($vc in $vcs){
      foreach($strPath in $Path){
        $root = Get-Folder -Name Datacenters -Server $vc
        $strPath.Split($Separator) | %{
          $root = Get-Inventory -Name $_ -Location $root -Server $vc -NoRecursion
          if((Get-Inventory -Location $root -NoRecursion | Select -ExpandProperty Name) -contains "vm"){
            $root = Get-Inventory -Name "vm" -Location $root -Server $vc -NoRecursion
          }
        }
        $root | where {$_ -is [VMware.VimAutomation.ViCore.Impl.V1.Inventory.FolderImpl]}|%{
          Get-Folder -Name $_.Name -Location $root.Parent -NoRecursion -Server $vc
        }
      }
    }
  }
}

Function Get-FolderPath{
<#
.SYNOPSIS
	Returns the folderpath for a folder
.DESCRIPTION
	The function will return the complete folderpath for
	a given folder, optionally with the "hidden" folders
	included. The function also indicats if it is a "blue"
	or "yellow" folder.
.NOTES
	Authors:	Luc Dekens
	Reference: http://www.lucd.info/2010/10/21/get-the-folderpath/
	Modified to use , instead of \ for the next folder level
.PARAMETER Folder
	On or more folders
.PARAMETER ShowHidden
	Switch to specify if "hidden" folders should be included
	in the returned path. The default is $false.
.EXAMPLE
	PS> Get-FolderPath -Folder (Get-Folder -Name "MyFolder")
.EXAMPLE
	PS> Get-Folder | Get-FolderPath -ShowHidden:$true
#>
 
	param(
	[parameter(valuefrompipeline = $true,
	position = 0,
	HelpMessage = "Enter a folder")]
	[VMware.VimAutomation.ViCore.Impl.V1.Inventory.FolderImpl[]]$Folder,
	[switch]$ShowHidden = $false
	)
 
	begin{
		$excludedNames = "Datacenters","vm","host"
	}
 
	process{
		$Folder | %{
			$fld = $_.Extensiondata
			$fldType = "yellow"
			if($fld.ChildType -contains "VirtualMachine"){
				$fldType = "blue"
			}
			$path = $fld.Name
			while($fld.Parent){
				$fld = Get-View $fld.Parent
				if((!$ShowHidden -and $excludedNames -notcontains $fld.Name) -or $ShowHidden){
					$path = $fld.Name + "," + $path
				}
			}
			$row = "" | Select Name,Path,Type
			$row.Name = $_.Name
			$row.Path = $path
			$row.Type = $fldType
			$row
		}
	}
}
 
Function MainForm {
<#
 .SYNOPSIS  
 Create MainForm and Populate fields  
 .DESCRIPTION  
 The function creates the MainForm and populates the field so that users can select inputs
 .NOTES   
 Author: Russell Hamker  
 Twitter: @butch7903 
 .PARAMETER N/a  
 No Parameters Required  
 .EXAMPLE  
  PS> $A = $MainForm  
#>
  #####################################    
  ## https://www.github.com/butch7903/PowerCLI   
  ## Version: 1    
  ## Written using Microsoft Visual Studio Community 2017   
  ## Tested this script on    
  ## 1) Powershell v5    
  ## 2) PowerShell Module VMware.PowerCLI 6.5 
  ## 3) PowerShell Module PowerNSX 3.0   
  ## 4) Vsphere 6.5
  ## 5) VMware NSX 6.3.3
  #####################################    

#Preset variables
$VCENTER = $DefaultVIServer | foreach { $_.Name }
$TEMPLATES = Get-Template *
$OSCUSTOMIZATIONS = Get-OSCustomizationSpec *
##Import VM Hard Drive Type List
TRY
{$VMTYPELIST = Import-CSV VMHDTypeList.csv}
CATCH
{Write-Warning "VMHDTypeList.csv File does not exist, create one to Properly Configure Hard Drives on VM"
BREAK}
##Import App List
TRY
{$APPLIST = Import-CSV AppList.csv}
CATCH
{Write-Warning "AppList.csv File does not exist, create one to install Applications"
BREAK}

[void][System.Reflection.Assembly]::Load('System.Drawing, Version=4.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a')
[void][System.Reflection.Assembly]::Load('System.Windows.Forms, Version=4.0.0.0, Culture=neutral, PublicKeyToken=b77a5c561934e089')
#MainForm
$MainForm = New-Object -TypeName System.Windows.Forms.Form
$MainForm.Text = 'VM Configuration'
$MainForm.ClientSize = (New-Object -TypeName System.Drawing.Size -ArgumentList @([System.Int32]457,[System.Int32]735))
$MainForm.StartPosition = [System.Windows.Forms.FormStartPosition]::CenterScreen
$MainForm.ResumeLayout($false)
$MainForm.PerformLayout()
$MainForm.AutoScroll = $true
$MainForm.AutoSizeMode = [System.Windows.Forms.AutoSizeMode]::GrowAndShrink
$MainForm.TopMost = $true
$MainForm.Add_Shown({$MainForm.Activate();$VMNameBox.focus()})

#vCenterTextBox
$vCenterTextBox = (New-Object -TypeName System.Windows.Forms.TextBox)
$vCenterTextBox.BackColor = [System.Drawing.SystemColors]::InactiveCaption
$vCenterTextBox.Location = (New-Object -TypeName System.Drawing.Point -ArgumentList @([System.Int32]113,[System.Int32]3))
$vCenterTextBox.Name = 'vCenterTextBox'
$vCenterTextBox.ReadOnly = $true
$vCenterTextBox.Size = (New-Object -TypeName System.Drawing.Size -ArgumentList @([System.Int32]332,[System.Int32]20))
$vCenterTextBox.TabIndex = [System.Int32]23
$vCenterTextBox.TabStop = $false
$vCenterTextBox.Text = $vCenter

#NSXManagerTextBox
$NSXManagerTextBox = (New-Object -TypeName System.Windows.Forms.TextBox)
$NSXManagerTextBox.BackColor = [System.Drawing.SystemColors]::InactiveCaption
$NSXManagerTextBox.Location = (New-Object -TypeName System.Drawing.Point -ArgumentList @([System.Int32]113,[System.Int32]26))
$NSXManagerTextBox.Name = 'NSXManagerTextBox'
$NSXManagerTextBox.ReadOnly = $true
$NSXManagerTextBox.Size = (New-Object -TypeName System.Drawing.Size -ArgumentList @([System.Int32]332,[System.Int32]20))
$NSXManagerTextBox.TabIndex = [System.Int32]24
$NSXManagerTextBox.TabStop = $false

#label1
$label1 = (New-Object -TypeName System.Windows.Forms.Label)
$label1.AutoSize = $true
$label1.Location = (New-Object -TypeName System.Drawing.Point -ArgumentList @([System.Int32]14,[System.Int32]6))
$label1.Name = 'label1'
$label1.Size = (New-Object -TypeName System.Drawing.Size -ArgumentList @([System.Int32]44,[System.Int32]13))
$label1.TabIndex = [System.Int32]4
$label1.Text = 'vCenter'

#label2
$label2 = (New-Object -TypeName System.Windows.Forms.Label)
$label2.AutoSize = $true
$label2.Location = (New-Object -TypeName System.Drawing.Point -ArgumentList @([System.Int32]13,[System.Int32]29))
$label2.Name = 'label2'
$label2.Size = (New-Object -TypeName System.Drawing.Size -ArgumentList @([System.Int32]74,[System.Int32]13))
$label2.TabIndex = [System.Int32]5
$label2.Text = 'NSX Manager'

#label3
$label3 = (New-Object -TypeName System.Windows.Forms.Label)
$label3.AutoSize = $true
$label3.Location = (New-Object -TypeName System.Drawing.Point -ArgumentList @([System.Int32]15,[System.Int32]52))
$label3.Name = 'label3'
$label3.Size = (New-Object -TypeName System.Drawing.Size -ArgumentList @([System.Int32]54,[System.Int32]13))
$label3.TabIndex = [System.Int32]7
$label3.Text = 'VM Name'

#label4
$label4 = (New-Object -TypeName System.Windows.Forms.Label)
$label4.AutoSize = $true
$label4.Location = (New-Object -TypeName System.Drawing.Point -ArgumentList @([System.Int32]305,[System.Int32]52))
$label4.Name = 'label4'
$label4.Size = (New-Object -TypeName System.Drawing.Size -ArgumentList @([System.Int32]138,[System.Int32]13))
$label4.TabIndex = [System.Int32]83
$label4.Text = '(Maximum of 15 Characters)'

#label5
$label5 = (New-Object -TypeName System.Windows.Forms.Label)
$label5.AutoSize = $true
$label5.Location = (New-Object -TypeName System.Drawing.Point -ArgumentList @([System.Int32]14,[System.Int32]74))
$label5.Name = 'label5'
$label5.Size = (New-Object -TypeName System.Drawing.Size -ArgumentList @([System.Int32]56,[System.Int32]13))
$label5.TabIndex = [System.Int32]10
$label5.Text = '# of CPUs'

#label6
$label6 = (New-Object -TypeName System.Windows.Forms.Label)
$label6.AutoSize = $true
$label6.Location = (New-Object -TypeName System.Drawing.Point -ArgumentList @([System.Int32]14,[System.Int32]97))
$label6.Name = 'label6'
$label6.Size = (New-Object -TypeName System.Drawing.Size -ArgumentList @([System.Int32]66,[System.Int32]13))
$label6.TabIndex = [System.Int32]12
$label6.Text = 'GBs of RAM'

#label7
$label7 = (New-Object -TypeName System.Windows.Forms.Label)
$label7.AutoSize = $true
$label7.Location = (New-Object -TypeName System.Drawing.Point -ArgumentList @([System.Int32]13,[System.Int32]172))
$label7.Name = 'label7'
$label7.Size = (New-Object -TypeName System.Drawing.Size -ArgumentList @([System.Int32]82,[System.Int32]13))
$label7.TabIndex = [System.Int32]20
$label7.Text = 'VM Designation'

#label8
$label8 = (New-Object -TypeName System.Windows.Forms.Label)
$label8.AutoSize = $true
$label8.Location = (New-Object -TypeName System.Drawing.Point -ArgumentList @([System.Int32]14,[System.Int32]627))
$label8.Name = 'label8'
$label8.Size = (New-Object -TypeName System.Drawing.Size -ArgumentList @([System.Int32]50,[System.Int32]13))
$label8.TabIndex = [System.Int32]62
$label8.Text = 'VM Tags'

#label9
$label9 = (New-Object -TypeName System.Windows.Forms.Label)
$label9.AutoSize = $true
$label9.Location = (New-Object -TypeName System.Drawing.Point -ArgumentList @([System.Int32]15,[System.Int32]224))
$label9.Name = 'label9'
$label9.Size = (New-Object -TypeName System.Drawing.Size -ArgumentList @([System.Int32]44,[System.Int32]13))
$label9.TabIndex = [System.Int32]22
$label9.Text = 'VM Site'

#label10
$label10 = (New-Object -TypeName System.Windows.Forms.Label)
$label10.AutoSize = $true
$label10.Location = (New-Object -TypeName System.Drawing.Point -ArgumentList @([System.Int32]15,[System.Int32]273))
$label10.Name = 'label10'
$label10.Size = (New-Object -TypeName System.Drawing.Size -ArgumentList @([System.Int32]39,[System.Int32]13))
$label10.TabIndex = [System.Int32]24
$label10.Text = 'Cluster'

#label11
$label11 = (New-Object -TypeName System.Windows.Forms.Label)
$label11.AutoSize = $true
$label11.Location = (New-Object -TypeName System.Drawing.Point -ArgumentList @([System.Int32]15,[System.Int32]298))
$label11.Name = 'label11'
$label11.Size = (New-Object -TypeName System.Drawing.Size -ArgumentList @([System.Int32]29,[System.Int32]13))
$label11.TabIndex = [System.Int32]26
$label11.Text = 'Host'

#label12
$label12 = (New-Object -TypeName System.Windows.Forms.Label)
$label12.AutoSize = $true
$label12.Location = (New-Object -TypeName System.Drawing.Point -ArgumentList @([System.Int32]15,[System.Int32]323))
$label12.Name = 'label12'
$label12.Size = (New-Object -TypeName System.Drawing.Size -ArgumentList @([System.Int32]58,[System.Int32]13))
$label12.TabIndex = [System.Int32]28
$label12.Text = 'Port Group'

#label13
$label13 = (New-Object -TypeName System.Windows.Forms.Label)
$label13.AutoSize = $true
$label13.Location = (New-Object -TypeName System.Drawing.Point -ArgumentList @([System.Int32]15,[System.Int32]348))
$label13.Name = 'label13'
$label13.Size = (New-Object -TypeName System.Drawing.Size -ArgumentList @([System.Int32]53,[System.Int32]13))
$label13.TabIndex = [System.Int32]30
$label13.Text = 'Datastore'

#label14
$label14 = (New-Object -TypeName System.Windows.Forms.Label)
$label14.AutoSize = $true
$label14.Location = (New-Object -TypeName System.Drawing.Point -ArgumentList @([System.Int32]12,[System.Int32]373))
$label14.Name = 'label14'
$label14.Size = (New-Object -TypeName System.Drawing.Size -ArgumentList @([System.Int32]90,[System.Int32]13))
$label14.TabIndex = [System.Int32]32
$label14.Text = 'OS Customization'

#label15
$label15 = (New-Object -TypeName System.Windows.Forms.Label)
$label15.AutoSize = $true
$label15.Location = (New-Object -TypeName System.Drawing.Point -ArgumentList @([System.Int32]15,[System.Int32]398))
$label15.Name = 'label15'
$label15.Size = (New-Object -TypeName System.Drawing.Size -ArgumentList @([System.Int32]69,[System.Int32]13))
$label15.TabIndex = [System.Int32]34
$label15.Text = 'VM HD Type'

#label16
$label16 = (New-Object -TypeName System.Windows.Forms.Label)
$label16.AutoSize = $true
$label16.Location = (New-Object -TypeName System.Drawing.Point -ArgumentList @([System.Int32]15,[System.Int32]423))
$label16.Name = 'label16'
$label16.Size = (New-Object -TypeName System.Drawing.Size -ArgumentList @([System.Int32]80,[System.Int32]13))
$label16.TabIndex = [System.Int32]36
$label16.Text = 'VM Folder Path'

#label17
$label17 = (New-Object -TypeName System.Windows.Forms.Label)
$label17.AutoSize = $true
$label17.Location = (New-Object -TypeName System.Drawing.Point -ArgumentList @([System.Int32]15,[System.Int32]447))
$label17.Name = 'label17'
$label17.Size = (New-Object -TypeName System.Drawing.Size -ArgumentList @([System.Int32]54,[System.Int32]13))
$label17.TabIndex = [System.Int32]38
$label17.Text = 'VM Notes'

#label18
$label18 = (New-Object -TypeName System.Windows.Forms.Label)
$label18.AutoSize = $true
$label18.Location = (New-Object -TypeName System.Drawing.Point -ArgumentList @([System.Int32]15,[System.Int32]470))
$label18.Name = 'label18'
$label18.Size = (New-Object -TypeName System.Drawing.Size -ArgumentList @([System.Int32]68,[System.Int32]13))
$label18.TabIndex = [System.Int32]40
$label18.Text = 'VM Owner(s)'

#label19
$label19 = (New-Object -TypeName System.Windows.Forms.Label)
$label19.AutoSize = $true
$label19.Location = (New-Object -TypeName System.Drawing.Point -ArgumentList @([System.Int32]13,[System.Int32]122))
$label19.Name = 'label19'
$label19.Size = (New-Object -TypeName System.Drawing.Size -ArgumentList @([System.Int32]70,[System.Int32]13))
$label19.TabIndex = [System.Int32]42
$label19.Text = 'VM Template'

#label20
$label20 = (New-Object -TypeName System.Windows.Forms.Label)
$label20.AutoSize = $true
$label20.Location = (New-Object -TypeName System.Drawing.Point -ArgumentList @([System.Int32]15,[System.Int32]674))
$label20.Name = 'label20'
$label20.Size = (New-Object -TypeName System.Drawing.Size -ArgumentList @([System.Int32]56,[System.Int32]13))
$label20.TabIndex = [System.Int32]44
$label20.Text = 'NSX Tags'

#label21
$label21 = (New-Object -TypeName System.Windows.Forms.Label)
$label21.AutoSize = $true
$label21.Location = (New-Object -TypeName System.Drawing.Point -ArgumentList @([System.Int32]3,[System.Int32]51))
$label21.Name = 'label21'
$label21.Size = (New-Object -TypeName System.Drawing.Size -ArgumentList @([System.Int32]54,[System.Int32]13))
$label21.TabIndex = [System.Int32]47
$label21.Text = 'VM Name'
$label21.Visible = $false

#label22
$label22 = (New-Object -TypeName System.Windows.Forms.Label)
$label22.AutoSize = $true
$label22.Location = (New-Object -TypeName System.Drawing.Point -ArgumentList @([System.Int32]15,[System.Int32]506))
$label22.Name = 'label22'
$label22.Size = (New-Object -TypeName System.Drawing.Size -ArgumentList @([System.Int32]73,[System.Int32]13))
$label22.TabIndex = [System.Int32]48
$label22.Text = 'Apps to Install'

#label23
$label23 = (New-Object -TypeName System.Windows.Forms.Label)
$label23.AutoSize = $true
$label23.Location = (New-Object -TypeName System.Drawing.Point -ArgumentList @([System.Int32]15,[System.Int32]541))
$label23.Name = 'label23'
$label23.Size = (New-Object -TypeName System.Drawing.Size -ArgumentList @([System.Int32]80,[System.Int32]13))
$label23.TabIndex = [System.Int32]51
$label23.Text = 'Override DHCP'

#label24
$label24 = (New-Object -TypeName System.Windows.Forms.Label)
$label24.AutoSize = $true
$label24.Location = (New-Object -TypeName System.Drawing.Point -ArgumentList @([System.Int32]70,[System.Int32]561))
$label24.Name = 'label24'
$label24.Visible = $false
$label24.Size = (New-Object -TypeName System.Drawing.Size -ArgumentList @([System.Int32]17,[System.Int32]13))
$label24.TabIndex = [System.Int32]54
$label24.Text = 'IP'

#label25
$label25 = (New-Object -TypeName System.Windows.Forms.Label)
$label25.AutoSize = $true
$label25.Location = (New-Object -TypeName System.Drawing.Point -ArgumentList @([System.Int32]185,[System.Int32]561))
$label25.Name = 'label25'
$label25.Visible = $false
$label25.Size = (New-Object -TypeName System.Drawing.Size -ArgumentList @([System.Int32]41,[System.Int32]13))
$label25.TabIndex = [System.Int32]55
$label25.Text = 'Subnet'

#label26
$label26 = (New-Object -TypeName System.Windows.Forms.Label)
$label26.AutoSize = $true
$label26.Location = (New-Object -TypeName System.Drawing.Point -ArgumentList @([System.Int32]325,[System.Int32]561))
$label26.Name = 'label26'
$label26.Visible = $false
$label26.Size = (New-Object -TypeName System.Drawing.Size -ArgumentList @([System.Int32]23,[System.Int32]13))
$label26.TabIndex = [System.Int32]57
$label26.Text = 'DG'

#label27
$label27 = (New-Object -TypeName System.Windows.Forms.Label)
$label27.AutoSize = $true
$label27.Location = (New-Object -TypeName System.Drawing.Point -ArgumentList @([System.Int32]52,[System.Int32]586))
$label27.Name = 'label27'
$label27.Visible = $false
$label27.Size = (New-Object -TypeName System.Drawing.Size -ArgumentList @([System.Int32]36,[System.Int32]13))
$label27.TabIndex = [System.Int32]58
$label27.Text = 'DNS1'

#label28
$label28 = (New-Object -TypeName System.Windows.Forms.Label)
$label28.AutoSize = $true
$label28.Location = (New-Object -TypeName System.Drawing.Point -ArgumentList @([System.Int32]189,[System.Int32]586))
$label28.Name = 'label28'
$label28.Visible = $false
$label28.Size = (New-Object -TypeName System.Drawing.Size -ArgumentList @([System.Int32]36,[System.Int32]13))
$label28.TabIndex = [System.Int32]60
$label28.Text = 'DNS2'

#label29
$label29 = (New-Object -TypeName System.Windows.Forms.Label)
$label29.AutoSize = $true
$label29.Location = (New-Object -TypeName System.Drawing.Point -ArgumentList @([System.Int32]15,[System.Int32]248))
$label29.Name = 'label29'
$label29.Size = (New-Object -TypeName System.Drawing.Size -ArgumentList @([System.Int32]60,[System.Int32]13))
$label29.TabIndex = [System.Int32]65
$label29.Text = 'Datacenter'

#VMNameBox
$VMNameBox = (New-Object -TypeName System.Windows.Forms.TextBox)
$VMNameBox.CharacterCasing = [System.Windows.Forms.CharacterCasing]::Upper
$VMNameBox.ImeMode = [System.Windows.Forms.ImeMode]::NoControl
$VMNameBox.Text = $VMNAME
$VMNameBox.Location = (New-Object -TypeName System.Drawing.Point -ArgumentList @([System.Int32]113,[System.Int32]49))
$VMNameBox.MaxLength = [System.Int32]15
$VMNameBox.Name = 'VMNameBox'
$VMNameBox.Size = (New-Object -TypeName System.Drawing.Size -ArgumentList @([System.Int32]190,[System.Int32]20))
$VMNameBox.TabIndex = [System.Int32]0

#CPUnumericUpDown
$CPUnumericUpDown = (New-Object -TypeName System.Windows.Forms.NumericUpDown)
$CPUnumericUpDown.Location = (New-Object -TypeName System.Drawing.Point -ArgumentList @([System.Int32]113,[System.Int32]72))
$CPUnumericUpDown.Value = $VCPUS
$CPUnumericUpDown.Minimum = 1
$CPUnumericUpDown.Maximum = 128
$CPUnumericUpDown.Name = 'CPUnumericUpDown'
$CPUnumericUpDown.Size = (New-Object -TypeName System.Drawing.Size -ArgumentList @([System.Int32]61,[System.Int32]20))
$CPUnumericUpDown.TabIndex = [System.Int32]1

#RAMnumericUpDown
$RAMnumericUpDown = (New-Object -TypeName System.Windows.Forms.NumericUpDown)
$RAMnumericUpDown.AllowDrop = $true
$RAMnumericUpDown.Location = (New-Object -TypeName System.Drawing.Point -ArgumentList @([System.Int32]113,[System.Int32]95))
$RAMnumericUpDown.Value = $RAM
$RAMnumericUpDown.Minimum = 4
$RAMnumericUpDown.Maximum = 768
$RAMnumericUpDown.Name = 'RAMnumericUpDown'
$RAMnumericUpDown.Size = (New-Object -TypeName System.Drawing.Size -ArgumentList @([System.Int32]61,[System.Int32]20))
$RAMnumericUpDown.TabIndex = [System.Int32]2

#VMTemplateComboBox
$VMTemplateComboBox = (New-Object -TypeName System.Windows.Forms.ComboBox)
$VMTemplateComboBox.DropDownStyle = [System.Windows.Forms.ComboBoxStyle]::DropDownList
$VMTemplateComboBox.FormattingEnabled = $true
$VMTemplateComboBox.Items.AddRange($TEMPLATES)
$VMTemplateComboBox.Location = (New-Object -TypeName System.Drawing.Point -ArgumentList @([System.Int32]113,[System.Int32]119))
$VMTemplateComboBox.Name = 'VMTemplateComboBox'
$VMTemplateComboBox.Size = (New-Object -TypeName System.Drawing.Size -ArgumentList @([System.Int32]332,[System.Int32]21))
$VMTemplateComboBox.Text = $TEMPLATE
$VMTemplateComboBox.TabIndex = [System.Int32]3

#DEVcheckBox
$DEVcheckBox = (New-Object -TypeName System.Windows.Forms.CheckBox)
$DEVcheckBox.AutoSize = $true
$DEVcheckBox.Location = (New-Object -TypeName System.Drawing.Point -ArgumentList @([System.Int32]114,[System.Int32]148))
$DEVcheckBox.Name = 'DEVcheckBox'
$DEVcheckBox.Size = (New-Object -TypeName System.Drawing.Size -ArgumentList @([System.Int32]67,[System.Int32]17))
$DEVcheckBox.CheckState = $DEV
$DEVcheckBox.Text = 'DEV VM'
$DEVcheckBox.UseVisualStyleBackColor = $true
$DEVcheckBox.TabIndex = [System.Int32]4

#DMZcheckBox
$DMZcheckBox = (New-Object -TypeName System.Windows.Forms.CheckBox)
$DMZcheckBox.AutoSize = $true
$DMZcheckBox.Location = (New-Object -TypeName System.Drawing.Point -ArgumentList @([System.Int32]114,[System.Int32]171))
$DMZcheckBox.Name = 'DMZcheckBox'
$DMZcheckBox.Size = (New-Object -TypeName System.Drawing.Size -ArgumentList @([System.Int32]69,[System.Int32]17))
$DMZcheckBox.CheckState = $DMZ
$DMZcheckBox.Text = 'DMZ VM'
$DMZcheckBox.UseVisualStyleBackColor = $true
$DMZcheckBox.TabIndex = [System.Int32]5

#PCIcheckBox
$PCIcheckBox = (New-Object -TypeName System.Windows.Forms.CheckBox)
$PCIcheckBox.AutoSize = $true
$PCIcheckBox.Location = (New-Object -TypeName System.Drawing.Point -ArgumentList @([System.Int32]114,[System.Int32]194))
$PCIcheckBox.Name = 'PCIcheckBox'
$PCIcheckBox.Size = (New-Object -TypeName System.Drawing.Size -ArgumentList @([System.Int32]62,[System.Int32]17))
$PCIcheckBox.CheckState = $PCI
$PCIcheckBox.Text = 'PCI VM'
$PCIcheckBox.UseVisualStyleBackColor = $true
$PCIcheckBox.TabIndex = [System.Int32]6

#ReplaceVMCheckBox
$ReplaceVMCheckBox = (New-Object -TypeName System.Windows.Forms.CheckBox)
$ReplaceVMCheckBox.AutoSize = $true
$ReplaceVMCheckBox.Location = (New-Object -TypeName System.Drawing.Point -ArgumentList @([System.Int32]6,[System.Int32]19))
$ReplaceVMCheckBox.Name = 'ReplaceVMCheckBox'
$ReplaceVMCheckBox.Size = (New-Object -TypeName System.Drawing.Size -ArgumentList @([System.Int32]124,[System.Int32]17))
$ReplaceVMCheckBox.Text = 'Replace Existing VM'
$ReplaceVMCheckBox.UseVisualStyleBackColor = $true
##Check if VM Replace box checked
$ReplaceVMCheckBox_Checked = {
	$ReplacementVMTextBox.Visible = $true
	$Label21.Visible = $true
}
$ReplaceVMCheckBox_UNChecked = {
	$ReplacementVMTextBox.Visible = $false
	$Label21.Visible = $false
}
$ReplaceVMCheckBox.add_CheckedChanged($ReplaceVMCheckBox_Checked)
$ReplaceVMCheckBox.remove_CheckedChanged($ReplaceVMCheckBox_UNChecked)
$ReplaceVMCheckBox.CheckState = $VMREPLACE
$ReplaceVMCheckBox.TabIndex = [System.Int32]8

#ReplacementVMTextBox
$ReplacementVMTextBox = (New-Object -TypeName System.Windows.Forms.TextBox)
$ReplacementVMTextBox.CharacterCasing = [System.Windows.Forms.CharacterCasing]::Upper
$ReplacementVMTextBox.Location = (New-Object -TypeName System.Drawing.Point -ArgumentList @([System.Int32]57,[System.Int32]48))
$ReplacementVMTextBox.Name = 'ReplacementVMTextBox'
$ReplacementVMTextBox.Size = (New-Object -TypeName System.Drawing.Size -ArgumentList @([System.Int32]191,[System.Int32]20))
$ReplacementVMTextBox.add_TextChanged($textBox1_TextChanged)
$ReplacementVMTextBox.Visible = $false
$ReplacementVMTextBox.Text = $VMNAMEREPLACE
$ReplacementVMTextBox.TabIndex = [System.Int32]9

#ReplaceVMGroupBox
$ReplaceVMGroupBox = (New-Object -TypeName System.Windows.Forms.GroupBox)
$ReplaceVMGroupBox.Controls.Add($label21)
$ReplaceVMGroupBox.Controls.Add($ReplaceVMCheckBox)
$ReplaceVMGroupBox.Controls.Add($ReplacementVMTextBox)
$ReplaceVMGroupBox.Location = (New-Object -TypeName System.Drawing.Point -ArgumentList @([System.Int32]189,[System.Int32]143))
$ReplaceVMGroupBox.Name = 'ReplaceVMGroupBox'
$ReplaceVMGroupBox.Size = (New-Object -TypeName System.Drawing.Size -ArgumentList @([System.Int32]256,[System.Int32]76))
$ReplaceVMGroupBox.TabStop = $false
$ReplaceVMGroupBox.Text = 'Replace VM'
$ReplaceVMGroupBox.TabIndex = [System.Int32]7

#SiteComboBox
$SiteComboBox = (New-Object -TypeName System.Windows.Forms.ComboBox)
$SiteComboBox.DropDownStyle = [System.Windows.Forms.ComboBoxStyle]::DropDownList
$SiteComboBox.FormattingEnabled = $true
$SiteComboBox.Items.AddRange(@('Production','DR'))
$SiteComboBox.Location = (New-Object -TypeName System.Drawing.Point -ArgumentList @([System.Int32]106,[System.Int32]221))
$SiteComboBox.Name = 'SiteComboBox'
$SiteComboBox.Size = (New-Object -TypeName System.Drawing.Size -ArgumentList @([System.Int32]339,[System.Int32]21))
$SiteComboBox.Text = $SITE
$SiteComboBox.TabIndex = [System.Int32]9

#DatacentercomboBox
$DatacentercomboBox = (New-Object -TypeName System.Windows.Forms.ComboBox)
$DatacentercomboBox.FormattingEnabled = $true
$DatacentercomboBox.Location = (New-Object -TypeName System.Drawing.Point -ArgumentList @([System.Int32]106,[System.Int32]245))
$DatacentercomboBox.Name = 'DatacentercomboBox'
$DatacentercomboBox.Size = (New-Object -TypeName System.Drawing.Size -ArgumentList @([System.Int32]339,[System.Int32]21))
$DATACENTERS = Get-DataCenter * | Select NAME
$DATACENTERS = $DATACENTERS.NAME
$DatacentercomboBox.Items.AddRange($DATACENTERS)
$DatacentercomboBox.Text = $DATACENTER
$DatacentercomboBox_SelectedIndexChanged = {
	$ClusterComboBox.Enabled = $true
	$CLUSTERS = (Get-Datacenter ($DatacentercomboBox).text | Get-Cluster * | Select NAME).Name
	$CLUSTERLIST = @()
	$CLUSTERLIST += $CLUSTERS
	$CLUSTERLIST += "*No Cluster"
	#$CLUSTERS = $CLUSTERS | Sort-Object
	$CLUSTERLIST = $CLUSTERLIST | Sort-Object
	#Write-HOST "Clusters include:"
	#Write-Host "$CLUSTERLIST"
	$ClusterComboBox.Items.Clear()
	$ClusterComboBox.Items.AddRange($CLUSTERLIST)
	$ClusterComboBox.Text = ""
	$ClusterComboBox.EndUpdate
	$HostComboBox.Items.Clear()
	$HostComboBox.Text = ""
	$HostComboBox.Enabled = $false
	$PortGroupComboBox.Items.Clear()
	$PortGroupComboBox.Text = ""
	$PortGroupComboBox.Enabled = $false
	$DatastoreComboBox.Items.Clear()
	$DatastoreComboBox.Text = ""
	$DatastoreComboBox.Enabled = $false
	$FolderPathComboBox.Items.Clear()
	$FolderPathComboBox.Text = ""
	$FolderPathComboBox.Enabled = $false
}
$DatacenterComboBox.add_SelectedIndexChanged($DatacenterComboBox_SelectedIndexChanged)
$DatacentercomboBox.TabIndex = [System.Int32]10

#ClusterComboBox
$ClusterComboBox = (New-Object -TypeName System.Windows.Forms.ComboBox)
#$ClusterComboBox.DropDownStyle = [System.Windows.Forms.ComboBoxStyle]::DropDownList #This Causes errors when user does not fill out all fields correctly
$ClusterComboBox.Enabled = $false
$ClusterComboBox.BeginUpdate
$ClusterComboBox.FormattingEnabled = $true
$ClusterComboBox.Location = (New-Object -TypeName System.Drawing.Point -ArgumentList @([System.Int32]106,[System.Int32]270))
$ClusterComboBox.Name = 'ClusterComboBox'
$ClusterComboBox.Size = (New-Object -TypeName System.Drawing.Size -ArgumentList @([System.Int32]339,[System.Int32]21))
$ClusterComboBox.Text = $CLUSTER
$ClusterComboBox_SelectedIndexChanged = {
$HostComboBox.Text = ""
	IF($ClusterComboBox.Text -ne "*No Cluster")
	{
		$HostComboBox.Enabled = $true
		$PortGroupComboBox.Items.Clear()
		$PortGroupComboBox.Text = ""
		$PortGroupComboBox.Enabled = $false
		$DatastoreComboBox.Items.Clear()
		$DatastoreComboBox.Text = ""
		$DatastoreComboBox.Enabled = $false
		$FolderPathComboBox.Items.Clear()
		$FolderPathComboBox.Text = ""
		$FolderPathComboBox.Enabled = $false
		$CLUSTER = Get-Cluster -Name $ClusterComboBox.Text
		$VMHOSTS = Get-Cluster $CLUSTER | Get-VMHost * | where ConnectionState -eq 'Connected'
		$HostComboBox.Items.Clear()
		$HostComboBox.Items.AddRange($VMHOSTS) 
		$HostComboBox.EndUpdate
	}ELSE{
		$HostComboBox.Enabled = $true
		$PortGroupComboBox.Items.Clear()
		$PortGroupComboBox.Text = ""
		$PortGroupComboBox.Enabled = $false
		$DatastoreComboBox.Items.Clear()
		$DatastoreComboBox.Text = ""
		$DatastoreComboBox.Enabled = $false
		$FolderPathComboBox.Items.Clear()
		$FolderPathComboBox.Text = ""
		$FolderPathComboBox.Enabled = $false
		$VMHOSTS = Get-VMHost * | where ConnectionState -eq 'Connected' | where {$_.ParentId -like "Folder*"}
		$HostComboBox.Items.Clear()
		$HostComboBox.Items.AddRange($VMHOSTS) 
		$HostComboBox.EndUpdate
	}
	
}
$ClusterComboBox.add_SelectedIndexChanged($ClusterComboBox_SelectedIndexChanged)
$ClusterComboBox.TabIndex = [System.Int32]11

#HostComboBox
$HostComboBox = (New-Object -TypeName System.Windows.Forms.ComboBox)
#$HostComboBox.DropDownStyle = [System.Windows.Forms.ComboBoxStyle]::DropDownList #This Causes errors when user does not fill out all fields correctly
$HostComboBox.Enabled = $false
$HostComboBox.BeginUpdate
$HostComboBox.FormattingEnabled = $true
$HostComboBox.Location = (New-Object -TypeName System.Drawing.Point -ArgumentList @([System.Int32]106,[System.Int32]295))
$HostComboBox.Name = 'HostComboBox'
$HostComboBox.Size = (New-Object -TypeName System.Drawing.Size -ArgumentList @([System.Int32]339,[System.Int32]21))
$HostComboBox_SelectedIndexChanged = {
#PortGroup
$PORTGROUPS = Get-VMHost $HostComboBox.Text | Get-VirtualPortGroup | Sort-Object Name
$PortGroupComboBox.Items.Clear()
$PortGroupComboBox.Items.AddRange($PORTGROUPS)
$PortGroupComboBox.Enabled = $true
$DatastoreComboBox.Items.Clear()
$DatastoreComboBox.Text = ""
$DatastoreComboBox.Enabled = $false
$FolderPathComboBox.Items.Clear()
$FolderPathComboBox.Text = ""
$FolderPathComboBox.Enabled = $false
$PortGroupComboBox.EndUpdate
#FolderPath
$DATACENTER = Get-VMHOST $HostComboBox.Text | Get-Datacenter
$VMFOLDERS = Get-FolderPath -Folder (Get-DataCenter $DATACENTER | Get-Folder -Type VM) | Select Path
$VMFOLDERS = $VMFOLDERS.Path
$VMFOLDERS = $VMFOLDERS[1..($VMFOLDERS.Length-1)]
$DATACENTERNAME = Get-DataCenter $DATACENTER | Select Name
$DATACENTERNAME = $DATACENTERNAME.NAME
$VMFOLDERS+=$DATACENTERNAME
$VMFOLDERS = $VMFOLDERS | Sort-Object
$FolderPathComboBox.Items.Clear()
$FolderPathComboBox.Items.AddRange($VMFOLDERS)
$FolderPathComboBox.Enabled = $true
$FolderPathComboBox.EndUpdate
}
$HostComboBox.add_SelectedIndexChanged($HostComboBox_SelectedIndexChanged)
$HostComboBox.TabIndex = [System.Int32]12

#PortGroupComboBox
$PortGroupComboBox = (New-Object -TypeName System.Windows.Forms.ComboBox)
#$PortGroupComboBox.DropDownStyle = [System.Windows.Forms.ComboBoxStyle]::DropDownList #This Causes errors when user does not fill out all fields correctly
$PortGroupComboBox.Enabled = $false
$PortGroupComboBox.BeginUpdate
$PortGroupComboBox.FormattingEnabled = $true
$PortGroupComboBox.Location = (New-Object -TypeName System.Drawing.Point -ArgumentList @([System.Int32]106,[System.Int32]320))
$PortGroupComboBox.Name = 'PortGroupComboBox'
$PortGroupComboBox.Size = (New-Object -TypeName System.Drawing.Size -ArgumentList @([System.Int32]339,[System.Int32]21))
$PortGroupComboBox.Text = $PORTGROUP
IF($PORTGROUP -ne ""){
$PORTGROUPS = Get-VMHost $HostComboBox.Text | Get-VirtualPortGroup | Sort-Object Name
$PortGroupComboBox.Items.Clear()
$PortGroupComboBox.Items.AddRange($PORTGROUPS)
$PortGroupComboBox.Enabled = $true
$PortGroupComboBox.EndUpdate
}
$PortGroupComboBox_SelectedIndexChanged = {
$DatastoreComboBox.Items.Clear()
$DATASTORES = Get-VMHost $HostComboBox.Text | Get-Datastore * | Sort-Object FreeSpaceGB -Descending | foreach {$_.Name + "  |  " + $_.FreeSpaceGB + "  |  " + $_.CapacityGB}
$DATASTORES = $DATASTORES -replace '@=',''
$DatastoreComboBox.Items.AddRange($DATASTORES)
$DatastoreComboBox.Enabled = $true
$DatastoreComboBox.EndUpdate
}
$PortGroupComboBox.add_SelectedIndexChanged($PortGroupComboBox_SelectedIndexChanged)
$PortGroupComboBox.TabIndex = [System.Int32]13

#DatastoreComboBox
$DatastoreComboBox = (New-Object -TypeName System.Windows.Forms.ComboBox)
#$DatastoreComboBox.DropDownStyle = [System.Windows.Forms.ComboBoxStyle]::DropDownList #This Causes errors when user does not fill out all fields correctly
$DatastoreComboBox.Enabled = $false
$DatastoreComboBox.BeginUpdate
$DatastoreComboBox.FormattingEnabled = $true
$DatastoreComboBox.Location = (New-Object -TypeName System.Drawing.Point -ArgumentList @([System.Int32]106,[System.Int32]345))
$DatastoreComboBox.Name = 'DatastoreComboBox'
$DatastoreComboBox.Size = (New-Object -TypeName System.Drawing.Size -ArgumentList @([System.Int32]339,[System.Int32]21))
$DatastoreComboBox.Text = $DATASTORE
IF($DATASTORE -ne ""){
$DatastoreComboBox.Items.Clear()
$DATASTORES = Get-VMHost $HostComboBox.Text | Get-Datastore * | Sort-Object FreeSpaceGB -Descending | foreach {$_.Name + "  |  " + $_.FreeSpaceGB + "  |  " + $_.CapacityGB}
$DATASTORES = $DATASTORES -replace '@=',''
$DatastoreComboBox.Items.AddRange($DATASTORES)
$DatastoreComboBox.Enabled = $true
$DatastoreComboBox.EndUpdate
}
#$DatastoreComboBox.add_SelectedIndexChanged($comboBox1_SelectedIndexChanged)
$DatastoreComboBox.TabIndex = [System.Int32]14

#OSCustomizationComboBox
$OSCustomizationComboBox = (New-Object -TypeName System.Windows.Forms.ComboBox)
$OSCustomizationComboBox.DropDownStyle = [System.Windows.Forms.ComboBoxStyle]::DropDownList
$OSCustomizationComboBox.FormattingEnabled = $true
$OSCustomizationComboBox.Items.AddRange($OSCUSTOMIZATIONS)
$OSCustomizationComboBox.Location = (New-Object -TypeName System.Drawing.Point -ArgumentList @([System.Int32]106,[System.Int32]370))
$OSCustomizationComboBox.Name = 'OSCustomizationComboBox'
$OSCustomizationComboBox.Size = (New-Object -TypeName System.Drawing.Size -ArgumentList @([System.Int32]339,[System.Int32]21))
$OSCustomizationComboBox.Text = $OSCUSTOMIZATION
IF($OSCUSTOMIZATION -ne "")
{
$OSCustomizationComboBoxInt = [array]::indexof($OSCUSTOMIZATIONS, $OSCUSTOMIZATION) #Get Integer for index number of Selected $OSCustomization
$OSCustomizationComboBox.SelectedIndex = $OSCustomizationComboBoxInt #Set $OSCustomization as default
}
$OSCustomizationComboBox.TabIndex = [System.Int32]15

#VMTypeComboBox
$VMTypeComboBox = (New-Object -TypeName System.Windows.Forms.ComboBox)
$VMTypeComboBox.DropDownStyle = [System.Windows.Forms.ComboBoxStyle]::DropDownList
$VMTypeComboBox.FormattingEnabled = $true
$VMTypeComboBox.Items.AddRange($VMTYPELIST.Name)
$VMTypeComboBox.Location = (New-Object -TypeName System.Drawing.Point -ArgumentList @([System.Int32]106,[System.Int32]395))
$VMTypeComboBox.Name = 'VMTypeComboBox'
$VMTypeComboBox.Size = (New-Object -TypeName System.Drawing.Size -ArgumentList @([System.Int32]339,[System.Int32]21))
$VMTypeComboBox.Text = $VMTYPE
$VMTypeComboBox.TabIndex = [System.Int32]16

#FolderPathComboBox
$FolderPathComboBox = (New-Object -TypeName System.Windows.Forms.ComboBox)
#$FolderPathComboBox.DropDownStyle = [System.Windows.Forms.ComboBoxStyle]::DropDownList #This Causes errors when user does not fill out all fields correctly
$FolderPathComboBox.Enabled = $false
$FolderPathComboBox.FormattingEnabled = $true
$FolderPathComboBox.Location = (New-Object -TypeName System.Drawing.Point -ArgumentList @([System.Int32]106,[System.Int32]420))
$FolderPathComboBox.Name = 'FolderPathComboBox'
$FolderPathComboBox.Size = (New-Object -TypeName System.Drawing.Size -ArgumentList @([System.Int32]339,[System.Int32]21))
$FolderPathComboBox.Text = $VMFOLDER
IF($VMFOLDER -ne ""){
$FolderPathComboBox.Enabled = $true
}
$FolderPathComboBox.TabIndex = [System.Int32]17

#NotesTextBox
$NotesTextBox = (New-Object -TypeName System.Windows.Forms.TextBox)
$NotesTextBox.ImeMode = [System.Windows.Forms.ImeMode]::NoControl
$NotesTextBox.Location = (New-Object -TypeName System.Drawing.Point -ArgumentList @([System.Int32]106,[System.Int32]444))
$NotesTextBox.MaxLength = [System.Int32]512
$NotesTextBox.Multiline = $true
$NotesTextBox.Name = 'NotesTextBox'
$NotesTextBox.Size = (New-Object -TypeName System.Drawing.Size -ArgumentList @([System.Int32]339,[System.Int32]20))
$NotesTextBox.Text = $NOTES
$NotesTextBox.add_TextChanged($textBox3_TextChanged)
$NotesTextBox.TabIndex = [System.Int32]18

#OwnersTextBox
$OwnersTextBox = (New-Object -TypeName System.Windows.Forms.TextBox)
$OwnersTextBox.ImeMode = [System.Windows.Forms.ImeMode]::NoControl
$OwnersTextBox.Location = (New-Object -TypeName System.Drawing.Point -ArgumentList @([System.Int32]106,[System.Int32]467))
$OwnersTextBox.MaxLength = [System.Int32]256
$OwnersTextBox.Name = 'OwnersTextBox'
$OwnersTextBox.Size = (New-Object -TypeName System.Drawing.Size -ArgumentList @([System.Int32]339,[System.Int32]20))
$OwnersTextBox.Text = $OWNERS
$OwnersTextBox.TabIndex = [System.Int32]19

#AppCheckedListBox
$AppCheckedListBox = (New-Object -TypeName System.Windows.Forms.CheckedListBox)
$AppCheckedListBox.FormattingEnabled = $true
$AppCheckedListBox.Location = (New-Object -TypeName System.Drawing.Point -ArgumentList @([System.Int32]106,[System.Int32]490))
$AppCheckedListBox.Name = 'AppCheckedListBox'
$AppCheckedListBox.Size = (New-Object -TypeName System.Drawing.Size -ArgumentList @([System.Int32]339,[System.Int32]49))
$AppCheckedListBox.Items.AddRange($APPLIST.Name)
FOREACH ($APP in $APPLIST)
{
	$AppCheckedListBox.SetItemChecked([int]$APP.AppOrder, [boolean]$APP.Default)
}
$AppCheckedListBox.TabIndex = [System.Int32]20

#OverrideDHCPcheckBox
#Out of Order to correctly set items to enabled with box is checked
$OverrideDHCPcheckBox = (New-Object -TypeName System.Windows.Forms.CheckBox)
$OverrideDHCPcheckBox.AutoSize = $true
$OverrideDHCPcheckBox.Location = (New-Object -TypeName System.Drawing.Point -ArgumentList @([System.Int32]112,[System.Int32]541))
$OverrideDHCPcheckBox.Name = 'OverrideDHCPcheckBox'
$OverrideDHCPcheckBox.Size = (New-Object -TypeName System.Drawing.Size -ArgumentList @([System.Int32]131,[System.Int32]17))
$OverrideDHCPcheckBox.Text = 'Check to Set Static IP'
$OverrideDHCPcheckBox.UseVisualStyleBackColor = $true
##Check if VM Replace box checked
$OverrideDHCPcheckBox_Checked = {
	$OverrideDHCPcheckBox.Visible = $true
	$Label24.Visible = $true
	$Label25.Visible = $true
	$Label26.Visible = $true
	$Label27.Visible = $true
	$Label28.Visible = $true
	$IPTextBox.Visible = $true
	$SubnetTextBox.Visible = $true
	$DGTextBox.Visible = $true
	$DNS1TextBox.Visible = $true
	$DNS2TextBox.Visible = $true
}
$OverrideDHCPcheckBox_UNChecked = {
	$ReplacementVMTextBox.Visible = $false
	$Label24.Visible = $false
	$Label25.Visible = $false
	$Label26.Visible = $false
	$Label27.Visible = $false
	$Label28.Visible = $false
	$IPTextBox.Visible = $false
	$SubnetTextBox.Visible = $false
	$DGTextBox.Visible = $false
	$DNS1TextBox.Visible = $false
	$DNS2TextBox.Visible = $false
}
$OverrideDHCPcheckBox.add_CheckedChanged($OverrideDHCPcheckBox_Checked)
$OverrideDHCPcheckBox.remove_CheckedChanged($OverrideDHCPcheckBox_UNChecked)
$OverrideDHCPcheckBox.CheckState = $OVERRIDEDHCP
$OverrideDHCPcheckBox.TabIndex = [System.Int32]21

#IPTextBox
$IPTextBox = (New-Object -TypeName System.Windows.Forms.TextBox)
$IPTextBox.Location = (New-Object -TypeName System.Drawing.Point -ArgumentList @([System.Int32]88,[System.Int32]558))
$IPTextBox.MaxLength = [System.Int32]15
$IPTextBox.Name = 'IPTextBox'
$IPTextBox.Visible = $false
$IPTextBox.Size = (New-Object -TypeName System.Drawing.Size -ArgumentList @([System.Int32]96,[System.Int32]20))
$IPTextBox.Text = $IP
$IPTextBox.TabIndex = [System.Int32]22

#SubnetTextBox
$SubnetTextBox = (New-Object -TypeName System.Windows.Forms.TextBox)
$SubnetTextBox.Location = (New-Object -TypeName System.Drawing.Point -ArgumentList @([System.Int32]226,[System.Int32]558))
$SubnetTextBox.MaxLength = [System.Int32]15
$SubnetTextBox.Name = 'SubnetTextBox'
$SubnetTextBox.Visible = $false
$SubnetTextBox.Size = (New-Object -TypeName System.Drawing.Size -ArgumentList @([System.Int32]96,[System.Int32]20))
$SubnetTextBox.Text = $SUBNET
$SubnetTextBox.TabIndex = [System.Int32]23

#DGTextBox
$DGTextBox = (New-Object -TypeName System.Windows.Forms.TextBox)
$DGTextBox.Location = (New-Object -TypeName System.Drawing.Point -ArgumentList @([System.Int32]349,[System.Int32]558))
$DGTextBox.MaxLength = [System.Int32]15
$DGTextBox.Name = 'DGTextBox'
$DGTextBox.Visible = $false
$DGTextBox.Size = (New-Object -TypeName System.Drawing.Size -ArgumentList @([System.Int32]96,[System.Int32]20))
$DGTextBox.Text = $DG
$DGTextBox.TabIndex = [System.Int32]24

#DNS1TextBox
$DNS1TextBox = (New-Object -TypeName System.Windows.Forms.TextBox)
$DNS1TextBox.Location = (New-Object -TypeName System.Drawing.Point -ArgumentList @([System.Int32]87,[System.Int32]583))
$DNS1TextBox.MaxLength = [System.Int32]15
$DNS1TextBox.Name = 'DNS1TextBox'
$DNS1TextBox.Visible = $false
$DNS1TextBox.Size = (New-Object -TypeName System.Drawing.Size -ArgumentList @([System.Int32]96,[System.Int32]20))
$DNS1TextBox.Text = $DNS1
$DNS1TextBox.TabIndex = [System.Int32]25

#DNS2TextBox
$DNS2TextBox = (New-Object -TypeName System.Windows.Forms.TextBox)
$DNS2TextBox.Location = (New-Object -TypeName System.Drawing.Point -ArgumentList @([System.Int32]226,[System.Int32]583))
$DNS2TextBox.Name = 'DNS2TextBox'
$DNS2TextBox.Visible = $false
$DNS2TextBox.Size = (New-Object -TypeName System.Drawing.Size -ArgumentList @([System.Int32]96,[System.Int32]20))
$DNS2TextBox.Text = $DNS2
$DNS2TextBox.TabIndex = [System.Int32]26

#VMTagCheckedListBox
$VMTagCheckedListBox = (New-Object -TypeName System.Windows.Forms.CheckedListBox)
$VMTagCheckedListBox.FormattingEnabled = $true
$VMTagCheckedListBox.HorizontalScrollbar = $true
$VMTagCheckedListBox.Location = (New-Object -TypeName System.Drawing.Point -ArgumentList @([System.Int32]106,[System.Int32]606))
$VMTagCheckedListBox.Name = 'VMTagCheckedListBox'
$VMTagCheckedListBox.Size = (New-Object -TypeName System.Drawing.Size -ArgumentList @([System.Int32]339,[System.Int32]49))
$VMTAGS = Get-Tag | foreach {$_.Name} | Sort-Object
$VMTagCheckedListBox.Items.AddRange($VMTAGS)
$VMTagCheckedListBox.TabIndex = [System.Int32]27

#NSXTagCheckedListBox
$NSXTagCheckedListBox = (New-Object -TypeName System.Windows.Forms.CheckedListBox)
if($DefaultNSXConnection.Server){
$NSXTAGS = Get-NsxSecurityTag | foreach {$_.Name} | Sort-Object
$NSXTagCheckedListBox.Items.AddRange($NSXTAGS) 
$NSXTagCheckedListBox.Enabled = $true
}
$NSXTagCheckedListBox.AccessibleDescription = 'NSX Tags'
$NSXTagCheckedListBox.FormattingEnabled = $true
$NSXTagCheckedListBox.Location = (New-Object -TypeName System.Drawing.Point -ArgumentList @([System.Int32]106,[System.Int32]658))
$NSXTagCheckedListBox.Name = 'NSXTagCheckedListBox'
$NSXTagCheckedListBox.Size = (New-Object -TypeName System.Drawing.Size -ArgumentList @([System.Int32]339,[System.Int32]49))
#Check Default NSX Tags
if($NSXDEFAULTTAGS){
ForEach($NSXDEFAULTTAG in $NSXDEFAULTTAGS)
{
$NewServerInt = [array]::indexof($NSXTAGS, $NSXDEFAULTTAG) #Get Integer for index number of $NSXDEFAULTTAG Tag
$NSXTagCheckedListBox.SetItemChecked($NewServerInt, $true) #Set $NSXDEFAULTTAG Tag as defaulted to True
}
}
$NSXTagCheckedListBox.TabIndex = [System.Int32]28

##NSX Config not present
if(!$DefaultNSXConnection.Server){
$NSXManagerTextBox.Text = 'N/A'
$NSXTagCheckedListBox.Visible = $false
$label20.Visible = $false
}

if($DefaultNSXConnection.Server){
$NSXManagerTextBox.Text = $DefaultNSXConnection.Server
$NSXTagCheckedListBox.Visible = $true
$label20.Visible = $true
}

#OK Button Click
$OKbutton_Click = [System.EventHandler]{
$MainForm.DialogResult = 1
$MainForm.Close();
}

#OKbutton
$OKbutton = (New-Object -TypeName System.Windows.Forms.Button)
$OKbutton.Location = (New-Object -TypeName System.Drawing.Point -ArgumentList @([System.Int32]162,[System.Int32]710))
$OKbutton.Name = 'OKbutton'
$OKbutton.Size = (New-Object -TypeName System.Drawing.Size -ArgumentList @([System.Int32]75,[System.Int32]23))
$OKbutton.Text = 'OK'
$OKbutton.UseVisualStyleBackColor = $true
$OKbutton.add_Click($OKbutton_Click)
$OKbutton.TabIndex = [System.Int32]29

#Cancel Button Click
$Cancelbutton_Click = { 
$MainForm.DialogResult = 0
$MainForm.Close()
}

#Cancelbutton
$Cancelbutton = (New-Object -TypeName System.Windows.Forms.Button)
$Cancelbutton.Location = (New-Object -TypeName System.Drawing.Point -ArgumentList @([System.Int32]258,[System.Int32]710))
$Cancelbutton.Name = 'Cancelbutton'
$Cancelbutton.Size = (New-Object -TypeName System.Drawing.Size -ArgumentList @([System.Int32]75,[System.Int32]23))
$Cancelbutton.Text = 'Cancel'
$Cancelbutton.UseVisualStyleBackColor = $true
$Cancelbutton.add_Click($Cancelbutton_Click)
$Cancelbutton.TabIndex = [System.Int32]30

#MainForm
$MainForm.Controls.Add($label1)
$MainForm.Controls.Add($label2)
$MainForm.Controls.Add($label3)
$MainForm.Controls.Add($label4)
$MainForm.Controls.Add($label5)
$MainForm.Controls.Add($label6)
$MainForm.Controls.Add($label7)
$MainForm.Controls.Add($label8)
$MainForm.Controls.Add($label9)
$MainForm.Controls.Add($label10)
$MainForm.Controls.Add($label11)
$MainForm.Controls.Add($label12)
$MainForm.Controls.Add($label13)
$MainForm.Controls.Add($label14)
$MainForm.Controls.Add($label15)
$MainForm.Controls.Add($label16)
$MainForm.Controls.Add($label17)
$MainForm.Controls.Add($label18)
$MainForm.Controls.Add($label19)
$MainForm.Controls.Add($label20)
#$MainForm.Controls.Add($label21) #Commented out to force into ReplaceVMGroupBox
#$MainForm.Controls.Add($ReplaceVMCheckBox) #Commented out to force into ReplaceVMGroupBox
#$MainForm.Controls.Add($ReplacementVMTextBox) #Commented out to force into ReplaceVMGroupBox
$MainForm.Controls.Add($label22)
$MainForm.Controls.Add($label23)
$MainForm.Controls.Add($label24)
$MainForm.Controls.Add($label25)
$MainForm.Controls.Add($label26)
$MainForm.Controls.Add($label27)
$MainForm.Controls.Add($label28)
$MainForm.Controls.Add($label29)
$MainForm.Controls.Add($Cancelbutton)
$MainForm.Controls.Add($OKbutton)
$MainForm.Controls.Add($NSXTagCheckedListBox)
$MainForm.Controls.Add($VMTagCheckedListBox)
$MainForm.Controls.Add($DNS2TextBox)
$MainForm.Controls.Add($DNS1TextBox)
$MainForm.Controls.Add($DGTextBox)
$MainForm.Controls.Add($SubnetTextBox)
$MainForm.Controls.Add($IPTextBox)
$MainForm.Controls.Add($OverrideDHCPcheckBox)
$MainForm.Controls.Add($AppCheckedListBox)
$MainForm.Controls.Add($OwnersTextBox)
$MainForm.Controls.Add($NotesTextBox)
$MainForm.Controls.Add($FolderPathComboBox)
$MainForm.Controls.Add($VMTypeComboBox)
$MainForm.Controls.Add($OSCustomizationComboBox)
$MainForm.Controls.Add($DatastoreComboBox)
$MainForm.Controls.Add($PortGroupComboBox)
$MainForm.Controls.Add($HostComboBox)
$MainForm.Controls.Add($ClusterComboBox)
$MainForm.Controls.Add($DatacenterComboBox)
$MainForm.Controls.Add($SiteComboBox)
$MainForm.Controls.Add($ReplaceVMGroupBox)
$MainForm.Controls.Add($DMZcheckBox)
$MainForm.Controls.Add($PCIcheckBox)
$MainForm.Controls.Add($DEVcheckBox)
$MainForm.Controls.Add($RAMnumericUpDown)
$MainForm.Controls.Add($CPUnumericUpDown)
$MainForm.Controls.Add($VMNameBox)
$MainForm.Controls.Add($NSXManagerTextBox)
$MainForm.Controls.Add($vCenterTextBox)
$MainForm.Controls.Add($VMTemplateComboBox)
$ret = $MainForm.ShowDialog()

#################return values
$OUTPUT = "" | Select-Object -Property VMName,VCPUS,RAM,Template,DEV,DMZ,PCI,VMReplace,VMNameReplace,Site,Datacenter,Cluster,VMHost,PortGroup,Datastore,OSCustomization,VMType,VMFolder,Notes,Owner,AppList,OverRideDHCP,IP,Subnet,DG,DNS1,DNS2,VMTags,NSXTags,Cancel
$OUTPUT.VMName = $VMNameBox.Text
$OUTPUT.VCPUS = $CPUnumericUpDown.Value
$OUTPUT.RAM = $RAMnumericUpDown.Value
$OUTPUT.Template = $VMTemplateComboBox.Text
$OUTPUT.DEV = $DEVcheckBox.CheckState
$OUTPUT.DMZ = $DMZcheckBox.CheckState
$OUTPUT.PCI = $PCIcheckBox.CheckState
$OUTPUT.VMREPLACE = $ReplaceVMCheckBox.CheckState
$OUTPUT.VMNAMEREPLACE = $ReplacementVMTextBox.Text
$OUTPUT.Site = $SiteComboBox.Text
$OUTPUT.Datacenter = $DatacenterComboBox.Text
$OUTPUT.Cluster = $ClusterComboBox.Text
$OUTPUT.VMHost = $HostComboBox.Text
$OUTPUT.PortGroup = $PortGroupComboBox.Text
$OUTPUT.Datastore = $DatastoreComboBox.Text
$OUTPUT.OSCustomization = $OSCustomizationComboBox.Text
$OUTPUT.VMType = $VMTypeComboBox.Text
$OUTPUT.VMFolder = $FolderPathComboBox.Text
$OUTPUT.Notes = $NotesTextBox.Text
$OUTPUT.Owner = $OwnersTextBox.Text
$OUTPUT.AppList = $AppCheckedListBox.CheckedItems
$OUTPUT.OverRideDHCP = $OverrideDHCPcheckBox.CheckState
$OUTPUT.IP = $IPTextBox.Text
$OUTPUT.Subnet = $SubnetTextBox.Text
$OUTPUT.DG = $DGTextBox.Text
$OUTPUT.DNS1 = $DNS1TextBox.Text
$OUTPUT.DNS2 = $DNS2TextBox.Text
$OUTPUT.VMTAGS = $VMTagCheckedListBox.CheckedItems
$OUTPUT.NSXTAGS = $NSXTagCheckedListBox.CheckedItems
$OUTPUT.CANCEL = $MainForm.DialogResult

RETURN $OUTPUT
}

Function HardDiskForm {
<#  
 .SYNOPSIS  
 Create Hard Disk Form and Populate fields  
 .DESCRIPTION  
 The function creates the Hard Disk Form and populates the field so that users can select inputs
 .NOTES   
 Author: Russell Hamker  
 Twitter: @butch7903 
 .PARAMETER N/a  
 No Parameters Required  
 .EXAMPLE  
  PS> $A = $HardDiskForm  
 #>  
  #####################################    
  ## https://www.github.com/butch7903/PowerCLI   
  ## Version: 1    
  ## Written using Microsoft Visual Studio Community 2017   
  ## Tested this script on    
  ## 1) Powershell v5    
  #####################################    

[void][System.Reflection.Assembly]::Load('System.Drawing, Version=4.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a')
[void][System.Reflection.Assembly]::Load('System.Windows.Forms, Version=4.0.0.0, Culture=neutral, PublicKeyToken=b77a5c561934e089')
#HardDiskForm
$HardDiskForm = New-Object -TypeName System.Windows.Forms.Form
$HardDiskForm.ClientSize = (New-Object -TypeName System.Drawing.Size -ArgumentList @([System.Int32]284,[System.Int32]412))
$HardDiskForm.Name = 'HardDiskForm'
$HardDiskForm.Text = 'VM Type Hard Disk Config'
$HardDiskForm.ResumeLayout($false)
$HardDiskForm.PerformLayout()
$HardDiskForm.AutoScroll = $true
$HardDiskForm.AutoSizeMode = [System.Windows.Forms.AutoSizeMode]::GrowAndShrink
$HardDiskForm.StartPosition = [System.Windows.Forms.FormStartPosition]::CenterScreen
$HardDiskForm.TopMost = $true

#Drive0label1
$Drive0label1 = (New-Object -TypeName System.Windows.Forms.Label)
$Drive0label1.AutoSize = $true
$Drive0label1.Location = (New-Object -TypeName System.Drawing.Point -ArgumentList @([System.Int32]16,[System.Int32]49))
$Drive0label1.Name = 'Drive1label1'
$Drive0label1.Size = (New-Object -TypeName System.Drawing.Size -ArgumentList @([System.Int32]38,[System.Int32]13))
$Drive0label1.TabIndex = [System.Int32]0
$Drive0label1.Text = 'Drive1'

#Drive0LabelLetter
$Drive0LabelLetter = (New-Object -TypeName System.Windows.Forms.Label)
$Drive0LabelLetter.AutoSize = $true
$Drive0LabelLetter.Location = (New-Object -TypeName System.Drawing.Point -ArgumentList @([System.Int32]53,[System.Int32]49))
$Drive0LabelLetter.Name = 'Drive1LabelLetter'
$Drive0LabelLetter.Size = (New-Object -TypeName System.Drawing.Size -ArgumentList @([System.Int32]34,[System.Int32]13))
$Drive0LabelLetter.TabIndex = [System.Int32]6
$Drive0LabelLetter.Text = 'Letter'

#Drive0TextBoxLetter
$Drive0TextBoxLetter = (New-Object -TypeName System.Windows.Forms.TextBox)
$Drive0TextBoxLetter.Location = (New-Object -TypeName System.Drawing.Point -ArgumentList @([System.Int32]87,[System.Int32]46))
$Drive0TextBoxLetter.Name = 'Drive1TextBoxLetter'
$Drive0TextBoxLetter.ReadOnly = $true
$Drive0TextBoxLetter.Size = (New-Object -TypeName System.Drawing.Size -ArgumentList @([System.Int32]19,[System.Int32]20))
$Drive0TextBoxLetter.TabIndex = [System.Int32]7
$Drive0TextBoxLetter.TabStop = $false
$Drive0TextBoxLetter.Text = $Drive0Letter

#Drive0LabelLabel
$Drive0LabelLabel = (New-Object -TypeName System.Windows.Forms.Label)
$Drive0LabelLabel.AutoSize = $true
$Drive0LabelLabel.Location = (New-Object -TypeName System.Drawing.Point -ArgumentList @([System.Int32]112,[System.Int32]49))
$Drive0LabelLabel.Name = 'Drive1LabelLabel'
$Drive0LabelLabel.Size = (New-Object -TypeName System.Drawing.Size -ArgumentList @([System.Int32]61,[System.Int32]13))
$Drive0LabelLabel.TabIndex = [System.Int32]8
$Drive0LabelLabel.Text = 'Drive Label'

#Drive0TextBoxLabel
$Drive0TextBoxLabel = (New-Object -TypeName System.Windows.Forms.TextBox)
$Drive0TextBoxLabel.Location = (New-Object -TypeName System.Drawing.Point -ArgumentList @([System.Int32]174,[System.Int32]46))
$Drive0TextBoxLabel.Name = 'Drive1TextBoxLabel'
$Drive0TextBoxLabel.ReadOnly = $true
$Drive0TextBoxLabel.Size = (New-Object -TypeName System.Drawing.Size -ArgumentList @([System.Int32]100,[System.Int32]20))
$Drive0TextBoxLabel.TabIndex = [System.Int32]9
$Drive0TextBoxLabel.TabStop = $false
$Drive0TextBoxLabel.Text = $Drive0Name

#Drive0SizeLabel
$Drive0SizeLabel = (New-Object -TypeName System.Windows.Forms.Label)
$Drive0SizeLabel.AutoSize = $true
$Drive0SizeLabel.Location = (New-Object -TypeName System.Drawing.Point -ArgumentList @([System.Int32]16,[System.Int32]69))
$Drive0SizeLabel.Name = 'Drive1SizeLabel'
$Drive0SizeLabel.Size = (New-Object -TypeName System.Drawing.Size -ArgumentList @([System.Int32]88,[System.Int32]13))
$Drive0SizeLabel.TabIndex = [System.Int32]10
$Drive0SizeLabel.Text = 'Drive 1 Size (GB)'

#Drive0numericUpDown
$Drive0numericUpDown = (New-Object -TypeName System.Windows.Forms.NumericUpDown)
$Drive0numericUpDown.Location = (New-Object -TypeName System.Drawing.Point -ArgumentList @([System.Int32]110,[System.Int32]67))
$Drive0numericUpDown.Name = 'Drive1numericUpDown'
$Drive0numericUpDown.Size = (New-Object -TypeName System.Drawing.Size -ArgumentList @([System.Int32]56,[System.Int32]20))
$Drive0numericUpDown.TabIndex = [System.Int32]1
$Drive0numericUpDown.Minimum = $Drive0Minimum

#Drive1numericUpDown
$Drive1numericUpDown = (New-Object -TypeName System.Windows.Forms.NumericUpDown)
$Drive1numericUpDown.Location = (New-Object -TypeName System.Drawing.Point -ArgumentList @([System.Int32]110,[System.Int32]119))
$Drive1numericUpDown.Name = 'Drive1numericUpDown'
$Drive1numericUpDown.Size = (New-Object -TypeName System.Drawing.Size -ArgumentList @([System.Int32]56,[System.Int32]20))
$Drive1numericUpDown.Visible = [System.Convert]::ToBoolean($VMTYPELIST.Drive1LabelLabel)
$Drive1numericUpDown.TabIndex = [System.Int32]2
$Drive1numericUpDown.Visible = $Drive1
$Drive1numericUpDown.Minimum = $Drive1Minimum

#Drive1SizeLabel
$Drive1SizeLabel = (New-Object -TypeName System.Windows.Forms.Label)
$Drive1SizeLabel.AutoSize = $true
$Drive1SizeLabel.Location = (New-Object -TypeName System.Drawing.Point -ArgumentList @([System.Int32]16,[System.Int32]121))
$Drive1SizeLabel.Name = 'Drive1SizeLabel'
$Drive1SizeLabel.Size = (New-Object -TypeName System.Drawing.Size -ArgumentList @([System.Int32]88,[System.Int32]13))
$Drive1SizeLabel.TabIndex = [System.Int32]24
$Drive1SizeLabel.Text = 'Drive 2 Size (GB)'
$Drive1SizeLabel.Visible = $Drive1

#Drive1TextBoxLabel
$Drive1TextBoxLabel = (New-Object -TypeName System.Windows.Forms.TextBox)
$Drive1TextBoxLabel.Location = (New-Object -TypeName System.Drawing.Point -ArgumentList @([System.Int32]174,[System.Int32]98))
$Drive1TextBoxLabel.Name = 'Drive1TextBoxLabel'
$Drive1TextBoxLabel.ReadOnly = $true
$Drive1TextBoxLabel.Size = (New-Object -TypeName System.Drawing.Size -ArgumentList @([System.Int32]100,[System.Int32]20))
$Drive1TextBoxLabel.TabIndex = [System.Int32]23
$Drive1TextBoxLabel.TabStop = $false
$Drive1TextBoxLabel.Visible = $Drive1
$Drive1TextBoxLabel.Text = $Drive1Name

#Drive1LabelLabel
$Drive1LabelLabel = (New-Object -TypeName System.Windows.Forms.Label)
$Drive1LabelLabel.AutoSize = $true
$Drive1LabelLabel.Location = (New-Object -TypeName System.Drawing.Point -ArgumentList @([System.Int32]112,[System.Int32]101))
$Drive1LabelLabel.Name = 'Drive1LabelLabel'
$Drive1LabelLabel.Size = (New-Object -TypeName System.Drawing.Size -ArgumentList @([System.Int32]61,[System.Int32]13))
$Drive1LabelLabel.TabIndex = [System.Int32]22
$Drive1LabelLabel.Text = 'Drive Label'
$Drive1LabelLabel.Visible = $Drive1

#Drive1TextBoxLetter
$Drive1TextBoxLetter = (New-Object -TypeName System.Windows.Forms.TextBox)
$Drive1TextBoxLetter.Location = (New-Object -TypeName System.Drawing.Point -ArgumentList @([System.Int32]87,[System.Int32]98))
$Drive1TextBoxLetter.Name = 'Drive1TextBoxLetter'
$Drive1TextBoxLetter.ReadOnly = $true
$Drive1TextBoxLetter.Size = (New-Object -TypeName System.Drawing.Size -ArgumentList @([System.Int32]19,[System.Int32]20))
$Drive1TextBoxLetter.TabIndex = [System.Int32]21
$Drive1TextBoxLetter.TabStop = $false
$Drive1TextBoxLetter.Visible = $Drive1
$Drive1TextBoxLetter.Text = $Drive1Letter

#Drive1LabelLetter
$Drive1LabelLetter = (New-Object -TypeName System.Windows.Forms.Label)
$Drive1LabelLetter.AutoSize = $true
$Drive1LabelLetter.Location = (New-Object -TypeName System.Drawing.Point -ArgumentList @([System.Int32]53,[System.Int32]101))
$Drive1LabelLetter.Name = 'Drive1LabelLetter'
$Drive1LabelLetter.Size = (New-Object -TypeName System.Drawing.Size -ArgumentList @([System.Int32]34,[System.Int32]13))
$Drive1LabelLetter.TabIndex = [System.Int32]20
$Drive1LabelLetter.Text = 'Letter'
$Drive1LabelLetter.Visible = $Drive1

#Drive1label1
$Drive1label1 = (New-Object -TypeName System.Windows.Forms.Label)
$Drive1label1.AutoSize = $true
$Drive1label1.Location = (New-Object -TypeName System.Drawing.Point -ArgumentList @([System.Int32]16,[System.Int32]101))
$Drive1label1.Name = 'Drive1label1'
$Drive1label1.Size = (New-Object -TypeName System.Drawing.Size -ArgumentList @([System.Int32]38,[System.Int32]13))
$Drive1label1.TabIndex = [System.Int32]19
$Drive1label1.Text = 'Drive1'
$Drive1label1.Visible = $Drive1

#Drive2numericUpDown
$Drive2numericUpDown = (New-Object -TypeName System.Windows.Forms.NumericUpDown)
$Drive2numericUpDown.Location = (New-Object -TypeName System.Drawing.Point -ArgumentList @([System.Int32]110,[System.Int32]172))
$Drive2numericUpDown.Name = 'Drive2numericUpDown'
$Drive2numericUpDown.Size = (New-Object -TypeName System.Drawing.Size -ArgumentList @([System.Int32]56,[System.Int32]20))
$Drive2numericUpDown.TabIndex = [System.Int32]3
$Drive2numericUpDown.Visible = $Drive2
$Drive2numericUpDown.Minimum = $Drive2Minimum

#Drive2SizeLabel
$Drive2SizeLabel = (New-Object -TypeName System.Windows.Forms.Label)
$Drive2SizeLabel.AutoSize = $true
$Drive2SizeLabel.Location = (New-Object -TypeName System.Drawing.Point -ArgumentList @([System.Int32]16,[System.Int32]174))
$Drive2SizeLabel.Name = 'Drive2SizeLabel'
$Drive2SizeLabel.Size = (New-Object -TypeName System.Drawing.Size -ArgumentList @([System.Int32]88,[System.Int32]13))
$Drive2SizeLabel.TabIndex = [System.Int32]31
$Drive2SizeLabel.Text = 'Drive 3 Size (GB)'
$Drive2SizeLabel.Visible = $Drive2

#Drive2TextBoxLabel
$Drive2TextBoxLabel = (New-Object -TypeName System.Windows.Forms.TextBox)
$Drive2TextBoxLabel.Location = (New-Object -TypeName System.Drawing.Point -ArgumentList @([System.Int32]174,[System.Int32]151))
$Drive2TextBoxLabel.Name = 'Drive2TextBoxLabel'
$Drive2TextBoxLabel.ReadOnly = $true
$Drive2TextBoxLabel.Size = (New-Object -TypeName System.Drawing.Size -ArgumentList @([System.Int32]100,[System.Int32]20))
$Drive2TextBoxLabel.TabIndex = [System.Int32]30
$Drive2TextBoxLabel.TabStop = $false
$Drive2TextBoxLabel.Text = $Drive2Name
$Drive2TextBoxLabel.Visible = $Drive2

#Drive2LabelLabel
$Drive2LabelLabel = (New-Object -TypeName System.Windows.Forms.Label)
$Drive2LabelLabel.AutoSize = $true
$Drive2LabelLabel.Location = (New-Object -TypeName System.Drawing.Point -ArgumentList @([System.Int32]112,[System.Int32]154))
$Drive2LabelLabel.Name = 'Drive2LabelLabel'
$Drive2LabelLabel.Size = (New-Object -TypeName System.Drawing.Size -ArgumentList @([System.Int32]61,[System.Int32]13))
$Drive2LabelLabel.TabIndex = [System.Int32]29
$Drive2LabelLabel.Text = 'Drive Label'
$Drive2LabelLabel.Visible = $Drive2

#Drive2TextBoxLetter
$Drive2TextBoxLetter = (New-Object -TypeName System.Windows.Forms.TextBox)
$Drive2TextBoxLetter.Location = (New-Object -TypeName System.Drawing.Point -ArgumentList @([System.Int32]87,[System.Int32]151))
$Drive2TextBoxLetter.Name = 'Drive2TextBoxLetter'
$Drive2TextBoxLetter.ReadOnly = $true
$Drive2TextBoxLetter.Size = (New-Object -TypeName System.Drawing.Size -ArgumentList @([System.Int32]19,[System.Int32]20))
$Drive2TextBoxLetter.TabIndex = [System.Int32]28
$Drive2TextBoxLetter.TabStop = $false
$Drive2TextBoxLetter.Visible = $Drive2
$Drive2TextBoxLetter.Text = $Drive2Letter

#Drive2LabelLetter
$Drive2LabelLetter = (New-Object -TypeName System.Windows.Forms.Label)
$Drive2LabelLetter.AutoSize = $true
$Drive2LabelLetter.Location = (New-Object -TypeName System.Drawing.Point -ArgumentList @([System.Int32]53,[System.Int32]154))
$Drive2LabelLetter.Name = 'Drive2LabelLetter'
$Drive2LabelLetter.Size = (New-Object -TypeName System.Drawing.Size -ArgumentList @([System.Int32]34,[System.Int32]13))
$Drive2LabelLetter.TabIndex = [System.Int32]27
$Drive2LabelLetter.Text = 'Letter'
$Drive2LabelLetter.Visible = $Drive2

#Drive2label1
$Drive2label1 = (New-Object -TypeName System.Windows.Forms.Label)
$Drive2label1.AutoSize = $true
$Drive2label1.Location = (New-Object -TypeName System.Drawing.Point -ArgumentList @([System.Int32]16,[System.Int32]154))
$Drive2label1.Name = 'Drive2label1'
$Drive2label1.Size = (New-Object -TypeName System.Drawing.Size -ArgumentList @([System.Int32]38,[System.Int32]13))
$Drive2label1.TabIndex = [System.Int32]26
$Drive2label1.Text = 'Drive2'
$Drive2label1.Visible = $Drive2

#Drive3numericUpDown
$Drive3numericUpDown = (New-Object -TypeName System.Windows.Forms.NumericUpDown)
$Drive3numericUpDown.Location = (New-Object -TypeName System.Drawing.Point -ArgumentList @([System.Int32]110,[System.Int32]226))
$Drive3numericUpDown.Name = 'Drive3numericUpDown'
$Drive3numericUpDown.Size = (New-Object -TypeName System.Drawing.Size -ArgumentList @([System.Int32]56,[System.Int32]20))
$Drive3numericUpDown.TabIndex = [System.Int32]4
$Drive3numericUpDown.Visible = $Drive3
$Drive3numericUpDown.Minimum = $Drive3Minimum

#Drive3SizeLabel
$Drive3SizeLabel = (New-Object -TypeName System.Windows.Forms.Label)
$Drive3SizeLabel.AutoSize = $true
$Drive3SizeLabel.Location = (New-Object -TypeName System.Drawing.Point -ArgumentList @([System.Int32]16,[System.Int32]228))
$Drive3SizeLabel.Name = 'Drive3SizeLabel'
$Drive3SizeLabel.Size = (New-Object -TypeName System.Drawing.Size -ArgumentList @([System.Int32]88,[System.Int32]13))
$Drive3SizeLabel.TabIndex = [System.Int32]38
$Drive3SizeLabel.Text = 'Drive 4 Size (GB)'
$Drive3SizeLabel.Visible = $Drive3

#Drive3TextBoxLabel
$Drive3TextBoxLabel = (New-Object -TypeName System.Windows.Forms.TextBox)
$Drive3TextBoxLabel.Location = (New-Object -TypeName System.Drawing.Point -ArgumentList @([System.Int32]174,[System.Int32]205))
$Drive3TextBoxLabel.Name = 'Drive3TextBoxLabel'
$Drive3TextBoxLabel.ReadOnly = $true
$Drive3TextBoxLabel.Size = (New-Object -TypeName System.Drawing.Size -ArgumentList @([System.Int32]100,[System.Int32]20))
$Drive3TextBoxLabel.TabIndex = [System.Int32]37
$Drive3TextBoxLabel.TabStop = $false
$Drive3TextBoxLabel.Visible = $Drive3
$Drive3TextBoxLabel.Text = $Drive3Name

#Drive3LabelLabel
$Drive3LabelLabel = (New-Object -TypeName System.Windows.Forms.Label)
$Drive3LabelLabel.AutoSize = $true
$Drive3LabelLabel.Location = (New-Object -TypeName System.Drawing.Point -ArgumentList @([System.Int32]112,[System.Int32]208))
$Drive3LabelLabel.Name = 'Drive3LabelLabel'
$Drive3LabelLabel.Size = (New-Object -TypeName System.Drawing.Size -ArgumentList @([System.Int32]61,[System.Int32]13))
$Drive3LabelLabel.TabIndex = [System.Int32]36
$Drive3LabelLabel.Text = 'Drive Label'
$Drive3LabelLabel.Visible = $Drive3

#Drive3TextBoxLetter
$Drive3TextBoxLetter = (New-Object -TypeName System.Windows.Forms.TextBox)
$Drive3TextBoxLetter.Location = (New-Object -TypeName System.Drawing.Point -ArgumentList @([System.Int32]87,[System.Int32]205))
$Drive3TextBoxLetter.Name = 'Drive3TextBoxLetter'
$Drive3TextBoxLetter.ReadOnly = $true
$Drive3TextBoxLetter.Size = (New-Object -TypeName System.Drawing.Size -ArgumentList @([System.Int32]19,[System.Int32]20))
$Drive3TextBoxLetter.TabIndex = [System.Int32]35
$Drive3TextBoxLetter.TabStop = $false
$Drive3TextBoxLetter.Visible = $Drive3
$Drive3TextBoxLetter.Text = $Drive3Letter

#Drive3LabelLetter
$Drive3LabelLetter = (New-Object -TypeName System.Windows.Forms.Label)
$Drive3LabelLetter.AutoSize = $true
$Drive3LabelLetter.Location = (New-Object -TypeName System.Drawing.Point -ArgumentList @([System.Int32]53,[System.Int32]208))
$Drive3LabelLetter.Name = 'Drive3LabelLetter'
$Drive3LabelLetter.Size = (New-Object -TypeName System.Drawing.Size -ArgumentList @([System.Int32]34,[System.Int32]13))
$Drive3LabelLetter.TabIndex = [System.Int32]34
$Drive3LabelLetter.Text = 'Letter'
$Drive3LabelLetter.Visible = $Drive3

#Drive3label1
$Drive3label1 = (New-Object -TypeName System.Windows.Forms.Label)
$Drive3label1.AutoSize = $true
$Drive3label1.Location = (New-Object -TypeName System.Drawing.Point -ArgumentList @([System.Int32]16,[System.Int32]208))
$Drive3label1.Name = 'Drive3label1'
$Drive3label1.Size = (New-Object -TypeName System.Drawing.Size -ArgumentList @([System.Int32]38,[System.Int32]13))
$Drive3label1.TabIndex = [System.Int32]33
$Drive3label1.Text = 'Drive3'
$Drive3label1.Visible = $Drive3

#Drive4numericUpDown
$Drive4numericUpDown = (New-Object -TypeName System.Windows.Forms.NumericUpDown)
$Drive4numericUpDown.Location = (New-Object -TypeName System.Drawing.Point -ArgumentList @([System.Int32]110,[System.Int32]281))
$Drive4numericUpDown.Name = 'Drive4numericUpDown'
$Drive4numericUpDown.Size = (New-Object -TypeName System.Drawing.Size -ArgumentList @([System.Int32]56,[System.Int32]20))
$Drive4numericUpDown.TabIndex = [System.Int32]5
$Drive4numericUpDown.Visible = $Drive4
$Drive4numericUpDown.Minimum = $Drive4Minimum

#Drive4SizeLabel
$Drive4SizeLabel = (New-Object -TypeName System.Windows.Forms.Label)
$Drive4SizeLabel.AutoSize = $true
$Drive4SizeLabel.Location = (New-Object -TypeName System.Drawing.Point -ArgumentList @([System.Int32]16,[System.Int32]283))
$Drive4SizeLabel.Name = 'Drive4SizeLabel'
$Drive4SizeLabel.Size = (New-Object -TypeName System.Drawing.Size -ArgumentList @([System.Int32]88,[System.Int32]13))
$Drive4SizeLabel.TabIndex = [System.Int32]45
$Drive4SizeLabel.Text = 'Drive 5 Size (GB)'
$Drive4SizeLabel.Visible = $Drive4

#Drive4TextBoxLabel
$Drive4TextBoxLabel = (New-Object -TypeName System.Windows.Forms.TextBox)
$Drive4TextBoxLabel.Location = (New-Object -TypeName System.Drawing.Point -ArgumentList @([System.Int32]174,[System.Int32]260))
$Drive4TextBoxLabel.Name = 'Drive4TextBoxLabel'
$Drive4TextBoxLabel.ReadOnly = $true
$Drive4TextBoxLabel.Size = (New-Object -TypeName System.Drawing.Size -ArgumentList @([System.Int32]100,[System.Int32]20))
$Drive4TextBoxLabel.TabIndex = [System.Int32]44
$Drive4TextBoxLabel.TabStop = $false
$Drive4TextBoxLabel.Text = $Drive4Name
$Drive4TextBoxLabel.Visible = $Drive4

#Drive4LabelLabel
$Drive4LabelLabel = (New-Object -TypeName System.Windows.Forms.Label)
$Drive4LabelLabel.AutoSize = $true
$Drive4LabelLabel.Location = (New-Object -TypeName System.Drawing.Point -ArgumentList @([System.Int32]112,[System.Int32]263))
$Drive4LabelLabel.Name = 'Drive4LabelLabel'
$Drive4LabelLabel.Size = (New-Object -TypeName System.Drawing.Size -ArgumentList @([System.Int32]61,[System.Int32]13))
$Drive4LabelLabel.TabIndex = [System.Int32]43
$Drive4LabelLabel.Text = 'Drive Label'
$Drive4LabelLabel.Visible = $Drive4

#Drive4TextBoxLetter
$Drive4TextBoxLetter = (New-Object -TypeName System.Windows.Forms.TextBox)
$Drive4TextBoxLetter.Location = (New-Object -TypeName System.Drawing.Point -ArgumentList @([System.Int32]87,[System.Int32]260))
$Drive4TextBoxLetter.Name = 'Drive4TextBoxLetter'
$Drive4TextBoxLetter.ReadOnly = $true
$Drive4TextBoxLetter.Size = (New-Object -TypeName System.Drawing.Size -ArgumentList @([System.Int32]19,[System.Int32]20))
$Drive4TextBoxLetter.TabIndex = [System.Int32]42
$Drive4TextBoxLetter.TabStop = $false
$Drive4TextBoxLetter.Visible = $Drive4
$Drive4TextBoxLetter.Text = $Drive4Letter

#Drive4LabelLetter
$Drive4LabelLetter = (New-Object -TypeName System.Windows.Forms.Label)
$Drive4LabelLetter.AutoSize = $true
$Drive4LabelLetter.Location = (New-Object -TypeName System.Drawing.Point -ArgumentList @([System.Int32]53,[System.Int32]263))
$Drive4LabelLetter.Name = 'Drive4LabelLetter'
$Drive4LabelLetter.Size = (New-Object -TypeName System.Drawing.Size -ArgumentList @([System.Int32]34,[System.Int32]13))
$Drive4LabelLetter.TabIndex = [System.Int32]41
$Drive4LabelLetter.Text = 'Letter'
$Drive4LabelLetter.Visible = $Drive4

#Drive4label1
$Drive4label1 = (New-Object -TypeName System.Windows.Forms.Label)
$Drive4label1.AutoSize = $true
$Drive4label1.Location = (New-Object -TypeName System.Drawing.Point -ArgumentList @([System.Int32]16,[System.Int32]263))
$Drive4label1.Name = 'Drive4label1'
$Drive4label1.Size = (New-Object -TypeName System.Drawing.Size -ArgumentList @([System.Int32]38,[System.Int32]13))
$Drive4label1.TabIndex = [System.Int32]40
$Drive4label1.Text = 'Drive4'
$Drive4label1.Visible = $Drive4

#Drive5numericUpDown
$Drive5numericUpDown = (New-Object -TypeName System.Windows.Forms.NumericUpDown)
$Drive5numericUpDown.Location = (New-Object -TypeName System.Drawing.Point -ArgumentList @([System.Int32]110,[System.Int32]338))
$Drive5numericUpDown.Name = 'Drive5numericUpDown'
$Drive5numericUpDown.Size = (New-Object -TypeName System.Drawing.Size -ArgumentList @([System.Int32]56,[System.Int32]20))
$Drive5numericUpDown.TabIndex = [System.Int32]6
$Drive5numericUpDown.Visible = $Drive5
$Drive5numericUpDown.Minimum = $Drive5Minimum

#Drive5SizeLabel
$Drive5SizeLabel = (New-Object -TypeName System.Windows.Forms.Label)
$Drive5SizeLabel.AutoSize = $true
$Drive5SizeLabel.Location = (New-Object -TypeName System.Drawing.Point -ArgumentList @([System.Int32]16,[System.Int32]340))
$Drive5SizeLabel.Name = 'Drive5SizeLabel'
$Drive5SizeLabel.Size = (New-Object -TypeName System.Drawing.Size -ArgumentList @([System.Int32]88,[System.Int32]13))
$Drive5SizeLabel.TabIndex = [System.Int32]52
$Drive5SizeLabel.Text = 'Drive 6 Size (GB)'
$Drive5SizeLabel.Visible = $Drive5

#Drive5TextBoxLabel
$Drive5TextBoxLabel = (New-Object -TypeName System.Windows.Forms.TextBox)
$Drive5TextBoxLabel.Location = (New-Object -TypeName System.Drawing.Point -ArgumentList @([System.Int32]174,[System.Int32]317))
$Drive5TextBoxLabel.Name = 'Drive5TextBoxLabel'
$Drive5TextBoxLabel.ReadOnly = $true
$Drive5TextBoxLabel.Size = (New-Object -TypeName System.Drawing.Size -ArgumentList @([System.Int32]100,[System.Int32]20))
$Drive5TextBoxLabel.TabIndex = [System.Int32]51
$Drive5TextBoxLabel.TabStop = $false
$Drive5TextBoxLabel.Visible = $Drive5
$Drive5TextBoxLabel.Text = $Drive5Name

#Drive5LabelLabel
$Drive5LabelLabel = (New-Object -TypeName System.Windows.Forms.Label)
$Drive5LabelLabel.AutoSize = $true
$Drive5LabelLabel.Location = (New-Object -TypeName System.Drawing.Point -ArgumentList @([System.Int32]112,[System.Int32]320))
$Drive5LabelLabel.Name = 'Drive5LabelLabel'
$Drive5LabelLabel.Size = (New-Object -TypeName System.Drawing.Size -ArgumentList @([System.Int32]61,[System.Int32]13))
$Drive5LabelLabel.TabIndex = [System.Int32]50
$Drive5LabelLabel.Text = 'Drive Label'
$Drive5LabelLabel.Visible = $Drive5

#Drive5TextBoxLetter
$Drive5TextBoxLetter = (New-Object -TypeName System.Windows.Forms.TextBox)
$Drive5TextBoxLetter.Location = (New-Object -TypeName System.Drawing.Point -ArgumentList @([System.Int32]87,[System.Int32]317))
$Drive5TextBoxLetter.Name = 'Drive5TextBoxLetter'
$Drive5TextBoxLetter.ReadOnly = $true
$Drive5TextBoxLetter.Size = (New-Object -TypeName System.Drawing.Size -ArgumentList @([System.Int32]19,[System.Int32]20))
$Drive5TextBoxLetter.TabIndex = [System.Int32]49
$Drive5TextBoxLetter.TabStop = $false
$Drive5TextBoxLetter.Visible = $Drive5
$Drive5TextBoxLetter.Text = $Drive5Letter

#Drive5LabelLetter
$Drive5LabelLetter = (New-Object -TypeName System.Windows.Forms.Label)
$Drive5LabelLetter.AutoSize = $true
$Drive5LabelLetter.Location = (New-Object -TypeName System.Drawing.Point -ArgumentList @([System.Int32]53,[System.Int32]320))
$Drive5LabelLetter.Name = 'Drive5LabelLetter'
$Drive5LabelLetter.Size = (New-Object -TypeName System.Drawing.Size -ArgumentList @([System.Int32]34,[System.Int32]13))
$Drive5LabelLetter.TabIndex = [System.Int32]48
$Drive5LabelLetter.Text = 'Letter'
$Drive5LabelLetter.Visible = $Drive5

#Drive5label1
$Drive5label1 = (New-Object -TypeName System.Windows.Forms.Label)
$Drive5label1.AutoSize = $true
$Drive5label1.Location = (New-Object -TypeName System.Drawing.Point -ArgumentList @([System.Int32]16,[System.Int32]320))
$Drive5label1.Name = 'Drive5label1'
$Drive5label1.Size = (New-Object -TypeName System.Drawing.Size -ArgumentList @([System.Int32]38,[System.Int32]13))
$Drive5label1.TabIndex = [System.Int32]47
$Drive5label1.Text = 'Drive5'
$Drive5label1.Visible = $Drive5

#OK Button Click
$OKbutton_Click = [System.EventHandler]{
$HardDiskForm.DialogResult = 1
$HardDiskForm.Close();
}

#OKbutton
$OKbutton = (New-Object -TypeName System.Windows.Forms.Button)
$OKbutton.Location = (New-Object -TypeName System.Drawing.Point -ArgumentList @([System.Int32]56,[System.Int32]382))
$OKbutton.Name = 'OKbutton'
$OKbutton.Size = (New-Object -TypeName System.Drawing.Size -ArgumentList @([System.Int32]75,[System.Int32]23))
$OKbutton.TabIndex = [System.Int32]7
$OKbutton.Text = 'OK'
$OKbutton.UseVisualStyleBackColor = $true
$OKbutton.add_Click($OKbutton_Click)

#Cancel Button Click
$Cancelbutton_Click = [System.EventHandler]{ 
$HardDiskForm.DialogResult = 0
$HardDiskForm.Close()
}

#Cancelbutton
$Cancelbutton = (New-Object -TypeName System.Windows.Forms.Button)
$Cancelbutton.Location = (New-Object -TypeName System.Drawing.Point -ArgumentList @([System.Int32]146,[System.Int32]382))
$Cancelbutton.Name = 'Cancelbutton'
$Cancelbutton.Size = (New-Object -TypeName System.Drawing.Size -ArgumentList @([System.Int32]75,[System.Int32]23))
$Cancelbutton.TabIndex = [System.Int32]8
$Cancelbutton.Text = 'Cancel'
$Cancelbutton.UseVisualStyleBackColor = $true
$Cancelbutton.add_Click($Cancelbutton_Click)

#DirectionsTextBox
$DirectionsTextBox = (New-Object -TypeName System.Windows.Forms.TextBox)
$DirectionsTextBox.BackColor = [System.Drawing.SystemColors]::Control
$DirectionsTextBox.BorderStyle = [System.Windows.Forms.BorderStyle]::None
$DirectionsTextBox.Font = (New-Object -TypeName System.Drawing.Font -ArgumentList @('Microsoft Sans Serif',[System.Single]9,[System.Drawing.FontStyle]::Bold,[System.Drawing.GraphicsUnit]::Point,([System.Byte][System.Byte]0)))
$DirectionsTextBox.Location = (New-Object -TypeName System.Drawing.Point -ArgumentList @([System.Int32]19,[System.Int32]6))
$DirectionsTextBox.Multiline = $true
$DirectionsTextBox.Name = 'DirectionsTextBox'
$DirectionsTextBox.ReadOnly = $true
$DirectionsTextBox.Size = (New-Object -TypeName System.Drawing.Size -ArgumentList @([System.Int32]253,[System.Int32]34))
$DirectionsTextBox.TabIndex = [System.Int32]53
$DirectionsTextBox.TabStop = $false
$DirectionsTextBox.Text = 'Please Select Drive Size based on the VM Type you selected in the MainForm'
$DirectionsTextBox.add_TextChanged($textBox1_TextChanged)

$HardDiskForm.Controls.Add($DirectionsTextBox)
$HardDiskForm.Controls.Add($Cancelbutton)
$HardDiskForm.Controls.Add($OKbutton)
$HardDiskForm.Controls.Add($Drive5numericUpDown)
$HardDiskForm.Controls.Add($Drive5SizeLabel)
$HardDiskForm.Controls.Add($Drive5TextBoxLabel)
$HardDiskForm.Controls.Add($Drive5LabelLabel)
$HardDiskForm.Controls.Add($Drive5TextBoxLetter)
$HardDiskForm.Controls.Add($Drive5LabelLetter)
$HardDiskForm.Controls.Add($Drive5label1)
$HardDiskForm.Controls.Add($Drive4numericUpDown)
$HardDiskForm.Controls.Add($Drive4SizeLabel)
$HardDiskForm.Controls.Add($Drive4TextBoxLabel)
$HardDiskForm.Controls.Add($Drive4LabelLabel)
$HardDiskForm.Controls.Add($Drive4TextBoxLetter)
$HardDiskForm.Controls.Add($Drive4LabelLetter)
$HardDiskForm.Controls.Add($Drive4label1)
$HardDiskForm.Controls.Add($Drive3numericUpDown)
$HardDiskForm.Controls.Add($Drive3SizeLabel)
$HardDiskForm.Controls.Add($Drive3TextBoxLabel)
$HardDiskForm.Controls.Add($Drive3LabelLabel)
$HardDiskForm.Controls.Add($Drive3TextBoxLetter)
$HardDiskForm.Controls.Add($Drive3LabelLetter)
$HardDiskForm.Controls.Add($Drive3label1)
$HardDiskForm.Controls.Add($Drive2numericUpDown)
$HardDiskForm.Controls.Add($Drive2SizeLabel)
$HardDiskForm.Controls.Add($Drive2TextBoxLabel)
$HardDiskForm.Controls.Add($Drive2LabelLabel)
$HardDiskForm.Controls.Add($Drive2TextBoxLetter)
$HardDiskForm.Controls.Add($Drive2LabelLetter)
$HardDiskForm.Controls.Add($Drive2label1)
$HardDiskForm.Controls.Add($Drive1numericUpDown)
$HardDiskForm.Controls.Add($Drive1SizeLabel)
$HardDiskForm.Controls.Add($Drive1TextBoxLabel)
$HardDiskForm.Controls.Add($Drive1LabelLabel)
$HardDiskForm.Controls.Add($Drive1TextBoxLetter)
$HardDiskForm.Controls.Add($Drive1LabelLetter)
$HardDiskForm.Controls.Add($Drive1label1)
$HardDiskForm.Controls.Add($Drive0numericUpDown)
$HardDiskForm.Controls.Add($Drive0SizeLabel)
$HardDiskForm.Controls.Add($Drive0TextBoxLabel)
$HardDiskForm.Controls.Add($Drive0LabelLabel)
$HardDiskForm.Controls.Add($Drive0TextBoxLetter)
$HardDiskForm.Controls.Add($Drive0LabelLetter)
$HardDiskForm.Controls.Add($Drive0label1)
$ret = $HardDiskForm.ShowDialog()

#################return values
$OUTPUT = "" | Select-Object -Property Cancel,Drive0Size,Drive1Size,Drive2Size,Drive3Size,Drive4Size,Drive5Size
$OUTPUT.CANCEL = $HardDiskForm.DialogResult
$OUTPUT.Drive0Size = $Drive0numericUpDown.Value
$OUTPUT.Drive1Size = $Drive1numericUpDown.Value
$OUTPUT.Drive2Size = $Drive2numericUpDown.Value
$OUTPUT.Drive3Size = $Drive3numericUpDown.Value
$OUTPUT.Drive4Size = $Drive4numericUpDown.Value
$OUTPUT.Drive5Size = $Drive5numericUpDown.Value

RETURN $OUTPUT
}

Function Stop-ScriptNow($StopReason)
{
	<#  
	 .SYNOPSIS  
	 Call this Function to stop script  
	 .DESCRIPTION  
	 This function stops script and presents user with press any key to end session
	 .NOTES   
	 Author: Russell Hamker  
	 Twitter: @butch7903 
	 .PARAMETER $StopReason  
	 Example is "This was caused by x Issue" 
	 .EXAMPLE  
	  PS> Stop-ScriptNow "Something happened"
	 #>
	Write-Host $StopReason -foregroundcolor "red"
	Write-Host "Stop Script Called" -foregroundcolor "red"
	Write-Host "Disconnecting from VI Server" -foregroundcolor "red"
	disconnect-viserver * -confirm:$false
	Write-Host "Disconnecting from NSX Server" -foregroundcolor "red"
	disconnect-nsxserver * -confirm:$false
	Write-Host "Press any key to end session ..." -foregroundcolor "green"
	[System.Reflection.Assembly]::LoadWithPartialName("Microsoft.VisualBasic") | Out-Null
	[Microsoft.VisualBasic.Interaction]::MsgBox("$StopReason. Press OK to End Session.", "OKOnly,SystemModal,Exclamation", "Warning")
	Stop-transcript	
	Break
}

$SERVERBUILDER = $env:UserDomain + "\" + $env:UserName

############################################################Start of Scritp#########################################################

##Starting Logging
Start-Transcript -path $LOGFILE -Append
Write-Host "-----------------------------------------------------------------------------------------------------------------------"
Write-Host (Get-Date -format "MMM-dd-yyyy_HH-mm-ss")
Write-Host "Script Logging Started"
Write-Host (Get-Date -format "MMM-dd-yyyy_HH-mm-ss")
Write-Host "-----------------------------------------------------------------------------------------------------------------------"

##List Settings
#Being stated 2nd time after Transcript has started to document info
Write-Host "-----------------------------------------------------------------------------------------------------------------------"
Write-Host (Get-Date -format "MMM-dd-yyyy_HH-mm-ss")
Write-Host "Settings will be: "
Write-Host "Version specified in file is: 		"$VERSION
Write-Host "SubVersion specified in file is: 	"$SUBVERSION
Write-Host "vCenter specified in file is: 		"$VCENTER
Write-Host "NSX Manager specified in file is: 	"$NSXMANAGER
Write-Host "SMTP Server will be: 			"$SMTPSERVER
Write-Host "SMTP Server Port will be: 		"$SMTPPORT
Write-Host "SMTP Server SSL will  be: 		"$SMTPENABLESSL
Write-Host "Emails will be sent from: 		"$MSGFROM
Write-Host "Emails will be sent to: 		"$MSGTO
Write-Host "VM SysPrep Timeout will be: 		"$VMSYSPREPTIMEOUT
Write-Host (Get-Date -format "MMM-dd-yyyy_HH-mm-ss")
Write-Host "-----------------------------------------------------------------------------------------------------------------------"

##Disconnect from any open vCenter Sessions,
#This can cause problems if there are any
Write-Host "-----------------------------------------------------------------------------------------------------------------------"
Write-Host (Get-Date -format "MMM-dd-yyyy_HH-mm-ss")
Write-Host "Disconnecting from any Open vCenter Sessions"
TRY
{Disconnect-VIServer * -Confirm:$false}
CATCH
{Write-Host "No Open vCenter Sessions found"}
Write-Host "Disconnecting from any Open NSX Manager Sessions"
if($DefaultNSXConnection.Server)
{
	Disconnect-NSXServer * -Confirm:$false
}
ELSE{
	Write-Host "No Open NSX Server Sessions found"
}
Write-Host (Get-Date -format "MMM-dd-yyyy_HH-mm-ss")
Write-Host "-----------------------------------------------------------------------------------------------------------------------"

##Connect to vCenter Server
Write-Host "-----------------------------------------------------------------------------------------------------------------------"
Write-Host (Get-Date -format "MMM-dd-yyyy_HH-mm-ss")
Write-Host "Connecting to vCenter "$vCenter
$VISERVER = Connect-VIServer -server $vCenter -Credential $MyCredential
Write-Host "Connected to vCenter "
IF ($NSXMANAGER)
{
Write-Host "Connecting to NSX Manager "$NSXMANAGER
$NSXSERVER = Connect-NSXServer -vCenterServer $vCenter -Credential $MyCredential
Write-Host "Connecting to NSX Manager"$NSXMANAGER" Completed"
}


Write-Host (Get-Date -format "MMM-dd-yyyy_HH-mm-ss")
Write-Host "-----------------------------------------------------------------------------------------------------------------------"

##Set Default Variable Settings
Write-Host "-----------------------------------------------------------------------------------------------------------------------"
Write-Host (Get-Date -format "MMM-dd-yyyy_HH-mm-ss")
Write-Host "Setting Default Variables for MainForm"
$VMNAME = "" #Setting Default
$VCPUS = 1 #Setting Default
$RAM = 4 #Setting Default
$TEMPLATE = "" #Setting Default
$DEV = "Unchecked" #Setting Default
$DMZ = "Unchecked" #Setting Default
$PCI = "Unchecked" #Setting Default
$VMREPLACE = "Unchecked" #Setting Default
$VMNAMEREPLACE = "" #Setting Default
$SITE = "Production" #Setting Default
$DATACENTER = "" ####Set this to "" otherwise form will not work correctly
$CLUSTER = "" ####Set this to "" otherwise form will not work correctly
$VMHOSTSELECTED = "1", "2" ####Set this to "1", "2" otherwise form will not work correctly
$PORTGROUP = "" ####Set this to "" otherwise form will not work correctly
$DATASTORE = "" ####Set this to "" otherwise form will not work correctly
$OSCUSTOMIZATION = "" ####Set this to "" otherwise form will not work correctly
$VMTYPE = "" ####Set this to "" otherwise form will not work correctly
$VMFOLDER = "" ####Set this to "" otherwise form will not work correctly
$NOTES = ""
$OWNERS = ""
$OVERRIDEDHCP = "Unchecked" #Setting Default
$IP = ""
$SUBNET = ""
$DG = ""
$DNS1 = ""
$DNS2 = ""
$NSXDEFAULTTAGS = 'New-Servers' #Case Sensitive
Write-Host "Setting Default Variables for MainForm Completed"
Write-Host (Get-Date -format "MMM-dd-yyyy_HH-mm-ss")
Write-Host "-----------------------------------------------------------------------------------------------------------------------"

##Call MainForm
Write-Host "-----------------------------------------------------------------------------------------------------------------------"
Write-Host (Get-Date -format "MMM-dd-yyyy_HH-mm-ss")
Write-Host "Calling MainForm and Allowing User to Set Variables"
$A = MainForm
Write-Host "Calling MainForm and Allowing User to Set Variables Completed"
Write-Host (Get-Date -format "MMM-dd-yyyy_HH-mm-ss")
Write-Host "-----------------------------------------------------------------------------------------------------------------------"

##Checking if Cancel was Called
Write-Host "-----------------------------------------------------------------------------------------------------------------------"
Write-Host (Get-Date -format "MMM-dd-yyyy_HH-mm-ss")
Write-Host "Checking to see if Cancel Was Hit"
$CANCEL = $A.CANCEL
#Check If Cancel Button was hit
IF($CANCEL -eq "CANCEL")
{
	Stop-ScriptNow "Cancel Button was hit"
}
Write-Host "Cancel Was Not Hit"
Write-Host (Get-Date -format "MMM-dd-yyyy_HH-mm-ss")
Write-Host "-----------------------------------------------------------------------------------------------------------------------"

##Convert Output to variables for verification
Write-Host "-----------------------------------------------------------------------------------------------------------------------"
Write-Host (Get-Date -format "MMM-dd-yyyy_HH-mm-ss")
Write-Host "Converting Variables from MainForm Output to Proper Formatting"
$VMNAME = $A.VMNAME
$VCPUS = $A.VCPUS
$RAM = $A.RAM
$TEMPLATE = $A.Template
$DEV = $A.DEV
$DMZ = $A.DMZ
$PCI = $A.PCI
$VMREPLACE = $A.VMREPLACE
$VMNAMEREPLACE = $A.VMNAMEREPLACE
$SITE = $A.Site
$DATACENTER = $A.Datacenter
$CLUSTER = $A.Cluster
$VMHOSTSELECTED = $A.VMHost
$PORTGROUP = $A.PORTGROUP
$DATASTORE = $A.Datastore
$OSCUSTOMIZATION = Get-OSCustomizationSpec $A.OSCUSTOMIZATION -ErrorAction SilentlyContinue
$VMTYPE = $A.VMTYPE
$VMFOLDER = $A.VMFOLDER
$NOTES = $A.NOTES
$OWNERS = $A.OWNER
$APPLIST = $A.APPLIST
$OVERRIDEDHCP = $A.OverRideDHCP
$IP = $A.IP
$SUBNET = $A.Subnet
$DG = $A.DG
$DNS1 = $A.DNS1
$DNS2 = $A.DNS2
$VMTAGS = $A.VMTAGS
$NSXTAGS = $A.NSXTAGS
Write-Host "Converting Variables from MainForm Output to Proper Formatting Completed"
Write-Host (Get-Date -format "MMM-dd-yyyy_HH-mm-ss")
Write-Host "-----------------------------------------------------------------------------------------------------------------------"

##Verifying User MainForm Inputs and Create AD Credential
#Verify OS Customization First
#Note: Must be first verifcation to correctly get Domain For VM Name Checking
Write-Host "-----------------------------------------------------------------------------------------------------------------------"
Write-Host (Get-Date -format "MMM-dd-yyyy_HH-mm-ss")
Write-Host "Verifying User MainForm Inputs and Create AD Credential"
WHILE($OSCUSTOMIZATION -eq "")
{
	Write-Warning "OS Customization Field Empty"
	Write-Host "Please select OS Customization" -foregroundcolor "green"
	Write-Host "Please re-input VM Tags if used" -foregroundcolor "green"
	IF($DefaultNSXConnection.Server){
		Write-Host "Please re-input NSX Tags if used" -foregroundcolor "green"
	}
	$A = MainForm
	$OSCUSTOMIZATION = $A.OSCUSTOMIZATION
	$CANCEL = $A.CANCEL
	IF($CANCEL -eq "CANCEL")
	{
		Stop-ScriptNow "Cancel Button was hit"
	}
}
##Assign Domain Credentials for AD and WinRM Usage
##Create Secure User Account file
#Specify Creds Login info
$DOMAIN = Get-OSCustomizationSpec $OSCUSTOMIZATION.Domain -ErrorAction SilentlyContinue
$DomainUserFile = $pwd.path+"\"+$DOMAIN+"_Creds.xml"
If (Test-Path $DomainUserFile){
	Write-Host "Domain Credentials Login file found"
	Write-Host "Continuing..."
	$ImportDomainObject = Import-Clixml $DomainUserFile
	$SecureStringDomain = ConvertTo-SecureString -String $ImportDomainObject.Password -Key $Key
	$MYDOMAINCREDENTIAL = New-Object System.Management.Automation.PSCredential($ImportDomainObject.UserName, $SecureStringDomain)
	$MYDOMAINUSERNAME = $MYDOMAINCREDENTIAL.UserName
	$MYDOMAINSECUREPASSWORD = $MYDOMAINCREDENTIAL.Password
	$MYDOMAINUNSECUREPASSWORD = (New-Object PSCredential "user",$MYDOMAINSECUREPASSWORD).GetNetworkCredential().Password
	Write-Host "Using Domain User "$MyDomainCredential.UserName" for Windows Domain "$DOMAIN" Management"
}
Else {
	$DomainPScreds = Get-Credential -message ("Enter the " + $DOMAIN + " Domain Credentials needed for AD and WinRM here:")
	$exportObjectDomain = New-Object psobject -Property @{
		UserName = $DomainPScreds.UserName
		Password = ConvertFrom-SecureString -SecureString $DomainPScreds.Password -Key $Key
	}
	$exportObjectDomain | Export-Clixml $DomainUserFile
	$MYDOMAINCREDENTIAL = $DomainPScreds
	$MYDOMAINUSERNAME = $MYDOMAINCREDENTIAL.UserName
	$MYDOMAINSECUREPASSWORD = $MYDOMAINCREDENTIAL.Password
	$MYDOMAINUNSECUREPASSWORD = (New-Object PSCredential "user",$MYDOMAINSECUREPASSWORD).GetNetworkCredential().Password
	Write-Host "Using Domain User "$MyDomainCredential.UserName" for Windows Domain "$DOMAIN" Management"
}
#Verify VM Name is not Empty
WHILE($VMNAME -match "\W+" )
{
	Write-Warning "VM Name DOES NOT use the proper Windows OS Naming Convention"
	Write-Host "Please update VM Name" -foregroundcolor "green"
	Write-Host "Please re-input VM Tags if used" -foregroundcolor "green"
	IF($DefaultNSXConnection.Server){
		Write-Host "Please re-input NSX Tags if used" -foregroundcolor "green"
	}
	$VMNAME = ""
	$A = MainForm
	$VMNAME = $A.VMNAME
	$CANCEL = $A.CANCEL
	IF($CANCEL -eq "CANCEL")
	{
		Stop-ScriptNow "Cancel Button was hit"
	}
}
#Verify that VM Name is not already in use in vCenter
TRY
{ $TESTVMNAME = Get-VM $VMNAME -ErrorAction SilentlyContinue }
CATCH
{ Write-Host "VM Name Not Found in vCenter, continueing..."}
WHILE($TESTVMNAME)
{
	Write-Warning "VM Name is already in use"
	Write-Host "Please choose different VM Name" -foregroundcolor "green"
	Write-Host "Please re-input VM Tags if used" -foregroundcolor "green"
	IF($DefaultNSXConnection.Server){
		Write-Host "Please re-input NSX Tags if used" -foregroundcolor "green"
	}
	$VMNAME = ""
	$A = MainForm
	$VMNAME = $A.VMNAME
	$CANCEL = $A.CANCEL
	IF($CANCEL -eq "CANCEL")
	{
		Stop-ScriptNow "Cancel Button was hit"
	}
	$TESTVMNAME = Get-VM $VMNAME
}
#Verify that the VM Name does not exist in Active Directory Already
$STRINGDOMAIN = [string]$DOMAIN
$FQDN = $VMNAME + "." + $STRINGDOMAIN
$ADCONTROLLER = Get-ADDomainController -Discover -Domain $STRINGDOMAIN
$ADCONTROLLERHN = $ADCONTROLLER.HostName
$ADCONTROLLERHN = $ADCONTROLLERHN.TRIMEND(" ")
$ADDOMAIN = Get-ADDomain $STRINGDOMAIN -Credential $MYDOMAINCREDENTIAL
TRY
{ $ADOBJECTTEST = Get-ADComputer $VMNAME -Credential $MYDOMAINCREDENTIAL -Server $ADCONTROLLERHN }
CATCH
{ Write-Host "VM Name "$VMNAME" is not in use in Active Directory, continueing..." }
WHILE($ADOBJECTTEST)
{
	Write-Warning "VM Name already in use in Active Directory"
	Write-Host "Please choose different VM Name" -foregroundcolor "green"
	Write-Host "Please re-input VM Tags if used" -foregroundcolor "green"
	Write-Host "Please re-input NSX Tags if used" -foregroundcolor "green"
	$VMNAME = ""
	$A = MainForm
	$VMNAME = $A.VMNAME
	$STRINGDOMAIN = [string]$DOMAIN
	$FQDN = $VMNAME + "." + $STRINGDOMAIN
	$ADCONTROLLER = Get-ADDomainController -Discover -Domain $STRINGDOMAIN
	$ADCONTROLLERHN = $ADCONTROLLER.HostName
	$ADCONTROLLERHN = $ADCONTROLLERHN.TRIMEND(" ")
	TRY
	{ $ADOBJECTTEST = Get-ADComputer $VMNAME -Credential $MYDOMAINCREDENTIAL -Server $ADCONTROLLERHN }
	CATCH
	{ 
		$ADOBJECTTEST = $null
		Write-Host "VM Name Active Directory Computer Object does not exist, continueing..."
	}
}
#Verify vCPUs is not 0
WHILE($VCPUS -eq 0)
{
	Write-Warning "VM VCPU Count Too Low"
	Write-Host "Please update VM VCPUs to minimum of 1" -foregroundcolor "green"
	Write-Host "Please re-input VM Tags if used" -foregroundcolor "green"
	IF($DefaultNSXConnection.Server){
		Write-Host "Please re-input NSX Tags if used" -foregroundcolor "green"
	}
	$A = MainForm
	$VCPUS = $A.VCPUS
	$CANCEL = $A.CANCEL
	IF($CANCEL -eq "CANCEL")
	{
		Stop-ScriptNow "Cancel Button was hit"
	}
}
#Verify RAM is not below minimum
WHILE($RAM -lt 4)
{
	Write-Warning "VM RAM Count Too Low"
	Write-Host "Please update VM RAM amount to minimum of 4" -foregroundcolor "green"
	Write-Host "Please re-input VM Tags if used" -foregroundcolor "green"
	IF($DefaultNSXConnection.Server){
		Write-Host "Please re-input NSX Tags if used" -foregroundcolor "green"
	}
	$A = MainForm
	$RAM = $A.RAM
	$CANCEL = $A.CANCEL
	IF($CANCEL -eq "CANCEL")
	{
		Stop-ScriptNow "Cancel Button was hit"
	}
}
#Verify Template is not Empty
WHILE($TEMPLATE -eq "")
{
	Write-Warning "VM Template Field Empty"
	Write-Host "Please input VM Template" -foregroundcolor "green"
	Write-Host "Please re-input VM Tags if used" -foregroundcolor "green"
	IF($DefaultNSXConnection.Server){
		Write-Host "Please re-input NSX Tags if used" -foregroundcolor "green"
	}
	$A = MainForm
	$TEMPLATE = $A.Template
	$CANCEL = $A.CANCEL
	IF($CANCEL -eq "CANCEL")
	{
		Stop-ScriptNow "Cancel Button was hit"
	}
}
#Verify VM Replacement Name if VM Replacement Check box CheckedItems
IF($VMREPLACE -eq "Checked")
{
	WHILE($VMNAMEREPLACE -eq "")
	{
		Write-Warning "VM Replacement Name Field Empty"
		Write-Host "Please input VM Replacement Name" -foregroundcolor "green"
		Write-Host "Please re-input VM Tags if used" -foregroundcolor "green"
		IF($DefaultNSXConnection.Server){
			Write-Host "Please re-input NSX Tags if used" -foregroundcolor "green"
		}
		$A = MainForm
		$VMNAMEREPLACE = $A.VMNAMEREPLACE
		$CANCEL = $A.CANCEL
		IF($CANCEL -eq "CANCEL")
		{
			Stop-ScriptNow "Cancel Button was hit"
		}
	}
	#Verify that VM Replacement Exists
	$TESTVMNAMEREPLACE = Get-VM $A.VMNAMEREPLACE
	WHILE(!$TESTVMNAMEREPLACE)
	{
		Write-Warning "VM Replacement Name Does Not Exist"
		Write-Host "Please input Corrected VM Replacement Name" -foregroundcolor "green"
		Write-Host "Please re-input VM Tags if used" -foregroundcolor "green"
		IF($DefaultNSXConnection.Server){
			Write-Host "Please re-input NSX Tags if used" -foregroundcolor "green"
		}
		$A = MainForm
		$VMNAMEREPLACE = $A.VMNAMEREPLACE
		$CANCEL = $A.CANCEL
		IF($CANCEL -eq "CANCEL")
		{
			Stop-ScriptNow "Cancel Button was hit"
		}
		$TESTVMNAMEREPLACE = Get-VM $A.VMNAMEREPLACE
	}
}
#Verify Site is not Empty
WHILE($SITE -eq "")
{
	Write-Warning "VM Site Field Empty"
	Write-Host "Please input VM Site" -foregroundcolor "green"
	Write-Host "Please re-input VM Tags if used" -foregroundcolor "green"
	IF($DefaultNSXConnection.Server){
		Write-Host "Please re-input NSX Tags if used" -foregroundcolor "green"
	}
	$A = MainForm
	$SITE = $A.SITE
	$CANCEL = $A.CANCEL
	IF($CANCEL -eq "CANCEL")
	{
		Stop-ScriptNow "Cancel Button was hit"
	}
}
#Verify Datacenter is not Empty
WHILE($DATACENTER -eq "")
{
	Write-Warning "VM Datacenter Field Empty"
	Write-Host "Please input VM Datacenter" -foregroundcolor "green"
	Write-Host "Please re-input VM Tags if used" -foregroundcolor "green"
	IF($DefaultNSXConnection.Server){
		Write-Host "Please re-input NSX Tags if used" -foregroundcolor "green"
	}
	$A = MainForm
	$DATACENTER = $A.Datacenter
	$CANCEL = $A.CANCEL
	IF($CANCEL -eq "CANCEL")
	{
		Stop-ScriptNow "Cancel Button was hit"
	}
}
#Verify Cluster Selected is not Empty
WHILE($CLUSTER -eq "")
{
	Write-Warning "Cluster Selected Field Empty"
	Write-Host "Please select Cluster" -foregroundcolor "green"
	Write-Host "Please re-input VM Tags if used" -foregroundcolor "green"
	IF($DefaultNSXConnection.Server){
		Write-Host "Please re-input NSX Tags if used" -foregroundcolor "green"
	}
	$A = MainForm
	$CLUSTER = $A.Cluster
	$CANCEL = $A.CANCEL
	IF($CANCEL -eq "CANCEL")
	{
		Stop-ScriptNow "Cancel Button was hit"
	}
}
#Verify VM Host Selected is not Empty
WHILE($VMHOSTSELECTED -eq "")
{
	Write-Warning "VMHost Selected Field Empty"
	Write-Host "Please select VMHost" -foregroundcolor "green"
	Write-Host "Please re-input VM Tags if used" -foregroundcolor "green"
	IF($DefaultNSXConnection.Server){
		Write-Host "Please re-input NSX Tags if used" -foregroundcolor "green"
	}
	$A = MainForm
	$VMHOSTSELECTED = $A.VMHOST
	$CANCEL = $A.CANCEL
	IF($CANCEL -eq "CANCEL")
	{
		Stop-ScriptNow "Cancel Button was hit"
	}
}
#Verify Port Group is not Empty
WHILE($PORTGROUP -eq "")
{
	Write-Warning "Host Port Group Field Empty"
	Write-Host "Please select Host Port Group" -foregroundcolor "green"
	Write-Host "Please re-input VM Tags if used" -foregroundcolor "green"
	IF($DefaultNSXConnection.Server){
		Write-Host "Please re-input NSX Tags if used" -foregroundcolor "green"
	}
	$A = MainForm
	$PORTGROUP = $A.PortGroup
	$CANCEL = $A.CANCEL
	IF($CANCEL -eq "CANCEL")
	{
		Stop-ScriptNow "Cancel Button was hit"
	}
}
#Verify Datastore is not Empty
WHILE($DATASTORE -eq "")
{
	Write-Warning "Datastore Field Empty"
	Write-Host "Please select Datastore" -foregroundcolor "green"
	Write-Host "Please re-input VM Tags if used" -foregroundcolor "green"
	IF($DefaultNSXConnection.Server){
		Write-Host "Please re-input NSX Tags if used" -foregroundcolor "green"
	}
	$A = MainForm
	$DATASTORE = $A.Datastore
	$CANCEL = $A.CANCEL
	IF($CANCEL -eq "CANCEL")
	{
		Stop-ScriptNow "Cancel Button was hit"
	}
}
#Verify VMTYPE is not Empty
WHILE($VMTYPE -eq "")
{
	Write-Warning "VM Type Field Selection Empty"
	Write-Host "Please select VM Type" -foregroundcolor "green"
	Write-Host "Please re-input VM Tags if used" -foregroundcolor "green"
	IF($DefaultNSXConnection.Server){
		Write-Host "Please re-input NSX Tags if used" -foregroundcolor "green"
	}
	$A = MainForm
	$VMTYPE = $A.VMTYPE
	$CANCEL = $A.CANCEL
	IF($CANCEL -eq "CANCEL")
	{
		Stop-ScriptNow "Cancel Button was hit"
	}
}
#Verify VM Folder is not Empty
WHILE($VMFOLDER -eq "")
{
	Write-Warning "VM Folder Field Selection Empty"
	Write-Host "Please select VM Folder" -foregroundcolor "green"
	Write-Host "Please re-input VM Tags if used" -foregroundcolor "green"
	Write-Host "Please re-input NSX Tags if used" -foregroundcolor "green"
	$A = MainForm
	$VMFOLDER = $A.VMFOLDER
	$CANCEL = $A.CANCEL
	IF($CANCEL -eq "CANCEL")
	{
		Stop-ScriptNow "Cancel Button was hit"
	}
}
#Verify Notes is not Empty
WHILE($NOTES -eq "")
{
	Write-Warning "VM Notes Field Empty"
	Write-Host "Please input VM Notes" -foregroundcolor "green"
	Write-Host "Please re-input VM Tags if used" -foregroundcolor "green"
	Write-Host "Please re-input NSX Tags if used" -foregroundcolor "green"
	$A = MainForm
	$NOTES = $A.NOTES
	$CANCEL = $A.CANCEL
	IF($CANCEL -eq "CANCEL")
	{
		Stop-ScriptNow "Cancel Button was hit"
	}
}
#Verify Owners is not Empty
WHILE($OWNERS -eq "")
{
	Write-Warning "VM Owners Field Empty"
	Write-Host "Please input VM Owners" -foregroundcolor "green"
	Write-Host "Please re-input VM Tags if used" -foregroundcolor "green"
	Write-Host "Please re-input NSX Tags if used" -foregroundcolor "green"
	$A = MainForm
	$OWNERS = $A.OWNERS
	$CANCEL = $A.CANCEL
	IF($CANCEL -eq "CANCEL")
	{
		Stop-ScriptNow "Cancel Button was hit"
	}
}
##Verify Static IP Formatting is correctly filled out and in the proper IPv4 Formatting
#NOTE: IF you have VMs that dont have Default Gateways, comment out check for Verifying $DG
IF($OVERRIDEDHCP -eq "Checked")
{
	#Set RegEx to Verify IPv4 Address Formatting
	$IPREGEX = "([1-9]|[1-9][0-9]|1[0-9][0-9]|2[0-4][0-9]|25[0-5])(\.([0-9]|[1-9][0-9]|1[0-9][0-9]|2[0-4][0-9]|25[0-5])){3}$"
	WHILE($IP -eq "")
	{
		Write-Warning "VM IP Field Empty"
		Write-Host "Please input VM IP" -foregroundcolor "green"
		Write-Host "Please re-input VM Tags if used" -foregroundcolor "green"
		Write-Host "Please re-input NSX Tags if used" -foregroundcolor "green"
		$A = MainForm
		$IP = $A.IP
		$CANCEL = $A.CANCEL
		IF($CANCEL -eq "CANCEL")
		{
			Stop-ScriptNow "Cancel Button was hit"
		}
	}
	WHILE($IP -notmatch $IPREGEX)
	{
		Write-Host "IP is "$IP
		Write-Warning "VM IP is an Invalid format"
		Write-Host "Please input VM IP" -foregroundcolor "green"
		Write-Host "Please re-input VM Tags if used" -foregroundcolor "green"
		Write-Host "Please re-input NSX Tags if used" -foregroundcolor "green"
		$A = MainForm
		$IP = $A.IP
		$CANCEL = $A.CANCEL
		IF($CANCEL -eq "CANCEL")
		{
			Stop-ScriptNow "Cancel Button was hit"
		}
	}
	WHILE($SUBNET -eq "")
	{
		Write-Warning "VM Subnet IP Field Empty"
		Write-Host "Please input VM  Subnet IP" -foregroundcolor "green"
		Write-Host "Please re-input VM Tags if used" -foregroundcolor "green"
		Write-Host "Please re-input NSX Tags if used" -foregroundcolor "green"
		$A = MainForm
		$SUBNET = $A.SUBNET
		$CANCEL = $A.CANCEL
		IF($CANCEL -eq "CANCEL")
		{
			Stop-ScriptNow "Cancel Button was hit"
		}
	}
	WHILE($SUBNET -notmatch $IPREGEX)
	{
		Write-Warning "VM IP is an Invalid format"
		Write-Host "Please input VM IP" -foregroundcolor "green"
		Write-Host "Please re-input VM Tags if used" -foregroundcolor "green"
		Write-Host "Please re-input NSX Tags if used" -foregroundcolor "green"
		$A = MainForm
		$SUBNET = $A.SUBNET
		$CANCEL = $A.CANCEL
		IF($CANCEL -eq "CANCEL")
		{
			Stop-ScriptNow "Cancel Button was hit"
		}
	}
	#Comment out starting here if you have VMs that will not have Default Gateways
	WHILE($DG -eq "")
	{
		Write-Warning "VM Default Gateway IP Field Empty"
		Write-Host "Please input VM Default Gateway IP" -foregroundcolor "green"
		Write-Host "Please re-input VM Tags if used" -foregroundcolor "green"
		Write-Host "Please re-input NSX Tags if used" -foregroundcolor "green"
		$A = MainForm
		$DG = $A.DG
		$CANCEL = $A.CANCEL
		IF($CANCEL -eq "CANCEL")
		{
			Stop-ScriptNow "Cancel Button was hit"
		}
	}
	WHILE($DG -notmatch $IPREGEX)
	{
		Write-Warning "VM Default Gateway IP is an Invalid format"
		Write-Host "Please input VM Default Gateway IP" -foregroundcolor "green"
		Write-Host "Please re-input VM Tags if used" -foregroundcolor "green"
		Write-Host "Please re-input NSX Tags if used" -foregroundcolor "green"
		$A = MainForm
		$DG = $A.DG
		$CANCEL = $A.CANCEL
		IF($CANCEL -eq "CANCEL")
		{
			Stop-ScriptNow "Cancel Button was hit"
		}
	}
	IF($DNS1)
	{
		WHILE($DNS1 -notmatch $IPREGEX)
		{
			Write-Warning "VM DNS1 IP is an Invalid format"
			Write-Host "Please input VM DNS1 IP" -foregroundcolor "green"
			Write-Host "Please re-input VM Tags if used" -foregroundcolor "green"
			Write-Host "Please re-input NSX Tags if used" -foregroundcolor "green"
			$A = MainForm
			$DNS1 = $A.DNS1
			$CANCEL = $A.CANCEL
			IF($CANCEL -eq "CANCEL")
			{
				Stop-ScriptNow "Cancel Button was hit"
			}
		}
	}
	IF($DNS2)
	{
		WHILE($DNS2 -notmatch $IPREGEX)
		{
			Write-Warning "VM DNS2 IP is an Invalid format"
			Write-Host "Please input VM DNS2 IP" -foregroundcolor "green"
			Write-Host "Please re-input VM Tags if used" -foregroundcolor "green"
			Write-Host "Please re-input NSX Tags if used" -foregroundcolor "green"
			$A = MainForm
			$DNS2 = $A.DNS2
			$CANCEL = $A.CANCEL
			IF($CANCEL -eq "CANCEL")
			{
				Stop-ScriptNow "Cancel Button was hit"
			}
		}
	}
}
#If App to be installed is MS SQL 2016, create SQL Service Password to auto-generate service account with
IF($A.APPLIST -match "MS SQL 2016")
{
	## SQL Service Account Password Generation
	$SQLCreds = $pwd.path+"\"+"SQL_Creds.xml"
	If (Test-Path $SQLCreds){
		Write-Host "SQL_Creds.xml file found"
		Write-Host "Continuing..."
		#Import SQL Creds
		$SQLImportObject = Import-Clixml $SQLCreds
		#Decrypt Password
		$SQLSecureStringDomain = ConvertTo-SecureString -String $SQLImportObject.Password -Key $Key
		$SQLCREDENTIAL = New-Object System.Management.Automation.PSCredential($SQLImportObject.UserName, $SQLSecureStringDomain)
		$SQLSECUREPASSWORD = $SQLCREDENTIAL.Password
		#Convert Password to Clear Text
		$SQLUNSECUREPASSWORD = (New-Object PSCredential "user",$SQLSECUREPASSWORD).GetNetworkCredential().Password
	}Else{
		$Key = Get-Content $KeyFile
		$SQLCREDENTIAL = Get-Credential -message "Enter SQL Service Account Password (AD Account is Auto Generated for SQL based on SQL Server Name:" -username "LEAVE TEXT HERE"
		$exportObject = New-Object psobject -Property @{
			UserName = $SQLCREDENTIAL.UserName
			Password = ConvertFrom-SecureString -SecureString $SQLCREDENTIAL.Password -Key $Key
		}
		#Export to XML
		$exportObject | Export-Clixml $SQLCreds
		$SQLSECUREPASSWORD = $SQLCREDENTIAL.Password
		#Convert Password to Plain Text
		$SQLUNSECUREPASSWORD = (New-Object PSCredential "user",$SQLSECUREPASSWORD).GetNetworkCredential().Password
	}
}
Write-Host "Verifying User MainForm Inputs and Create AD Credential Completed"
Write-Host (Get-Date -format "MMM-dd-yyyy_HH-mm-ss")
Write-Host "-----------------------------------------------------------------------------------------------------------------------"

##Convert Output to proper formatting/variables
Write-Host "-----------------------------------------------------------------------------------------------------------------------"
Write-Host (Get-Date -format "MMM-dd-yyyy_HH-mm-ss")
Write-Host "Converting User MainForm Variables to Proper Formatting/Variables"
$VMNAME = $A.VMNAME
$VCPUS = $A.VCPUS
$RAM = $A.RAM
$TEMPLATE = Get-Template $A.Template
$DEV = $A.DEV
IF($DEV -eq "Checked")
{
$DEV = $TRUE
}
Else{
$DEV = $FALSE
}
$DMZ = $A.DMZ
IF($DMZ -eq "Checked")
{
$DMZ = $TRUE
}
Else{
$DMZ = $FALSE
}
$PCI = $A.PCI
IF($PCI -eq "Checked")
{
$PCI = $TRUE
}
Else{
$PCI = $FALSE
}
$VMREPLACE = $A.VMREPLACE
IF($VMREPLACE -eq "Checked")
{
	$VMREPLACE = $TRUE
	TRY
	{ $VMNAMEREPLACE = Get-VM $A.VMNAMEREPLACE }
	CATCH
	{ $VMNAMEREPLACE = $null}
}
$SITE = $A.Site
$DATACENTER = $A.DATACENTER
IF($CLUSTER -ne "*No Cluster")
{
	$CLUSTER = Get-Cluster $CLUSTER
}ELSE{
$CLUSTER = "*No Cluster"
}
$VMHOST = Get-VMHost $VMHOSTSELECTED
$PORTGROUP = Get-VDPortgroup -Name $A.PORTGROUP
$DATASTORE = $A.Datastore
$DATASTORE = $DATASTORE.substring(0, $DATASTORE.IndexOf("|"))
$DATASTORE = $DATASTORE.TrimEnd()
$DATASTORE = Get-Datastore $DATASTORE
$OSCUSTOMIZATION = Get-OSCustomizationSpec $A.OSCUSTOMIZATION
$VMTYPE = $A.VMTYPE
$VMFOLDER = $A.VMFOLDER
$VMFOLDER = $VMFOLDER -replace ",","/"
$VMFOLDER = $VMFOLDER.TRIMEND(" ")
$NOTES = $A.NOTES
$OWNER = $A.OWNER
$APPLIST = $A.APPLIST
IF($OVERRIDEDHCP -eq "Checked")
{
$OVERRIDEDHCP = $TRUE
}
Else{
$OVERRIDEDHCP = $FALSE
}
$IP = $A.IP
$SUBNET = $A.Subnet
$DG = $A.DG
$DNS1 = $A.DNS1
$DNS2 = $A.DNS2
$NSXTAGS = $A.NSXTAGS
Write-Host "Converting User MainForm Variables to Proper Formatting/Variables Completed"
Write-Host (Get-Date -format "MMM-dd-yyyy_HH-mm-ss")
Write-Host "-----------------------------------------------------------------------------------------------------------------------"

Write-Host "-----------------------------------------------------------------------------------------------------------------------"
Write-Host (Get-Date -format "MMM-dd-yyyy_HH-mm-ss")
Write-Host "Importing VM Hard Disk Type List and Setting Variables"
#Importing VM HD Type List CSV
TRY
{
	$VMTYPELIST = Import-CSV VMHDTypeList.CSV
}
CATCH
{
	Stop-ScriptNow "Hard Drive Config File Not found"
}
##Update Hard Drive Configuration based on Selected Hard Disk Configuration
$VMTYPELIST = $VMTYPELIST.Where({$_.Name -eq $VMTYPE})
##Set Variables for Modification
$DriveCount = $VMTYPELIST.DriveCount
$ControllerCount = $VMTYPELIST.ControllerCount
$DVDLetter = $VMTYPELIST.DVDLetter
$Drive0 = [System.Convert]::ToBoolean($VMTYPELIST.Drive0)
$Drive0Letter = $VMTYPELIST.Drive0Letter
$Drive0Name = $VMTYPELIST.Drive0Name
$Drive0Minimum = $VMTYPELIST.Drive0Minimum
$Drive0Size = $Drive0Minimum
$Drive0Persistence = $VMTYPELIST.Drive0Persistence
$Drive0StorageFormat= $VMTYPELIST.Drive0StorageFormat
$Drive0Controller = $VMTYPELIST.Drive0Controller
$Drive0FileSystem = $VMTYPELIST.Drive0FileSystem
$Drive0AllocationUnitSize = $VMTYPELIST.Drive0AllocationUnitSize
$Drive1 = [System.Convert]::ToBoolean($VMTYPELIST.Drive1)
$Drive1Letter = $VMTYPELIST.Drive1Letter
$Drive1Name = $VMTYPELIST.Drive1Name
$Drive1Minimum = $VMTYPELIST.Drive1Minimum
$Drive1Size = $Drive1Minimum
$Drive1Persistence = $VMTYPELIST.Drive1Persistence
$Drive1StorageFormat= $VMTYPELIST.Drive1StorageFormat
$Drive1Controller = $VMTYPELIST.Drive1Controller
$Drive1ControllerScsiID = $VMTYPELIST.Drive1ControllerScsiID
$Drive1FileSystem = $VMTYPELIST.Drive1FileSystem
$Drive1AllocationUnitSize = $VMTYPELIST.Drive1AllocationUnitSize
$Drive2 = [System.Convert]::ToBoolean($VMTYPELIST.Drive2)
$Drive2Letter = $VMTYPELIST.Drive2Letter
$Drive2Name = $VMTYPELIST.Drive2Name
$Drive2Minimum = $VMTYPELIST.Drive2Minimum
$Drive2Size = $Drive2Minimum
$Drive2Persistence = $VMTYPELIST.Drive2Persistence
$Drive2StorageFormat = $VMTYPELIST.Drive2StorageFormat
$Drive2Controller = $VMTYPELIST.Drive2Controller
$Drive2ControllerScsiID = $VMTYPELIST.Drive2ControllerScsiID
$Drive2FileSystem = $VMTYPELIST.Drive2FileSystem
$Drive2AllocationUnitSize = $VMTYPELIST.Drive2AllocationUnitSize
$Drive3 = [System.Convert]::ToBoolean($VMTYPELIST.Drive3)
$Drive3Letter = $VMTYPELIST.Drive3Letter
$Drive3Name = $VMTYPELIST.Drive3Name
$Drive3Minimum = $VMTYPELIST.Drive3Minimum
$Drive3Size = $Drive3Minimum
$Drive3Persistence = $VMTYPELIST.Drive3Persistence
$Drive3StorageFormat = $VMTYPELIST.Drive3StorageFormat
$Drive3Controller = $VMTYPELIST.Drive3Controller
$Drive3ControllerScsiID = $VMTYPELIST.Drive3ControllerScsiID
$Drive3FileSystem = $VMTYPELIST.Drive3FileSystem
$Drive3AllocationUnitSize = $VMTYPELIST.Drive3AllocationUnitSize
$Drive4 = [System.Convert]::ToBoolean($VMTYPELIST.Drive4)
$Drive4Letter = $VMTYPELIST.Drive4Letter
$Drive4Name = $VMTYPELIST.Drive4Name
$Drive4Minimum = $VMTYPELIST.Drive4Minimum
$Drive4Size = $Drive4Minimum
$Drive4Persistence = $VMTYPELIST.Drive4Persistence
$Drive4StorageFormat = $VMTYPELIST.Drive4StorageFormat
$Drive4Controller = $VMTYPELIST.Drive4Controller
$Drive4ControllerScsiID = $VMTYPELIST.Drive4ControllerScsiID
$Drive4FileSystem = $VMTYPELIST.Drive4FileSystem
$Drive4AllocationUnitSize = $VMTYPELIST.Drive4AllocationUnitSize
$Drive5 = [System.Convert]::ToBoolean($VMTYPELIST.Drive5)
$Drive5Letter = $VMTYPELIST.Drive5Letter
$Drive5Name = $VMTYPELIST.Drive5Name
$Drive5Minimum = $VMTYPELIST.Drive5Minimum
$Drive5Size = $Drive5Minimum
$Drive5Persistence = $VMTYPELIST.Drive5Persistence
$Drive5StorageFormat = $VMTYPELIST.Drive5StorageFormat
$Drive5Controller = $VMTYPELIST.Drive5Controller
$Drive5ControllerScsiID = $VMTYPELIST.Drive5ControllerScsiID
$Drive5FileSystem = $VMTYPELIST.Drive5FileSystem
$Drive5AllocationUnitSize = $VMTYPELIST.Drive5AllocationUnitSize
Write-Host "Importing VM Hard Disk Type List and Setting Variables Completed"
Write-Host (Get-Date -format "MMM-dd-yyyy_HH-mm-ss")
Write-Host "-----------------------------------------------------------------------------------------------------------------------"

##Call HardDiskForm
Write-Host "-----------------------------------------------------------------------------------------------------------------------"
Write-Host (Get-Date -format "MMM-dd-yyyy_HH-mm-ss")
Write-Host "Calling HardDiskForm and Allowing User to Set Drive Sizes"
IF($VMTYPE -ne "Unmodified")
{
	$H = HardDiskForm
}
Write-Host "Calling HardDiskForm and Allowing User to Set Drive Sizes Completed"
Write-Host (Get-Date -format "MMM-dd-yyyy_HH-mm-ss")
Write-Host "-----------------------------------------------------------------------------------------------------------------------"


##Checking if Cancel was Called
Write-Host "-----------------------------------------------------------------------------------------------------------------------"
Write-Host (Get-Date -format "MMM-dd-yyyy_HH-mm-ss")
Write-Host "Checking to see if Cancel Was Hit"
$CANCEL = $H.CANCEL
#Check If Cancel Button was hit
IF($CANCEL -eq "CANCEL")
	{
		Stop-ScriptNow "Cancel Button was hit"
	}
Write-Host "Cancel Was Not Hit"
Write-Host (Get-Date -format "MMM-dd-yyyy_HH-mm-ss")
Write-Host "-----------------------------------------------------------------------------------------------------------------------"

##Set HardDiskForm Output to Variables
Write-Host "-----------------------------------------------------------------------------------------------------------------------"
Write-Host (Get-Date -format "MMM-dd-yyyy_HH-mm-ss")
Write-Host "Setting HardDiskForm Output to Variables"
IF($VMTYPE -ne "Unmodified")
{
	$DRIVE0SIZE = $H.Drive0Size
	$DRIVE1SIZE = $H.Drive1Size
	$DRIVE2SIZE = $H.Drive2Size
	$DRIVE3SIZE = $H.Drive3Size
	$DRIVE4SIZE = $H.Drive4Size
	$DRIVE5SIZE = $H.Drive5Size
}
Else{
	$TEMPLATEGB = Get-HardDisk -Template $TEMPLATE | Select CapacityGB
	$TEMPLATEGB = $TEMPLATEGB.CapacityGB
	$DRIVE0SIZE = $TEMPLATEGB
}
Write-Host "Setting HardDiskForm Output to Variables Completed"
Write-Host (Get-Date -format "MMM-dd-yyyy_HH-mm-ss")
Write-Host "-----------------------------------------------------------------------------------------------------------------------"

##List Settings
#Being stated for Verification
Write-Host "-----------------------------------------------------------------------------------------------------------------------"
Write-Host (Get-Date -format "MMM-dd-yyyy_HH-mm-ss")
Write-Host "Settings will be: "
Write-Host "Version specified in file is: 		"$VERSION
Write-Host "SubVersion specified in file is: 	"$SUBVERSION
Write-Host "vCenter specified in file is: 		"$VCENTER
Write-Host "NSX Manager specified in file is: 	"$NSXMANAGER
Write-Host "SMTP Server will be: 			"$SMTPSERVER
Write-Host "SMTP Server Port will be: 		"$SMTPPORT
Write-Host "SMTP Server SSL will be: 		"$SMTPENABLESSL
Write-Host "Emails will be sent from: 		"$MSGFROM
Write-Host "Emails will be sent to: 		"$MSGTO
Write-Host "VM Name will be:			"$VMNAME
Write-Host "VM Domain will be:			"$DOMAIN
Write-Host "VM vCPU count will be:			"$VCPUS
Write-Host "VM RAM amount will be:			"$RAM
Write-Host "Will VM replace existing:		"$VMREPLACE
IF($VMREPLACE -eq $true)
{Write-Host "VM will replace:			"$VMNAMEREPLACE}
Write-Host "Template Selected will be:		"$TEMPLATE
Write-Host "Datacenter Selected will be:		"$DATACENTER
Write-Host "Cluster Selected will be:		"$CLUSTER
Write-Host "VMHost Selected will be:		"$VMHOST
Write-Host "Port Group Selected will be:		"$PORTGROUP
Write-Host "Datastore Selected will be:		"$DATASTORE.Name
Write-Host "OS Customization will be:		"$OSCUSTOMIZATION
Write-Host "VM HD Type will be:			"$VMTYPE
Write-Host "VM Folder Path will be:			"$VMFOLDER
Write-Host "VM Site will be:			"$SITE
Write-Host "VM App List will be:			"($APPLIST -Join ", ")
IF($OVERRIDEDHCP -eq $true)
{
	Write-Host "VM IP will be:				"$IP
	Write-Host "VM Subnet IP will be:			"$SUBNET
	Write-Host "VM Default Gateway IP will be:		"$DG
	Write-Host "VM DNS1 IP will be:			"$DNS1
	Write-Host "VM DNS2 IP will be:			"$DNS2
}
Else{
	Write-Host "VM IP will be:				 DHCP"
}
Write-Host "Is VM a DEV Server:			"$DEV
Write-Host "Is VM a PCI Server:			"$PCI
Write-Host "Is VM a DMZ Server:			"$DMZ
Write-Host "VM Notes include:			"$NOTES
Write-Host "VM Owner(s) is/are:			"$OWNER
Write-Host "VM Tags Selected:			"($VMTAGS -Join ", ")
IF($DefaultNSXConnection.Server){
	IF($CLUSTER -ne "*No Cluster")
	{
		Write-Host "NSX Tags Selected:			"($NSXTAGS -Join ", ")
	}
}
Write-Host "VM is being built by			"$SERVERBUILDER
##WAIT For User Acknowledgement
[System.Reflection.Assembly]::LoadWithPartialName("Microsoft.VisualBasic") | Out-Null
$CORRECT = [Microsoft.VisualBasic.Interaction]::MsgBox("Is the Build Information Correct?",'YesNo,Question', "Respond please")
IF ($CORRECT -eq "No")
{
Stop-ScriptNow "No was selected."
}
Write-Host (Get-Date -format "MMM-dd-yyyy_HH-mm-ss")
Write-Host "-----------------------------------------------------------------------------------------------------------------------"

##Update PowerShell Window Title
$pswindow.windowtitle = "vDeploy - " + $VMNAME 

##Create Computer AD Account Prior to PowerOn (Put in Build OU)
Write-Host "-----------------------------------------------------------------------------------------------------------------------"
Write-Host (Get-Date -format "MMM-dd-yyyy_HH-mm-ss")
$STRINGDOMAIN = [string]$DOMAIN
$FQDN = $VMNAME + "." + $STRINGDOMAIN
$ADCONTROLLER = Get-ADDomainController -Discover -Domain $STRINGDOMAIN
$ADCONTROLLERHN = $ADCONTROLLER.HostName
$ADCONTROLLERHN = $ADCONTROLLERHN.TRIMEND(" ")
$ADDOMAIN = Get-ADDomain $STRINGDOMAIN -Credential $MYDOMAINCREDENTIAL
$DNDOMAIN = $ADDOMAIN.DistinguishedName
$TARGETPATH = 'ou=Build,ou=Server_OU,' + $DNDOMAIN
Write-Host "Creating AD Computer Object for "$FQDN
#Update PowerShell Window Title
$pswindow.windowtitle = "vDeploy - " + $VMNAME + " - Creating AD Computer Object for " + $FQDN
Write-Host $MYDOMAINCREDENTIAL
New-ADComputer -Name $VMNAME -Credential $MYDOMAINCREDENTIAL -Server $ADCONTROLLERHN -Path $TARGETPATH
Write-Host "Creating AD Computer Object for "$FQDN" Completed."
Write-Host (Get-Date -format "MMM-dd-yyyy_HH-mm-ss")
Write-Host "-----------------------------------------------------------------------------------------------------------------------"
 
##Create Clone from Template
Write-Host "-----------------------------------------------------------------------------------------------------------------------"
Write-Host (Get-Date -format "MMM-dd-yyyy_HH-mm-ss")
Write-Host "Cloning VM from Template"
#Update PowerShell Window Title
$pswindow.windowtitle = "vDeploy - " + $VMNAME + " - Cloning VM from Template"
$STARTTIMECLONE = (Get-Date -format "MMM-dd-yyyy HH-mm-ss")
$STARTTIMECLONESW = [Diagnostics.Stopwatch]::StartNew()
$VMSTARTTIMESW = [Diagnostics.Stopwatch]::StartNew()
#Check to use DHCP
IF ($OVERRIDEDHCP -eq $FALSE)
{
	##Create VM using DHCP
	Write-Host "Creating VM Using default DHCP from OS Customization Spec"
	Write-Host "VM Name "$VMNAME
	Write-Host "VM FQDN "$FQDN
	Write-Host "Datastore "$DATASTORE
	Write-Host "Template "$TEMPLATE
	Write-Host "OS Customization Spec "$OSCUSTOMIZATION
	New-VM -VMHost $VMHOST -Name $VMNAME -Datastore $DATASTORE -DiskStorageFormat $Drive0StorageFormat -Template $TEMPLATE -Location (Get-FolderByPath -Path $VMFOLDER) -OSCustomizationSpec (Get-OSCustomizationSpec $OSCUSTOMIZATION)
}
#Static IP is selected
ELSE{
	##Create Temporary Customization Spec with Static IP Information
	#Reference https://blogs.vmware.com/PowerCLI/2014/06/working-customization-specifications-powercli-part-2.html
	$TEMPOSCUSTOMIZATIONSPEC = New-OSCustomizationSpec -Spec $OSCUSTOMIZATION -Type NonPersistent
	#$TEMPOSCUSTOMIZATIONSPEC | Set-OSCustomizationSpec -GUIRunOnce $GUIRUNONCE_SCRIPT1 -AutoLogonCount 2
	$nicMapping = Get-OSCustomizationNicMapping -OSCustomizationSpec $TEMPOSCUSTOMIZATIONSPEC
	$nicMapping | Set-OSCustomizationNicMapping -IpMode UseStaticIP -IpAddress $IP -SubnetMask $SUBNET -DefaultGateway $DG -DNS $DNS1,$DNS2
	##Create VM using Static IP Settings
	Write-Host "Creating Temporary VM Customization Spec with Static IP Information"
	Write-Host "VM Name "$VMNAME
	Write-Host "Datastore "$DATASTORE
	Write-Host "Template "$TEMPLATE
	Write-Host "OS Customization Spec "$OSCUSTOMIZATION
	Write-Host "IP Address "$IP
	Write-Host "Subnet Mask "$Subnet
	Write-HOST "Default Gateway "$DG
	Write-Host "DNS Server(s) "$DNS1,$DNS2
	New-VM -VMHost $VMHOST -Name $VMNAME -Datastore $DATASTORE -DiskStorageFormat $Drive0StorageFormat -Template $TEMPLATE -Location (Get-FolderByPath -Path $VMFOLDER) -OSCustomizationSpec $TEMPOSCUSTOMIZATIONSPEC
}
$STARTTIMECLONESW.STOP()
$STOPTIMECLONE = (Get-Date -format "MMM-dd-yyyy HH-mm-ss")
Write-Host "Cloning VM from Template Completed"
Write-Host (Get-Date -format "MMM-dd-yyyy_HH-mm-ss")
Write-Host "-----------------------------------------------------------------------------------------------------------------------"

##Upgrade Hardware Version to Current
Write-Host "-----------------------------------------------------------------------------------------------------------------------"
Write-Host (Get-Date -format "MMM-dd-yyyy_HH-mm-ss")
Write-Host "Upgrading Virtual Hardware to Current Version"
#Update PowerShell Window Title
$pswindow.windowtitle = "vDeploy - " + $VMNAME + " - Upgrading Virtual Hardware to Current Version"
$VMHOSTDETAILS = Get-VMHost $VMHOST
$VMHOSTVERSION = $VMHOSTDETAILS.VERSION
IF($VMHOSTVERSION -eq "6.5.0")
{
	Write-Host "VMHost "$VMHOST" is running ESXi 6.5.0"
	$VMEXPECTEDVERSION = "v13"
	$VMVERSION = Get-VM $VMNAME | Select Version
	$VMVERSION = $VMVERSION.Version
	IF($VMEXPECTEDVERSION -notmatch $VMVERSION)
	{
		Write-Host "Upgrading VM "$VMNAME" to match VMHost ESXi version"
		Set-VM -VM (Get-VM -Name $VMNAME) -Version v13 -Confirm:$false
	}ELSE{
	Write-Host "VM is presently at Current Hardware Version for VMHost "$VMHOST
	}
}
IF($VMHOSTVERSION -eq "6.0.0")
{
	Write-Host "VMHost "$VMHOST" is running ESXi 6.0.0"
	$VMEXPECTEDVERSION = "v11"
	$VMVERSION = Get-VM $VMNAME | Select Version
	$VMVERSION = $VMVERSION.Version
	IF($VMEXPECTEDVERSION -notmatch $VMVERSION)
	{
		Write-Host "Upgrading VM "$VMNAME" to match VMHost ESXi version"
		Set-VM -VM (Get-VM -Name $VMNAME) -Version v11 -Confirm:$false
	}ELSE{
	Write-Host "VM is presently at Current Hardware Version for VMHost "$VMHOST
	}
}
Write-Host "Upgrading Virtual Hardware to Current Version Completed"
Write-Host (Get-Date -format "MMM-dd-yyyy_HH-mm-ss")
Write-Host "-----------------------------------------------------------------------------------------------------------------------"

#Set CPU on VM
Write-Host "-----------------------------------------------------------------------------------------------------------------------"
Write-Host (Get-Date -format "MMM-dd-yyyy_HH-mm-ss")
Write-Host "Setting CPU Configuration on VM "$VMNAME
#Update PowerShell Window Title
$pswindow.windowtitle = "vDeploy - " + $VMNAME + " - Setting CPU Configuration on VM"
Get-VM -Name $VMNAME | Set-VM -NumCPU $VCPUS -Confirm:$false
Get-VM -Name $VMNAME | Select Name, NumCPU
Write-Host "Setting CPU Configuration on VM "$VMNAME" Completed"
Write-Host (Get-Date -format "MMM-dd-yyyy_HH-mm-ss")
Write-Host "-----------------------------------------------------------------------------------------------------------------------"

##Set RAM on VM
Write-Host "-----------------------------------------------------------------------------------------------------------------------"
Write-Host (Get-Date -format "MMM-dd-yyyy_HH-mm-ss")
Write-Host "Setting Memory on VM"$VMNAME
#Update PowerShell Window Title
$pswindow.windowtitle = "vDeploy - " + $VMNAME + " - Setting Memory on VM"
Get-VM -Name $VMNAME | Set-VM -MemoryGB $RAM -Confirm:$false
Get-VM -Name $VMNAME | Select Name, MemoryGB
Write-Host "Setting Memory on VM "$VMNAME" Completed"
Write-Host (Get-Date -format "MMM-dd-yyyy_HH-mm-ss")
Write-Host "-----------------------------------------------------------------------------------------------------------------------"

##Set PortGroup on VM
Write-Host "-----------------------------------------------------------------------------------------------------------------------"
Write-Host (Get-Date -format "MMM-dd-yyyy_HH-mm-ss")
Write-Host "Setting Port Group on VM "$VMNAME
Write-Host "Setting VM to Port Group "$PORTGROUP
#Update PowerShell Window Title
$pswindow.windowtitle = "vDeploy - " + $VMNAME + " - Setting VM to Port Group " + $PORTGROUP
#Get-VM -Name $VMNAME | Get-NetworkAdapter | Set-NetworkAdapter -PortGroup $PORTGROUP -Connected:$TRUE -Confirm:$false
$myNetworkAdapters = Get-VM -Name $VMNAME | Get-NetworkAdapter -Name "Network adapter 1"
Set-NetworkAdapter -NetworkAdapter $myNetworkAdapters -Portgroup $PORTGROUP -Confirm:$false
Write-Host "Setting Network Adapter to be Connected"
Set-NetworkAdapter -NetworkAdapter $myNetworkAdapters -StartConnected:$TRUE -Confirm:$false
Write-Host "Setting Port Group on VM "$VMNAME" Completed"
Write-Host (Get-Date -format "MMM-dd-yyyy_HH-mm-ss")
Write-Host "-----------------------------------------------------------------------------------------------------------------------"

##Set Notes on VM
Write-Host "-----------------------------------------------------------------------------------------------------------------------"
Write-Host (Get-Date -format "MMM-dd-yyyy_HH-mm-ss")
Write-Host "Setting Notes on VM"$VMNAME
#Update PowerShell Window Title
$pswindow.windowtitle = "vDeploy - " + $VMNAME + " - Setting Notes on VM"
$BUILD_DATE = Get-Date
$TOTAL_NOTES = "
$NOTES `
Owner is: $OWNER `
VM Build Date: $BUILD_DATE `
Built by: $env:UserDomain\$env:UserName `
VM HD Type: $VMTYPE `
Apps include: "+($APPLIST -Join ', ')
Get-VM -Name $VMNAME | Set-VM -Description $TOTAL_NOTES -Confirm:$false
Get-VM -Name $VMNAME | Select Name, Description
Write-Host "Setting Memory on VM "$VMNAME" Completed"
Write-Host (Get-Date -format "MMM-dd-yyyy_HH-mm-ss")
Write-Host "-----------------------------------------------------------------------------------------------------------------------"

##Add VM to DRS Group for Site
IF($CLUSTER -ne "*No Cluster")
{
	Write-Host "-----------------------------------------------------------------------------------------------------------------------"
	Write-Host (Get-Date -format "MMM-dd-yyyy_HH-mm-ss")
	Write-Host "Adding VM to DRS Group for Site "$SITE
	#Update PowerShell Window Title
	$pswindow.windowtitle = "vDeploy - " + $VMNAME + " - Adding VM to DRS Group for Site " + $SITE
	IF ($SITE -eq "Production")
	{
	#Check and see if DRS Group is created, if not create it
	$DRSGROUPRESULT = Get-Cluster $CLUSTER | Get-DrsClusterGroup -Type VMGroup -Name "Production VMs" -ErrorAction SilentlyContinue
	IF (!$DRSGROUPRESULT)
	{
		New-DrsClusterGroup -Name "Production VMs" -Cluster $CLUSTER -VM $VMNAME
	}
	#Set VM in DRS Group
	Get-Cluster $CLUSTER | Get-DrsClusterGroup -Type VMGroup -Name "Production VMs" | Set-DRSClusterGroup -VM $VMNAME -Add -ErrorAction SilentlyContinue
	}
	IF ($SITE -eq "DR")
	{
	#Check and see if DRS Group is created, if not create it
	$DRSGROUPRESULT = Get-Cluster $CLUSTER | Get-DrsClusterGroup -Type VMGroup -Name "DR VMs" -ErrorAction SilentlyContinue
	IF (!$DRSGROUPRESULT)
	{
		New-DrsClusterGroup -Name "DR VMs" -Cluster $CLUSTER -VM $VMNAME
	}
	#Set VM in DRS Group
	Get-Cluster $CLUSTER | Get-DrsClusterGroup -Type VMGroup -Name "DR VMs" | Set-DRSClusterGroup -VM $VMNAME -Add -ErrorAction SilentlyContinue
	}
	Write-Host "Adding VM to DRS Group for Site "$SITE" Completed"
	Write-Host (Get-Date -format "MMM-dd-yyyy_HH-mm-ss")
	Write-Host "-----------------------------------------------------------------------------------------------------------------------"
}

Write-Host "-----------------------------------------------------------------------------------------------------------------------"
Write-Host (Get-Date -format "MMM-dd-yyyy_HH-mm-ss")
Write-Host "Configuring VM for Hard Drive Type "$VMTYPE
#Update PowerShell Window Title
$pswindow.windowtitle = "vDeploy - " + $VMNAME + " - Configuring VM for Hard Drive Type " + $VMTYPE
#Note: Drives Start at 0 and go up
##Expand Hard Disk 0 (If Needed)
Write-Host "Expanding Disk 0 if Needed"
$NEWDISK0 = Get-HardDisk -VM $VMNAME -Name "Hard disk 1" | Set-HardDisk -CapacityGB $Drive0Size -Confirm:$false
##Create Hard Disk 1
IF($Drive1 -eq $TRUE){
Write-Host "Creating Hard Disk 1"
$VMCONTROLLERS = Get-VM -Name $VMNAME | Get-ScsiController
$TESTCONTROLLERCOUNT = [int]$Drive1Controller + 1
IF($VMCONTROLLERS.Count -eq $TESTCONTROLLERCOUNT)
{
	$NEWDISK1 = Get-VM -NAME $VMNAME | New-HardDisk -CapacityGB $Drive1Size -Persistence $Drive1Persistence -StorageFormat $Drive1StorageFormat
}
Else{
	$NEWDISK1 = Get-VM -NAME $VMNAME | New-HardDisk -CapacityGB $Drive1Size -Persistence $Drive1Persistence -StorageFormat $Drive1StorageFormat | New-ScsiController -Type Paravirtual -BusSharingMode NoSharing
}
##Set SCSI Controller
Write-Host "Setting SCSI Controller for Hard Disk 1"
$DISK1CONTROLLER = "SCSI Controller " + $Drive1Controller
$CONTROLLER = Get-ScsiController -Name $DISK1CONTROLLER -VM $VMNAME
$DISK1CONTROLLER = "SCSI Controller " + $Drive1Controller
$CONTROLLER = Get-ScsiController -Name $DISK1CONTROLLER -VM $VMNAME
Get-HardDisk -VM $VMNAME -Name "Hard disk 2" | Set-HardDisk -Controller $CONTROLLER -Confirm:$false
## Set SCSI Controller ID on New Hard Disk
#Reference: https://communities.vmware.com/thread/421110
$strVMToUpdate = $VMNAME
$vmToUpdate = Get-VM $strVMToUpdate
$hdskToChange = Get-HardDisk -VM $vmToUpdate -Name "Hard disk 2"
$spec = New-Object VMware.Vim.VirtualMachineConfigSpec
$spec.deviceChange = New-Object VMware.Vim.VirtualDeviceConfigSpec
$spec.deviceChange[0].operation = "edit"
$spec.deviceChange[0].device = $hdskToChange.ExtensionData
$spec.deviceChange[0].device.unitNumber = $Drive1ControllerScsiID
$vmToUpdate.ExtensionData.ReconfigVM_Task($spec)
Start-Sleep -s 3
}
##Create Hard Disk 2
IF($Drive2 -eq $TRUE){
Write-Host "Creating Hard Disk 2"
$VMCONTROLLERS = Get-VM -Name $VMNAME | Get-ScsiController
$TESTCONTROLLERCOUNT = [int]$Drive2Controller + 1
IF($VMCONTROLLERS.Count -eq $TESTCONTROLLERCOUNT)
{
	$NEWDISK2 = Get-VM -NAME $VMNAME | New-HardDisk -CapacityGB $Drive2Size -Persistence $Drive2Persistence -StorageFormat $Drive2StorageFormat
}
Else{
	$NEWDISK2 = Get-VM -NAME $VMNAME | New-HardDisk -CapacityGB $Drive2Size -Persistence $Drive2Persistence -StorageFormat $Drive2StorageFormat | New-ScsiController -Type Paravirtual -BusSharingMode NoSharing
}
##Set SCSI Controller
Write-Host "Setting SCSI Controller for Hard Disk 2"
$DISK2CONTROLLER = "SCSI Controller " + $Drive2Controller
$CONTROLLER = Get-ScsiController -Name $DISK2CONTROLLER -VM $VMNAME
Get-HardDisk -VM $VMNAME -Name "Hard disk 3" | Set-HardDisk -Controller $CONTROLLER -Confirm:$false
## Set SCSI Controller ID on New Hard Disk
#Reference: https://communities.vmware.com/thread/421110
$strVMToUpdate = $VMNAME
$vmToUpdate = Get-VM $strVMToUpdate
$hdskToChange = Get-HardDisk -VM $vmToUpdate -Name "Hard disk 3"
$spec = New-Object VMware.Vim.VirtualMachineConfigSpec
$spec.deviceChange = New-Object VMware.Vim.VirtualDeviceConfigSpec
$spec.deviceChange[0].operation = "edit"
$spec.deviceChange[0].device = $hdskToChange.ExtensionData
$spec.deviceChange[0].device.unitNumber = $Drive2ControllerScsiID
$vmToUpdate.ExtensionData.ReconfigVM_Task($spec)
Start-Sleep -s 3
}
##Create Hard Disk 3
IF($Drive3 -eq $TRUE){
Write-Host "Creating Hard Disk 3"
$VMCONTROLLERS = Get-VM -Name $VMNAME | Get-ScsiController
$TESTCONTROLLERCOUNT = [int]$Drive3Controller + 1
IF($VMCONTROLLERS.Count -eq $TESTCONTROLLERCOUNT)
{
	$NEWDISK3 = Get-VM -NAME $VMNAME | New-HardDisk -CapacityGB $Drive3Size -Persistence $Drive3Persistence -StorageFormat $Drive3StorageFormat
}
Else{
	$NEWDISK3 = Get-VM -NAME $VMNAME | New-HardDisk -CapacityGB $Drive3Size -Persistence $Drive3Persistence -StorageFormat $Drive3StorageFormat | New-ScsiController -Type Paravirtual -BusSharingMode NoSharing
}
##Set SCSI Controller
Write-Host "Setting SCSI Controller for Hard Disk 3"
$DISK3CONTROLLER = "SCSI Controller " + $Drive3Controller
$CONTROLLER = Get-ScsiController -Name $DISK3CONTROLLER -VM $VMNAME
Get-HardDisk -VM $VMNAME -Name "Hard disk 4" | Set-HardDisk -Controller $CONTROLLER -Confirm:$false
## Set SCSI Controller ID on New Hard Disk
#Reference: https://communities.vmware.com/thread/421110
$strVMToUpdate = $VMNAME
$vmToUpdate = Get-VM $strVMToUpdate
$hdskToChange = Get-HardDisk -VM $vmToUpdate -Name "Hard disk 4"
$spec = New-Object VMware.Vim.VirtualMachineConfigSpec
$spec.deviceChange = New-Object VMware.Vim.VirtualDeviceConfigSpec
$spec.deviceChange[0].operation = "edit"
$spec.deviceChange[0].device = $hdskToChange.ExtensionData
$spec.deviceChange[0].device.unitNumber = $Drive3ControllerScsiID
$vmToUpdate.ExtensionData.ReconfigVM_Task($spec)
Start-Sleep -s 3
}
##Create Hard Disk 4
IF($Drive4 -eq $TRUE){
Write-Host "Creating Hard Disk 4"
$VMCONTROLLERS = Get-VM -Name $VMNAME | Get-ScsiController
$TESTCONTROLLERCOUNT = [int]$Drive4Controller + 1
IF($VMCONTROLLERS.Count -eq $TESTCONTROLLERCOUNT)
{
	$NEWDISK4 = Get-VM -NAME $VMNAME | New-HardDisk -CapacityGB $Drive4Size -Persistence $Drive4Persistence -StorageFormat $Drive4StorageFormat
}
Else{
	$NEWDISK4 = Get-VM -NAME $VMNAME | New-HardDisk -CapacityGB $Drive4Size -Persistence $Drive4Persistence -StorageFormat $Drive4StorageFormat | New-ScsiController -Type Paravirtual -BusSharingMode NoSharing
}
##Set SCSI Controller
Write-Host "Setting SCSI Controller for Hard Disk 4"
$DISK4CONTROLLER = "SCSI Controller " + $Drive4Controller
$CONTROLLER = Get-ScsiController -Name $DISK4CONTROLLER -VM $VMNAME
Get-HardDisk -VM $VMNAME -Name "Hard disk 5" | Set-HardDisk -Controller $CONTROLLER -Confirm:$false
## Set SCSI Controller ID on New Hard Disk
#Reference: https://communities.vmware.com/thread/421110
$strVMToUpdate = $VMNAME
$vmToUpdate = Get-VM $strVMToUpdate
$hdskToChange = Get-HardDisk -VM $vmToUpdate -Name "Hard disk 5"
$spec = New-Object VMware.Vim.VirtualMachineConfigSpec
$spec.deviceChange = New-Object VMware.Vim.VirtualDeviceConfigSpec
$spec.deviceChange[0].operation = "edit"
$spec.deviceChange[0].device = $hdskToChange.ExtensionData
$spec.deviceChange[0].device.unitNumber = $Drive4ControllerScsiID
$vmToUpdate.ExtensionData.ReconfigVM_Task($spec)
Start-Sleep -s 3
}
##Create Hard Disk 5
IF($Drive5 -eq $TRUE){
Write-Host "Creating Hard Disk 5"
$VMCONTROLLERS = Get-VM -Name $VMNAME | Get-ScsiController
$TESTCONTROLLERCOUNT = [int]$Drive5Controller + 1
IF($VMCONTROLLERS.Count -eq $TESTCONTROLLERCOUNT)
{
	$NEWDISK5 = Get-VM -NAME $VMNAME | New-HardDisk -CapacityGB $Drive5Size -Persistence $Drive5Persistence -StorageFormat $Drive5StorageFormat
}
Else{
	$NEWDISK5 = Get-VM -NAME $VMNAME | New-HardDisk -CapacityGB $Drive5Size -Persistence $Drive5Persistence -StorageFormat $Drive5StorageFormat | New-ScsiController -Type Paravirtual -BusSharingMode NoSharing
}
##Set SCSI Controller
Write-Host "Setting SCSI Controller for Hard Disk 5"
$DISK5CONTROLLER = "SCSI Controller " + $Drive5Controller
$CONTROLLER = Get-ScsiController -Name $DISK5CONTROLLER -VM $VMNAME
Get-HardDisk -VM $VMNAME -Name "Hard disk 6" | Set-HardDisk -Controller $CONTROLLER -Confirm:$false
## Set SCSI Controller ID on New Hard Disk
#Reference: https://communities.vmware.com/thread/421110
$strVMToUpdate = $VMNAME
$vmToUpdate = Get-VM $strVMToUpdate
$hdskToChange = Get-HardDisk -VM $vmToUpdate -Name "Hard disk 6"
$spec = New-Object VMware.Vim.VirtualMachineConfigSpec
$spec.deviceChange = New-Object VMware.Vim.VirtualDeviceConfigSpec
$spec.deviceChange[0].operation = "edit"
$spec.deviceChange[0].device = $hdskToChange.ExtensionData
$spec.deviceChange[0].device.unitNumber = $Drive5ControllerScsiID
$vmToUpdate.ExtensionData.ReconfigVM_Task($spec)
Start-Sleep -s 3
}
Write-Host "Creating Addtional Hard Drives for VM Completed"
Write-Host (Get-Date -format "MMM-dd-yyyy_HH-mm-ss")
Write-Host "-----------------------------------------------------------------------------------------------------------------------"

##Set NSX Security Tags
#If Not in a Cluster, cannot Set NSX TAGS. NSX is only usable in a Cluster.
IF($CLUSTER -ne "*No Cluster")
{
	Write-Host "-----------------------------------------------------------------------------------------------------------------------"
	Write-Host (Get-Date -format "MMM-dd-yyyy_HH-mm-ss")
	#If NSX is available continue
	IF($DefaultNSXConnection.Server){
		#Verify that NSX is Installed on VMHost/Cluster
		Write-Host "Verifing that NSX is Installed on VMHost"
		$NSXHOSTRESULT = Get-VMHost $VMHOST | Get-Cluster | Get-NSXClusterStatus | Where {$_.featureId -eq "com.vmware.vshield.vsm.nwfabric.hostPrep"}
		$NSXCLUSTERVERSION = $NSXHOSTRESULT.featureVersion
		IF($NSXHOSTRESULT.installed -eq "true")
		{
			Write-Host "NSX Installation on Host Verified"
			Write-Host "Verifying NSX Functionality Status on VMHost"
			#Verify that NSX is Functional on VMHost
			IF($NSXHOSTRESULT.status -eq "GREEN")
			{
				Write-Host "NSX Functionality Status is Verified" -foregroundcolor "white" -NoNewLine; Write-Host " GREEN" -foregroundcolor "green"
				Write-Host "Setting NSX Security Tags"
				#Update PowerShell Window Title
				$pswindow.windowtitle = "vDeploy - " + $VMNAME + " - Setting NSX Security Tags"
				#Set NSX Tags based on user selection
				Write-Host "Setting NSX Tags selected on MainForm"
				ForEach($TAG in $NSXTAGS)
				{
					Write-Host "Applying NSX TAG "$TAG
					Get-VM $VMNAME | New-NsxSecurityTagAssignment -ApplyTag -SecurityTag (Get-NsxSecurityTag $TAG)
				}
				#Set NSX Tags based on predefined Tag Names In Application Answer File
				$ApplicationList = Import-CSV AppList.csv
				Write-Host "Setting NSX Tags Based on Applications Selected in MainForm"
				$APPNSXTAGS_List = @()
				ForEach($Application in $ApplicationList)
				{
					$APPLICATIONNAME = $Application.Name
					IF($APPLIST -contains $APPLICATIONNAME)
					{
						$APPNSXTAGS = $Application.NSXTAGS
						
						IF($APPNSXTAGS -ne "")
						{
							IF($APPNSXTAGS -match ",")
							{
								Write-Host "Splitting NSX Tag into Array "$APPNSXTAGS
								$APPNSXTAGS = $APPNSXTAGS -split ","
							}
							ForEach($APPNSXTAG in $APPNSXTAGS)
							{
								Write-Host "Applying Application NSX TAG "$APPNSXTAG
								Get-VM $VMNAME | New-NsxSecurityTagAssignment -ApplyTag -SecurityTag (Get-NsxSecurityTag $APPNSXTAG)
								$APPNSXTAGS_List+=$APPNSXTAG
							}
						}
					}
				}
				#IF Server is replacing another Server, copy NSX Tags from Old Serer to new
				IF ($VMREPLACE -eq $true)
				{
					$ORIGINALTAGS = Get-VM $VMNAMEREPLACE | Get-NSXSecurityTagAssignment
					FOREACH ($TAG in $ORIGINALTAGS)
					{
						Write-Host "Duplicating NSX Tags from original VM"
						Get-VM $VMNAME | New-NsxSecurityTagAssignment -ApplyTag -SecurityTag (Get-NsxSecurityTag $TAG)
					}
				}
				Write-Host "Setting Custom tags you selected"
				ForEach($TAG in $NSXTAGS)
				{
					Get-VM $VMNAME | New-NsxSecurityTagAssignment -ApplyTag -SecurityTag (Get-NsxSecurityTag $TAG)
				}
				Write-Host "Setting Custom tags you selected Completed"
				Write-Host "Setting NSX Security Tags Completed"
				Write-Host (Get-Date -format "MMM-dd-yyyy_HH-mm-ss")
				Write-Host "-----------------------------------------------------------------------------------------------------------------------"

				##VERIFY NSX Tags
				Write-Host "-----------------------------------------------------------------------------------------------------------------------"
				Write-Host (Get-Date -format "MMM-dd-yyyy_HH-mm-ss")
				Write-Host "Verifying NSX TAGS Applied"
				$APPLIEDNSXTAGS = Get-VM $VMNAME | Get-NsxSecurityTagAssignment | select-object @{Name="SecurityTag"; expression = {$_.securitytag.name}}
				$APPLIEDNSXTAGS
				Write-Host "Verifying NSX TAGS Applied Completed"
				Write-Host (Get-Date -format "MMM-dd-yyyy_HH-mm-ss")
				Write-Host "-----------------------------------------------------------------------------------------------------------------------"
			}
		}
	}
}

##Set VM Tags
Write-Host "-----------------------------------------------------------------------------------------------------------------------"
Write-Host (Get-Date -format "MMM-dd-yyyy_HH-mm-ss")
Write-Host "Setting VMware TAGS Starting"
#Update PowerShell Window Title
$pswindow.windowtitle = "vDeploy - " + $VMNAME + " - Setting VMware TAGS Starting"
Write-Host "Setting VM Tags based on MainForm user selection"
ForEach($VMTAG in $VMTAGS)
{
	Write-Host "Applying VMware TAG "$VMTAG
	Get-VM $VMNAME | New-TagAssignment -Tag (Get-Tag $VMTAG)
}
Write-Host "Setting VM Tags based on MainForm user selection Completed"
Write-Host "Setting VMware TAGS Based on Application List"
$ApplicationList = Import-CSV AppList.csv
$APPLIEDVMAPPTAGS = @()
ForEach($Application in $ApplicationList)
{
	$APPLICATIONNAME = $Application.Name
	IF($APPLIST -contains $APPLICATIONNAME)
	{
		$APPVMTAGS = $Application.VMTAGS
		IF($APPVMTAGS -ne "")
		{
			IF($APPVMTAGS -match ",")
			{
				Write-Host "Splitting VM Tags into Array "$APPVMTAGS
				$APPVMTAGS = $APPVMTAGS -split ","
			}
			ForEach($APPVMTAG in $APPVMTAGS)
			{
				Write-Host "Applying VMware TAG "$APPVMTAG
				$APPLIEDVMAPPTAGS += $APPVMTAG
				Get-VM $VMNAME | New-TagAssignment -Tag (Get-Tag $APPVMTAG)
			}
		}
	}
}
Write-Host "Setting VMware TAGS Based on Application List Completed"
Write-Host "Setting VMware TAGS Completed"
Write-Host (Get-Date -format "MMM-dd-yyyy_HH-mm-ss")
Write-Host "-----------------------------------------------------------------------------------------------------------------------"

##VERIFY VM Tags
Write-Host "-----------------------------------------------------------------------------------------------------------------------"
Write-Host (Get-Date -format "MMM-dd-yyyy_HH-mm-ss")
Write-Host "Verifying VM TAGS Applied"
#Update PowerShell Window Title
$pswindow.windowtitle = "vDeploy - " + $VMNAME + " - Verifying VM TAGS Applied"
$APPLIEDVMTAGS = Get-VM $VMNAME | Get-TagAssignment | Select Tag
$APPLIEDVMTAGS = $APPLIEDVMTAGS.Tag.Name
Write-Host "Verifying VM TAGS Applied Completed"
Write-Host (Get-Date -format "MMM-dd-yyyy_HH-mm-ss")
Write-Host "-----------------------------------------------------------------------------------------------------------------------"

##Power On VM
Write-Host "-----------------------------------------------------------------------------------------------------------------------"
Write-Host (Get-Date -format "MMM-dd-yyyy_HH-mm-ss")
Write-Host "Powering on VM"
#Update PowerShell Window Title
$pswindow.windowtitle = "vDeploy - " + $VMNAME + " - Powering on VM"
Start-VM -VM $VMNAME -Confirm:$false -RunAsync
$VMSTARTTIMESW.STOP()
Write-Host "Powering on VM Completed"
Write-Host (Get-Date -format "MMM-dd-yyyy_HH-mm-ss")
Write-Host "-----------------------------------------------------------------------------------------------------------------------"

##Wait Until VM is SysPrep'edit
Write-Host "-----------------------------------------------------------------------------------------------------------------------"
Write-Host (Get-Date -format "MMM-dd-yyyy_HH-mm-ss")
$FQDN = $VMNAME + "." + $DOMAIN 
Write-Host "Starting process monitoring for VM: "$VMName
Write-Host "Fully Qualified Domain Name will be: "$FQDN
Write-Host "Waiting for VM " $VMNAME " to complete SysPrep"
$VMSYSPREPSTARTTIMESW = [Diagnostics.Stopwatch]::StartNew()
#Update PowerShell Window Title
$pswindow.windowtitle = "vDeploy - " + $VMNAME + " - Waiting for VM to complete SysPrep"
Do     
{
	$VirtualMachine = Get-VM -Name $VMNAME
	$GuestHostName = $VirtualMachine.ExtensionData.Guest.Hostname
	Write-Host (Get-Date -Format o) "Waiting for VM named:" $VMNAME "to match guest named:" $GuestHostName
	Start-Sleep -Seconds 1
	$LOOPCOUNTER++
	##If Loop Counter goes for longer than 20 Minutes Stop all processes
	IF($LOOPCOUNTER -GT $VMSYSPREPTIMEOUT)
	{
	Write-Host "Something went wrong the SysPrep Process Stopping all processes"
	Write-Host "Powering Off VM"
	Stop-VM -Kill -VM $VMNAME -Confirm:$FALSE
	Write-Host "Deleting VM"
	Remove-VM -DeleteFromDisk -VM $VMNAME -Confirm:$FALSE
	Write-Host "Stop Transcript"
	Stop-Transcript
	Stop-ScriptNow "VM Build Process Failed. SysPrep did not complete. Please Reattempt Build Process"
	
	}
} 
Until ($GuestHostName -eq $FQDN)
IF ($GUESTHOSTNAME -eq $FQDN)
{
$BUILDVERIFY = "Success"
}
Write-Host "VM" $VMName "is now Online and SysPrep'ed"
Write-Host "Waiting 60 seconds before proceeding"
$VMSYSPREPSTARTTIMESW.STOP()
#Update PowerShell Window Title
$pswindow.windowtitle = "vDeploy - " + $VMNAME + " - SysPrep Completed. Waiting 60 Seconds"
Start-Sleep -Seconds 60
Write-Host (Get-Date -format "MMM-dd-yyyy_HH-mm-ss")
Write-Host "-----------------------------------------------------------------------------------------------------------------------"

##Verify that VM is Completely Online
##Wait for VM to complete restart process
Write-Host "-----------------------------------------------------------------------------------------------------------------------"
Write-Host (Get-Date -format "MMM-dd-yyyy_HH-mm-ss")
Write-Host "Verifying Server is Fully Online "$FQDN
Do     
{
	$VirtualMachine = Get-VM -Name $VMNAME
	$GuestHostName = $VirtualMachine.ExtensionData.Guest.Hostname
	Write-Host (Get-Date -Format o) "Waiting for VM named:" $VMNAME "to match guest named:" $GuestHostName
	Start-Sleep -s 1
} 
Until ($GuestHostName -eq $FQDN)
Write-Host "Verifying Server is Fully Online "$FQDN" Completed"
Write-Host (Get-Date -format "MMM-dd-yyyy_HH-mm-ss")
Write-Host "-----------------------------------------------------------------------------------------------------------------------"

##Verify VM DNS/IP Resolution
Write-Host "-----------------------------------------------------------------------------------------------------------------------"
Write-Host (Get-Date -format "MMM-dd-yyyy_HH-mm-ss")
Write-Host "Verify VM DNS/IP Resolution Starting"
#Update PowerShell Window Title
$pswindow.windowtitle = "vDeploy - " + $VMNAME + " - Verifying VM DNS/IP Resolution"
$CHECKDNS = Resolve-DnsName $FQDN
WHILE(!$CHECKDNS)
{
	Start-Sleep -s 15
	##Check if DNS Name is Resolvable
	$CHECKDNS = Resolve-DnsName $FQDN
	##Attempt to register DNS on Remote VM via WMI Call
	Write-Host "Attempting to remotely register VM with DNS with WMI"
	$VMIPADDRESS = Get-VM $VMNAME | Select @{Name="IPAddress";Expression={$_.ExtensionData.Guest.IPAddress}}
	$VMIPADDRESS = $VMIPADDRESS.IPAddress
	Invoke-WmiMethod -class Win32_process -name Create -ArgumentList ("cmd.exe /c ipconfig /registerdns") -ComputerName $VMIPADDRESS -Credential $MYDOMAINCREDENTIAL
	Start-Sleep -s 15
	##Check if DNS Name is Resolvable
	$CHECKDNS = Resolve-DnsName $FQDN
	#If not resolvable, clear DNS Cache
	Write-Host "Clearing DNS Cache on Scripting Server"
	Clear-DnsClientCache
	#Reboot Guest Reboot VM
	Write-Host "Rebooting VM to attempt to resolve DNS Resolution Issues"
	Get-VM $VMNAME | Restart-VMGuest -Confirm:$false
	Write-Host "Waiting for 20 Seconds for the VM to Restart"
	Start-Sleep -s 20
	##Wait until VM Restarts
	Do     
	{
		$VirtualMachine = Get-VM -Name $VMNAME
		$GuestHostName = $VirtualMachine.ExtensionData.Guest.Hostname
		Write-Host (Get-Date -Format o) "Waiting for VM named:" $VMNAME "to match guest named:" $GuestHostName
		Start-Sleep -s 1
	} 
	Until ($GuestHostName -eq $FQDN)
	##Check if DNS resolves for FQDN of VM
	$CHECKDNS = Resolve-DnsName $FQDN
	Start-Sleep -s 60
	$DNSRESTARTCOUNT++
	IF($DNSRESTARTCOUNT -eq 5)
	{
		Write-Host "VM has been restarted 5x's. DNS of VM will not resolve" -foregroundcolor "red"
		Stop-ScriptNow "VM DNS Will Not Resolve. Canceling all tasks."
	}	
}
Write-Host "VM DNS Resolution is Working Properly for "$FQDN
Write-Host "VM DNS to IP Resolution Check Starting"
$VMIPADDRESS = Get-VM $VMNAME | Select @{Name="IPAddress";Expression={$_.ExtensionData.Guest.IPAddress}}
$VMIPADDRESS = $VMIPADDRESS.IPAddress
Write-Host "VM IP Address is: "$VMIPADDRESS
$DNSIPADDRESS = Resolve-DnsName $FQDN | Select IPAddress
$DNSIPADDRESS = $DNSIPADDRESS.IPAddress
Write-Host "DNS IP Address is: "$DNSIPADDRESS
WHILE($VMIPADDRESS -ne $DNSIPADDRESS)
{
	#Wait a few seconds
	Start-Sleep -s 15
	#Check if DNS Resolves Now
	$VMIPADDRESS = Get-VM $VMNAME | Select @{Name="IPAddress";Expression={$_.ExtensionData.Guest.IPAddress}}
	$VMIPADDRESS = $VMIPADDRESS.IPAddress
	$DNSIPADDRESS = Resolve-DnsName $FQDN | Select IPAddress
	$DNSIPADDRESS = $DNSIPADDRESS.IPAddress
	##Attempt to update DNS registeristration on Remote VM via WMI
	Write-Host "Attempting to remotely register VM with DNS"
	$VMIPADDRESS = Get-VM $VMNAME | Select @{Name="IPAddress";Expression={$_.ExtensionData.Guest.IPAddress}}
	$VMIPADDRESS = $VMIPADDRESS.IPAddress
	Invoke-WmiMethod -class Win32_process -name Create -ArgumentList ("cmd.exe /c ipconfig /registerdns") -ComputerName $VMIPADDRESS -Credential $MyDomainCredential
	Start-Sleep -s 15
	##Restarting VM
	Write-Host "Rebooting VM to attempt to resolve DNS Resolution Issues"
	Get-VM $VMNAME | Restart-VMGuest -Confirm:$false
	##Wait for VM to complete restart process
	Do     
	{
		$VirtualMachine = Get-VM -Name $VMNAME
		$GuestHostName = $VirtualMachine.ExtensionData.Guest.Hostname
		Write-Host (Get-Date -Format o) "Waiting for VM named:" $VMNAME "to match guest named:" $GuestHostName
		Start-Sleep -s 1
	} 
	Until ($GuestHostName -eq $FQDN)
	##Check IP Resolution
	$VMIPADDRESS = Get-VM $VMNAME | Select @{Name="IPAddress";Expression={$_.ExtensionData.Guest.IPAddress}}
	$VMIPADDRESS = $VMIPADDRESS.IPAddress
	$DNSIPADDRESS = Resolve-DnsName $FQDN | Select IPAddress
	$DNSIPADDRESS = $DNSIPADDRESS.IPAddress
	$IPRESTARTCOUNT++
	IF($IPRESTARTCOUNT -eq 5)
	{
		Write-Host "VM has been restarted 5x's. IP of VM will not resolve to DNS Properly" -foregroundcolor green
		Write-Host "Canceling all tasks" -foregroundcolor red
		Write-Host "VM Process Haulted" -foregroundcolor red
		Write-Host "VM Build Process Failed" -foregroundcolor red -background yellow
		Stop-Transcriptye
		Write-Host "Press any key to end session ..."
		$x = $host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown")
		disconnect-viserver * -confirm:$false
		disconnect-nsxserver * -confirm:$false
		Stop-transcript	
	}
}
Write-Host "VM and DNS IP Addresses Match"
Write-Host "Continuing..."
Write-Host "Verifying VM DNS/IP Resolution Completed"
Write-Host (Get-Date -format "MMM-dd-yyyy_HH-mm-ss")
Write-Host "-----------------------------------------------------------------------------------------------------------------------"

##Invoke Group Policy Update on Remote Server
Write-Host "-----------------------------------------------------------------------------------------------------------------------"
Write-Host (Get-Date -format "MMM-dd-yyyy_HH-mm-ss")
Write-Host "Updating Group Policy for on remote server "$FQDN
#Update PowerShell Window Title
$pswindow.windowtitle = "vDeploy - " + $VMNAME + " - Updating Group Policy for on remote server " + $FQDN
#Note - This requires the Windows Firewall rules for Remote Scheduled Tasks Management Firewall rules be enabled prior. 
#Either via GPO or via set in the Windows Template.
Invoke-GPUpdate -Computer $FQDN -Force -ErrorAction SilentlyContinue
Write-Host "Updating Group Policy for on remote server Completed"
Write-Host (Get-Date -format "MMM-dd-yyyy_HH-mm-ss")
Write-Host "-----------------------------------------------------------------------------------------------------------------------"

############################################Install Client Base Applications/Run Plugins############################################

Write-Host "Installing Applications and Plug-ins that were Selected from MainForm"
$ApplicationList = Import-CSV AppList.csv
$APPRESULTS = @()
$APPELAPSEDTIME = @()
$APPINSTALLED = @()
ForEach($Application in $ApplicationList)
{
	$APPLICATIONNAME = $Application.Name
	IF($APPLIST -contains $APPLICATIONNAME)
	{
		Write-Host "-----------------------------------------------------------------------------------------------------------------------"
		Write-Host (Get-Date -format "MMM-dd-yyyy_HH-mm-ss")
		$APPSTARTTIMESW = [Diagnostics.Stopwatch]::StartNew()
		$APPNAME = $Application.NAME
		$APPINSTALLED+=$APPNAME
		Write-Host "Application/Plug-in Installation/configuration starting for "$APPNAME
		#Update PowerShell Window Title
		$pswindow.windowtitle = "vDeploy - " + $VMNAME + " - App/Plug-in Install/config running for " + $APPNAME
		$APPLOCATION = $Application.Location
		$SOURCEINSTALLLOCATION = $pwd.path + $APPLOCATION
		$SOURCEVMSCRIPTS = $pwd.path + $APPLOCATION + '\VMware'
		$SOURCELOCALFILES = $pwd.path + $APPLOCATION + '\Local'
		$SOURCEVERIFYSCRIPTS = $pwd.path + $APPLOCATION + '\Verify'
		$INSTALLERDESTINATION = 'C:' + $APPLOCATION
		##Check if Local Files. If they do copy them to the New VM.
		$DirectoryInfo = Get-ChildItem $SOURCELOCALFILES | Measure-Object
		IF($DirectoryInfo.count -ne 0)
		{
			##Copy Local Files to VM to be processed
			Write-Host "Copying files for App "$APPNAME" to VM "$VMNAME" at folder location "$INSTALLERDESTINATION
			Copy-VMGuestFile -Source $SOURCELOCALFILES  -Destination $INSTALLERDESTINATION -VM $VMNAME -LocalToGuest -GuestCredential $MYDOMAINCREDENTIAL -FORCE -Confirm:$false
		}
		##Document all PowerShell files that need to be run from the VMware Folder
		Write-Host "Documenting all VMware PowerShell Scripts that will be run for this Application/Plug-in"$APPNAME
		$SOURCEVMDIR = Get-ChildItem $SOURCEVMSCRIPTS
		$PS1LIST = $SOURCEVMDIR | where {$_.extension -eq ".ps1"}
		Write-Host "Starting Install/Configuration Scripts for "$APPNAME
		ForEach($PSFILE in $PS1List)
		{
			Write-Host "#######################################################################################################################" -foregroundcolor "white" -backgroundcolor "green"
			Write-Host (Get-Date -format "MMM-dd-yyyy_HH-mm-ss")
			$PSFULLNAME  = $PSFILE.FULLNAME
			Write-Host "Importing Script"$PSFULLNAME -foregroundcolor "cyan"
			$TEXT = Get-Content $PSFULLNAME -RAW
			$TEXT = $TEXT #Fill in any variables that are already specified in file and already present in parent script
			Write-Host "Running Script "$PSFULLNAME -foregroundcolor "green"
			Invoke-Expression $TEXT
			Write-Host "Completed Script "$PSFULLNAME -foregroundcolor "green"
			Write-Host (Get-Date -format "MMM-dd-yyyy_HH-mm-ss")
			Write-Host "#######################################################################################################################" -foregroundcolor "white" -backgroundcolor "green"
		}
		Write-Host "Install/Configuration Scripts for "$APPNAME" Completed"
		##Document all PowerShell files that need to be run from the Verify Folder
		Write-Host "Documenting all Verification PowerShell Scripts that will be run for this Application/Plug-in"
		$SOURCEVERIFYDIR = Get-ChildItem $SOURCEVERIFYSCRIPTS
		$PS1LIST = $SOURCEVERIFYDIR | where {$_.extension -eq ".ps1"}
		Write-Host "Starting Verification Scripts for "$APPNAME
		ForEach($PSFILE in $PS1List)
		{
			Write-Host "***********************************************************************************************************************" -foregroundcolor "white" -backgroundcolor "cyan"
			Write-Host (Get-Date -format "MMM-dd-yyyy_HH-mm-ss")
			$PSFULLNAME  = $PSFILE.FULLNAME
			Write-Host "Importing Script "$PSFULLNAME -foregroundcolor "cyan"
			$TEXT = Get-Content $PSFULLNAME -RAW
			$TEXT = $TEXT #Fill in any variables that are already specified in file and already present in parent script
			Write-Host "Running Script "$PSFULLNAME -foregroundcolor "green"
			Invoke-Expression $TEXT
			Write-Host "Completed Script "$PSFULLNAME -foregroundcolor "green"
			Write-Host (Get-Date -format "MMM-dd-yyyy_HH-mm-ss")
			Write-Host "***********************************************************************************************************************" -foregroundcolor "white" -backgroundcolor "cyan"
		}
		Write-Host "Verification Scripts for "$APPNAME" Completed"
		##Adding Email Addresses to be emailed for each Application
		IF($Application.AddToEmail -ne "")
		{
			Write-Host "Adding Email Address(s) to Email Notification based on Application selected "$APPNAME
			$MSGTO = $MSGTO + "," + $Application.AddToEmail
		}
		Write-Host (Get-Date -format "MMM-dd-yyyy_HH-mm-ss")
		Write-Host "-----------------------------------------------------------------------------------------------------------------------"
		$APPSTARTTIMESW.STOP()
		$APPELAPSEDTIME+= $APPNAME + " elapsed install time: " + $APPSTARTTIMESW.Elapsed.TotalMinutes + " Minutes"
	}
}
Write-Host "All Applications and Plug-ins Installed and Verified" -foregroundcolor "magenta"

############################################All Install Processes Completed#################################################################

##Post All Processes Reboot
Write-Host "-----------------------------------------------------------------------------------------------------------------------"
Write-Host (Get-Date -format "MMM-dd-yyyy_HH-mm-ss")
Write-Host "Rebooting VM Post All Processes"
#Update PowerShell Window Title
$pswindow.windowtitle = "vDeploy - " + $VMNAME + " - Rebooting VM Post All Processes"
Get-VM $VMNAME | Restart-VMGuest -Confirm:$false
##Wait for VM to complete restart process
Start-Sleep -s 15
Write-Host "Starting VM Reboot Monitoring"
Do     
{
	$VirtualMachine = Get-VM -Name $VMNAME
	$GuestHostName = $VirtualMachine.ExtensionData.Guest.Hostname
	Write-Host (Get-Date -Format o) "Waiting for VM named:" $VMNAME "to match guest named:" $GuestHostName
	Start-Sleep -s 1
} 
Until ($GuestHostName -eq $FQDN)
Start-Sleep -s 15
Write-Host "Rebooting VM Post All Processes Completed"
Write-Host (Get-Date -format "MMM-dd-yyyy_HH-mm-ss")
Write-Host "-----------------------------------------------------------------------------------------------------------------------"

############################################Gathering Post Information######################################################################

##Document New VM Details
Write-Host "-----------------------------------------------------------------------------------------------------------------------"
Write-Host (Get-Date -format "MMM-dd-yyyy_HH-mm-ss")
Write-Host "Getting Current Info from new VM "$VMNAME
#Update PowerShell Window Title
$pswindow.windowtitle = "vDeploy - " + $VMNAME + " - Getting Current Info for new VM"
$VMPOST = Get-VM -Name $VMNAME | Select *
$VMHOSTPOST = Get-VM -Name $VMNAME | Get-VMHost
Write-Host "Getting Current Info from new VM "$VMNAME" Completed"
Write-Host (Get-Date -format "MMM-dd-yyyy_HH-mm-ss")
Write-Host "-----------------------------------------------------------------------------------------------------------------------"

##Document MAC Address(es) of New VM
Write-Host "-----------------------------------------------------------------------------------------------------------------------"
Write-Host (Get-Date -format "MMM-dd-yyyy_HH-mm-ss")
Write-Host "Getting MAC Address(es) of new VM "$VMNAME
#Update PowerShell Window Title
$pswindow.windowtitle = "vDeploy - " + $VMNAME + " - Getting MAC Address(es) of new VM"
$MACADDRESSES = (Get-VM $VMNAME) | Get-NetworkAdapter | Select MacAddress
$MACADDRESSES = $MACADDRESSES.MacAddress
Write-Host "Getting MAC Address(es) of new VM "$VMNAME" Completed"
Write-Host (Get-Date -format "MMM-dd-yyyy_HH-mm-ss")
Write-Host "-----------------------------------------------------------------------------------------------------------------------"

##Document Hard Disk Info of New VM
Write-Host "-----------------------------------------------------------------------------------------------------------------------"
Write-Host (Get-Date -format "MMM-dd-yyyy_HH-mm-ss")
Write-Host "Getting Hard Disk info of new VM "$VMNAME
#Update PowerShell Window Title
$pswindow.windowtitle = "vDeploy - " + $VMNAME + " - Getting Hard Disk info of new VM"
$VMDISKCOUNT = (Get-VM $VMNAME | Get-HardDisk).count
$VMDISKCAPACITY = (Get-VM $VMNAME | Get-HardDisk).CapacityGB
Write-Host "Getting Hard Disk info of new VM "$VMNAME" Completed"
Write-Host (Get-Date -format "MMM-dd-yyyy_HH-mm-ss")
Write-Host "-----------------------------------------------------------------------------------------------------------------------"

############################################Ending all Processes/disconnecting######################################################

##Disconnect from PS Session
Write-Host "-----------------------------------------------------------------------------------------------------------------------"
Write-Host (Get-Date -format "MMM-dd-yyyy_HH-mm-ss")
Write-Host "Disconnect and Remove from Existing PS Sessions"
#Update PowerShell Window Title
$pswindow.windowtitle = "vDeploy - " + $VMNAME + " - Disconnect and Remove from Existing PS Sessions"
Get-PSSession | Disconnect-PSSession -ErrorAction SilentlyContinue
Get-PSSession | Remove-PSSession -ErrorAction SilentlyContinue
Write-Host "Disconnect and Remove from PS Session Completed"
Write-Host (Get-Date -format "MMM-dd-yyyy_HH-mm-ss")
Write-Host "-----------------------------------------------------------------------------------------------------------------------"

##Disconnect from vCenter
Write-Host "-----------------------------------------------------------------------------------------------------------------------"
Write-Host (Get-Date -format "MMM-dd-yyyy_HH-mm-ss")
Write-Host "Disconnecting from vCenter"
#Update PowerShell Window Title
$pswindow.windowtitle = "vDeploy - " + $VMNAME + " - Disconnecting from vCenter"
disconnect-viserver $vCenter -confirm:$false
IF ($NSXMANAGER)
{
Write-Host "Disconnecting from NSX Manager"
Disconnect-NSXServer -NSXServer $NSXMANAGER -Confirm:$false
}
Write-Host (Get-Date -format "MMM-dd-yyyy_HH-mm-ss")
Write-Host "-----------------------------------------------------------------------------------------------------------------------"

##Building Email Body
Write-Host "-----------------------------------------------------------------------------------------------------------------------"
Write-Host (Get-Date -format "MMM-dd-yyyy_HH-mm-ss")
#Stopping Script Timer
Write-Host "Stopping Script Timer"
$STARTTIMESW.STOP()
$CompletionTime = Get-Date -format "MMM-dd-yyyy HH-mm-ss"

#Creating Email Body
Write-Host "Creating Email Body for Reporting"
$EMAILBODY =@()

#Main Detail
$EMAILBODY += "Attached is the log file from this VM Build Process for <b>" + $VMNAME + "</b>"
$EMAILBODY += ""
$EMAILBODY += "New VM <b>" + $VMNAME + "</b> Build Creation : <u><b>"  + $BUILDVERIFY  + "</b></u>"
$EMAILBODY += ""

##VM Detail
$EMAILBODY += "<u>VM Info</u>"
$EMAILBODY += "VM Name : " + [string]$VMNAME
$EMAILBODY += "VM Domain : " + [string]$DOMAIN
$EMAILBODY += "VM vCPU(s) : " + [string]$VCPUS
$EMAILBODY += "VM RAM : " + [string]$RAM + " GBs"
$EMAILBODY += "VM Template : " + $TEMPLATE.Name
$EMAILBODY += "VM HW Version : " + $VMPOST.Version
$EMAILBODY += "VM Datacenter : " + [string]$DATACENTER
$EMAILBODY += "VM Cluster : " + [string]$CLUSTER
$EMAILBODY += "VM DRS Site : " + [string]$SITE
$EMAILBODY += "VM Port Group : " + [string]$PORTGROUP
$EMAILBODY += "VM Datastore : " + $DATASTORE.Name
$EMAILBODY += "VM HD Type : " + [string]$VMTYPE
$EMAILBODY += "VM HD Count : " + [string]$VMDISKCOUNT 
$EMAILBODY += "VM HD Capacity(s) : " + ($VMDISKCAPACITY -Join ", ") + " GBs"
$EMAILBODY += "VM OS Customization : " + [string]$OSCUSTOMIZATION
$EMAILBODY += "VM Folder : " + [string]$VMFOLDER
$EMAILBODY += "VM Owner(s) : " + [string]$OWNER
$EMAILBODY += "VM Notes : " + [string]$NOTES 
$EMAILBODY += "VM TAGS : " + (($APPLIEDVMTAGS | Sort-Object) -Join ", ")
$EMAILBODY += "VM TAGS Applied for Apps : " + (($APPLIEDVMAPPTAGS | Sort-Object) -Join ", ")
$EMAILBODY += "DEV : " + $DEV
$EMAILBODY += "PCI : " + $PCI
$EMAILBODY += "DMZ : " + $DMZ
$EMAILBODY += "VM replace : " + $VMREPLACE
IF ($VMREPLACE -eq $true)
{
	$EMAILBODY += "Original VM : " + $VMNAMEREPLACE
}
$EMAILBODY += "VM Current Host : " + ($VMHOSTPOST.Name)
$EMAILBODY += "VM VMware Tools Version : " + ($VMPOST.Guest.ToolsVersion)
$EMAILBODY += "VM VMware Tools Build Version : " + ($VMPOST.Guest.ExtensionData.ToolsVersion)
$EMAILBODY += "VM Current IPv4 Address : " + ($VMPOST.Guest.IPAddress | where {([IPAddress]$_).AddressFamily -eq [System.Net.Sockets.AddressFamily]::InterNetwork})
$EMAILBODY += "VM MacAddress(es) include: " + ($MACADDRESSES -Join ", ")
$EMAILBODY += "VM Current DNS Name is : " + ($VMPOST.Guest.HostName)
$EMAILBODY += ""

##NSX Detail
#IF NSX TAGs were Applied
IF($APPLIEDNSXTAGS.SecurityTag)
{
	$EMAILBODY += "<u>NSX Info</u>"
	$EMAILBODY += "NSX Tags : " + (($APPLIEDNSXTAGS.SecurityTag | Sort-Object) -Join ", ")
	$EMAILBODY += "NSX Tags Applied for Apps : " + (($APPNSXTAGS_List | Sort-Object) -Join ", ")
	$EMAILBODY += "NSX Manager : " + $NSXSERVER.Server
	$EMAILBODY += "NSX Manager Version : " + $NSXSERVER.Version
	$EMAILBODY += "NSX Manager Build Version : " + $NSXSERVER.BuildNumber
	$EMAILBODY += "NSX Cluster Version : " + $NSXCLUSTERVERSION
	$EMAILBODY += ""
}

##Application Detail
$EMAILBODY += "<u>Application/Plug-in Info</u>"
$EMAILBODY += "Applications/Plug-ins Installed Include : " 
$EMAILBODY += ($APPINSTALLED -Join "`r`n")
$EMAILBODY += ""

##Application Verification
$EMAILBODY += "<u>Application Verification</u>"
$EMAILBODY += ($APPRESULTS -Join "`r`n")
$EMAILBODY += ""

##Application Elapsed Time
$EMAILBODY += "<u>Application Elapsed Time</u>"
$EMAILBODY += ($APPELAPSEDTIME -Join "`r`n")
$EMAILBODY += ""

##vCenter Information
$EMAILBODY += "<u>vCenter Info</u>"
$EMAILBODY += "vCenter Server Name : " + $VISERVER.NAME
$EMAILBODY += "vCenter Server Version : " + $VISERVER.VERSION
$EMAILBODY += "vCenter Server Build Version : " + $VISERVER.BUILD
$EMAILBODY += ""

##VM Build Host Information
$EMAILBODY += "<u>VM Build Host Info</u>"
$EMAILBODY += "VM Build Host : " + $VMHOSTDETAILS.NAME
$EMAILBODY += "VM Build Host ESXi Version : " + $VMHOSTDETAILS.Version
$EMAILBODY += "VM Build Host ESXi Build Version : " + $VMHOSTDETAILS.Build
$EMAILBODY += ""

#Total Script Run Time Details
$EMAILBODY += "<u>Build Info</u>"
$EMAILBODY += "Start Time : " + $StartTime
$EMAILBODY += "Completion Time : " + $CompletionTime
$EMAILBODY += "Total Build Run Time : " + $STARTTIMESW.Elapsed.TotalMinutes + " Minutes"
$EMAILBODY += "Total VM Clone Time : " + $STARTTIMECLONESW.Elapsed.TotalMinutes + " Minutes"
$EMAILBODY += "Total VM Clone/Configuration Time : " + $VMSTARTTIMESW.Elapsed.TotalMinutes + " Minutes"
$EMAILBODY += "Total VM SysPrep Time : " + $VMSYSPREPSTARTTIMESW.Elapsed.TotalMinutes + " Minutes"
$EMAILBODY += "VM Built By : " + $SERVERBUILDER
$EMAILBODY += "VM Built by Script Server : " + ([System.Net.Dns]::GetHostByName(($env:computerName))).HostName
$EMAILBODY += ""

#Stating VM was deployed with vDeploy
$EMAILBODY += "VM deployed with vDeploy"
Write-Host "Email Body will be: "
Write-Host ($EMAILBODY -Join "`n")
Write-Host (Get-Date -format "MMM-dd-yyyy_HH-mm-ss")
Write-Host "-----------------------------------------------------------------------------------------------------------------------"

##Export Email Body to CSV as Email Attachment
Write-Host "-----------------------------------------------------------------------------------------------------------------------"
Write-Host (Get-Date -format "MMM-dd-yyyy_HH-mm-ss")
Write-Host "Export Email Body information to CSV"
$EMAILCSV = $LogBuildsFolder+"\"+$VMNAME+"_"+$CompletionTime+".csv"
$EMAILBODY | Out-File -FilePath $EMAILCSV
#Import CSV to fix issues with correct formatting of Email Body
Write-Host "Importing Email Body information to Email"
$EMAILBODYIMPORT = Get-Content $EMAILCSV
Write-Host "Export/Import Completed"
Write-Host "-----------------------------------------------------------------------------------------------------------------------"
Write-Host (Get-Date -format "MMM-dd-yyyy_HH-mm-ss")

##Stopping Logging
#Note: Must stop transcriptting prior to sending email report with attached log file
Write-Host "-----------------------------------------------------------------------------------------------------------------------"
Write-Host (Get-Date -format "MMM-dd-yyyy_HH-mm-ss")
Write-Host "All Processes Completed"
Write-Host "Stopping Transcript"
#Update PowerShell Window Title
$pswindow.windowtitle = "vDeploy - " + $VMNAME + " - Stopping Transcript"
Write-Host (Get-Date -format "MMM-dd-yyyy_HH-mm-ss")
Write-Host "-----------------------------------------------------------------------------------------------------------------------"
Stop-Transcript

############################################Emailing Results and Ending Script######################################################

##Send Email Report
IF ($SMTPSERVER){
	#Update PowerShell Window Title
	$pswindow.windowtitle = "vDeploy - " + $VMNAME + " - Sending Email Results"
	$att = new-object Net.Mail.Attachment($LOGFILE)
	$att2 = new-object Net.Mail.Attachment($EMAILCSV)
	$msg = new-object Net.Mail.MailMessage
	$smtp = new-object Net.Mail.SmtpClient($SMTPSERVER, $SMTPPORT)
	$msg.IsBodyHTML = $true
	$msg.From = $MSGFROM
	$msg.To.Add($MSGTO)
	$msg.Subject = "VM Build Process for  " + $VMNAME + " - Completed"
	$msg.Body = ($EMAILBODYIMPORT -Join "<br>")
	$msg.Attachments.Add($att)
	$msg.Attachments.Add($att2)
	IF($SMTPENABLESSL -eq "False")
	{
		$smtp.EnableSSL = $false
	}ELSE{
		$smtp.EnableSSL = $true
	}
	IF($SMTPCREDENTIAL)
	{
		$smtp.credentials = New-Object System.Net.NetworkCredential( $SMTPCREDENTIAL.UserName , $SMTPCREDENTIAL.password );
	}
	$smtp.Send($msg)
}

##Reporting Completion
#Comment the below out if you just want the script to close when done
[System.Reflection.Assembly]::LoadWithPartialName("Microsoft.VisualBasic") | Out-Null
[Microsoft.VisualBasic.Interaction]::MsgBox("vDeploy Processing Completed.
Press OK to End this Script.", "OKOnly,SystemModal,Information", "Success")
