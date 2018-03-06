[void][System.Reflection.Assembly]::Load('System.Drawing, Version=4.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a')
[void][System.Reflection.Assembly]::Load('System.Windows.Forms, Version=4.0.0.0, Culture=neutral, PublicKeyToken=b77a5c561934e089')
$HardDiskForm = New-Object -TypeName System.Windows.Forms.Form
[System.Windows.Forms.Label]$Drive1label1 = $null
[System.Windows.Forms.Label]$Drive1LabelLetter = $null
[System.Windows.Forms.TextBox]$Drive1TextBoxLetter = $null
[System.Windows.Forms.Label]$Drive1LabelLabel = $null
[System.Windows.Forms.TextBox]$Drive1TextBoxLabel = $null
[System.Windows.Forms.Label]$Drive1SizeLabel = $null
[System.Windows.Forms.NumericUpDown]$Drive1numericUpDown = $null
[System.Windows.Forms.Splitter]$splitter1 = $null
[System.Windows.Forms.NumericUpDown]$Drive2numericUpDown = $null
[System.Windows.Forms.Label]$Drive2SizeLabel = $null
[System.Windows.Forms.TextBox]$Drive2TextBoxLabel = $null
[System.Windows.Forms.Label]$Drive2LabelLabel = $null
[System.Windows.Forms.TextBox]$Drive2TextBoxLetter = $null
[System.Windows.Forms.Label]$Drive2LabelLetter = $null
[System.Windows.Forms.Label]$Drive2label1 = $null
[System.Windows.Forms.NumericUpDown]$Drive3numericUpDown = $null
[System.Windows.Forms.Label]$Drive3SizeLabel = $null
[System.Windows.Forms.TextBox]$Drive3TextBoxLabel = $null
[System.Windows.Forms.Label]$Drive3LabelLabel = $null
[System.Windows.Forms.TextBox]$Drive3TextBoxLetter = $null
[System.Windows.Forms.Label]$Drive3LabelLetter = $null
[System.Windows.Forms.Label]$Drive3label1 = $null
[System.Windows.Forms.NumericUpDown]$Drive4numericUpDown = $null
[System.Windows.Forms.Label]$Drive4SizeLabel = $null
[System.Windows.Forms.TextBox]$Drive4TextBoxLabel = $null
[System.Windows.Forms.Label]$Drive4LabelLabel = $null
[System.Windows.Forms.TextBox]$Drive4TextBoxLetter = $null
[System.Windows.Forms.Label]$Drive4LabelLetter = $null
[System.Windows.Forms.Label]$Drive4label1 = $null
[System.Windows.Forms.NumericUpDown]$Drive5numericUpDown = $null
[System.Windows.Forms.Label]$Drive5SizeLabel = $null
[System.Windows.Forms.TextBox]$Drive5TextBoxLabel = $null
[System.Windows.Forms.Label]$Drive5LabelLabel = $null
[System.Windows.Forms.TextBox]$Drive5TextBoxLetter = $null
[System.Windows.Forms.Label]$Drive5LabelLetter = $null
[System.Windows.Forms.Label]$Drive5label1 = $null
[System.Windows.Forms.NumericUpDown]$Drive6numericUpDown = $null
[System.Windows.Forms.Label]$Drive6SizeLabel = $null
[System.Windows.Forms.TextBox]$Drive6TextBoxLabel = $null
[System.Windows.Forms.Label]$Drive6LabelLabel = $null
[System.Windows.Forms.TextBox]$Drive6TextBoxLetter = $null
[System.Windows.Forms.Label]$Drive6LabelLetter = $null
[System.Windows.Forms.Label]$Drive6label1 = $null
[System.Windows.Forms.Button]$OKbutton = $null
[System.Windows.Forms.Button]$Cancelbutton = $null
[System.Windows.Forms.TextBox]$DirectionsTextBox = $null
[System.Windows.Forms.Button]$button1 = $null
function InitializeComponent
{
$Drive1label1 = (New-Object -TypeName System.Windows.Forms.Label)
$Drive1LabelLetter = (New-Object -TypeName System.Windows.Forms.Label)
$Drive1TextBoxLetter = (New-Object -TypeName System.Windows.Forms.TextBox)
$Drive1LabelLabel = (New-Object -TypeName System.Windows.Forms.Label)
$Drive1TextBoxLabel = (New-Object -TypeName System.Windows.Forms.TextBox)
$Drive1SizeLabel = (New-Object -TypeName System.Windows.Forms.Label)
$Drive1numericUpDown = (New-Object -TypeName System.Windows.Forms.NumericUpDown)
$splitter1 = (New-Object -TypeName System.Windows.Forms.Splitter)
$Drive2numericUpDown = (New-Object -TypeName System.Windows.Forms.NumericUpDown)
$Drive2SizeLabel = (New-Object -TypeName System.Windows.Forms.Label)
$Drive2TextBoxLabel = (New-Object -TypeName System.Windows.Forms.TextBox)
$Drive2LabelLabel = (New-Object -TypeName System.Windows.Forms.Label)
$Drive2TextBoxLetter = (New-Object -TypeName System.Windows.Forms.TextBox)
$Drive2LabelLetter = (New-Object -TypeName System.Windows.Forms.Label)
$Drive2label1 = (New-Object -TypeName System.Windows.Forms.Label)
$Drive3numericUpDown = (New-Object -TypeName System.Windows.Forms.NumericUpDown)
$Drive3SizeLabel = (New-Object -TypeName System.Windows.Forms.Label)
$Drive3TextBoxLabel = (New-Object -TypeName System.Windows.Forms.TextBox)
$Drive3LabelLabel = (New-Object -TypeName System.Windows.Forms.Label)
$Drive3TextBoxLetter = (New-Object -TypeName System.Windows.Forms.TextBox)
$Drive3LabelLetter = (New-Object -TypeName System.Windows.Forms.Label)
$Drive3label1 = (New-Object -TypeName System.Windows.Forms.Label)
$Drive4numericUpDown = (New-Object -TypeName System.Windows.Forms.NumericUpDown)
$Drive4SizeLabel = (New-Object -TypeName System.Windows.Forms.Label)
$Drive4TextBoxLabel = (New-Object -TypeName System.Windows.Forms.TextBox)
$Drive4LabelLabel = (New-Object -TypeName System.Windows.Forms.Label)
$Drive4TextBoxLetter = (New-Object -TypeName System.Windows.Forms.TextBox)
$Drive4LabelLetter = (New-Object -TypeName System.Windows.Forms.Label)
$Drive4label1 = (New-Object -TypeName System.Windows.Forms.Label)
$Drive5numericUpDown = (New-Object -TypeName System.Windows.Forms.NumericUpDown)
$Drive5SizeLabel = (New-Object -TypeName System.Windows.Forms.Label)
$Drive5TextBoxLabel = (New-Object -TypeName System.Windows.Forms.TextBox)
$Drive5LabelLabel = (New-Object -TypeName System.Windows.Forms.Label)
$Drive5TextBoxLetter = (New-Object -TypeName System.Windows.Forms.TextBox)
$Drive5LabelLetter = (New-Object -TypeName System.Windows.Forms.Label)
$Drive5label1 = (New-Object -TypeName System.Windows.Forms.Label)
$Drive6numericUpDown = (New-Object -TypeName System.Windows.Forms.NumericUpDown)
$Drive6SizeLabel = (New-Object -TypeName System.Windows.Forms.Label)
$Drive6TextBoxLabel = (New-Object -TypeName System.Windows.Forms.TextBox)
$Drive6LabelLabel = (New-Object -TypeName System.Windows.Forms.Label)
$Drive6TextBoxLetter = (New-Object -TypeName System.Windows.Forms.TextBox)
$Drive6LabelLetter = (New-Object -TypeName System.Windows.Forms.Label)
$Drive6label1 = (New-Object -TypeName System.Windows.Forms.Label)
$OKbutton = (New-Object -TypeName System.Windows.Forms.Button)
$Cancelbutton = (New-Object -TypeName System.Windows.Forms.Button)
$DirectionsTextBox = (New-Object -TypeName System.Windows.Forms.TextBox)
([System.ComponentModel.ISupportInitialize]$Drive1numericUpDown).BeginInit()
([System.ComponentModel.ISupportInitialize]$Drive2numericUpDown).BeginInit()
([System.ComponentModel.ISupportInitialize]$Drive3numericUpDown).BeginInit()
([System.ComponentModel.ISupportInitialize]$Drive4numericUpDown).BeginInit()
([System.ComponentModel.ISupportInitialize]$Drive5numericUpDown).BeginInit()
([System.ComponentModel.ISupportInitialize]$Drive6numericUpDown).BeginInit()
$HardDiskForm.SuspendLayout()
#
#Drive1label1
#
$Drive1label1.AutoSize = $true
$Drive1label1.Location = (New-Object -TypeName System.Drawing.Point -ArgumentList @([System.Int32]16,[System.Int32]49))
$Drive1label1.Name = 'Drive1label1'
$Drive1label1.Size = (New-Object -TypeName System.Drawing.Size -ArgumentList @([System.Int32]38,[System.Int32]13))
$Drive1label1.TabIndex = [System.Int32]0
$Drive1label1.Text = 'Drive1'
$Drive1label1.add_Click($Drive1label1_Click)
#
#Drive1LabelLetter
#
$Drive1LabelLetter.AutoSize = $true
$Drive1LabelLetter.Location = (New-Object -TypeName System.Drawing.Point -ArgumentList @([System.Int32]53,[System.Int32]49))
$Drive1LabelLetter.Name = 'Drive1LabelLetter'
$Drive1LabelLetter.Size = (New-Object -TypeName System.Drawing.Size -ArgumentList @([System.Int32]34,[System.Int32]13))
$Drive1LabelLetter.TabIndex = [System.Int32]6
$Drive1LabelLetter.Text = 'Letter'
#
#Drive1TextBoxLetter
#
$Drive1TextBoxLetter.Location = (New-Object -TypeName System.Drawing.Point -ArgumentList @([System.Int32]87,[System.Int32]46))
$Drive1TextBoxLetter.Name = 'Drive1TextBoxLetter'
$Drive1TextBoxLetter.ReadOnly = $true
$Drive1TextBoxLetter.Size = (New-Object -TypeName System.Drawing.Size -ArgumentList @([System.Int32]19,[System.Int32]20))
$Drive1TextBoxLetter.TabIndex = [System.Int32]7
$Drive1TextBoxLetter.TabStop = $false
#
#Drive1LabelLabel
#
$Drive1LabelLabel.AutoSize = $true
$Drive1LabelLabel.Location = (New-Object -TypeName System.Drawing.Point -ArgumentList @([System.Int32]112,[System.Int32]49))
$Drive1LabelLabel.Name = 'Drive1LabelLabel'
$Drive1LabelLabel.Size = (New-Object -TypeName System.Drawing.Size -ArgumentList @([System.Int32]61,[System.Int32]13))
$Drive1LabelLabel.TabIndex = [System.Int32]8
$Drive1LabelLabel.Text = 'Drive Label'
#
#Drive1TextBoxLabel
#
$Drive1TextBoxLabel.Location = (New-Object -TypeName System.Drawing.Point -ArgumentList @([System.Int32]174,[System.Int32]46))
$Drive1TextBoxLabel.Name = 'Drive1TextBoxLabel'
$Drive1TextBoxLabel.ReadOnly = $true
$Drive1TextBoxLabel.Size = (New-Object -TypeName System.Drawing.Size -ArgumentList @([System.Int32]100,[System.Int32]20))
$Drive1TextBoxLabel.TabIndex = [System.Int32]9
$Drive1TextBoxLabel.TabStop = $false
$Drive1TextBoxLabel.add_TextChanged($Drive1TextBoxLabel_TextChanged)
#
#Drive1SizeLabel
#
$Drive1SizeLabel.AutoSize = $true
$Drive1SizeLabel.Location = (New-Object -TypeName System.Drawing.Point -ArgumentList @([System.Int32]16,[System.Int32]69))
$Drive1SizeLabel.Name = 'Drive1SizeLabel'
$Drive1SizeLabel.Size = (New-Object -TypeName System.Drawing.Size -ArgumentList @([System.Int32]88,[System.Int32]13))
$Drive1SizeLabel.TabIndex = [System.Int32]10
$Drive1SizeLabel.Text = 'Drive 1 Size (GB)'
#
#Drive1numericUpDown
#
$Drive1numericUpDown.Location = (New-Object -TypeName System.Drawing.Point -ArgumentList @([System.Int32]110,[System.Int32]67))
$Drive1numericUpDown.Name = 'Drive1numericUpDown'
$Drive1numericUpDown.Size = (New-Object -TypeName System.Drawing.Size -ArgumentList @([System.Int32]56,[System.Int32]20))
$Drive1numericUpDown.TabIndex = [System.Int32]1
#
#splitter1
#
$splitter1.Location = (New-Object -TypeName System.Drawing.Point -ArgumentList @([System.Int32]0,[System.Int32]0))
$splitter1.Name = 'splitter1'
$splitter1.Size = (New-Object -TypeName System.Drawing.Size -ArgumentList @([System.Int32]3,[System.Int32]412))
$splitter1.TabIndex = [System.Int32]12
$splitter1.TabStop = $false
#
#Drive2numericUpDown
#
$Drive2numericUpDown.Location = (New-Object -TypeName System.Drawing.Point -ArgumentList @([System.Int32]110,[System.Int32]119))
$Drive2numericUpDown.Name = 'Drive2numericUpDown'
$Drive2numericUpDown.Size = (New-Object -TypeName System.Drawing.Size -ArgumentList @([System.Int32]56,[System.Int32]20))
$Drive2numericUpDown.TabIndex = [System.Int32]2
#
#Drive2SizeLabel
#
$Drive2SizeLabel.AutoSize = $true
$Drive2SizeLabel.Location = (New-Object -TypeName System.Drawing.Point -ArgumentList @([System.Int32]16,[System.Int32]121))
$Drive2SizeLabel.Name = 'Drive2SizeLabel'
$Drive2SizeLabel.Size = (New-Object -TypeName System.Drawing.Size -ArgumentList @([System.Int32]88,[System.Int32]13))
$Drive2SizeLabel.TabIndex = [System.Int32]24
$Drive2SizeLabel.Text = 'Drive 2 Size (GB)'
#
#Drive2TextBoxLabel
#
$Drive2TextBoxLabel.Location = (New-Object -TypeName System.Drawing.Point -ArgumentList @([System.Int32]174,[System.Int32]98))
$Drive2TextBoxLabel.Name = 'Drive2TextBoxLabel'
$Drive2TextBoxLabel.ReadOnly = $true
$Drive2TextBoxLabel.Size = (New-Object -TypeName System.Drawing.Size -ArgumentList @([System.Int32]100,[System.Int32]20))
$Drive2TextBoxLabel.TabIndex = [System.Int32]23
$Drive2TextBoxLabel.TabStop = $false
#
#Drive2LabelLabel
#
$Drive2LabelLabel.AutoSize = $true
$Drive2LabelLabel.Location = (New-Object -TypeName System.Drawing.Point -ArgumentList @([System.Int32]112,[System.Int32]101))
$Drive2LabelLabel.Name = 'Drive2LabelLabel'
$Drive2LabelLabel.Size = (New-Object -TypeName System.Drawing.Size -ArgumentList @([System.Int32]61,[System.Int32]13))
$Drive2LabelLabel.TabIndex = [System.Int32]22
$Drive2LabelLabel.Text = 'Drive Label'
#
#Drive2TextBoxLetter
#
$Drive2TextBoxLetter.Location = (New-Object -TypeName System.Drawing.Point -ArgumentList @([System.Int32]87,[System.Int32]98))
$Drive2TextBoxLetter.Name = 'Drive2TextBoxLetter'
$Drive2TextBoxLetter.ReadOnly = $true
$Drive2TextBoxLetter.Size = (New-Object -TypeName System.Drawing.Size -ArgumentList @([System.Int32]19,[System.Int32]20))
$Drive2TextBoxLetter.TabIndex = [System.Int32]21
$Drive2TextBoxLetter.TabStop = $false
#
#Drive2LabelLetter
#
$Drive2LabelLetter.AutoSize = $true
$Drive2LabelLetter.Location = (New-Object -TypeName System.Drawing.Point -ArgumentList @([System.Int32]53,[System.Int32]101))
$Drive2LabelLetter.Name = 'Drive2LabelLetter'
$Drive2LabelLetter.Size = (New-Object -TypeName System.Drawing.Size -ArgumentList @([System.Int32]34,[System.Int32]13))
$Drive2LabelLetter.TabIndex = [System.Int32]20
$Drive2LabelLetter.Text = 'Letter'
#
#Drive2label1
#
$Drive2label1.AutoSize = $true
$Drive2label1.Location = (New-Object -TypeName System.Drawing.Point -ArgumentList @([System.Int32]16,[System.Int32]101))
$Drive2label1.Name = 'Drive2label1'
$Drive2label1.Size = (New-Object -TypeName System.Drawing.Size -ArgumentList @([System.Int32]38,[System.Int32]13))
$Drive2label1.TabIndex = [System.Int32]19
$Drive2label1.Text = 'Drive2'
#
#Drive3numericUpDown
#
$Drive3numericUpDown.Location = (New-Object -TypeName System.Drawing.Point -ArgumentList @([System.Int32]110,[System.Int32]172))
$Drive3numericUpDown.Name = 'Drive3numericUpDown'
$Drive3numericUpDown.Size = (New-Object -TypeName System.Drawing.Size -ArgumentList @([System.Int32]56,[System.Int32]20))
$Drive3numericUpDown.TabIndex = [System.Int32]3
#
#Drive3SizeLabel
#
$Drive3SizeLabel.AutoSize = $true
$Drive3SizeLabel.Location = (New-Object -TypeName System.Drawing.Point -ArgumentList @([System.Int32]16,[System.Int32]174))
$Drive3SizeLabel.Name = 'Drive3SizeLabel'
$Drive3SizeLabel.Size = (New-Object -TypeName System.Drawing.Size -ArgumentList @([System.Int32]88,[System.Int32]13))
$Drive3SizeLabel.TabIndex = [System.Int32]31
$Drive3SizeLabel.Text = 'Drive 3 Size (GB)'
#
#Drive3TextBoxLabel
#
$Drive3TextBoxLabel.Location = (New-Object -TypeName System.Drawing.Point -ArgumentList @([System.Int32]174,[System.Int32]151))
$Drive3TextBoxLabel.Name = 'Drive3TextBoxLabel'
$Drive3TextBoxLabel.ReadOnly = $true
$Drive3TextBoxLabel.Size = (New-Object -TypeName System.Drawing.Size -ArgumentList @([System.Int32]100,[System.Int32]20))
$Drive3TextBoxLabel.TabIndex = [System.Int32]30
$Drive3TextBoxLabel.TabStop = $false
#
#Drive3LabelLabel
#
$Drive3LabelLabel.AutoSize = $true
$Drive3LabelLabel.Location = (New-Object -TypeName System.Drawing.Point -ArgumentList @([System.Int32]112,[System.Int32]154))
$Drive3LabelLabel.Name = 'Drive3LabelLabel'
$Drive3LabelLabel.Size = (New-Object -TypeName System.Drawing.Size -ArgumentList @([System.Int32]61,[System.Int32]13))
$Drive3LabelLabel.TabIndex = [System.Int32]29
$Drive3LabelLabel.Text = 'Drive Label'
#
#Drive3TextBoxLetter
#
$Drive3TextBoxLetter.Location = (New-Object -TypeName System.Drawing.Point -ArgumentList @([System.Int32]87,[System.Int32]151))
$Drive3TextBoxLetter.Name = 'Drive3TextBoxLetter'
$Drive3TextBoxLetter.ReadOnly = $true
$Drive3TextBoxLetter.Size = (New-Object -TypeName System.Drawing.Size -ArgumentList @([System.Int32]19,[System.Int32]20))
$Drive3TextBoxLetter.TabIndex = [System.Int32]28
$Drive3TextBoxLetter.TabStop = $false
#
#Drive3LabelLetter
#
$Drive3LabelLetter.AutoSize = $true
$Drive3LabelLetter.Location = (New-Object -TypeName System.Drawing.Point -ArgumentList @([System.Int32]53,[System.Int32]154))
$Drive3LabelLetter.Name = 'Drive3LabelLetter'
$Drive3LabelLetter.Size = (New-Object -TypeName System.Drawing.Size -ArgumentList @([System.Int32]34,[System.Int32]13))
$Drive3LabelLetter.TabIndex = [System.Int32]27
$Drive3LabelLetter.Text = 'Letter'
#
#Drive3label1
#
$Drive3label1.AutoSize = $true
$Drive3label1.Location = (New-Object -TypeName System.Drawing.Point -ArgumentList @([System.Int32]16,[System.Int32]154))
$Drive3label1.Name = 'Drive3label1'
$Drive3label1.Size = (New-Object -TypeName System.Drawing.Size -ArgumentList @([System.Int32]38,[System.Int32]13))
$Drive3label1.TabIndex = [System.Int32]26
$Drive3label1.Text = 'Drive3'
#
#Drive4numericUpDown
#
$Drive4numericUpDown.Location = (New-Object -TypeName System.Drawing.Point -ArgumentList @([System.Int32]110,[System.Int32]226))
$Drive4numericUpDown.Name = 'Drive4numericUpDown'
$Drive4numericUpDown.Size = (New-Object -TypeName System.Drawing.Size -ArgumentList @([System.Int32]56,[System.Int32]20))
$Drive4numericUpDown.TabIndex = [System.Int32]4
#
#Drive4SizeLabel
#
$Drive4SizeLabel.AutoSize = $true
$Drive4SizeLabel.Location = (New-Object -TypeName System.Drawing.Point -ArgumentList @([System.Int32]16,[System.Int32]228))
$Drive4SizeLabel.Name = 'Drive4SizeLabel'
$Drive4SizeLabel.Size = (New-Object -TypeName System.Drawing.Size -ArgumentList @([System.Int32]88,[System.Int32]13))
$Drive4SizeLabel.TabIndex = [System.Int32]38
$Drive4SizeLabel.Text = 'Drive 4 Size (GB)'
#
#Drive4TextBoxLabel
#
$Drive4TextBoxLabel.Location = (New-Object -TypeName System.Drawing.Point -ArgumentList @([System.Int32]174,[System.Int32]205))
$Drive4TextBoxLabel.Name = 'Drive4TextBoxLabel'
$Drive4TextBoxLabel.ReadOnly = $true
$Drive4TextBoxLabel.Size = (New-Object -TypeName System.Drawing.Size -ArgumentList @([System.Int32]100,[System.Int32]20))
$Drive4TextBoxLabel.TabIndex = [System.Int32]37
$Drive4TextBoxLabel.TabStop = $false
#
#Drive4LabelLabel
#
$Drive4LabelLabel.AutoSize = $true
$Drive4LabelLabel.Location = (New-Object -TypeName System.Drawing.Point -ArgumentList @([System.Int32]112,[System.Int32]208))
$Drive4LabelLabel.Name = 'Drive4LabelLabel'
$Drive4LabelLabel.Size = (New-Object -TypeName System.Drawing.Size -ArgumentList @([System.Int32]61,[System.Int32]13))
$Drive4LabelLabel.TabIndex = [System.Int32]36
$Drive4LabelLabel.Text = 'Drive Label'
#
#Drive4TextBoxLetter
#
$Drive4TextBoxLetter.Location = (New-Object -TypeName System.Drawing.Point -ArgumentList @([System.Int32]87,[System.Int32]205))
$Drive4TextBoxLetter.Name = 'Drive4TextBoxLetter'
$Drive4TextBoxLetter.ReadOnly = $true
$Drive4TextBoxLetter.Size = (New-Object -TypeName System.Drawing.Size -ArgumentList @([System.Int32]19,[System.Int32]20))
$Drive4TextBoxLetter.TabIndex = [System.Int32]35
$Drive4TextBoxLetter.TabStop = $false
#
#Drive4LabelLetter
#
$Drive4LabelLetter.AutoSize = $true
$Drive4LabelLetter.Location = (New-Object -TypeName System.Drawing.Point -ArgumentList @([System.Int32]53,[System.Int32]208))
$Drive4LabelLetter.Name = 'Drive4LabelLetter'
$Drive4LabelLetter.Size = (New-Object -TypeName System.Drawing.Size -ArgumentList @([System.Int32]34,[System.Int32]13))
$Drive4LabelLetter.TabIndex = [System.Int32]34
$Drive4LabelLetter.Text = 'Letter'
#
#Drive4label1
#
$Drive4label1.AutoSize = $true
$Drive4label1.Location = (New-Object -TypeName System.Drawing.Point -ArgumentList @([System.Int32]16,[System.Int32]208))
$Drive4label1.Name = 'Drive4label1'
$Drive4label1.Size = (New-Object -TypeName System.Drawing.Size -ArgumentList @([System.Int32]38,[System.Int32]13))
$Drive4label1.TabIndex = [System.Int32]33
$Drive4label1.Text = 'Drive4'
#
#Drive5numericUpDown
#
$Drive5numericUpDown.Location = (New-Object -TypeName System.Drawing.Point -ArgumentList @([System.Int32]110,[System.Int32]281))
$Drive5numericUpDown.Name = 'Drive5numericUpDown'
$Drive5numericUpDown.Size = (New-Object -TypeName System.Drawing.Size -ArgumentList @([System.Int32]56,[System.Int32]20))
$Drive5numericUpDown.TabIndex = [System.Int32]5
#
#Drive5SizeLabel
#
$Drive5SizeLabel.AutoSize = $true
$Drive5SizeLabel.Location = (New-Object -TypeName System.Drawing.Point -ArgumentList @([System.Int32]16,[System.Int32]283))
$Drive5SizeLabel.Name = 'Drive5SizeLabel'
$Drive5SizeLabel.Size = (New-Object -TypeName System.Drawing.Size -ArgumentList @([System.Int32]88,[System.Int32]13))
$Drive5SizeLabel.TabIndex = [System.Int32]45
$Drive5SizeLabel.Text = 'Drive 5 Size (GB)'
#
#Drive5TextBoxLabel
#
$Drive5TextBoxLabel.Location = (New-Object -TypeName System.Drawing.Point -ArgumentList @([System.Int32]174,[System.Int32]260))
$Drive5TextBoxLabel.Name = 'Drive5TextBoxLabel'
$Drive5TextBoxLabel.ReadOnly = $true
$Drive5TextBoxLabel.Size = (New-Object -TypeName System.Drawing.Size -ArgumentList @([System.Int32]100,[System.Int32]20))
$Drive5TextBoxLabel.TabIndex = [System.Int32]44
$Drive5TextBoxLabel.TabStop = $false
#
#Drive5LabelLabel
#
$Drive5LabelLabel.AutoSize = $true
$Drive5LabelLabel.Location = (New-Object -TypeName System.Drawing.Point -ArgumentList @([System.Int32]112,[System.Int32]263))
$Drive5LabelLabel.Name = 'Drive5LabelLabel'
$Drive5LabelLabel.Size = (New-Object -TypeName System.Drawing.Size -ArgumentList @([System.Int32]61,[System.Int32]13))
$Drive5LabelLabel.TabIndex = [System.Int32]43
$Drive5LabelLabel.Text = 'Drive Label'
#
#Drive5TextBoxLetter
#
$Drive5TextBoxLetter.Location = (New-Object -TypeName System.Drawing.Point -ArgumentList @([System.Int32]87,[System.Int32]260))
$Drive5TextBoxLetter.Name = 'Drive5TextBoxLetter'
$Drive5TextBoxLetter.ReadOnly = $true
$Drive5TextBoxLetter.Size = (New-Object -TypeName System.Drawing.Size -ArgumentList @([System.Int32]19,[System.Int32]20))
$Drive5TextBoxLetter.TabIndex = [System.Int32]42
$Drive5TextBoxLetter.TabStop = $false
#
#Drive5LabelLetter
#
$Drive5LabelLetter.AutoSize = $true
$Drive5LabelLetter.Location = (New-Object -TypeName System.Drawing.Point -ArgumentList @([System.Int32]53,[System.Int32]263))
$Drive5LabelLetter.Name = 'Drive5LabelLetter'
$Drive5LabelLetter.Size = (New-Object -TypeName System.Drawing.Size -ArgumentList @([System.Int32]34,[System.Int32]13))
$Drive5LabelLetter.TabIndex = [System.Int32]41
$Drive5LabelLetter.Text = 'Letter'
#
#Drive5label1
#
$Drive5label1.AutoSize = $true
$Drive5label1.Location = (New-Object -TypeName System.Drawing.Point -ArgumentList @([System.Int32]16,[System.Int32]263))
$Drive5label1.Name = 'Drive5label1'
$Drive5label1.Size = (New-Object -TypeName System.Drawing.Size -ArgumentList @([System.Int32]38,[System.Int32]13))
$Drive5label1.TabIndex = [System.Int32]40
$Drive5label1.Text = 'Drive5'
#
#Drive6numericUpDown
#
$Drive6numericUpDown.Location = (New-Object -TypeName System.Drawing.Point -ArgumentList @([System.Int32]110,[System.Int32]338))
$Drive6numericUpDown.Name = 'Drive6numericUpDown'
$Drive6numericUpDown.Size = (New-Object -TypeName System.Drawing.Size -ArgumentList @([System.Int32]56,[System.Int32]20))
$Drive6numericUpDown.TabIndex = [System.Int32]6
#
#Drive6SizeLabel
#
$Drive6SizeLabel.AutoSize = $true
$Drive6SizeLabel.Location = (New-Object -TypeName System.Drawing.Point -ArgumentList @([System.Int32]16,[System.Int32]340))
$Drive6SizeLabel.Name = 'Drive6SizeLabel'
$Drive6SizeLabel.Size = (New-Object -TypeName System.Drawing.Size -ArgumentList @([System.Int32]88,[System.Int32]13))
$Drive6SizeLabel.TabIndex = [System.Int32]52
$Drive6SizeLabel.Text = 'Drive 6 Size (GB)'
#
#Drive6TextBoxLabel
#
$Drive6TextBoxLabel.Location = (New-Object -TypeName System.Drawing.Point -ArgumentList @([System.Int32]174,[System.Int32]317))
$Drive6TextBoxLabel.Name = 'Drive6TextBoxLabel'
$Drive6TextBoxLabel.ReadOnly = $true
$Drive6TextBoxLabel.Size = (New-Object -TypeName System.Drawing.Size -ArgumentList @([System.Int32]100,[System.Int32]20))
$Drive6TextBoxLabel.TabIndex = [System.Int32]51
$Drive6TextBoxLabel.TabStop = $false
#
#Drive6LabelLabel
#
$Drive6LabelLabel.AutoSize = $true
$Drive6LabelLabel.Location = (New-Object -TypeName System.Drawing.Point -ArgumentList @([System.Int32]112,[System.Int32]320))
$Drive6LabelLabel.Name = 'Drive6LabelLabel'
$Drive6LabelLabel.Size = (New-Object -TypeName System.Drawing.Size -ArgumentList @([System.Int32]61,[System.Int32]13))
$Drive6LabelLabel.TabIndex = [System.Int32]50
$Drive6LabelLabel.Text = 'Drive Label'
#
#Drive6TextBoxLetter
#
$Drive6TextBoxLetter.Location = (New-Object -TypeName System.Drawing.Point -ArgumentList @([System.Int32]87,[System.Int32]317))
$Drive6TextBoxLetter.Name = 'Drive6TextBoxLetter'
$Drive6TextBoxLetter.ReadOnly = $true
$Drive6TextBoxLetter.Size = (New-Object -TypeName System.Drawing.Size -ArgumentList @([System.Int32]19,[System.Int32]20))
$Drive6TextBoxLetter.TabIndex = [System.Int32]49
$Drive6TextBoxLetter.TabStop = $false
#
#Drive6LabelLetter
#
$Drive6LabelLetter.AutoSize = $true
$Drive6LabelLetter.Location = (New-Object -TypeName System.Drawing.Point -ArgumentList @([System.Int32]53,[System.Int32]320))
$Drive6LabelLetter.Name = 'Drive6LabelLetter'
$Drive6LabelLetter.Size = (New-Object -TypeName System.Drawing.Size -ArgumentList @([System.Int32]34,[System.Int32]13))
$Drive6LabelLetter.TabIndex = [System.Int32]48
$Drive6LabelLetter.Text = 'Letter'
#
#Drive6label1
#
$Drive6label1.AutoSize = $true
$Drive6label1.Location = (New-Object -TypeName System.Drawing.Point -ArgumentList @([System.Int32]16,[System.Int32]320))
$Drive6label1.Name = 'Drive6label1'
$Drive6label1.Size = (New-Object -TypeName System.Drawing.Size -ArgumentList @([System.Int32]38,[System.Int32]13))
$Drive6label1.TabIndex = [System.Int32]47
$Drive6label1.Text = 'Drive6'
#
#OKbutton
#
$OKbutton.Location = (New-Object -TypeName System.Drawing.Point -ArgumentList @([System.Int32]56,[System.Int32]382))
$OKbutton.Name = 'OKbutton'
$OKbutton.Size = (New-Object -TypeName System.Drawing.Size -ArgumentList @([System.Int32]75,[System.Int32]23))
$OKbutton.TabIndex = [System.Int32]7
$OKbutton.Text = 'OK'
$OKbutton.UseVisualStyleBackColor = $true
$OKbutton.add_Click($OKbutton_Click)
#
#Cancelbutton
#
$Cancelbutton.Location = (New-Object -TypeName System.Drawing.Point -ArgumentList @([System.Int32]146,[System.Int32]382))
$Cancelbutton.Name = 'Cancelbutton'
$Cancelbutton.Size = (New-Object -TypeName System.Drawing.Size -ArgumentList @([System.Int32]75,[System.Int32]23))
$Cancelbutton.TabIndex = [System.Int32]8
$Cancelbutton.Text = 'Cancel'
$Cancelbutton.UseVisualStyleBackColor = $true
$Cancelbutton.add_Click($Cancelbutton_Click)
#
#DirectionsTextBox
#
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
#
#HardDiskForm
#
$HardDiskForm.ClientSize = (New-Object -TypeName System.Drawing.Size -ArgumentList @([System.Int32]284,[System.Int32]412))
$HardDiskForm.Controls.Add($DirectionsTextBox)
$HardDiskForm.Controls.Add($Cancelbutton)
$HardDiskForm.Controls.Add($OKbutton)
$HardDiskForm.Controls.Add($Drive6numericUpDown)
$HardDiskForm.Controls.Add($Drive6SizeLabel)
$HardDiskForm.Controls.Add($Drive6TextBoxLabel)
$HardDiskForm.Controls.Add($Drive6LabelLabel)
$HardDiskForm.Controls.Add($Drive6TextBoxLetter)
$HardDiskForm.Controls.Add($Drive6LabelLetter)
$HardDiskForm.Controls.Add($Drive6label1)
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
$HardDiskForm.Controls.Add($splitter1)
$HardDiskForm.Controls.Add($Drive1numericUpDown)
$HardDiskForm.Controls.Add($Drive1SizeLabel)
$HardDiskForm.Controls.Add($Drive1TextBoxLabel)
$HardDiskForm.Controls.Add($Drive1LabelLabel)
$HardDiskForm.Controls.Add($Drive1TextBoxLetter)
$HardDiskForm.Controls.Add($Drive1LabelLetter)
$HardDiskForm.Controls.Add($Drive1label1)
$HardDiskForm.Name = 'HardDiskForm'
$HardDiskForm.StartPosition = [System.Windows.Forms.FormStartPosition]::CenterScreen
$HardDiskForm.Text = 'VM Type Hard Disk Config'
$HardDiskForm.TopMost = $true
$HardDiskForm.add_Load($HardDiskForm_Load)
([System.ComponentModel.ISupportInitialize]$Drive1numericUpDown).EndInit()
([System.ComponentModel.ISupportInitialize]$Drive2numericUpDown).EndInit()
([System.ComponentModel.ISupportInitialize]$Drive3numericUpDown).EndInit()
([System.ComponentModel.ISupportInitialize]$Drive4numericUpDown).EndInit()
([System.ComponentModel.ISupportInitialize]$Drive5numericUpDown).EndInit()
([System.ComponentModel.ISupportInitialize]$Drive6numericUpDown).EndInit()
$HardDiskForm.ResumeLayout($false)
$HardDiskForm.PerformLayout()
Add-Member -InputObject $HardDiskForm -Name base -Value $base -MemberType NoteProperty
Add-Member -InputObject $HardDiskForm -Name Drive1label1 -Value $Drive1label1 -MemberType NoteProperty
Add-Member -InputObject $HardDiskForm -Name Drive1LabelLetter -Value $Drive1LabelLetter -MemberType NoteProperty
Add-Member -InputObject $HardDiskForm -Name Drive1TextBoxLetter -Value $Drive1TextBoxLetter -MemberType NoteProperty
Add-Member -InputObject $HardDiskForm -Name Drive1LabelLabel -Value $Drive1LabelLabel -MemberType NoteProperty
Add-Member -InputObject $HardDiskForm -Name Drive1TextBoxLabel -Value $Drive1TextBoxLabel -MemberType NoteProperty
Add-Member -InputObject $HardDiskForm -Name Drive1SizeLabel -Value $Drive1SizeLabel -MemberType NoteProperty
Add-Member -InputObject $HardDiskForm -Name Drive1numericUpDown -Value $Drive1numericUpDown -MemberType NoteProperty
Add-Member -InputObject $HardDiskForm -Name splitter1 -Value $splitter1 -MemberType NoteProperty
Add-Member -InputObject $HardDiskForm -Name Drive2numericUpDown -Value $Drive2numericUpDown -MemberType NoteProperty
Add-Member -InputObject $HardDiskForm -Name Drive2SizeLabel -Value $Drive2SizeLabel -MemberType NoteProperty
Add-Member -InputObject $HardDiskForm -Name Drive2TextBoxLabel -Value $Drive2TextBoxLabel -MemberType NoteProperty
Add-Member -InputObject $HardDiskForm -Name Drive2LabelLabel -Value $Drive2LabelLabel -MemberType NoteProperty
Add-Member -InputObject $HardDiskForm -Name Drive2TextBoxLetter -Value $Drive2TextBoxLetter -MemberType NoteProperty
Add-Member -InputObject $HardDiskForm -Name Drive2LabelLetter -Value $Drive2LabelLetter -MemberType NoteProperty
Add-Member -InputObject $HardDiskForm -Name Drive2label1 -Value $Drive2label1 -MemberType NoteProperty
Add-Member -InputObject $HardDiskForm -Name Drive3numericUpDown -Value $Drive3numericUpDown -MemberType NoteProperty
Add-Member -InputObject $HardDiskForm -Name Drive3SizeLabel -Value $Drive3SizeLabel -MemberType NoteProperty
Add-Member -InputObject $HardDiskForm -Name Drive3TextBoxLabel -Value $Drive3TextBoxLabel -MemberType NoteProperty
Add-Member -InputObject $HardDiskForm -Name Drive3LabelLabel -Value $Drive3LabelLabel -MemberType NoteProperty
Add-Member -InputObject $HardDiskForm -Name Drive3TextBoxLetter -Value $Drive3TextBoxLetter -MemberType NoteProperty
Add-Member -InputObject $HardDiskForm -Name Drive3LabelLetter -Value $Drive3LabelLetter -MemberType NoteProperty
Add-Member -InputObject $HardDiskForm -Name Drive3label1 -Value $Drive3label1 -MemberType NoteProperty
Add-Member -InputObject $HardDiskForm -Name Drive4numericUpDown -Value $Drive4numericUpDown -MemberType NoteProperty
Add-Member -InputObject $HardDiskForm -Name Drive4SizeLabel -Value $Drive4SizeLabel -MemberType NoteProperty
Add-Member -InputObject $HardDiskForm -Name Drive4TextBoxLabel -Value $Drive4TextBoxLabel -MemberType NoteProperty
Add-Member -InputObject $HardDiskForm -Name Drive4LabelLabel -Value $Drive4LabelLabel -MemberType NoteProperty
Add-Member -InputObject $HardDiskForm -Name Drive4TextBoxLetter -Value $Drive4TextBoxLetter -MemberType NoteProperty
Add-Member -InputObject $HardDiskForm -Name Drive4LabelLetter -Value $Drive4LabelLetter -MemberType NoteProperty
Add-Member -InputObject $HardDiskForm -Name Drive4label1 -Value $Drive4label1 -MemberType NoteProperty
Add-Member -InputObject $HardDiskForm -Name Drive5numericUpDown -Value $Drive5numericUpDown -MemberType NoteProperty
Add-Member -InputObject $HardDiskForm -Name Drive5SizeLabel -Value $Drive5SizeLabel -MemberType NoteProperty
Add-Member -InputObject $HardDiskForm -Name Drive5TextBoxLabel -Value $Drive5TextBoxLabel -MemberType NoteProperty
Add-Member -InputObject $HardDiskForm -Name Drive5LabelLabel -Value $Drive5LabelLabel -MemberType NoteProperty
Add-Member -InputObject $HardDiskForm -Name Drive5TextBoxLetter -Value $Drive5TextBoxLetter -MemberType NoteProperty
Add-Member -InputObject $HardDiskForm -Name Drive5LabelLetter -Value $Drive5LabelLetter -MemberType NoteProperty
Add-Member -InputObject $HardDiskForm -Name Drive5label1 -Value $Drive5label1 -MemberType NoteProperty
Add-Member -InputObject $HardDiskForm -Name Drive6numericUpDown -Value $Drive6numericUpDown -MemberType NoteProperty
Add-Member -InputObject $HardDiskForm -Name Drive6SizeLabel -Value $Drive6SizeLabel -MemberType NoteProperty
Add-Member -InputObject $HardDiskForm -Name Drive6TextBoxLabel -Value $Drive6TextBoxLabel -MemberType NoteProperty
Add-Member -InputObject $HardDiskForm -Name Drive6LabelLabel -Value $Drive6LabelLabel -MemberType NoteProperty
Add-Member -InputObject $HardDiskForm -Name Drive6TextBoxLetter -Value $Drive6TextBoxLetter -MemberType NoteProperty
Add-Member -InputObject $HardDiskForm -Name Drive6LabelLetter -Value $Drive6LabelLetter -MemberType NoteProperty
Add-Member -InputObject $HardDiskForm -Name Drive6label1 -Value $Drive6label1 -MemberType NoteProperty
Add-Member -InputObject $HardDiskForm -Name OKbutton -Value $OKbutton -MemberType NoteProperty
Add-Member -InputObject $HardDiskForm -Name Cancelbutton -Value $Cancelbutton -MemberType NoteProperty
Add-Member -InputObject $HardDiskForm -Name DirectionsTextBox -Value $DirectionsTextBox -MemberType NoteProperty
Add-Member -InputObject $HardDiskForm -Name button1 -Value $button1 -MemberType NoteProperty
}
. InitializeComponent
