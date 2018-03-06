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


##Import CSV for Answer File
TRY
{
	$VMTYPELIST = Import-CSV VMHDTypeList.CSV
}
CATCH
{
	Write-Warning "Hard Drive Config File Not found"
	BREAK
}

##Update Hard Drive Configuration based on Selected Hard Disk Configuration
$VMTYPELIST = $VMTYPELIST.Where({$_.Name -eq $VMTYPE})
##Set Variables for Modification
$DVDLetter = $VMTYPELIST.DVDLetter
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
$Drive1 = $VMTYPELIST.Drive1
$Drive1Letter = $VMTYPELIST.Drive1Letter
$Drive1Name = $VMTYPELIST.Drive1Name
$Drive1Minimum = $VMTYPELIST.Drive1Minimum
$Drive1Size = $Drive1Minimum
$Drive1Persistence = $VMTYPELIST.Drive1Persistence
$Drive1StorageFormat= $VMTYPELIST.Drive1StorageFormat
$Drive1Controller = $VMTYPELIST.Drive1Controller
$Drive1FileSystem = $VMTYPELIST.Drive1FileSystem
$Drive1AllocationUnitSize = $VMTYPELIST.Drive1AllocationUnitSize
$Drive2 = [System.Convert]::ToBoolean($VMTYPELIST.Drive2)
$Drive2Letter = $VMTYPELIST.Drive2Letter
$Drive2Name = $VMTYPELIST.Drive2Name
$Drive2Minimum = $VMTYPELIST.Drive2Minimum
$Drive2Size = $Drive2Minimum
$Drive2Persistence = $VMTYPELIST.Drive2Persistence
$Drive2StorageFormat= $VMTYPELIST.Drive2StorageFormat
$Drive2Controller = $VMTYPELIST.Drive2Controller
$Drive2FileSystem = $VMTYPELIST.Drive2FileSystem
$Drive2AllocationUnitSize = $VMTYPELIST.Drive2AllocationUnitSize
$Drive3 = [System.Convert]::ToBoolean($VMTYPELIST.Drive3)
$Drive3Letter = $VMTYPELIST.Drive3Letter
$Drive3Name = $VMTYPELIST.Drive3Name
$Drive3Minimum = $VMTYPELIST.Drive3Minimum
$Drive3Size = $Drive3Minimum
$Drive3Persistence = $VMTYPELIST.Drive3Persistence
$Drive3StorageFormat= $VMTYPELIST.Drive3StorageFormat
$Drive3Controller = $VMTYPELIST.Drive3Controller
$Drive3FileSystem = $VMTYPELIST.Drive3FileSystem
$Drive3AllocationUnitSize = $VMTYPELIST.Drive3AllocationUnitSize
$Drive4 = [System.Convert]::ToBoolean($VMTYPELIST.Drive4)
$Drive4Letter = $VMTYPELIST.Drive4Letter
$Drive4Name = $VMTYPELIST.Drive4Name
$Drive4Minimum = $VMTYPELIST.Drive4Minimum
$Drive4Size = $Drive4Minimum
$Drive4Persistence = $VMTYPELIST.Drive4Persistence
$Drive4StorageFormat= $VMTYPELIST.Drive4StorageFormat
$Drive4Controller = $VMTYPELIST.Drive4Controller
$Drive4FileSystem = $VMTYPELIST.Drive4FileSystem
$Drive4AllocationUnitSize = $VMTYPELIST.Drive4AllocationUnitSize
$Drive5 = [System.Convert]::ToBoolean($VMTYPELIST.Drive5)
$Drive5Letter = $VMTYPELIST.Drive5Letter
$Drive5Name = $VMTYPELIST.Drive5Name
$Drive5Minimum = $VMTYPELIST.Drive5Minimum
$Drive5Size = $Drive5Minimum
$Drive5Persistence = $VMTYPELIST.Drive5Persistence
$Drive5StorageFormat= $VMTYPELIST.Drive5StorageFormat
$Drive5Controller = $VMTYPELIST.Drive5Controller
$Drive5FileSystem = $VMTYPELIST.Drive5FileSystem
$Drive5AllocationUnitSize = $VMTYPELIST.Drive5AllocationUnitSize


$H = HardDiskForm

$Drive0Size = $H.Drive0Size
$Drive1Size = $H.Drive1Size
$Drive2Size = $H.Drive2Size
$Drive3Size = $H.Drive3Size
$Drive4Size = $H.Drive4Size
$Drive5Size = $H.Drive5Size

##List Drive Sizes
Write-Host "Drive 0 Size"
$Drive0Size
Write-Host "Drive 1 Size"
$Drive1Size
Write-Host "Drive 2 Size"
$Drive2Size
Write-Host "Drive 3 Size"
$Drive3Size
Write-Host "Drive 4 Size"
$Drive4Size
Write-Host "Drive 5 Size"
$Drive5Size

