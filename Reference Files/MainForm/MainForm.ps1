##Create Function Get-FolderPath
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
$CLUSTERS = Get-Cluster *
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
$MainForm.ClientSize = (New-Object -TypeName System.Drawing.Size -ArgumentList @([System.Int32]457,[System.Int32]778))
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
$vCenterTextBox.Location = (New-Object -TypeName System.Drawing.Point -ArgumentList @([System.Int32]113,[System.Int32]11))
$vCenterTextBox.Name = 'vCenterTextBox'
$vCenterTextBox.ReadOnly = $true
$vCenterTextBox.Size = (New-Object -TypeName System.Drawing.Size -ArgumentList @([System.Int32]333,[System.Int32]20))
$vCenterTextBox.TabIndex = [System.Int32]23
$vCenterTextBox.TabStop = $false
$vCenterTextBox.Text = $vCenter

#NSXManagerTextBox
$NSXManagerTextBox = (New-Object -TypeName System.Windows.Forms.TextBox)
$NSXManagerTextBox.BackColor = [System.Drawing.SystemColors]::InactiveCaption
$NSXManagerTextBox.Location = (New-Object -TypeName System.Drawing.Point -ArgumentList @([System.Int32]113,[System.Int32]37))
$NSXManagerTextBox.Name = 'NSXManagerTextBox'
$NSXManagerTextBox.ReadOnly = $true
$NSXManagerTextBox.Size = (New-Object -TypeName System.Drawing.Size -ArgumentList @([System.Int32]333,[System.Int32]20))
$NSXManagerTextBox.TabIndex = [System.Int32]24
$NSXManagerTextBox.TabStop = $false

#label1
$label1 = (New-Object -TypeName System.Windows.Forms.Label)
$label1.AutoSize = $true
$label1.Location = (New-Object -TypeName System.Drawing.Point -ArgumentList @([System.Int32]14,[System.Int32]14))
$label1.Name = 'label1'
$label1.Size = (New-Object -TypeName System.Drawing.Size -ArgumentList @([System.Int32]44,[System.Int32]13))
$label1.TabIndex = [System.Int32]4
$label1.Text = 'vCenter'

#label2
$label2 = (New-Object -TypeName System.Windows.Forms.Label)
$label2.AutoSize = $true
$label2.Location = (New-Object -TypeName System.Drawing.Point -ArgumentList @([System.Int32]13,[System.Int32]40))
$label2.Name = 'label2'
$label2.Size = (New-Object -TypeName System.Drawing.Size -ArgumentList @([System.Int32]74,[System.Int32]13))
$label2.TabIndex = [System.Int32]5
$label2.Text = 'NSX Manager'

#label3
$label3 = (New-Object -TypeName System.Windows.Forms.Label)
$label3.AutoSize = $true
$label3.Location = (New-Object -TypeName System.Drawing.Point -ArgumentList @([System.Int32]15,[System.Int32]70))
$label3.Name = 'label3'
$label3.Size = (New-Object -TypeName System.Drawing.Size -ArgumentList @([System.Int32]54,[System.Int32]13))
$label3.TabIndex = [System.Int32]7
$label3.Text = 'VM Name'

#label4
$label4 = (New-Object -TypeName System.Windows.Forms.Label)
$label4.AutoSize = $true
$label4.Location = (New-Object -TypeName System.Drawing.Point -ArgumentList @([System.Int32]305,[System.Int32]70))
$label4.Name = 'label4'
$label4.Size = (New-Object -TypeName System.Drawing.Size -ArgumentList @([System.Int32]138,[System.Int32]13))
$label4.TabIndex = [System.Int32]83
$label4.Text = '(Maximum of 15 Characters)'

#label5
$label5 = (New-Object -TypeName System.Windows.Forms.Label)
$label5.AutoSize = $true
$label5.Location = (New-Object -TypeName System.Drawing.Point -ArgumentList @([System.Int32]13,[System.Int32]95))
$label5.Name = 'label5'
$label5.Size = (New-Object -TypeName System.Drawing.Size -ArgumentList @([System.Int32]56,[System.Int32]13))
$label5.TabIndex = [System.Int32]10
$label5.Text = '# of CPUs'

#label6
$label6 = (New-Object -TypeName System.Windows.Forms.Label)
$label6.AutoSize = $true
$label6.Location = (New-Object -TypeName System.Drawing.Point -ArgumentList @([System.Int32]13,[System.Int32]121))
$label6.Name = 'label6'
$label6.Size = (New-Object -TypeName System.Drawing.Size -ArgumentList @([System.Int32]66,[System.Int32]13))
$label6.TabIndex = [System.Int32]12
$label6.Text = 'GBs of RAM'

#label7
$label7 = (New-Object -TypeName System.Windows.Forms.Label)
$label7.AutoSize = $true
$label7.Location = (New-Object -TypeName System.Drawing.Point -ArgumentList @([System.Int32]13,[System.Int32]201))
$label7.Name = 'label7'
$label7.Size = (New-Object -TypeName System.Drawing.Size -ArgumentList @([System.Int32]82,[System.Int32]13))
$label7.TabIndex = [System.Int32]20
$label7.Text = 'VM Designation'

#label8
$label8 = (New-Object -TypeName System.Windows.Forms.Label)
$label8.AutoSize = $true
$label8.Location = (New-Object -TypeName System.Drawing.Point -ArgumentList @([System.Int32]14,[System.Int32]661))
$label8.Name = 'label8'
$label8.Size = (New-Object -TypeName System.Drawing.Size -ArgumentList @([System.Int32]50,[System.Int32]13))
$label8.TabIndex = [System.Int32]62
$label8.Text = 'VM Tags'

#label9
$label9 = (New-Object -TypeName System.Windows.Forms.Label)
$label9.AutoSize = $true
$label9.Location = (New-Object -TypeName System.Drawing.Point -ArgumentList @([System.Int32]15,[System.Int32]255))
$label9.Name = 'label9'
$label9.Size = (New-Object -TypeName System.Drawing.Size -ArgumentList @([System.Int32]44,[System.Int32]13))
$label9.TabIndex = [System.Int32]22
$label9.Text = 'VM Site'

#label10
$label10 = (New-Object -TypeName System.Windows.Forms.Label)
$label10.AutoSize = $true
$label10.Location = (New-Object -TypeName System.Drawing.Point -ArgumentList @([System.Int32]15,[System.Int32]282))
$label10.Name = 'label10'
$label10.Size = (New-Object -TypeName System.Drawing.Size -ArgumentList @([System.Int32]39,[System.Int32]13))
$label10.TabIndex = [System.Int32]24
$label10.Text = 'Cluster'

#label11
$label11 = (New-Object -TypeName System.Windows.Forms.Label)
$label11.AutoSize = $true
$label11.Location = (New-Object -TypeName System.Drawing.Point -ArgumentList @([System.Int32]15,[System.Int32]309))
$label11.Name = 'label11'
$label11.Size = (New-Object -TypeName System.Drawing.Size -ArgumentList @([System.Int32]29,[System.Int32]13))
$label11.TabIndex = [System.Int32]26
$label11.Text = 'Host'

#label12
$label12 = (New-Object -TypeName System.Windows.Forms.Label)
$label12.AutoSize = $true
$label12.Location = (New-Object -TypeName System.Drawing.Point -ArgumentList @([System.Int32]15,[System.Int32]336))
$label12.Name = 'label12'
$label12.Size = (New-Object -TypeName System.Drawing.Size -ArgumentList @([System.Int32]58,[System.Int32]13))
$label12.TabIndex = [System.Int32]28
$label12.Text = 'Port Group'

#label13
$label13 = (New-Object -TypeName System.Windows.Forms.Label)
$label13.AutoSize = $true
$label13.Location = (New-Object -TypeName System.Drawing.Point -ArgumentList @([System.Int32]15,[System.Int32]363))
$label13.Name = 'label13'
$label13.Size = (New-Object -TypeName System.Drawing.Size -ArgumentList @([System.Int32]53,[System.Int32]13))
$label13.TabIndex = [System.Int32]30
$label13.Text = 'Datastore'

#label14
$label14 = (New-Object -TypeName System.Windows.Forms.Label)
$label14.AutoSize = $true
$label14.Location = (New-Object -TypeName System.Drawing.Point -ArgumentList @([System.Int32]15,[System.Int32]390))
$label14.Name = 'label14'
$label14.Size = (New-Object -TypeName System.Drawing.Size -ArgumentList @([System.Int32]90,[System.Int32]13))
$label14.TabIndex = [System.Int32]32
$label14.Text = 'OS Customization'

#label15
$label15 = (New-Object -TypeName System.Windows.Forms.Label)
$label15.AutoSize = $true
$label15.Location = (New-Object -TypeName System.Drawing.Point -ArgumentList @([System.Int32]15,[System.Int32]417))
$label15.Name = 'label15'
$label15.Size = (New-Object -TypeName System.Drawing.Size -ArgumentList @([System.Int32]50,[System.Int32]13))
$label15.TabIndex = [System.Int32]34
$label15.Text = 'VM HD Type'

#label16
$label16 = (New-Object -TypeName System.Windows.Forms.Label)
$label16.AutoSize = $true
$label16.Location = (New-Object -TypeName System.Drawing.Point -ArgumentList @([System.Int32]15,[System.Int32]444))
$label16.Name = 'label16'
$label16.Size = (New-Object -TypeName System.Drawing.Size -ArgumentList @([System.Int32]80,[System.Int32]13))
$label16.TabIndex = [System.Int32]36
$label16.Text = 'VM Folder Path'

#label17
$label17 = (New-Object -TypeName System.Windows.Forms.Label)
$label17.AutoSize = $true
$label17.Location = (New-Object -TypeName System.Drawing.Point -ArgumentList @([System.Int32]15,[System.Int32]470))
$label17.Name = 'label17'
$label17.Size = (New-Object -TypeName System.Drawing.Size -ArgumentList @([System.Int32]54,[System.Int32]13))
$label17.TabIndex = [System.Int32]38
$label17.Text = 'VM Notes'

#label18
$label18 = (New-Object -TypeName System.Windows.Forms.Label)
$label18.AutoSize = $true
$label18.Location = (New-Object -TypeName System.Drawing.Point -ArgumentList @([System.Int32]15,[System.Int32]496))
$label18.Name = 'label18'
$label18.Size = (New-Object -TypeName System.Drawing.Size -ArgumentList @([System.Int32]68,[System.Int32]13))
$label18.TabIndex = [System.Int32]40
$label18.Text = 'VM Owner(s)'

#label19
$label19 = (New-Object -TypeName System.Windows.Forms.Label)
$label19.AutoSize = $true
$label19.Location = (New-Object -TypeName System.Drawing.Point -ArgumentList @([System.Int32]13,[System.Int32]148))
$label19.Name = 'label19'
$label19.Size = (New-Object -TypeName System.Drawing.Size -ArgumentList @([System.Int32]70,[System.Int32]13))
$label19.TabIndex = [System.Int32]42
$label19.Text = 'VM Template'

#label20
$label20 = (New-Object -TypeName System.Windows.Forms.Label)
$label20.AutoSize = $true
$label20.Location = (New-Object -TypeName System.Drawing.Point -ArgumentList @([System.Int32]15,[System.Int32]711))
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
$label22.Location = (New-Object -TypeName System.Drawing.Point -ArgumentList @([System.Int32]15,[System.Int32]535))
$label22.Name = 'label22'
$label22.Size = (New-Object -TypeName System.Drawing.Size -ArgumentList @([System.Int32]54,[System.Int32]13))
$label22.TabIndex = [System.Int32]48
$label22.Text = 'Apps to Install'

#label23
$label23 = (New-Object -TypeName System.Windows.Forms.Label)
$label23.AutoSize = $true
$label23.Location = (New-Object -TypeName System.Drawing.Point -ArgumentList @([System.Int32]15,[System.Int32]573))
$label23.Name = 'label23'
$label23.Size = (New-Object -TypeName System.Drawing.Size -ArgumentList @([System.Int32]80,[System.Int32]13))
$label23.TabIndex = [System.Int32]51
$label23.Text = 'Override DHCP'

#label24
$label24 = (New-Object -TypeName System.Windows.Forms.Label)
$label24.AutoSize = $true
$label24.Location = (New-Object -TypeName System.Drawing.Point -ArgumentList @([System.Int32]70,[System.Int32]593))
$label24.Name = 'label24'
$label24.Visible = $false
$label24.Size = (New-Object -TypeName System.Drawing.Size -ArgumentList @([System.Int32]17,[System.Int32]13))
$label24.TabIndex = [System.Int32]54
$label24.Text = 'IP'

#label25
$label25 = (New-Object -TypeName System.Windows.Forms.Label)
$label25.AutoSize = $true
$label25.Location = (New-Object -TypeName System.Drawing.Point -ArgumentList @([System.Int32]185,[System.Int32]593))
$label25.Name = 'label25'
$label25.Visible = $false
$label25.Size = (New-Object -TypeName System.Drawing.Size -ArgumentList @([System.Int32]41,[System.Int32]13))
$label25.TabIndex = [System.Int32]55
$label25.Text = 'Subnet'

#label26
$label26 = (New-Object -TypeName System.Windows.Forms.Label)
$label26.AutoSize = $true
$label26.Location = (New-Object -TypeName System.Drawing.Point -ArgumentList @([System.Int32]325,[System.Int32]593))
$label26.Name = 'label26'
$label26.Visible = $false
$label26.Size = (New-Object -TypeName System.Drawing.Size -ArgumentList @([System.Int32]23,[System.Int32]13))
$label26.TabIndex = [System.Int32]57
$label26.Text = 'DG'

#label27
$label27 = (New-Object -TypeName System.Windows.Forms.Label)
$label27.AutoSize = $true
$label27.Location = (New-Object -TypeName System.Drawing.Point -ArgumentList @([System.Int32]52,[System.Int32]618))
$label27.Name = 'label27'
$label27.Visible = $false
$label27.Size = (New-Object -TypeName System.Drawing.Size -ArgumentList @([System.Int32]36,[System.Int32]13))
$label27.TabIndex = [System.Int32]58
$label27.Text = 'DNS1'

#label28
$label28 = (New-Object -TypeName System.Windows.Forms.Label)
$label28.AutoSize = $true
$label28.Location = (New-Object -TypeName System.Drawing.Point -ArgumentList @([System.Int32]189,[System.Int32]618))
$label28.Name = 'label28'
$label28.Visible = $false
$label28.Size = (New-Object -TypeName System.Drawing.Size -ArgumentList @([System.Int32]36,[System.Int32]13))
$label28.TabIndex = [System.Int32]60
$label28.Text = 'DNS2'

#VMNameBox
$VMNameBox = (New-Object -TypeName System.Windows.Forms.TextBox)
$VMNameBox.CharacterCasing = [System.Windows.Forms.CharacterCasing]::Upper
$VMNameBox.ImeMode = [System.Windows.Forms.ImeMode]::NoControl
$VMNameBox.Text = $VMNAME
$VMNameBox.Location = (New-Object -TypeName System.Drawing.Point -ArgumentList @([System.Int32]113,[System.Int32]67))
$VMNameBox.MaxLength = [System.Int32]15
$VMNameBox.Name = 'VMNameBox'
$VMNameBox.Size = (New-Object -TypeName System.Drawing.Size -ArgumentList @([System.Int32]190,[System.Int32]20))
$VMNameBox.TabIndex = [System.Int32]0

#CPUnumericUpDown
$CPUnumericUpDown = (New-Object -TypeName System.Windows.Forms.NumericUpDown)
$CPUnumericUpDown.Location = (New-Object -TypeName System.Drawing.Point -ArgumentList @([System.Int32]113,[System.Int32]93))
$CPUnumericUpDown.Value = $VCPUS
$CPUnumericUpDown.Minimum = 1
$CPUnumericUpDown.Maximum = 128
$CPUnumericUpDown.Name = 'CPUnumericUpDown'
$CPUnumericUpDown.Size = (New-Object -TypeName System.Drawing.Size -ArgumentList @([System.Int32]61,[System.Int32]20))
$CPUnumericUpDown.TabIndex = [System.Int32]1

#RAMnumericUpDown
$RAMnumericUpDown = (New-Object -TypeName System.Windows.Forms.NumericUpDown)
$RAMnumericUpDown.AllowDrop = $true
$RAMnumericUpDown.Location = (New-Object -TypeName System.Drawing.Point -ArgumentList @([System.Int32]113,[System.Int32]119))
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
$VMTemplateComboBox.Location = (New-Object -TypeName System.Drawing.Point -ArgumentList @([System.Int32]113,[System.Int32]145))
$VMTemplateComboBox.Name = 'VMTemplateComboBox'
$VMTemplateComboBox.Size = (New-Object -TypeName System.Drawing.Size -ArgumentList @([System.Int32]333,[System.Int32]21))
$VMTemplateComboBox.Text = $TEMPLATE
$VMTemplateComboBox.TabIndex = [System.Int32]3
$VMTemplateComboBox.add_SelectedIndexChanged($comboBox1_SelectedIndexChanged_1)

#DEVcheckBox
$DEVcheckBox = (New-Object -TypeName System.Windows.Forms.CheckBox)
$DEVcheckBox.AutoSize = $true
$DEVcheckBox.Location = (New-Object -TypeName System.Drawing.Point -ArgumentList @([System.Int32]113,[System.Int32]176))
$DEVcheckBox.Name = 'DEVcheckBox'
$DEVcheckBox.Size = (New-Object -TypeName System.Drawing.Size -ArgumentList @([System.Int32]67,[System.Int32]17))
$DEVcheckBox.CheckState = $DEV
$DEVcheckBox.TabIndex = [System.Int32]4
$DEVcheckBox.Text = 'DEV VM'
$DEVcheckBox.UseVisualStyleBackColor = $true

#DMZcheckBox
$DMZcheckBox = (New-Object -TypeName System.Windows.Forms.CheckBox)
$DMZcheckBox.AutoSize = $true
$DMZcheckBox.Location = (New-Object -TypeName System.Drawing.Point -ArgumentList @([System.Int32]113,[System.Int32]199))
$DMZcheckBox.Name = 'DMZcheckBox'
$DMZcheckBox.Size = (New-Object -TypeName System.Drawing.Size -ArgumentList @([System.Int32]69,[System.Int32]17))
$DMZcheckBox.CheckState = $DMZ
$DMZcheckBox.TabIndex = [System.Int32]5
$DMZcheckBox.Text = 'DMZ VM'
$DMZcheckBox.UseVisualStyleBackColor = $true
$DMZcheckBox.add_CheckedChanged($checkBox3_CheckedChanged)

#PCIcheckBox
$PCIcheckBox = (New-Object -TypeName System.Windows.Forms.CheckBox)
$PCIcheckBox.AutoSize = $true
$PCIcheckBox.Location = (New-Object -TypeName System.Drawing.Point -ArgumentList @([System.Int32]113,[System.Int32]222))
$PCIcheckBox.Name = 'PCIcheckBox'
$PCIcheckBox.Size = (New-Object -TypeName System.Drawing.Size -ArgumentList @([System.Int32]62,[System.Int32]17))
$PCIcheckBox.CheckState = $PCI
$PCIcheckBox.TabIndex = [System.Int32]6
$PCIcheckBox.Text = 'PCI VM'
$PCIcheckBox.UseVisualStyleBackColor = $true

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

#ReplaceVMGroupBox
$ReplaceVMGroupBox = (New-Object -TypeName System.Windows.Forms.GroupBox)
$ReplaceVMGroupBox.Controls.Add($label21)
$ReplaceVMGroupBox.Controls.Add($ReplaceVMCheckBox)
$ReplaceVMGroupBox.Controls.Add($ReplacementVMTextBox)
$ReplaceVMGroupBox.Location = (New-Object -TypeName System.Drawing.Point -ArgumentList @([System.Int32]189,[System.Int32]171))
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
$SiteComboBox.Location = (New-Object -TypeName System.Drawing.Point -ArgumentList @([System.Int32]113,[System.Int32]252))
$SiteComboBox.Name = 'SiteComboBox'
$SiteComboBox.Size = (New-Object -TypeName System.Drawing.Size -ArgumentList @([System.Int32]333,[System.Int32]21))
$SiteComboBox.Text = $SITE
$SiteComboBox.TabIndex = [System.Int32]11

#ClusterComboBox
$ClusterComboBox = (New-Object -TypeName System.Windows.Forms.ComboBox)
$ClusterComboBox.DropDownStyle = [System.Windows.Forms.ComboBoxStyle]::DropDownList
$ClusterComboBox.FormattingEnabled = $true
$ClusterComboBox.Items.AddRange($CLUSTERS)
$ClusterComboBox.Location = (New-Object -TypeName System.Drawing.Point -ArgumentList @([System.Int32]113,[System.Int32]279))
$ClusterComboBox.Name = 'ClusterComboBox'
$ClusterComboBox.Size = (New-Object -TypeName System.Drawing.Size -ArgumentList @([System.Int32]333,[System.Int32]21))
$ClusterComboBox.Text = $CLUSTER
$ClusterComboBox_SelectedIndexChanged = {
$CLUSTER = Get-Cluster -Name $ClusterComboBox.Text
$VMHOSTS = Get-Cluster $CLUSTER | Get-VMHost * | where ConnectionState -eq 'Connected'
$HostComboBox.Items.Clear()
$HostComboBox.Items.AddRange($VMHOSTS) 
$HostComboBox.Enabled = $true
$HostComboBox.EndUpdate
}
$ClusterComboBox.add_SelectedIndexChanged($ClusterComboBox_SelectedIndexChanged)
$ClusterComboBox.TabIndex = [System.Int32]12

#HostComboBox
$HostComboBox = (New-Object -TypeName System.Windows.Forms.ComboBox)
$HostComboBox.DropDownStyle = [System.Windows.Forms.ComboBoxStyle]::DropDownList
$HostComboBox.Enabled = $false
$HostComboBox.BeginUpdate
$HostComboBox.FormattingEnabled = $true
$HostComboBox.Location = (New-Object -TypeName System.Drawing.Point -ArgumentList @([System.Int32]113,[System.Int32]306))
$HostComboBox.Name = 'HostComboBox'
$HostComboBox.Size = (New-Object -TypeName System.Drawing.Size -ArgumentList @([System.Int32]333,[System.Int32]21))
$HostComboBox.Text = $VMHOSTSELECTED
$HostComboBox_SelectedIndexChanged = {
#PortGroup
$PORTGROUPS = Get-VMHost $HostComboBox.Text | Get-VirtualPortGroup | Sort-Object Name
$PortGroupComboBox.Items.Clear()
$PortGroupComboBox.Items.AddRange($PORTGROUPS)
$PortGroupComboBox.Enabled = $true
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
$HostComboBox.TabIndex = [System.Int32]13

#PortGroupComboBox
$PortGroupComboBox = (New-Object -TypeName System.Windows.Forms.ComboBox)
$PortGroupComboBox.DropDownStyle = [System.Windows.Forms.ComboBoxStyle]::DropDownList
$PortGroupComboBox.Enabled = $false
$PortGroupComboBox.BeginUpdate
$PortGroupComboBox.FormattingEnabled = $true
$PortGroupComboBox.Location = (New-Object -TypeName System.Drawing.Point -ArgumentList @([System.Int32]112,[System.Int32]333))
$PortGroupComboBox.Name = 'PortGroupComboBox'
$PortGroupComboBox.Size = (New-Object -TypeName System.Drawing.Size -ArgumentList @([System.Int32]333,[System.Int32]21))
$PortGroupComboBox.Text = $PORTGROUP
$PortGroupComboBox_SelectedIndexChanged = {
$DatastoreComboBox.Items.Clear()
$DATASTORES = Get-VMHost $HostComboBox.Text | Get-Datastore * | Sort-Object FreeSpaceGB -Descending | foreach {$_.Name + "  |  " + $_.FreeSpaceGB + "  |  " + $_.CapacityGB}
$DATASTORES = $DATASTORES -replace '@=',''
$DatastoreComboBox.Items.AddRange($DATASTORES)
$DatastoreComboBox.Enabled = $true
$DatastoreComboBox.EndUpdate
}
$PortGroupComboBox.add_SelectedIndexChanged($PortGroupComboBox_SelectedIndexChanged)
$PortGroupComboBox.TabIndex = [System.Int32]14

#DatastoreComboBox
$DatastoreComboBox = (New-Object -TypeName System.Windows.Forms.ComboBox)
$DatastoreComboBox.DropDownStyle = [System.Windows.Forms.ComboBoxStyle]::DropDownList
$DatastoreComboBox.Enabled = $false
$DatastoreComboBox.BeginUpdate
$DatastoreComboBox.FormattingEnabled = $true
$DatastoreComboBox.Location = (New-Object -TypeName System.Drawing.Point -ArgumentList @([System.Int32]112,[System.Int32]360))
$DatastoreComboBox.Name = 'DatastoreComboBox'
$DatastoreComboBox.Size = (New-Object -TypeName System.Drawing.Size -ArgumentList @([System.Int32]333,[System.Int32]21))
$DatastoreComboBox.Text = $DATASTORE
$DatastoreComboBox.add_SelectedIndexChanged($comboBox1_SelectedIndexChanged)
$DatastoreComboBox.TabIndex = [System.Int32]15

#OSCustomizationComboBox
$OSCustomizationComboBox = (New-Object -TypeName System.Windows.Forms.ComboBox)
$OSCustomizationComboBox.DropDownStyle = [System.Windows.Forms.ComboBoxStyle]::DropDownList
$OSCustomizationComboBox.FormattingEnabled = $true
$OSCustomizationComboBox.Items.AddRange($OSCUSTOMIZATIONS)
$OSCustomizationComboBox.Location = (New-Object -TypeName System.Drawing.Point -ArgumentList @([System.Int32]112,[System.Int32]387))
$OSCustomizationComboBox.Name = 'OSCustomizationComboBox'
$OSCustomizationComboBox.Size = (New-Object -TypeName System.Drawing.Size -ArgumentList @([System.Int32]333,[System.Int32]21))
$OSCustomizationComboBox.Text = $OSCUSTOMIZATION
$OSCustomizationComboBox.TabIndex = [System.Int32]16

#VMTypeComboBox
$VMTypeComboBox = (New-Object -TypeName System.Windows.Forms.ComboBox)
$VMTypeComboBox.DropDownStyle = [System.Windows.Forms.ComboBoxStyle]::DropDownList
$VMTypeComboBox.FormattingEnabled = $true
$VMTypeComboBox.Items.AddRange($VMTYPELIST.Name)
$VMTypeComboBox.Location = (New-Object -TypeName System.Drawing.Point -ArgumentList @([System.Int32]112,[System.Int32]414))
$VMTypeComboBox.Name = 'VMTypeComboBox'
$VMTypeComboBox.Size = (New-Object -TypeName System.Drawing.Size -ArgumentList @([System.Int32]333,[System.Int32]21))
$VMTypeComboBox.Text = $VMTYPE
$VMTypeComboBox.TabIndex = [System.Int32]17

#FolderPathComboBox
$FolderPathComboBox = (New-Object -TypeName System.Windows.Forms.ComboBox)
$FolderPathComboBox.DropDownStyle = [System.Windows.Forms.ComboBoxStyle]::DropDownList
$FolderPathComboBox.Enabled = $false
$FolderPathComboBox.FormattingEnabled = $true
$FolderPathComboBox.Location = (New-Object -TypeName System.Drawing.Point -ArgumentList @([System.Int32]112,[System.Int32]441))
$FolderPathComboBox.Name = 'FolderPathComboBox'
$FolderPathComboBox.Size = (New-Object -TypeName System.Drawing.Size -ArgumentList @([System.Int32]333,[System.Int32]21))
$FolderPathComboBox.Text = $VMFOLDER
$FolderPathComboBox.TabIndex = [System.Int32]18

#NotesTextBox
$NotesTextBox = (New-Object -TypeName System.Windows.Forms.TextBox)
$NotesTextBox.ImeMode = [System.Windows.Forms.ImeMode]::NoControl
$NotesTextBox.Location = (New-Object -TypeName System.Drawing.Point -ArgumentList @([System.Int32]112,[System.Int32]467))
$NotesTextBox.MaxLength = [System.Int32]512
$NotesTextBox.Multiline = $true
$NotesTextBox.Name = 'NotesTextBox'
$NotesTextBox.Size = (New-Object -TypeName System.Drawing.Size -ArgumentList @([System.Int32]333,[System.Int32]20))
$NotesTextBox.Text = $NOTES
$NotesTextBox.add_TextChanged($textBox3_TextChanged)
$NotesTextBox.TabIndex = [System.Int32]19

#OwnersTextBox
$OwnersTextBox = (New-Object -TypeName System.Windows.Forms.TextBox)
$OwnersTextBox.ImeMode = [System.Windows.Forms.ImeMode]::NoControl
$OwnersTextBox.Location = (New-Object -TypeName System.Drawing.Point -ArgumentList @([System.Int32]112,[System.Int32]493))
$OwnersTextBox.MaxLength = [System.Int32]256
$OwnersTextBox.Name = 'OwnersTextBox'
$OwnersTextBox.Size = (New-Object -TypeName System.Drawing.Size -ArgumentList @([System.Int32]333,[System.Int32]20))
$OwnersTextBox.Text = $OWNERS
$OwnersTextBox.TabIndex = [System.Int32]20

#AppCheckedListBox
$AppCheckedListBox = (New-Object -TypeName System.Windows.Forms.CheckedListBox)
$AppCheckedListBox.FormattingEnabled = $true
$AppCheckedListBox.Location = (New-Object -TypeName System.Drawing.Point -ArgumentList @([System.Int32]112,[System.Int32]519))
$AppCheckedListBox.Name = 'AppCheckedListBox'
$AppCheckedListBox.Size = (New-Object -TypeName System.Drawing.Size -ArgumentList @([System.Int32]333,[System.Int32]49))
$AppCheckedListBox.Items.AddRange($APPLIST.Name)
FOREACH ($APP in $APPLIST)
{
	$AppCheckedListBox.SetItemChecked([int]$APP.AppOrder, [boolean]$APP.Default)
}
$AppCheckedListBox.TabIndex = [System.Int32]21

#IPTextBox
$IPTextBox = (New-Object -TypeName System.Windows.Forms.TextBox)
$IPTextBox.Location = (New-Object -TypeName System.Drawing.Point -ArgumentList @([System.Int32]88,[System.Int32]590))
$IPTextBox.MaxLength = [System.Int32]15
$IPTextBox.Name = 'IPTextBox'
$IPTextBox.Visible = $false
$IPTextBox.Size = (New-Object -TypeName System.Drawing.Size -ArgumentList @([System.Int32]96,[System.Int32]20))
$IPTextBox.Text = $IP
$IPTextBox.TabIndex = [System.Int32]23

#SubnetTextBox
$SubnetTextBox = (New-Object -TypeName System.Windows.Forms.TextBox)
$SubnetTextBox.Location = (New-Object -TypeName System.Drawing.Point -ArgumentList @([System.Int32]226,[System.Int32]590))
$SubnetTextBox.MaxLength = [System.Int32]15
$SubnetTextBox.Name = 'SubnetTextBox'
$SubnetTextBox.Visible = $false
$SubnetTextBox.Size = (New-Object -TypeName System.Drawing.Size -ArgumentList @([System.Int32]96,[System.Int32]20))
$SubnetTextBox.Text = $SUBNET
$SubnetTextBox.TabIndex = [System.Int32]24

#DGTextBox
$DGTextBox = (New-Object -TypeName System.Windows.Forms.TextBox)
$DGTextBox.Location = (New-Object -TypeName System.Drawing.Point -ArgumentList @([System.Int32]349,[System.Int32]590))
$DGTextBox.MaxLength = [System.Int32]15
$DGTextBox.Name = 'DGTextBox'
$DGTextBox.Visible = $false
$DGTextBox.Size = (New-Object -TypeName System.Drawing.Size -ArgumentList @([System.Int32]96,[System.Int32]20))
$DGTextBox.Text = $DG
$DGTextBox.TabIndex = [System.Int32]25

#DNS1TextBox
$DNS1TextBox = (New-Object -TypeName System.Windows.Forms.TextBox)
$DNS1TextBox.Location = (New-Object -TypeName System.Drawing.Point -ArgumentList @([System.Int32]87,[System.Int32]615))
$DNS1TextBox.MaxLength = [System.Int32]15
$DNS1TextBox.Name = 'DNS1TextBox'
$DNS1TextBox.Visible = $false
$DNS1TextBox.Size = (New-Object -TypeName System.Drawing.Size -ArgumentList @([System.Int32]96,[System.Int32]20))
$DNS1TextBox.Text = $DNS1
$DNS1TextBox.TabIndex = [System.Int32]26

#DNS2TextBox
$DNS2TextBox = (New-Object -TypeName System.Windows.Forms.TextBox)
$DNS2TextBox.Location = (New-Object -TypeName System.Drawing.Point -ArgumentList @([System.Int32]226,[System.Int32]615))
$DNS2TextBox.Name = 'DNS2TextBox'
$DNS2TextBox.Visible = $false
$DNS2TextBox.Size = (New-Object -TypeName System.Drawing.Size -ArgumentList @([System.Int32]96,[System.Int32]20))
$DNS2TextBox.Text = $DNS2
$DNS2TextBox.TabIndex = [System.Int32]27

#OverrideDHCPcheckBox
#Out of Order to correctly set items to enabled with box is checked
$OverrideDHCPcheckBox = (New-Object -TypeName System.Windows.Forms.CheckBox)
$OverrideDHCPcheckBox.AutoSize = $true
$OverrideDHCPcheckBox.Location = (New-Object -TypeName System.Drawing.Point -ArgumentList @([System.Int32]112,[System.Int32]573))
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
$OverrideDHCPcheckBox.TabIndex = [System.Int32]22

#VMTagCheckedListBox
$VMTagCheckedListBox = (New-Object -TypeName System.Windows.Forms.CheckedListBox)
$VMTagCheckedListBox.FormattingEnabled = $true
$VMTagCheckedListBox.HorizontalScrollbar = $true
$VMTagCheckedListBox.Location = (New-Object -TypeName System.Drawing.Point -ArgumentList @([System.Int32]112,[System.Int32]640))
$VMTagCheckedListBox.Name = 'VMTagCheckedListBox'
$VMTagCheckedListBox.Size = (New-Object -TypeName System.Drawing.Size -ArgumentList @([System.Int32]333,[System.Int32]49))
$VMTAGS = Get-Tag | foreach {$_.Name} | Sort-Object
$VMTagCheckedListBox.Items.AddRange($VMTAGS)
$VMTagCheckedListBox.TabIndex = [System.Int32]28

#NSXTagCheckedListBox
$NSXTagCheckedListBox = (New-Object -TypeName System.Windows.Forms.CheckedListBox)
if($DefaultNSXConnection.Server){
$NSXTAGS = Get-NsxSecurityTag | foreach {$_.Name} | Sort-Object
$NSXTagCheckedListBox.Items.AddRange($NSXTAGS) 
$NSXTagCheckedListBox.Enabled = $true
}
$NSXTagCheckedListBox.AccessibleDescription = 'NSX Tags'
$NSXTagCheckedListBox.FormattingEnabled = $true
$NSXTagCheckedListBox.Location = (New-Object -TypeName System.Drawing.Point -ArgumentList @([System.Int32]112,[System.Int32]695))
$NSXTagCheckedListBox.Name = 'NSXTagCheckedListBox'
$NSXTagCheckedListBox.Size = (New-Object -TypeName System.Drawing.Size -ArgumentList @([System.Int32]333,[System.Int32]49))
#Check Default NSX Tags
if($NSXDEFAULTTAGS){
ForEach($NSXDEFAULTTAG in $NSXDEFAULTTAGS)
{
$NewServerInt = [array]::indexof($NSXTAGS, $NSXDEFAULTTAG) #Get Integer for index number of $NSXDEFAULTTAG Tag
$NSXTagCheckedListBox.SetItemChecked($NewServerInt, $true) #Set $NSXDEFAULTTAG Tag as defaulted to True
}
}
$NSXTagCheckedListBox.TabIndex = [System.Int32]29

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
$OKbutton.Location = (New-Object -TypeName System.Drawing.Point -ArgumentList @([System.Int32]162,[System.Int32]750))
$OKbutton.Name = 'OKbutton'
$OKbutton.Size = (New-Object -TypeName System.Drawing.Size -ArgumentList @([System.Int32]75,[System.Int32]23))
$OKbutton.Text = 'OK'
$OKbutton.UseVisualStyleBackColor = $true
$OKbutton.add_Click($OKbutton_Click)
$OKbutton.TabIndex = [System.Int32]30

#Cancel Button Click
$Cancelbutton_Click = { 
$MainForm.DialogResult = 0
$MainForm.Close()
}

#Cancelbutton
$Cancelbutton = (New-Object -TypeName System.Windows.Forms.Button)
$Cancelbutton.Location = (New-Object -TypeName System.Drawing.Point -ArgumentList @([System.Int32]258,[System.Int32]750))
$Cancelbutton.Name = 'Cancelbutton'
$Cancelbutton.Size = (New-Object -TypeName System.Drawing.Size -ArgumentList @([System.Int32]75,[System.Int32]23))
$Cancelbutton.Text = 'Cancel'
$Cancelbutton.UseVisualStyleBackColor = $true
$Cancelbutton.add_Click($Cancelbutton_Click)
$Cancelbutton.TabIndex = [System.Int32]31

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
$MainForm.Controls.Add($ReplaceVMGroupBox)
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
$MainForm.Controls.Add($SiteComboBox)
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
$OUTPUT = "" | Select-Object -Property VMName,VCPUS,RAM,Template,DEV,DMZ,PCI,VMReplace,VMNameReplace,Site,Cluster,VMHost,PortGroup,Datastore,OSCustomization,VMType,VMFolder,Notes,Owner,AppList,OverRideDHCP,IP,Subnet,DG,DNS1,DNS2,VMTags,NSXTags,Cancel
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
$CLUSTERS = Get-Cluster *
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
$MainForm.ClientSize = (New-Object -TypeName System.Drawing.Size -ArgumentList @([System.Int32]457,[System.Int32]778))
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
$vCenterTextBox.Location = (New-Object -TypeName System.Drawing.Point -ArgumentList @([System.Int32]113,[System.Int32]11))
$vCenterTextBox.Name = 'vCenterTextBox'
$vCenterTextBox.ReadOnly = $true
$vCenterTextBox.Size = (New-Object -TypeName System.Drawing.Size -ArgumentList @([System.Int32]333,[System.Int32]20))
$vCenterTextBox.TabIndex = [System.Int32]23
$vCenterTextBox.TabStop = $false
$vCenterTextBox.Text = $vCenter

#NSXManagerTextBox
$NSXManagerTextBox = (New-Object -TypeName System.Windows.Forms.TextBox)
$NSXManagerTextBox.BackColor = [System.Drawing.SystemColors]::InactiveCaption
$NSXManagerTextBox.Location = (New-Object -TypeName System.Drawing.Point -ArgumentList @([System.Int32]113,[System.Int32]37))
$NSXManagerTextBox.Name = 'NSXManagerTextBox'
$NSXManagerTextBox.ReadOnly = $true
$NSXManagerTextBox.Size = (New-Object -TypeName System.Drawing.Size -ArgumentList @([System.Int32]333,[System.Int32]20))
$NSXManagerTextBox.TabIndex = [System.Int32]24
$NSXManagerTextBox.TabStop = $false

#label1
$label1 = (New-Object -TypeName System.Windows.Forms.Label)
$label1.AutoSize = $true
$label1.Location = (New-Object -TypeName System.Drawing.Point -ArgumentList @([System.Int32]14,[System.Int32]14))
$label1.Name = 'label1'
$label1.Size = (New-Object -TypeName System.Drawing.Size -ArgumentList @([System.Int32]44,[System.Int32]13))
$label1.TabIndex = [System.Int32]4
$label1.Text = 'vCenter'

#label2
$label2 = (New-Object -TypeName System.Windows.Forms.Label)
$label2.AutoSize = $true
$label2.Location = (New-Object -TypeName System.Drawing.Point -ArgumentList @([System.Int32]13,[System.Int32]40))
$label2.Name = 'label2'
$label2.Size = (New-Object -TypeName System.Drawing.Size -ArgumentList @([System.Int32]74,[System.Int32]13))
$label2.TabIndex = [System.Int32]5
$label2.Text = 'NSX Manager'

#label3
$label3 = (New-Object -TypeName System.Windows.Forms.Label)
$label3.AutoSize = $true
$label3.Location = (New-Object -TypeName System.Drawing.Point -ArgumentList @([System.Int32]15,[System.Int32]70))
$label3.Name = 'label3'
$label3.Size = (New-Object -TypeName System.Drawing.Size -ArgumentList @([System.Int32]54,[System.Int32]13))
$label3.TabIndex = [System.Int32]7
$label3.Text = 'VM Name'

#label4
$label4 = (New-Object -TypeName System.Windows.Forms.Label)
$label4.AutoSize = $true
$label4.Location = (New-Object -TypeName System.Drawing.Point -ArgumentList @([System.Int32]305,[System.Int32]70))
$label4.Name = 'label4'
$label4.Size = (New-Object -TypeName System.Drawing.Size -ArgumentList @([System.Int32]138,[System.Int32]13))
$label4.TabIndex = [System.Int32]83
$label4.Text = '(Maximum of 15 Characters)'

#label5
$label5 = (New-Object -TypeName System.Windows.Forms.Label)
$label5.AutoSize = $true
$label5.Location = (New-Object -TypeName System.Drawing.Point -ArgumentList @([System.Int32]13,[System.Int32]95))
$label5.Name = 'label5'
$label5.Size = (New-Object -TypeName System.Drawing.Size -ArgumentList @([System.Int32]56,[System.Int32]13))
$label5.TabIndex = [System.Int32]10
$label5.Text = '# of CPUs'

#label6
$label6 = (New-Object -TypeName System.Windows.Forms.Label)
$label6.AutoSize = $true
$label6.Location = (New-Object -TypeName System.Drawing.Point -ArgumentList @([System.Int32]13,[System.Int32]121))
$label6.Name = 'label6'
$label6.Size = (New-Object -TypeName System.Drawing.Size -ArgumentList @([System.Int32]66,[System.Int32]13))
$label6.TabIndex = [System.Int32]12
$label6.Text = 'GBs of RAM'

#label7
$label7 = (New-Object -TypeName System.Windows.Forms.Label)
$label7.AutoSize = $true
$label7.Location = (New-Object -TypeName System.Drawing.Point -ArgumentList @([System.Int32]13,[System.Int32]201))
$label7.Name = 'label7'
$label7.Size = (New-Object -TypeName System.Drawing.Size -ArgumentList @([System.Int32]82,[System.Int32]13))
$label7.TabIndex = [System.Int32]20
$label7.Text = 'VM Designation'

#label8
$label8 = (New-Object -TypeName System.Windows.Forms.Label)
$label8.AutoSize = $true
$label8.Location = (New-Object -TypeName System.Drawing.Point -ArgumentList @([System.Int32]14,[System.Int32]661))
$label8.Name = 'label8'
$label8.Size = (New-Object -TypeName System.Drawing.Size -ArgumentList @([System.Int32]50,[System.Int32]13))
$label8.TabIndex = [System.Int32]62
$label8.Text = 'VM Tags'

#label9
$label9 = (New-Object -TypeName System.Windows.Forms.Label)
$label9.AutoSize = $true
$label9.Location = (New-Object -TypeName System.Drawing.Point -ArgumentList @([System.Int32]15,[System.Int32]255))
$label9.Name = 'label9'
$label9.Size = (New-Object -TypeName System.Drawing.Size -ArgumentList @([System.Int32]44,[System.Int32]13))
$label9.TabIndex = [System.Int32]22
$label9.Text = 'VM Site'

#label10
$label10 = (New-Object -TypeName System.Windows.Forms.Label)
$label10.AutoSize = $true
$label10.Location = (New-Object -TypeName System.Drawing.Point -ArgumentList @([System.Int32]15,[System.Int32]282))
$label10.Name = 'label10'
$label10.Size = (New-Object -TypeName System.Drawing.Size -ArgumentList @([System.Int32]39,[System.Int32]13))
$label10.TabIndex = [System.Int32]24
$label10.Text = 'Cluster'

#label11
$label11 = (New-Object -TypeName System.Windows.Forms.Label)
$label11.AutoSize = $true
$label11.Location = (New-Object -TypeName System.Drawing.Point -ArgumentList @([System.Int32]15,[System.Int32]309))
$label11.Name = 'label11'
$label11.Size = (New-Object -TypeName System.Drawing.Size -ArgumentList @([System.Int32]29,[System.Int32]13))
$label11.TabIndex = [System.Int32]26
$label11.Text = 'Host'

#label12
$label12 = (New-Object -TypeName System.Windows.Forms.Label)
$label12.AutoSize = $true
$label12.Location = (New-Object -TypeName System.Drawing.Point -ArgumentList @([System.Int32]15,[System.Int32]336))
$label12.Name = 'label12'
$label12.Size = (New-Object -TypeName System.Drawing.Size -ArgumentList @([System.Int32]58,[System.Int32]13))
$label12.TabIndex = [System.Int32]28
$label12.Text = 'Port Group'

#label13
$label13 = (New-Object -TypeName System.Windows.Forms.Label)
$label13.AutoSize = $true
$label13.Location = (New-Object -TypeName System.Drawing.Point -ArgumentList @([System.Int32]15,[System.Int32]363))
$label13.Name = 'label13'
$label13.Size = (New-Object -TypeName System.Drawing.Size -ArgumentList @([System.Int32]53,[System.Int32]13))
$label13.TabIndex = [System.Int32]30
$label13.Text = 'Datastore'

#label14
$label14 = (New-Object -TypeName System.Windows.Forms.Label)
$label14.AutoSize = $true
$label14.Location = (New-Object -TypeName System.Drawing.Point -ArgumentList @([System.Int32]15,[System.Int32]390))
$label14.Name = 'label14'
$label14.Size = (New-Object -TypeName System.Drawing.Size -ArgumentList @([System.Int32]90,[System.Int32]13))
$label14.TabIndex = [System.Int32]32
$label14.Text = 'OS Customization'

#label15
$label15 = (New-Object -TypeName System.Windows.Forms.Label)
$label15.AutoSize = $true
$label15.Location = (New-Object -TypeName System.Drawing.Point -ArgumentList @([System.Int32]15,[System.Int32]417))
$label15.Name = 'label15'
$label15.Size = (New-Object -TypeName System.Drawing.Size -ArgumentList @([System.Int32]50,[System.Int32]13))
$label15.TabIndex = [System.Int32]34
$label15.Text = 'VM HD Type'

#label16
$label16 = (New-Object -TypeName System.Windows.Forms.Label)
$label16.AutoSize = $true
$label16.Location = (New-Object -TypeName System.Drawing.Point -ArgumentList @([System.Int32]15,[System.Int32]444))
$label16.Name = 'label16'
$label16.Size = (New-Object -TypeName System.Drawing.Size -ArgumentList @([System.Int32]80,[System.Int32]13))
$label16.TabIndex = [System.Int32]36
$label16.Text = 'VM Folder Path'

#label17
$label17 = (New-Object -TypeName System.Windows.Forms.Label)
$label17.AutoSize = $true
$label17.Location = (New-Object -TypeName System.Drawing.Point -ArgumentList @([System.Int32]15,[System.Int32]470))
$label17.Name = 'label17'
$label17.Size = (New-Object -TypeName System.Drawing.Size -ArgumentList @([System.Int32]54,[System.Int32]13))
$label17.TabIndex = [System.Int32]38
$label17.Text = 'VM Notes'

#label18
$label18 = (New-Object -TypeName System.Windows.Forms.Label)
$label18.AutoSize = $true
$label18.Location = (New-Object -TypeName System.Drawing.Point -ArgumentList @([System.Int32]15,[System.Int32]496))
$label18.Name = 'label18'
$label18.Size = (New-Object -TypeName System.Drawing.Size -ArgumentList @([System.Int32]68,[System.Int32]13))
$label18.TabIndex = [System.Int32]40
$label18.Text = 'VM Owner(s)'

#label19
$label19 = (New-Object -TypeName System.Windows.Forms.Label)
$label19.AutoSize = $true
$label19.Location = (New-Object -TypeName System.Drawing.Point -ArgumentList @([System.Int32]13,[System.Int32]148))
$label19.Name = 'label19'
$label19.Size = (New-Object -TypeName System.Drawing.Size -ArgumentList @([System.Int32]70,[System.Int32]13))
$label19.TabIndex = [System.Int32]42
$label19.Text = 'VM Template'

#label20
$label20 = (New-Object -TypeName System.Windows.Forms.Label)
$label20.AutoSize = $true
$label20.Location = (New-Object -TypeName System.Drawing.Point -ArgumentList @([System.Int32]15,[System.Int32]711))
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
$label22.Location = (New-Object -TypeName System.Drawing.Point -ArgumentList @([System.Int32]15,[System.Int32]535))
$label22.Name = 'label22'
$label22.Size = (New-Object -TypeName System.Drawing.Size -ArgumentList @([System.Int32]54,[System.Int32]13))
$label22.TabIndex = [System.Int32]48
$label22.Text = 'Apps to Install'

#label23
$label23 = (New-Object -TypeName System.Windows.Forms.Label)
$label23.AutoSize = $true
$label23.Location = (New-Object -TypeName System.Drawing.Point -ArgumentList @([System.Int32]15,[System.Int32]573))
$label23.Name = 'label23'
$label23.Size = (New-Object -TypeName System.Drawing.Size -ArgumentList @([System.Int32]80,[System.Int32]13))
$label23.TabIndex = [System.Int32]51
$label23.Text = 'Override DHCP'

#label24
$label24 = (New-Object -TypeName System.Windows.Forms.Label)
$label24.AutoSize = $true
$label24.Location = (New-Object -TypeName System.Drawing.Point -ArgumentList @([System.Int32]70,[System.Int32]593))
$label24.Name = 'label24'
$label24.Visible = $false
$label24.Size = (New-Object -TypeName System.Drawing.Size -ArgumentList @([System.Int32]17,[System.Int32]13))
$label24.TabIndex = [System.Int32]54
$label24.Text = 'IP'

#label25
$label25 = (New-Object -TypeName System.Windows.Forms.Label)
$label25.AutoSize = $true
$label25.Location = (New-Object -TypeName System.Drawing.Point -ArgumentList @([System.Int32]185,[System.Int32]593))
$label25.Name = 'label25'
$label25.Visible = $false
$label25.Size = (New-Object -TypeName System.Drawing.Size -ArgumentList @([System.Int32]41,[System.Int32]13))
$label25.TabIndex = [System.Int32]55
$label25.Text = 'Subnet'

#label26
$label26 = (New-Object -TypeName System.Windows.Forms.Label)
$label26.AutoSize = $true
$label26.Location = (New-Object -TypeName System.Drawing.Point -ArgumentList @([System.Int32]325,[System.Int32]593))
$label26.Name = 'label26'
$label26.Visible = $false
$label26.Size = (New-Object -TypeName System.Drawing.Size -ArgumentList @([System.Int32]23,[System.Int32]13))
$label26.TabIndex = [System.Int32]57
$label26.Text = 'DG'

#label27
$label27 = (New-Object -TypeName System.Windows.Forms.Label)
$label27.AutoSize = $true
$label27.Location = (New-Object -TypeName System.Drawing.Point -ArgumentList @([System.Int32]52,[System.Int32]618))
$label27.Name = 'label27'
$label27.Visible = $false
$label27.Size = (New-Object -TypeName System.Drawing.Size -ArgumentList @([System.Int32]36,[System.Int32]13))
$label27.TabIndex = [System.Int32]58
$label27.Text = 'DNS1'

#label28
$label28 = (New-Object -TypeName System.Windows.Forms.Label)
$label28.AutoSize = $true
$label28.Location = (New-Object -TypeName System.Drawing.Point -ArgumentList @([System.Int32]189,[System.Int32]618))
$label28.Name = 'label28'
$label28.Visible = $false
$label28.Size = (New-Object -TypeName System.Drawing.Size -ArgumentList @([System.Int32]36,[System.Int32]13))
$label28.TabIndex = [System.Int32]60
$label28.Text = 'DNS2'

#VMNameBox
$VMNameBox = (New-Object -TypeName System.Windows.Forms.TextBox)
$VMNameBox.CharacterCasing = [System.Windows.Forms.CharacterCasing]::Upper
$VMNameBox.ImeMode = [System.Windows.Forms.ImeMode]::NoControl
$VMNameBox.Text = $VMNAME
$VMNameBox.Location = (New-Object -TypeName System.Drawing.Point -ArgumentList @([System.Int32]113,[System.Int32]67))
$VMNameBox.MaxLength = [System.Int32]15
$VMNameBox.Name = 'VMNameBox'
$VMNameBox.Size = (New-Object -TypeName System.Drawing.Size -ArgumentList @([System.Int32]190,[System.Int32]20))
$VMNameBox.TabIndex = [System.Int32]0

#CPUnumericUpDown
$CPUnumericUpDown = (New-Object -TypeName System.Windows.Forms.NumericUpDown)
$CPUnumericUpDown.Location = (New-Object -TypeName System.Drawing.Point -ArgumentList @([System.Int32]113,[System.Int32]93))
$CPUnumericUpDown.Value = $VCPUS
$CPUnumericUpDown.Minimum = 1
$CPUnumericUpDown.Maximum = 128
$CPUnumericUpDown.Name = 'CPUnumericUpDown'
$CPUnumericUpDown.Size = (New-Object -TypeName System.Drawing.Size -ArgumentList @([System.Int32]61,[System.Int32]20))
$CPUnumericUpDown.TabIndex = [System.Int32]1

#RAMnumericUpDown
$RAMnumericUpDown = (New-Object -TypeName System.Windows.Forms.NumericUpDown)
$RAMnumericUpDown.AllowDrop = $true
$RAMnumericUpDown.Location = (New-Object -TypeName System.Drawing.Point -ArgumentList @([System.Int32]113,[System.Int32]119))
$RAMnumericUpDown.Value = $RAM
$RAMnumericUpDown.Minimum = 4
$RAMnumericUpDown.Maximum = 768
$RAMnumericUpDown.Name = 'RAMnumericUpDown'
$RAMnumericUpDown.Size = (New-Object -TypeName System.Drawing.Size -ArgumentList @([System.Int32]61,[System.Int32]20))
$RAMnumericUpDown.TabIndex = [System.Int32]2

#VMTemplateComboBox
$VMTemplateComboBox = (New-Object -TypeName System.Windows.Forms.ComboBox)
$VMTemplateComboBox.FormattingEnabled = $true
$VMTemplateComboBox.Items.AddRange($TEMPLATES)
$VMTemplateComboBox.Location = (New-Object -TypeName System.Drawing.Point -ArgumentList @([System.Int32]113,[System.Int32]145))
$VMTemplateComboBox.Name = 'VMTemplateComboBox'
$VMTemplateComboBox.Size = (New-Object -TypeName System.Drawing.Size -ArgumentList @([System.Int32]333,[System.Int32]21))
$VMTemplateComboBox.Text = $TEMPLATE
$VMTemplateComboBox.TabIndex = [System.Int32]3
$VMTemplateComboBox.add_SelectedIndexChanged($comboBox1_SelectedIndexChanged_1)

#DEVcheckBox
$DEVcheckBox = (New-Object -TypeName System.Windows.Forms.CheckBox)
$DEVcheckBox.AutoSize = $true
$DEVcheckBox.Location = (New-Object -TypeName System.Drawing.Point -ArgumentList @([System.Int32]113,[System.Int32]176))
$DEVcheckBox.Name = 'DEVcheckBox'
$DEVcheckBox.Size = (New-Object -TypeName System.Drawing.Size -ArgumentList @([System.Int32]67,[System.Int32]17))
$DEVcheckBox.CheckState = $DEV
$DEVcheckBox.TabIndex = [System.Int32]4
$DEVcheckBox.Text = 'DEV VM'
$DEVcheckBox.UseVisualStyleBackColor = $true

#DMZcheckBox
$DMZcheckBox = (New-Object -TypeName System.Windows.Forms.CheckBox)
$DMZcheckBox.AutoSize = $true
$DMZcheckBox.Location = (New-Object -TypeName System.Drawing.Point -ArgumentList @([System.Int32]113,[System.Int32]199))
$DMZcheckBox.Name = 'DMZcheckBox'
$DMZcheckBox.Size = (New-Object -TypeName System.Drawing.Size -ArgumentList @([System.Int32]69,[System.Int32]17))
$DMZcheckBox.CheckState = $DMZ
$DMZcheckBox.TabIndex = [System.Int32]5
$DMZcheckBox.Text = 'DMZ VM'
$DMZcheckBox.UseVisualStyleBackColor = $true
$DMZcheckBox.add_CheckedChanged($checkBox3_CheckedChanged)

#PCIcheckBox
$PCIcheckBox = (New-Object -TypeName System.Windows.Forms.CheckBox)
$PCIcheckBox.AutoSize = $true
$PCIcheckBox.Location = (New-Object -TypeName System.Drawing.Point -ArgumentList @([System.Int32]113,[System.Int32]222))
$PCIcheckBox.Name = 'PCIcheckBox'
$PCIcheckBox.Size = (New-Object -TypeName System.Drawing.Size -ArgumentList @([System.Int32]62,[System.Int32]17))
$PCIcheckBox.CheckState = $PCI
$PCIcheckBox.TabIndex = [System.Int32]6
$PCIcheckBox.Text = 'PCI VM'
$PCIcheckBox.UseVisualStyleBackColor = $true

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

#ReplaceVMGroupBox
$ReplaceVMGroupBox = (New-Object -TypeName System.Windows.Forms.GroupBox)
$ReplaceVMGroupBox.Controls.Add($label21)
$ReplaceVMGroupBox.Controls.Add($ReplaceVMCheckBox)
$ReplaceVMGroupBox.Controls.Add($ReplacementVMTextBox)
$ReplaceVMGroupBox.Location = (New-Object -TypeName System.Drawing.Point -ArgumentList @([System.Int32]189,[System.Int32]171))
$ReplaceVMGroupBox.Name = 'ReplaceVMGroupBox'
$ReplaceVMGroupBox.Size = (New-Object -TypeName System.Drawing.Size -ArgumentList @([System.Int32]256,[System.Int32]76))
$ReplaceVMGroupBox.TabStop = $false
$ReplaceVMGroupBox.Text = 'Replace VM'
$ReplaceVMGroupBox.TabIndex = [System.Int32]7

#SiteComboBox
$SiteComboBox = (New-Object -TypeName System.Windows.Forms.ComboBox)
$SiteComboBox.FormattingEnabled = $true
$SiteComboBox.Items.AddRange(@('Production','DR'))
$SiteComboBox.Location = (New-Object -TypeName System.Drawing.Point -ArgumentList @([System.Int32]113,[System.Int32]252))
$SiteComboBox.Name = 'SiteComboBox'
$SiteComboBox.Size = (New-Object -TypeName System.Drawing.Size -ArgumentList @([System.Int32]333,[System.Int32]21))
$SiteComboBox.Text = $SITE
$SiteComboBox.TabIndex = [System.Int32]11

#ClusterComboBox
$ClusterComboBox = (New-Object -TypeName System.Windows.Forms.ComboBox)
$ClusterComboBox.FormattingEnabled = $true
$ClusterComboBox.Items.AddRange($CLUSTERS)
$ClusterComboBox.Location = (New-Object -TypeName System.Drawing.Point -ArgumentList @([System.Int32]113,[System.Int32]279))
$ClusterComboBox.Name = 'ClusterComboBox'
$ClusterComboBox.Size = (New-Object -TypeName System.Drawing.Size -ArgumentList @([System.Int32]333,[System.Int32]21))
$ClusterComboBox.Text = $CLUSTER
$ClusterComboBox_SelectedIndexChanged = {
$CLUSTER = Get-Cluster -Name $ClusterComboBox.Text
$VMHOSTS = Get-Cluster $CLUSTER | Get-VMHost * | where ConnectionState -eq 'Connected'
$HostComboBox.Items.Clear()
$HostComboBox.Items.AddRange($VMHOSTS) 
$HostComboBox.Enabled = $true
$HostComboBox.EndUpdate
}
$ClusterComboBox.add_SelectedIndexChanged($ClusterComboBox_SelectedIndexChanged)
$ClusterComboBox.TabIndex = [System.Int32]12

#HostComboBox
$HostComboBox = (New-Object -TypeName System.Windows.Forms.ComboBox)
$HostComboBox.Enabled = $false
$HostComboBox.BeginUpdate
$HostComboBox.FormattingEnabled = $true
$HostComboBox.Location = (New-Object -TypeName System.Drawing.Point -ArgumentList @([System.Int32]112,[System.Int32]306))
$HostComboBox.Name = 'HostComboBox'
$HostComboBox.Size = (New-Object -TypeName System.Drawing.Size -ArgumentList @([System.Int32]333,[System.Int32]21))
$HostComboBox.Text = $VMHOSTSELECTED
$HostComboBox_SelectedIndexChanged = {
#PortGroup
$PORTGROUPS = Get-VMHost $HostComboBox.Text | Get-VirtualPortGroup | Sort-Object Name
$PortGroupComboBox.Items.Clear()
$PortGroupComboBox.Items.AddRange($PORTGROUPS)
$PortGroupComboBox.Enabled = $true
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
$HostComboBox.TabIndex = [System.Int32]13

#PortGroupComboBox
$PortGroupComboBox = (New-Object -TypeName System.Windows.Forms.ComboBox)
$PortGroupComboBox.Enabled = $false
$PortGroupComboBox.BeginUpdate
$PortGroupComboBox.FormattingEnabled = $true
$PortGroupComboBox.Location = (New-Object -TypeName System.Drawing.Point -ArgumentList @([System.Int32]112,[System.Int32]333))
$PortGroupComboBox.Name = 'PortGroupComboBox'
$PortGroupComboBox.Size = (New-Object -TypeName System.Drawing.Size -ArgumentList @([System.Int32]333,[System.Int32]21))
$PortGroupComboBox.Text = $PORTGROUP
$PortGroupComboBox_SelectedIndexChanged = {
$DATASTORES = Get-VMHost $HostComboBox.Text | Get-Datastore * | Sort-Object FreeSpaceGB -Descending | foreach {$_.Name + "  |  " + $_.FreeSpaceGB + "  |  " + $_.CapacityGB}
$DATASTORES = $DATASTORES -replace '@=',''
$DatastoreComboBox.Items.Clear()
$DatastoreComboBox.Items.AddRange($DATASTORES)
$DatastoreComboBox.Enabled = $true
$DatastoreComboBox.EndUpdate
}
$PortGroupComboBox.add_SelectedIndexChanged($PortGroupComboBox_SelectedIndexChanged)
$PortGroupComboBox.TabIndex = [System.Int32]14

#DatastoreComboBox
$DatastoreComboBox = (New-Object -TypeName System.Windows.Forms.ComboBox)
$DatastoreComboBox.Enabled = $false
$DatastoreComboBox.BeginUpdate
$DatastoreComboBox.FormattingEnabled = $true
$DatastoreComboBox.Location = (New-Object -TypeName System.Drawing.Point -ArgumentList @([System.Int32]112,[System.Int32]360))
$DatastoreComboBox.Name = 'DatastoreComboBox'
$DatastoreComboBox.Size = (New-Object -TypeName System.Drawing.Size -ArgumentList @([System.Int32]333,[System.Int32]21))
$DatastoreComboBox.Text = $DATASTORE
$DatastoreComboBox.add_SelectedIndexChanged($comboBox1_SelectedIndexChanged)
$DatastoreComboBox.TabIndex = [System.Int32]15

#OSCustomizationComboBox
$OSCustomizationComboBox = (New-Object -TypeName System.Windows.Forms.ComboBox)
$OSCustomizationComboBox.FormattingEnabled = $true
$OSCustomizationComboBox.Items.AddRange($OSCUSTOMIZATIONS)
$OSCustomizationComboBox.Location = (New-Object -TypeName System.Drawing.Point -ArgumentList @([System.Int32]112,[System.Int32]387))
$OSCustomizationComboBox.Name = 'OSCustomizationComboBox'
$OSCustomizationComboBox.Size = (New-Object -TypeName System.Drawing.Size -ArgumentList @([System.Int32]333,[System.Int32]21))
$OSCustomizationComboBox.Text = $OSCUSTOMIZATION
$OSCustomizationComboBox.TabIndex = [System.Int32]16

#VMTypeComboBox
$VMTypeComboBox = (New-Object -TypeName System.Windows.Forms.ComboBox)
$VMTypeComboBox.FormattingEnabled = $true
$VMTypeComboBox.Items.AddRange($VMTYPELIST.Name)
$VMTypeComboBox.Location = (New-Object -TypeName System.Drawing.Point -ArgumentList @([System.Int32]112,[System.Int32]414))
$VMTypeComboBox.Name = 'VMTypeComboBox'
$VMTypeComboBox.Size = (New-Object -TypeName System.Drawing.Size -ArgumentList @([System.Int32]333,[System.Int32]21))
$VMTypeComboBox.Text = $VMTYPE
$VMTypeComboBox.TabIndex = [System.Int32]17

#FolderPathComboBox
$FolderPathComboBox = (New-Object -TypeName System.Windows.Forms.ComboBox)
$FolderPathComboBox.Enabled = $false
$FolderPathComboBox.FormattingEnabled = $true
$FolderPathComboBox.Location = (New-Object -TypeName System.Drawing.Point -ArgumentList @([System.Int32]112,[System.Int32]441))
$FolderPathComboBox.Name = 'FolderPathComboBox'
$FolderPathComboBox.Size = (New-Object -TypeName System.Drawing.Size -ArgumentList @([System.Int32]333,[System.Int32]21))
$FolderPathComboBox.Text = $VMFOLDER
$FolderPathComboBox.TabIndex = [System.Int32]18

#NotesTextBox
$NotesTextBox = (New-Object -TypeName System.Windows.Forms.TextBox)
$NotesTextBox.ImeMode = [System.Windows.Forms.ImeMode]::NoControl
$NotesTextBox.Location = (New-Object -TypeName System.Drawing.Point -ArgumentList @([System.Int32]112,[System.Int32]467))
$NotesTextBox.MaxLength = [System.Int32]512
$NotesTextBox.Multiline = $true
$NotesTextBox.Name = 'NotesTextBox'
$NotesTextBox.Size = (New-Object -TypeName System.Drawing.Size -ArgumentList @([System.Int32]333,[System.Int32]20))
$NotesTextBox.Text = $NOTES
$NotesTextBox.add_TextChanged($textBox3_TextChanged)
$NotesTextBox.TabIndex = [System.Int32]19

#OwnersTextBox
$OwnersTextBox = (New-Object -TypeName System.Windows.Forms.TextBox)
$OwnersTextBox.ImeMode = [System.Windows.Forms.ImeMode]::NoControl
$OwnersTextBox.Location = (New-Object -TypeName System.Drawing.Point -ArgumentList @([System.Int32]112,[System.Int32]493))
$OwnersTextBox.MaxLength = [System.Int32]256
$OwnersTextBox.Name = 'OwnersTextBox'
$OwnersTextBox.Size = (New-Object -TypeName System.Drawing.Size -ArgumentList @([System.Int32]333,[System.Int32]20))
$OwnersTextBox.Text = $OWNERS
$OwnersTextBox.TabIndex = [System.Int32]20

#AppCheckedListBox
$AppCheckedListBox = (New-Object -TypeName System.Windows.Forms.CheckedListBox)
$AppCheckedListBox.FormattingEnabled = $true
$AppCheckedListBox.Location = (New-Object -TypeName System.Drawing.Point -ArgumentList @([System.Int32]112,[System.Int32]519))
$AppCheckedListBox.Name = 'AppCheckedListBox'
$AppCheckedListBox.Size = (New-Object -TypeName System.Drawing.Size -ArgumentList @([System.Int32]333,[System.Int32]49))
$AppCheckedListBox.Items.AddRange($APPLIST.Name)
FOREACH ($APP in $APPLIST)
{
	$AppCheckedListBox.SetItemChecked([int]$APP.AppOrder, [boolean]$APP.Default)
}
$AppCheckedListBox.TabIndex = [System.Int32]21

#IPTextBox
$IPTextBox = (New-Object -TypeName System.Windows.Forms.TextBox)
$IPTextBox.Location = (New-Object -TypeName System.Drawing.Point -ArgumentList @([System.Int32]88,[System.Int32]590))
$IPTextBox.MaxLength = [System.Int32]15
$IPTextBox.Name = 'IPTextBox'
$IPTextBox.Visible = $false
$IPTextBox.Size = (New-Object -TypeName System.Drawing.Size -ArgumentList @([System.Int32]96,[System.Int32]20))
$IPTextBox.Text = $IP
$IPTextBox.TabIndex = [System.Int32]23

#SubnetTextBox
$SubnetTextBox = (New-Object -TypeName System.Windows.Forms.TextBox)
$SubnetTextBox.Location = (New-Object -TypeName System.Drawing.Point -ArgumentList @([System.Int32]226,[System.Int32]590))
$SubnetTextBox.MaxLength = [System.Int32]15
$SubnetTextBox.Name = 'SubnetTextBox'
$SubnetTextBox.Visible = $false
$SubnetTextBox.Size = (New-Object -TypeName System.Drawing.Size -ArgumentList @([System.Int32]96,[System.Int32]20))
$SubnetTextBox.Text = $SUBNET
$SubnetTextBox.TabIndex = [System.Int32]24

#DGTextBox
$DGTextBox = (New-Object -TypeName System.Windows.Forms.TextBox)
$DGTextBox.Location = (New-Object -TypeName System.Drawing.Point -ArgumentList @([System.Int32]349,[System.Int32]590))
$DGTextBox.MaxLength = [System.Int32]15
$DGTextBox.Name = 'DGTextBox'
$DGTextBox.Visible = $false
$DGTextBox.Size = (New-Object -TypeName System.Drawing.Size -ArgumentList @([System.Int32]96,[System.Int32]20))
$DGTextBox.Text = $DG
$DGTextBox.TabIndex = [System.Int32]25

#DNS1TextBox
$DNS1TextBox = (New-Object -TypeName System.Windows.Forms.TextBox)
$DNS1TextBox.Location = (New-Object -TypeName System.Drawing.Point -ArgumentList @([System.Int32]87,[System.Int32]615))
$DNS1TextBox.MaxLength = [System.Int32]15
$DNS1TextBox.Name = 'DNS1TextBox'
$DNS1TextBox.Visible = $false
$DNS1TextBox.Size = (New-Object -TypeName System.Drawing.Size -ArgumentList @([System.Int32]96,[System.Int32]20))
$DNS1TextBox.Text = $DNS1
$DNS1TextBox.TabIndex = [System.Int32]26

#DNS2TextBox
$DNS2TextBox = (New-Object -TypeName System.Windows.Forms.TextBox)
$DNS2TextBox.Location = (New-Object -TypeName System.Drawing.Point -ArgumentList @([System.Int32]226,[System.Int32]615))
$DNS2TextBox.Name = 'DNS2TextBox'
$DNS2TextBox.Visible = $false
$DNS2TextBox.Size = (New-Object -TypeName System.Drawing.Size -ArgumentList @([System.Int32]96,[System.Int32]20))
$DNS2TextBox.Text = $DNS2
$DNS2TextBox.TabIndex = [System.Int32]27

#OverrideDHCPcheckBox
#Out of Order to correctly set items to enabled with box is checked
$OverrideDHCPcheckBox = (New-Object -TypeName System.Windows.Forms.CheckBox)
$OverrideDHCPcheckBox.AutoSize = $true
$OverrideDHCPcheckBox.Location = (New-Object -TypeName System.Drawing.Point -ArgumentList @([System.Int32]112,[System.Int32]573))
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
$OverrideDHCPcheckBox.TabIndex = [System.Int32]22

#VMTagCheckedListBox
$VMTagCheckedListBox = (New-Object -TypeName System.Windows.Forms.CheckedListBox)
$VMTagCheckedListBox.FormattingEnabled = $true
$VMTagCheckedListBox.HorizontalScrollbar = $true
$VMTagCheckedListBox.Location = (New-Object -TypeName System.Drawing.Point -ArgumentList @([System.Int32]112,[System.Int32]640))
$VMTagCheckedListBox.Name = 'VMTagCheckedListBox'
$VMTagCheckedListBox.Size = (New-Object -TypeName System.Drawing.Size -ArgumentList @([System.Int32]333,[System.Int32]49))
$VMTAGS = Get-Tag | foreach {$_.Name} | Sort-Object
$VMTagCheckedListBox.Items.AddRange($VMTAGS)
$VMTagCheckedListBox.TabIndex = [System.Int32]28

#NSXTagCheckedListBox
$NSXTagCheckedListBox = (New-Object -TypeName System.Windows.Forms.CheckedListBox)
if($DefaultNSXConnection.Server){
$NSXTAGS = Get-NsxSecurityTag | foreach {$_.Name} | Sort-Object
$NSXTagCheckedListBox.Items.AddRange($NSXTAGS) 
$NSXTagCheckedListBox.Enabled = $true
}
$NSXTagCheckedListBox.AccessibleDescription = 'NSX Tags'
$NSXTagCheckedListBox.FormattingEnabled = $true
$NSXTagCheckedListBox.Location = (New-Object -TypeName System.Drawing.Point -ArgumentList @([System.Int32]112,[System.Int32]695))
$NSXTagCheckedListBox.Name = 'NSXTagCheckedListBox'
$NSXTagCheckedListBox.Size = (New-Object -TypeName System.Drawing.Size -ArgumentList @([System.Int32]333,[System.Int32]49))
#Check Default NSX Tags
if($NSXDEFAULTTAG1){
$NewServerInt1 = [array]::indexof($NSXTAGS, $NSXDEFAULTTAG1) #Get Integer for index number of $NSXDEFAULTTAG1 Tag
$NSXTagCheckedListBox.SetItemChecked($NewServerInt1, $true) #Set $NSXDEFAULTTAG1 Tag as defaulted to True
}
if($NSXDEFAULTTAG2){
$NewServerInt2 = [array]::indexof($NSXTAGS, $NSXDEFAULTTAG2) #Get Integer for index number of $NSXDEFAULTTAG2 Tag
$NSXTagCheckedListBox.SetItemChecked($NewServerInt2, $true) #Set $NSXDEFAULTTAG2 Tag as defaulted to True
}
$NSXTagCheckedListBox.TabIndex = [System.Int32]29

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
$MainForm.Close();
}

#OKbutton
$OKbutton = (New-Object -TypeName System.Windows.Forms.Button)
$OKbutton.Location = (New-Object -TypeName System.Drawing.Point -ArgumentList @([System.Int32]162,[System.Int32]750))
$OKbutton.Name = 'OKbutton'
$OKbutton.Size = (New-Object -TypeName System.Drawing.Size -ArgumentList @([System.Int32]75,[System.Int32]23))
$OKbutton.Text = 'OK'
$OKbutton.UseVisualStyleBackColor = $true
$OKbutton.add_Click($OKbutton_Click)
$OKbutton.TabIndex = [System.Int32]30

#Cancel Button Click
$Cancelbutton_Click = { 
Disconnect-VIServer -Confirm:$false
Disconnect-NSXServer -Confirm:$false
Stop-Transcript
$MainForm.Close()
}

#Cancelbutton
$Cancelbutton = (New-Object -TypeName System.Windows.Forms.Button)
$Cancelbutton.Location = (New-Object -TypeName System.Drawing.Point -ArgumentList @([System.Int32]258,[System.Int32]750))
$Cancelbutton.Name = 'Cancelbutton'
$Cancelbutton.Size = (New-Object -TypeName System.Drawing.Size -ArgumentList @([System.Int32]75,[System.Int32]23))
$Cancelbutton.Text = 'Cancel'
$Cancelbutton.UseVisualStyleBackColor = $true
$Cancelbutton.add_Click($Cancelbutton_Click)
$Cancelbutton.TabIndex = [System.Int32]31

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
$MainForm.Controls.Add($ReplaceVMGroupBox)
$MainForm.Controls.Add($Cancelbutton)
$MainForm.Controls.Add($OKbutton)
$MainForm.Controls.Add($NSXTagCheckedListBox)
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
$MainForm.Controls.Add($SiteComboBox)
$MainForm.Controls.Add($VMTagCheckedListBox)
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
$OUTPUT = "" | Select-Object -Property VMName,VCPUS,RAM,Template,DEV,DMZ,PCI,VMReplace,VMNameReplace,Site,Cluster,VMHost,PortGroup,Datastore,OSCustomization,VMType,VMFolder,Notes,Owner,AppList,OverRideDHCP,IP,Subnet,DG,DNS1,DNS2,VMTags,NSXTags
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

RETURN $OUTPUT
}

##Set Default Variable Settings
$VMNAME = "" #Setting Default
$VCPUS = 1 #Setting Default
$RAM = 4 #Setting Default
$COUNTRY = 'US' #Setting Default
$TEMPLATE = "" #Setting Default
$DEV = "Unchecked" #Setting Default
$DMZ = "Unchecked" #Setting Default
$PCI = "Unchecked" #Setting Default
$VMREPLACE = "Unchecked" #Setting Default
$VMNAMEREPLACE = "" #Setting Default
$SITE = "Production" #Setting Default
$CLUSTER = ""
$VMHOSTSELECTED = ""
$PORTGROUP = ""
$DATASTORE = ""
$OSCUSTOMIZATION = ""
$VMTYPE = ""
$VMFOLDER = ""
$NOTES = ""
$OWNERS = ""
$OVERRIDEDHCP = "Unchecked" #Setting Default

##Call MainForm
$A = MainForm
<#
##Convert Output to variables for verification
$VMNAME = $A.VMNAME
$VCPUS = $A.VCPUS
$RAM = $A.RAM
$TEMPLATE = $A.Template
$DEV = $A.DEV
$DMZ = $A.DMZ
$PCI = $A.PCI
$VMREPLACE = $A.VMREPLACE
$VMNAMEREPLACE = $A.VMNAMEREPLACE
$COUNTRY = $A.Country
$SITE = $A.Site
$CLUSTER = $A.Cluster
$VMHOSTSELECTED = $A.VMHost
$PORTGROUP = $A.PORTGROUP
$DATASTORE = $A.Datastore
$OSCUSTOMIZATION = Get-OSCustomizationSpec $A.OSCUSTOMIZATION
$VMTYPE = $A.VMTYPE
$VMFOLDER = $A.VMFOLDER
$NOTES = $A.NOTES
$OWNERS = $A.OWNER
$NSXTAGS = $A.NSXTAGS

##Assign Domain Credentials for AD and WinRM Usage
##Create Secure User Account file
#Specify Creds Login info
$DOMAIN = Get-OSCustomizationSpec $OSCUSTOMIZATION.Domain
$DomainUserFile = $pwd.path+"\"+$DOMAIN+"_Creds.xml"
If (Test-Path $DomainUserFile){
Write-Host "User File Exists"
Write-Host "Continuing..."
$MYDOMAINCREDENTIAL = Import-Clixml $DomainUserFile
}
Else{
$DomainPScreds = Get-Credential -message "Enter the OS Customization Domain creds here:"
$DomainPScreds | Export-Clixml $DomainUserFile
$MYDOMAINCREDENTIAL = $DomainPScreds
}

##Verify Inputs
#Verify OS Customization First
#Note: Must be first verifcation to correctly get Domain For VM Name Checking
WHILE($OSCUSTOMIZATION -eq "")
{
	Write-Warning "OS Customization Field Empty"
	Write-Warning "Please select OS Customization"
	Write-Warning "Please re-input NSX Tags if used"
	$A = MainForm
	$OSCUSTOMIZATION = $A.OSCUSTOMIZATION
	
	##Assign Domain Credentials for AD and WinRM Usage
	##Create Secure User Account file
	#Specify Creds Login info
	$DOMAIN = Get-OSCustomizationSpec $OSCUSTOMIZATION.Domain
	$DomainUserFile = $pwd.path+"\"+$DOMAIN+"_Creds.xml"
	If (Test-Path $DomainUserFile){
		Write-Host "User File Exists"
		Write-Host "Continuing..."
		$MYDOMAINCREDENTIAL = Import-Clixml $DomainUserFile
	}
	Else{
		$DomainPScreds = Get-Credential -message "Enter the OS Customization Domain creds here:"
		$DomainPScreds | Export-Clixml $DomainUserFile
		$MYDOMAINCREDENTIAL = $DomainPScreds
	}
}
#Verify VM Name is not Empty
WHILE($VMNAME -match "\W+" )
{
	Write-Warning "VM Name DOES NOT use the proper Windows OS Naming Convention"
	Write-Warning "Please update VM Name"
	Write-Warning "Please re-input NSX Tags if used"
	$VMNAME = ""
	$A = MainForm
	$VMNAME = $A.VMNAME
}
#Verify that VM Name is not already in use in vCenter
TRY
{ $TEMPVMNAME = Get-VM $VMNAME }
CATCH
{ Write-Host "VM Name" $VMNAME "Is not in use, continueing..." }
WHILE($TEMPVMNAME)
{
	Write-Warning "VM Name is already in use"
	Write-Warning "Please choose different VM Name"
	Write-Warning "Please re-input NSX Tags if used"
	$VMNAME = ""
	$A = MainForm
	$VMNAME = $A.VMNAME
	$TEMPVMNAME = Get-VM $VMNAME
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
{ Write-Host "VM Name" $VMNAME "Is not in use in Active Directory, continueing..." }
WHILE($ADOBJECTTEST)
{
	Write-Warning "VM Name already in use in Active Directory"
	Write-Warning "Please choose different VM Name"
	Write-Warning "Please re-input NSX Tags if used"
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
	Write-Warning "Please update VM VCPUs to minimum of 1"
	Write-Warning "Please re-input NSX Tags if used"
	$A = MainForm
	$VCPUS = $A.VCPUS
}
#Verify RAM is not below minimum
WHILE($RAM -lt 4)
{
	Write-Warning "VM RAM Count Too Low"
	Write-Warning "Please update VM RAM amount to minimum of 4"
	Write-Warning "Please re-input NSX Tags if used"
	$A = MainForm
	$RAM = $A.RAM
}
#Verify Template is not Empty
WHILE($TEMPLATE -eq "")
{
	Write-Warning "VM Template Field Empty"
	Write-Warning "Please input VM Template"
	Write-Warning "Please re-input NSX Tags if used"
	$A = MainForm
	$TEMPLATE = $A.Template
}
#Verify VM Replacement Name if VM Replacement Check box CheckedItems
IF($VMREPLACE -eq "Checked")
{
	WHILE($VMNAMEREPLACE -eq "")
	{
		Write-Warning "VM Replacement Name Field Empty"
		Write-Warning "Please input VM Replacement Name"
		Write-Warning "Please re-input NSX Tags if used"
		$A = MainForm
		$VMNAMEREPLACE = $A.VMNAMEREPLACE
	}
}
#Verify that VM Replacement Exists
$TESTVMNAMEREPLACE = Get-VM $A.VMNAMEREPLACE
WHILE(!$TESTVMNAMEREPLACE)
{
	Write-Warning "VM Replacement Name Does Not Exist"
	Write-Warning "Please input Corrected VM Replacement Name"
	Write-Warning "Please re-input NSX Tags if used"
	$A = MainForm
	$VMNAMEREPLACE = $A.VMNAMEREPLACE
	$TESTVMNAMEREPLACE = Get-VM $A.VMNAMEREPLACE
}
#Verify Country is not Empty
WHILE($COUNTRY -eq "")
{
	Write-Warning "VM Country Field Empty"
	Write-Warning "Please input VM Country"
	Write-Warning "Please re-input NSX Tags if used"
	$A = MainForm
	$COUNTRY = $A.Country
}
#Verify Site is not Empty
WHILE($SITE -eq "")
{
	Write-Warning "VM Site Field Empty"
	Write-Warning "Please input VM Site"
	Write-Warning "Please re-input NSX Tags if used"
	$A = MainForm
	$SITE = $A.SITE
}
#Verify VM Host Selected is not Empty
WHILE($VMHOSTSELECTED -eq "")
{
	Write-Warning "VMHost Selected Field Empty"
	Write-Warning "Please select VMHost"
	Write-Warning "Please re-input NSX Tags if used"
	$A = MainForm
	$VMHOSTSELECTED = $A.VMHOST
}
#Verify Port Group is not Empty
WHILE($PORTGROUP -eq "")
{
	Write-Warning "Host Port Group Field Empty"
	Write-Warning "Please select Host Port Group"
	Write-Warning "Please re-input NSX Tags if used"
	$A = MainForm
	$PORTGROUP = $A.PortGroup
}
#Verify Datastore is not Empty
WHILE($DATASTORE -eq "")
{
	Write-Warning "Datastore Field Empty"
	Write-Warning "Please select Datastore"
	Write-Warning "Please re-input NSX Tags if used"
	$A = MainForm
	$DATASTORE = $A.Datastore
}
#Verify VMTYPE is not Empty
WHILE($VMTYPE -eq "")
{
	Write-Warning "VM Type Field Selection Empty"
	Write-Warning "Please select VM Type"
	Write-Warning "Please re-input NSX Tags if used"
	$A = MainForm
	$VMTYPE = $A.VMTYPE
}
#Verify VM Folder is not Empty
WHILE($VMFOLDER -eq "")
{
	Write-Warning "VM Folder Field Selection Empty"
	Write-Warning "Please select VM Folder"
	Write-Warning "Please re-input NSX Tags if used"
	$A = MainForm
	$VMFOLDER = $A.VMFOLDER
}
#Verify Notes is not Empty
WHILE($NOTES -eq "")
{
	Write-Warning "VM Notes Field Empty"
	Write-Warning "Please input VM Notes"
	Write-Warning "Please re-input NSX Tags if used"
	$A = MainForm
	$NOTES = $A.NOTES
}
#Verify Owners is not Empty
WHILE($OWNERS -eq "")
{
	Write-Warning "VM Owners Field Empty"
	Write-Warning "Please input VM Owners"
	Write-Warning "Please re-input NSX Tags if used"
	$A = MainForm
	$OWNERS = $A.OWNERS
}

##Convert Output to proper formatting/variables
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
}
TRY
{ $VMNAMEREPLACE = Get-VM $VMNAME }
CATCH
{ $VMNAMEREPLACE = $null }
$VMNAMEREPLACE = Get-VM $A.VMNAMEREPLACE
$COUNTRY = $A.Country
$SITE = $A.Site
$CLUSTER = Get-Cluster $A.Cluster
$VMHOST = Get-VMHost $VMHOSTSELECTED
$PORTGROUP = Get-VirtualPortGroup -Name $A.PORTGROUP
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
$NSXTAGS = $A.NSXTAGS

##LIST Results
$VMNAME
$VCPUS
$RAM
$TEMPLATE
$DEV
$DMZ
$PCI
$VMREPLACE
$VMNAMEREPLACE
$COUNTRY
$SITE
$CLUSTER
$VMHOST
$PORTGROUP
$DATASTORE
$OSCUSTOMIZATION
$VMTYPE
$VMFOLDER
$NOTES
$OWNERS
$NSXTAGS
#>

