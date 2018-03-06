[void][System.Reflection.Assembly]::Load('System.Drawing, Version=4.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a')
[void][System.Reflection.Assembly]::Load('System.Windows.Forms, Version=4.0.0.0, Culture=neutral, PublicKeyToken=b77a5c561934e089')
$MainForm = New-Object -TypeName System.Windows.Forms.Form
[System.Windows.Forms.Label]$label1 = $null
[System.Windows.Forms.Label]$label2 = $null
[System.Windows.Forms.Label]$label3 = $null
[System.Windows.Forms.Label]$label4 = $null
[System.Windows.Forms.Label]$label5 = $null
[System.Windows.Forms.Label]$label6 = $null
[System.Windows.Forms.Label]$label7 = $null
[System.Windows.Forms.Label]$label9 = $null
[System.Windows.Forms.Label]$label10 = $null
[System.Windows.Forms.Label]$label11 = $null
[System.Windows.Forms.Label]$label12 = $null
[System.Windows.Forms.TextBox]$VMNameBox = $null
[System.Windows.Forms.NumericUpDown]$CPUnumericUpDown = $null
[System.Windows.Forms.NumericUpDown]$RAMnumericUpDown = $null
[System.Windows.Forms.CheckBox]$DEVcheckBox = $null
[System.Windows.Forms.CheckBox]$PCIcheckBox = $null
[System.Windows.Forms.CheckBox]$DMZcheckBox = $null
[System.Windows.Forms.ComboBox]$SiteComboBox = $null
[System.Windows.Forms.ComboBox]$ClusterComboBox = $null
[System.Windows.Forms.ComboBox]$HostComboBox = $null
[System.Windows.Forms.ComboBox]$PortGroupComboBox = $null
[System.Windows.Forms.Label]$label13 = $null
[System.Windows.Forms.ComboBox]$DatastoreComboBox = $null
[System.Windows.Forms.Label]$label14 = $null
[System.Windows.Forms.ComboBox]$OSCustomizationComboBox = $null
[System.Windows.Forms.Label]$label15 = $null
[System.Windows.Forms.ComboBox]$VMTypeComboBox = $null
[System.Windows.Forms.Label]$label16 = $null
[System.Windows.Forms.ComboBox]$FolderPathComboBox = $null
[System.Windows.Forms.Label]$label17 = $null
[System.Windows.Forms.Label]$label18 = $null
[System.Windows.Forms.Button]$OKbutton = $null
[System.Windows.Forms.Button]$Cancelbutton = $null
[System.Windows.Forms.TextBox]$vCenterTextBox = $null
[System.Windows.Forms.TextBox]$NSXManagerTextBox = $null
[System.Windows.Forms.TextBox]$NotesTextBox = $null
[System.Windows.Forms.TextBox]$OwnersTextBox = $null
[System.Windows.Forms.Label]$label19 = $null
[System.Windows.Forms.ComboBox]$VMTemplateComboBox = $null
[System.Windows.Forms.CheckedListBox]$NSXTagCheckedListBox = $null
[System.Windows.Forms.Label]$label20 = $null
[System.Windows.Forms.Label]$label21 = $null
[System.Windows.Forms.CheckBox]$ReplaceVMCheckBox = $null
[System.Windows.Forms.TextBox]$ReplacementVMTextBox = $null
[System.Windows.Forms.GroupBox]$ReplaceVMGroupBox = $null
[System.Windows.Forms.Label]$label22 = $null
[System.Windows.Forms.CheckBox]$OverrideDHCPcheckBox = $null
[System.Windows.Forms.Label]$label23 = $null
[System.Windows.Forms.TextBox]$IPTextBox = $null
[System.Windows.Forms.TextBox]$SubnetTextBox = $null
[System.Windows.Forms.Label]$label24 = $null
[System.Windows.Forms.Label]$label25 = $null
[System.Windows.Forms.Label]$label26 = $null
[System.Windows.Forms.TextBox]$DGTextBox = $null
[System.Windows.Forms.CheckedListBox]$AppCheckedListBox = $null
[System.Windows.Forms.Label]$label27 = $null
[System.Windows.Forms.TextBox]$DNS1TextBox = $null
[System.Windows.Forms.Label]$label28 = $null
[System.Windows.Forms.TextBox]$DNS2TextBox = $null
[System.Windows.Forms.Label]$label8 = $null
[System.Windows.Forms.CheckedListBox]$VMTagCheckedListBox = $null
[System.Windows.Forms.ComboBox]$DatacentercomboBox = $null
[System.Windows.Forms.Label]$label29 = $null
[System.Windows.Forms.Button]$button1 = $null
function InitializeComponent
{
$vCenterTextBox = (New-Object -TypeName System.Windows.Forms.TextBox)
$NSXManagerTextBox = (New-Object -TypeName System.Windows.Forms.TextBox)
$label1 = (New-Object -TypeName System.Windows.Forms.Label)
$label2 = (New-Object -TypeName System.Windows.Forms.Label)
$VMNameBox = (New-Object -TypeName System.Windows.Forms.TextBox)
$label3 = (New-Object -TypeName System.Windows.Forms.Label)
$label4 = (New-Object -TypeName System.Windows.Forms.Label)
$label5 = (New-Object -TypeName System.Windows.Forms.Label)
$CPUnumericUpDown = (New-Object -TypeName System.Windows.Forms.NumericUpDown)
$label6 = (New-Object -TypeName System.Windows.Forms.Label)
$RAMnumericUpDown = (New-Object -TypeName System.Windows.Forms.NumericUpDown)
$DEVcheckBox = (New-Object -TypeName System.Windows.Forms.CheckBox)
$PCIcheckBox = (New-Object -TypeName System.Windows.Forms.CheckBox)
$DMZcheckBox = (New-Object -TypeName System.Windows.Forms.CheckBox)
$label7 = (New-Object -TypeName System.Windows.Forms.Label)
$SiteComboBox = (New-Object -TypeName System.Windows.Forms.ComboBox)
$label9 = (New-Object -TypeName System.Windows.Forms.Label)
$label10 = (New-Object -TypeName System.Windows.Forms.Label)
$ClusterComboBox = (New-Object -TypeName System.Windows.Forms.ComboBox)
$label11 = (New-Object -TypeName System.Windows.Forms.Label)
$HostComboBox = (New-Object -TypeName System.Windows.Forms.ComboBox)
$label12 = (New-Object -TypeName System.Windows.Forms.Label)
$PortGroupComboBox = (New-Object -TypeName System.Windows.Forms.ComboBox)
$label13 = (New-Object -TypeName System.Windows.Forms.Label)
$DatastoreComboBox = (New-Object -TypeName System.Windows.Forms.ComboBox)
$label14 = (New-Object -TypeName System.Windows.Forms.Label)
$OSCustomizationComboBox = (New-Object -TypeName System.Windows.Forms.ComboBox)
$label15 = (New-Object -TypeName System.Windows.Forms.Label)
$VMTypeComboBox = (New-Object -TypeName System.Windows.Forms.ComboBox)
$label16 = (New-Object -TypeName System.Windows.Forms.Label)
$FolderPathComboBox = (New-Object -TypeName System.Windows.Forms.ComboBox)
$label17 = (New-Object -TypeName System.Windows.Forms.Label)
$NotesTextBox = (New-Object -TypeName System.Windows.Forms.TextBox)
$label18 = (New-Object -TypeName System.Windows.Forms.Label)
$OwnersTextBox = (New-Object -TypeName System.Windows.Forms.TextBox)
$OKbutton = (New-Object -TypeName System.Windows.Forms.Button)
$Cancelbutton = (New-Object -TypeName System.Windows.Forms.Button)
$label19 = (New-Object -TypeName System.Windows.Forms.Label)
$VMTemplateComboBox = (New-Object -TypeName System.Windows.Forms.ComboBox)
$NSXTagCheckedListBox = (New-Object -TypeName System.Windows.Forms.CheckedListBox)
$label20 = (New-Object -TypeName System.Windows.Forms.Label)
$ReplaceVMCheckBox = (New-Object -TypeName System.Windows.Forms.CheckBox)
$ReplacementVMTextBox = (New-Object -TypeName System.Windows.Forms.TextBox)
$ReplaceVMGroupBox = (New-Object -TypeName System.Windows.Forms.GroupBox)
$label21 = (New-Object -TypeName System.Windows.Forms.Label)
$label22 = (New-Object -TypeName System.Windows.Forms.Label)
$AppCheckedListBox = (New-Object -TypeName System.Windows.Forms.CheckedListBox)
$OverrideDHCPcheckBox = (New-Object -TypeName System.Windows.Forms.CheckBox)
$label23 = (New-Object -TypeName System.Windows.Forms.Label)
$IPTextBox = (New-Object -TypeName System.Windows.Forms.TextBox)
$SubnetTextBox = (New-Object -TypeName System.Windows.Forms.TextBox)
$label24 = (New-Object -TypeName System.Windows.Forms.Label)
$label25 = (New-Object -TypeName System.Windows.Forms.Label)
$DGTextBox = (New-Object -TypeName System.Windows.Forms.TextBox)
$label26 = (New-Object -TypeName System.Windows.Forms.Label)
$label27 = (New-Object -TypeName System.Windows.Forms.Label)
$DNS1TextBox = (New-Object -TypeName System.Windows.Forms.TextBox)
$label28 = (New-Object -TypeName System.Windows.Forms.Label)
$DNS2TextBox = (New-Object -TypeName System.Windows.Forms.TextBox)
$label8 = (New-Object -TypeName System.Windows.Forms.Label)
$VMTagCheckedListBox = (New-Object -TypeName System.Windows.Forms.CheckedListBox)
$DatacentercomboBox = (New-Object -TypeName System.Windows.Forms.ComboBox)
$label29 = (New-Object -TypeName System.Windows.Forms.Label)
([System.ComponentModel.ISupportInitialize]$CPUnumericUpDown).BeginInit()
([System.ComponentModel.ISupportInitialize]$RAMnumericUpDown).BeginInit()
$ReplaceVMGroupBox.SuspendLayout()
$MainForm.SuspendLayout()
#
#vCenterTextBox
#
$vCenterTextBox.BackColor = [System.Drawing.SystemColors]::InactiveCaption
$vCenterTextBox.Location = (New-Object -TypeName System.Drawing.Point -ArgumentList @([System.Int32]113,[System.Int32]3))
$vCenterTextBox.Name = 'vCenterTextBox'
$vCenterTextBox.ReadOnly = $true
$vCenterTextBox.Size = (New-Object -TypeName System.Drawing.Size -ArgumentList @([System.Int32]332,[System.Int32]20))
$vCenterTextBox.TabIndex = [System.Int32]22
$vCenterTextBox.TabStop = $false
$vCenterTextBox.Text = '$global:DefaultVIServer | %{$._Name} '
#
#NSXManagerTextBox
#
$NSXManagerTextBox.BackColor = [System.Drawing.SystemColors]::InactiveCaption
$NSXManagerTextBox.Location = (New-Object -TypeName System.Drawing.Point -ArgumentList @([System.Int32]113,[System.Int32]26))
$NSXManagerTextBox.Name = 'NSXManagerTextBox'
$NSXManagerTextBox.ReadOnly = $true
$NSXManagerTextBox.Size = (New-Object -TypeName System.Drawing.Size -ArgumentList @([System.Int32]332,[System.Int32]20))
$NSXManagerTextBox.TabIndex = [System.Int32]23
$NSXManagerTextBox.TabStop = $false
$NSXManagerTextBox.Text = '$global:DefaultNSXConnection.Server'
#
#label1
#
$label1.AutoSize = $true
$label1.Location = (New-Object -TypeName System.Drawing.Point -ArgumentList @([System.Int32]14,[System.Int32]6))
$label1.Name = 'label1'
$label1.Size = (New-Object -TypeName System.Drawing.Size -ArgumentList @([System.Int32]44,[System.Int32]13))
$label1.TabIndex = [System.Int32]4
$label1.Text = 'vCenter'
$label1.add_Click($label1_Click)
#
#label2
#
$label2.AutoSize = $true
$label2.Location = (New-Object -TypeName System.Drawing.Point -ArgumentList @([System.Int32]13,[System.Int32]29))
$label2.Name = 'label2'
$label2.Size = (New-Object -TypeName System.Drawing.Size -ArgumentList @([System.Int32]74,[System.Int32]13))
$label2.TabIndex = [System.Int32]5
$label2.Text = 'NSX Manager'
$label2.add_Click($label2_Click)
#
#VMNameBox
#
$VMNameBox.CharacterCasing = [System.Windows.Forms.CharacterCasing]::Upper
$VMNameBox.ImeMode = [System.Windows.Forms.ImeMode]::NoControl
$VMNameBox.Location = (New-Object -TypeName System.Drawing.Point -ArgumentList @([System.Int32]113,[System.Int32]49))
$VMNameBox.MaxLength = [System.Int32]15
$VMNameBox.Name = 'VMNameBox'
$VMNameBox.Size = (New-Object -TypeName System.Drawing.Size -ArgumentList @([System.Int32]190,[System.Int32]20))
$VMNameBox.TabIndex = [System.Int32]0
$VMNameBox.add_TextChanged($VMNameBox_TextChanged)
#
#label3
#
$label3.AutoSize = $true
$label3.Location = (New-Object -TypeName System.Drawing.Point -ArgumentList @([System.Int32]15,[System.Int32]52))
$label3.Name = 'label3'
$label3.Size = (New-Object -TypeName System.Drawing.Size -ArgumentList @([System.Int32]54,[System.Int32]13))
$label3.TabIndex = [System.Int32]7
$label3.Text = 'VM Name'
$label3.add_Click($label3_Click)
#
#label4
#
$label4.AutoSize = $true
$label4.Location = (New-Object -TypeName System.Drawing.Point -ArgumentList @([System.Int32]305,[System.Int32]52))
$label4.Name = 'label4'
$label4.Size = (New-Object -TypeName System.Drawing.Size -ArgumentList @([System.Int32]138,[System.Int32]13))
$label4.TabIndex = [System.Int32]8
$label4.Text = '(Maximum of 15 Characters)'
#
#label5
#
$label5.AutoSize = $true
$label5.Location = (New-Object -TypeName System.Drawing.Point -ArgumentList @([System.Int32]14,[System.Int32]74))
$label5.Name = 'label5'
$label5.Size = (New-Object -TypeName System.Drawing.Size -ArgumentList @([System.Int32]56,[System.Int32]13))
$label5.TabIndex = [System.Int32]10
$label5.Text = '# of CPUs'
$label5.add_Click($label5_Click)
#
#CPUnumericUpDown
#
$CPUnumericUpDown.Location = (New-Object -TypeName System.Drawing.Point -ArgumentList @([System.Int32]113,[System.Int32]72))
$CPUnumericUpDown.Maximum = (New-Object -TypeName System.Decimal -ArgumentList @(@([System.Int32]0,[System.Int32]0,[System.Int32]0,[System.Int32]0)))
$CPUnumericUpDown.Name = 'CPUnumericUpDown'
$CPUnumericUpDown.Size = (New-Object -TypeName System.Drawing.Size -ArgumentList @([System.Int32]61,[System.Int32]20))
$CPUnumericUpDown.TabIndex = [System.Int32]1
#
#label6
#
$label6.AutoSize = $true
$label6.Location = (New-Object -TypeName System.Drawing.Point -ArgumentList @([System.Int32]14,[System.Int32]97))
$label6.Name = 'label6'
$label6.Size = (New-Object -TypeName System.Drawing.Size -ArgumentList @([System.Int32]66,[System.Int32]13))
$label6.TabIndex = [System.Int32]12
$label6.Text = 'GBs of RAM'
$label6.add_Click($label6_Click)
#
#RAMnumericUpDown
#
$RAMnumericUpDown.AllowDrop = $true
$RAMnumericUpDown.Location = (New-Object -TypeName System.Drawing.Point -ArgumentList @([System.Int32]113,[System.Int32]95))
$RAMnumericUpDown.Maximum = (New-Object -TypeName System.Decimal -ArgumentList @(@([System.Int32]0,[System.Int32]0,[System.Int32]0,[System.Int32]0)))
$RAMnumericUpDown.Name = 'RAMnumericUpDown'
$RAMnumericUpDown.Size = (New-Object -TypeName System.Drawing.Size -ArgumentList @([System.Int32]61,[System.Int32]20))
$RAMnumericUpDown.TabIndex = [System.Int32]2
#
#DEVcheckBox
#
$DEVcheckBox.AutoSize = $true
$DEVcheckBox.Location = (New-Object -TypeName System.Drawing.Point -ArgumentList @([System.Int32]114,[System.Int32]148))
$DEVcheckBox.Name = 'DEVcheckBox'
$DEVcheckBox.Size = (New-Object -TypeName System.Drawing.Size -ArgumentList @([System.Int32]67,[System.Int32]17))
$DEVcheckBox.TabIndex = [System.Int32]4
$DEVcheckBox.Text = 'DEV VM'
$DEVcheckBox.UseVisualStyleBackColor = $true
$DEVcheckBox.add_CheckedChanged($DEVcheckBox_CheckedChanged)
#
#PCIcheckBox
#
$PCIcheckBox.AutoSize = $true
$PCIcheckBox.Location = (New-Object -TypeName System.Drawing.Point -ArgumentList @([System.Int32]114,[System.Int32]194))
$PCIcheckBox.Name = 'PCIcheckBox'
$PCIcheckBox.Size = (New-Object -TypeName System.Drawing.Size -ArgumentList @([System.Int32]62,[System.Int32]17))
$PCIcheckBox.TabIndex = [System.Int32]6
$PCIcheckBox.Text = 'PCI VM'
$PCIcheckBox.UseVisualStyleBackColor = $true
#
#DMZcheckBox
#
$DMZcheckBox.AutoSize = $true
$DMZcheckBox.Location = (New-Object -TypeName System.Drawing.Point -ArgumentList @([System.Int32]114,[System.Int32]171))
$DMZcheckBox.Name = 'DMZcheckBox'
$DMZcheckBox.Size = (New-Object -TypeName System.Drawing.Size -ArgumentList @([System.Int32]69,[System.Int32]17))
$DMZcheckBox.TabIndex = [System.Int32]5
$DMZcheckBox.Text = 'DMZ VM'
$DMZcheckBox.UseVisualStyleBackColor = $true
$DMZcheckBox.add_CheckedChanged($checkBox3_CheckedChanged)
#
#label7
#
$label7.AutoSize = $true
$label7.Location = (New-Object -TypeName System.Drawing.Point -ArgumentList @([System.Int32]13,[System.Int32]172))
$label7.Name = 'label7'
$label7.Size = (New-Object -TypeName System.Drawing.Size -ArgumentList @([System.Int32]82,[System.Int32]13))
$label7.TabIndex = [System.Int32]19
$label7.Text = 'VM Designation'
$label7.add_Click($label7_Click)
#
#SiteComboBox
#
$SiteComboBox.FormattingEnabled = $true
$SiteComboBox.Items.AddRange(@('Production','DR'))
$SiteComboBox.Location = (New-Object -TypeName System.Drawing.Point -ArgumentList @([System.Int32]106,[System.Int32]221))
$SiteComboBox.Name = 'SiteComboBox'
$SiteComboBox.Size = (New-Object -TypeName System.Drawing.Size -ArgumentList @([System.Int32]339,[System.Int32]21))
$SiteComboBox.TabIndex = [System.Int32]9
#
#label9
#
$label9.AutoSize = $true
$label9.Location = (New-Object -TypeName System.Drawing.Point -ArgumentList @([System.Int32]15,[System.Int32]224))
$label9.Name = 'label9'
$label9.Size = (New-Object -TypeName System.Drawing.Size -ArgumentList @([System.Int32]44,[System.Int32]13))
$label9.TabIndex = [System.Int32]22
$label9.Text = 'VM Site'
$label9.add_Click($label9_Click)
#
#label10
#
$label10.AutoSize = $true
$label10.Location = (New-Object -TypeName System.Drawing.Point -ArgumentList @([System.Int32]15,[System.Int32]273))
$label10.Name = 'label10'
$label10.Size = (New-Object -TypeName System.Drawing.Size -ArgumentList @([System.Int32]39,[System.Int32]13))
$label10.TabIndex = [System.Int32]24
$label10.Text = 'Cluster'
#
#ClusterComboBox
#
$ClusterComboBox.FormattingEnabled = $true
$ClusterComboBox.Location = (New-Object -TypeName System.Drawing.Point -ArgumentList @([System.Int32]106,[System.Int32]270))
$ClusterComboBox.Name = 'ClusterComboBox'
$ClusterComboBox.Size = (New-Object -TypeName System.Drawing.Size -ArgumentList @([System.Int32]339,[System.Int32]21))
$ClusterComboBox.TabIndex = [System.Int32]11
$ClusterComboBox.add_SelectedIndexChanged($ClusterComboBox_SelectedIndexChanged)
#
#label11
#
$label11.AutoSize = $true
$label11.Location = (New-Object -TypeName System.Drawing.Point -ArgumentList @([System.Int32]15,[System.Int32]298))
$label11.Name = 'label11'
$label11.Size = (New-Object -TypeName System.Drawing.Size -ArgumentList @([System.Int32]29,[System.Int32]13))
$label11.TabIndex = [System.Int32]26
$label11.Text = 'Host'
#
#HostComboBox
#
$HostComboBox.FormattingEnabled = $true
$HostComboBox.Location = (New-Object -TypeName System.Drawing.Point -ArgumentList @([System.Int32]106,[System.Int32]295))
$HostComboBox.Name = 'HostComboBox'
$HostComboBox.Size = (New-Object -TypeName System.Drawing.Size -ArgumentList @([System.Int32]339,[System.Int32]21))
$HostComboBox.TabIndex = [System.Int32]12
#
#label12
#
$label12.AutoSize = $true
$label12.Location = (New-Object -TypeName System.Drawing.Point -ArgumentList @([System.Int32]15,[System.Int32]323))
$label12.Name = 'label12'
$label12.Size = (New-Object -TypeName System.Drawing.Size -ArgumentList @([System.Int32]58,[System.Int32]13))
$label12.TabIndex = [System.Int32]28
$label12.Text = 'Port Group'
#
#PortGroupComboBox
#
$PortGroupComboBox.FormattingEnabled = $true
$PortGroupComboBox.Location = (New-Object -TypeName System.Drawing.Point -ArgumentList @([System.Int32]106,[System.Int32]320))
$PortGroupComboBox.Name = 'PortGroupComboBox'
$PortGroupComboBox.Size = (New-Object -TypeName System.Drawing.Size -ArgumentList @([System.Int32]339,[System.Int32]21))
$PortGroupComboBox.TabIndex = [System.Int32]13
#
#label13
#
$label13.AutoSize = $true
$label13.Location = (New-Object -TypeName System.Drawing.Point -ArgumentList @([System.Int32]15,[System.Int32]348))
$label13.Name = 'label13'
$label13.Size = (New-Object -TypeName System.Drawing.Size -ArgumentList @([System.Int32]53,[System.Int32]13))
$label13.TabIndex = [System.Int32]30
$label13.Text = 'Datastore'
$label13.add_Click($label13_Click)
#
#DatastoreComboBox
#
$DatastoreComboBox.FormattingEnabled = $true
$DatastoreComboBox.Location = (New-Object -TypeName System.Drawing.Point -ArgumentList @([System.Int32]106,[System.Int32]345))
$DatastoreComboBox.Name = 'DatastoreComboBox'
$DatastoreComboBox.Size = (New-Object -TypeName System.Drawing.Size -ArgumentList @([System.Int32]339,[System.Int32]21))
$DatastoreComboBox.TabIndex = [System.Int32]14
$DatastoreComboBox.add_SelectedIndexChanged($comboBox1_SelectedIndexChanged)
#
#label14
#
$label14.AutoSize = $true
$label14.Location = (New-Object -TypeName System.Drawing.Point -ArgumentList @([System.Int32]13,[System.Int32]373))
$label14.Name = 'label14'
$label14.Size = (New-Object -TypeName System.Drawing.Size -ArgumentList @([System.Int32]90,[System.Int32]13))
$label14.TabIndex = [System.Int32]32
$label14.Text = 'OS Customization'
$label14.add_Click($label14_Click)
#
#OSCustomizationComboBox
#
$OSCustomizationComboBox.DropDownStyle = [System.Windows.Forms.ComboBoxStyle]::DropDownList
$OSCustomizationComboBox.FormattingEnabled = $true
$OSCustomizationComboBox.Location = (New-Object -TypeName System.Drawing.Point -ArgumentList @([System.Int32]106,[System.Int32]370))
$OSCustomizationComboBox.Name = 'OSCustomizationComboBox'
$OSCustomizationComboBox.Size = (New-Object -TypeName System.Drawing.Size -ArgumentList @([System.Int32]339,[System.Int32]21))
$OSCustomizationComboBox.TabIndex = [System.Int32]15
#
#label15
#
$label15.AutoSize = $true
$label15.Location = (New-Object -TypeName System.Drawing.Point -ArgumentList @([System.Int32]15,[System.Int32]398))
$label15.Name = 'label15'
$label15.Size = (New-Object -TypeName System.Drawing.Size -ArgumentList @([System.Int32]69,[System.Int32]13))
$label15.TabIndex = [System.Int32]34
$label15.Text = 'VM HD Type'
$label15.add_Click($label15_Click)
#
#VMTypeComboBox
#
$VMTypeComboBox.DropDownStyle = [System.Windows.Forms.ComboBoxStyle]::DropDownList
$VMTypeComboBox.FormattingEnabled = $true
$VMTypeComboBox.Items.AddRange(@('1generic','2generic','3generic','4generic','5generic','EXTAPPS','FileServer','IIS','SQL','Unmodified'))
$VMTypeComboBox.Location = (New-Object -TypeName System.Drawing.Point -ArgumentList @([System.Int32]106,[System.Int32]395))
$VMTypeComboBox.Name = 'VMTypeComboBox'
$VMTypeComboBox.Size = (New-Object -TypeName System.Drawing.Size -ArgumentList @([System.Int32]339,[System.Int32]21))
$VMTypeComboBox.TabIndex = [System.Int32]16
#
#label16
#
$label16.AutoSize = $true
$label16.Location = (New-Object -TypeName System.Drawing.Point -ArgumentList @([System.Int32]15,[System.Int32]423))
$label16.Name = 'label16'
$label16.Size = (New-Object -TypeName System.Drawing.Size -ArgumentList @([System.Int32]80,[System.Int32]13))
$label16.TabIndex = [System.Int32]36
$label16.Text = 'VM Folder Path'
#
#FolderPathComboBox
#
$FolderPathComboBox.FormattingEnabled = $true
$FolderPathComboBox.Location = (New-Object -TypeName System.Drawing.Point -ArgumentList @([System.Int32]106,[System.Int32]420))
$FolderPathComboBox.Name = 'FolderPathComboBox'
$FolderPathComboBox.Size = (New-Object -TypeName System.Drawing.Size -ArgumentList @([System.Int32]339,[System.Int32]21))
$FolderPathComboBox.TabIndex = [System.Int32]17
#
#label17
#
$label17.AutoSize = $true
$label17.Location = (New-Object -TypeName System.Drawing.Point -ArgumentList @([System.Int32]15,[System.Int32]447))
$label17.Name = 'label17'
$label17.Size = (New-Object -TypeName System.Drawing.Size -ArgumentList @([System.Int32]54,[System.Int32]13))
$label17.TabIndex = [System.Int32]38
$label17.Text = 'VM Notes'
$label17.add_Click($label17_Click)
#
#NotesTextBox
#
$NotesTextBox.ImeMode = [System.Windows.Forms.ImeMode]::NoControl
$NotesTextBox.Location = (New-Object -TypeName System.Drawing.Point -ArgumentList @([System.Int32]106,[System.Int32]444))
$NotesTextBox.MaxLength = [System.Int32]512
$NotesTextBox.Multiline = $true
$NotesTextBox.Name = 'NotesTextBox'
$NotesTextBox.Size = (New-Object -TypeName System.Drawing.Size -ArgumentList @([System.Int32]339,[System.Int32]20))
$NotesTextBox.TabIndex = [System.Int32]18
$NotesTextBox.add_TextChanged($textBox3_TextChanged)
#
#label18
#
$label18.AutoSize = $true
$label18.Location = (New-Object -TypeName System.Drawing.Point -ArgumentList @([System.Int32]15,[System.Int32]470))
$label18.Name = 'label18'
$label18.Size = (New-Object -TypeName System.Drawing.Size -ArgumentList @([System.Int32]68,[System.Int32]13))
$label18.TabIndex = [System.Int32]40
$label18.Text = 'VM Owner(s)'
#
#OwnersTextBox
#
$OwnersTextBox.ImeMode = [System.Windows.Forms.ImeMode]::NoControl
$OwnersTextBox.Location = (New-Object -TypeName System.Drawing.Point -ArgumentList @([System.Int32]106,[System.Int32]467))
$OwnersTextBox.MaxLength = [System.Int32]256
$OwnersTextBox.Name = 'OwnersTextBox'
$OwnersTextBox.Size = (New-Object -TypeName System.Drawing.Size -ArgumentList @([System.Int32]339,[System.Int32]20))
$OwnersTextBox.TabIndex = [System.Int32]19
#
#OKbutton
#
$OKbutton.Location = (New-Object -TypeName System.Drawing.Point -ArgumentList @([System.Int32]162,[System.Int32]710))
$OKbutton.Name = 'OKbutton'
$OKbutton.Size = (New-Object -TypeName System.Drawing.Size -ArgumentList @([System.Int32]75,[System.Int32]23))
$OKbutton.TabIndex = [System.Int32]29
$OKbutton.Text = 'OK'
$OKbutton.UseVisualStyleBackColor = $true
$OKbutton.add_Click($OKbutton_Click)
#
#Cancelbutton
#
$Cancelbutton.Location = (New-Object -TypeName System.Drawing.Point -ArgumentList @([System.Int32]258,[System.Int32]710))
$Cancelbutton.Name = 'Cancelbutton'
$Cancelbutton.Size = (New-Object -TypeName System.Drawing.Size -ArgumentList @([System.Int32]75,[System.Int32]23))
$Cancelbutton.TabIndex = [System.Int32]30
$Cancelbutton.Text = 'Cancel'
$Cancelbutton.UseVisualStyleBackColor = $true
$Cancelbutton.add_Click($Cancelbutton_Click)
#
#label19
#
$label19.AutoSize = $true
$label19.Location = (New-Object -TypeName System.Drawing.Point -ArgumentList @([System.Int32]13,[System.Int32]122))
$label19.Name = 'label19'
$label19.Size = (New-Object -TypeName System.Drawing.Size -ArgumentList @([System.Int32]70,[System.Int32]13))
$label19.TabIndex = [System.Int32]42
$label19.Text = 'VM Template'
$label19.add_Click($label19_Click)
#
#VMTemplateComboBox
#
$VMTemplateComboBox.FormattingEnabled = $true
$VMTemplateComboBox.Items.AddRange(@('US','CAN','UK'))
$VMTemplateComboBox.Location = (New-Object -TypeName System.Drawing.Point -ArgumentList @([System.Int32]113,[System.Int32]119))
$VMTemplateComboBox.Name = 'VMTemplateComboBox'
$VMTemplateComboBox.Size = (New-Object -TypeName System.Drawing.Size -ArgumentList @([System.Int32]332,[System.Int32]21))
$VMTemplateComboBox.TabIndex = [System.Int32]3
$VMTemplateComboBox.add_SelectedIndexChanged($comboBox1_SelectedIndexChanged_1)
#
#NSXTagCheckedListBox
#
$NSXTagCheckedListBox.AccessibleDescription = 'NSX Tags'
$NSXTagCheckedListBox.FormattingEnabled = $true
$NSXTagCheckedListBox.HorizontalScrollbar = $true
$NSXTagCheckedListBox.Items.AddRange(@('Test1','Test2','Test3'))
$NSXTagCheckedListBox.Location = (New-Object -TypeName System.Drawing.Point -ArgumentList @([System.Int32]106,[System.Int32]658))
$NSXTagCheckedListBox.Name = 'NSXTagCheckedListBox'
$NSXTagCheckedListBox.Size = (New-Object -TypeName System.Drawing.Size -ArgumentList @([System.Int32]339,[System.Int32]49))
$NSXTagCheckedListBox.TabIndex = [System.Int32]28
$NSXTagCheckedListBox.Visible = $false
#
#label20
#
$label20.AutoSize = $true
$label20.Location = (New-Object -TypeName System.Drawing.Point -ArgumentList @([System.Int32]15,[System.Int32]674))
$label20.Name = 'label20'
$label20.Size = (New-Object -TypeName System.Drawing.Size -ArgumentList @([System.Int32]56,[System.Int32]13))
$label20.TabIndex = [System.Int32]44
$label20.Text = 'NSX Tags'
#
#ReplaceVMCheckBox
#
$ReplaceVMCheckBox.AutoSize = $true
$ReplaceVMCheckBox.Location = (New-Object -TypeName System.Drawing.Point -ArgumentList @([System.Int32]6,[System.Int32]19))
$ReplaceVMCheckBox.Name = 'ReplaceVMCheckBox'
$ReplaceVMCheckBox.Size = (New-Object -TypeName System.Drawing.Size -ArgumentList @([System.Int32]124,[System.Int32]17))
$ReplaceVMCheckBox.TabIndex = [System.Int32]7
$ReplaceVMCheckBox.Text = 'Replace Existing VM'
$ReplaceVMCheckBox.UseVisualStyleBackColor = $true
$ReplaceVMCheckBox.add_CheckedChanged($ReplaceVMCheckBox_CheckedChanged)
#
#ReplacementVMTextBox
#
$ReplacementVMTextBox.Location = (New-Object -TypeName System.Drawing.Point -ArgumentList @([System.Int32]57,[System.Int32]48))
$ReplacementVMTextBox.Name = 'ReplacementVMTextBox'
$ReplacementVMTextBox.Size = (New-Object -TypeName System.Drawing.Size -ArgumentList @([System.Int32]191,[System.Int32]20))
$ReplacementVMTextBox.TabIndex = [System.Int32]8
$ReplacementVMTextBox.add_TextChanged($textBox1_TextChanged)
#
#ReplaceVMGroupBox
#
$ReplaceVMGroupBox.Controls.Add($label21)
$ReplaceVMGroupBox.Controls.Add($ReplaceVMCheckBox)
$ReplaceVMGroupBox.Controls.Add($ReplacementVMTextBox)
$ReplaceVMGroupBox.Location = (New-Object -TypeName System.Drawing.Point -ArgumentList @([System.Int32]189,[System.Int32]143))
$ReplaceVMGroupBox.Name = 'ReplaceVMGroupBox'
$ReplaceVMGroupBox.Size = (New-Object -TypeName System.Drawing.Size -ArgumentList @([System.Int32]256,[System.Int32]76))
$ReplaceVMGroupBox.TabIndex = [System.Int32]47
$ReplaceVMGroupBox.TabStop = $false
$ReplaceVMGroupBox.Text = 'Replace VM'
#
#label21
#
$label21.AutoSize = $true
$label21.Location = (New-Object -TypeName System.Drawing.Point -ArgumentList @([System.Int32]3,[System.Int32]51))
$label21.Name = 'label21'
$label21.Size = (New-Object -TypeName System.Drawing.Size -ArgumentList @([System.Int32]54,[System.Int32]13))
$label21.TabIndex = [System.Int32]47
$label21.Text = 'VM Name'
#
#label22
#
$label22.AutoSize = $true
$label22.Location = (New-Object -TypeName System.Drawing.Point -ArgumentList @([System.Int32]15,[System.Int32]506))
$label22.Name = 'label22'
$label22.Size = (New-Object -TypeName System.Drawing.Size -ArgumentList @([System.Int32]73,[System.Int32]13))
$label22.TabIndex = [System.Int32]48
$label22.Text = 'Apps to Install'
#
#AppCheckedListBox
#
$AppCheckedListBox.FormattingEnabled = $true
$AppCheckedListBox.Location = (New-Object -TypeName System.Drawing.Point -ArgumentList @([System.Int32]106,[System.Int32]490))
$AppCheckedListBox.Name = 'AppCheckedListBox'
$AppCheckedListBox.Size = (New-Object -TypeName System.Drawing.Size -ArgumentList @([System.Int32]339,[System.Int32]49))
$AppCheckedListBox.TabIndex = [System.Int32]20
$AppCheckedListBox.add_SelectedIndexChanged($checkedListBox1_SelectedIndexChanged)
#
#OverrideDHCPcheckBox
#
$OverrideDHCPcheckBox.AutoSize = $true
$OverrideDHCPcheckBox.Location = (New-Object -TypeName System.Drawing.Point -ArgumentList @([System.Int32]112,[System.Int32]541))
$OverrideDHCPcheckBox.Name = 'OverrideDHCPcheckBox'
$OverrideDHCPcheckBox.Size = (New-Object -TypeName System.Drawing.Size -ArgumentList @([System.Int32]131,[System.Int32]17))
$OverrideDHCPcheckBox.TabIndex = [System.Int32]21
$OverrideDHCPcheckBox.Text = 'Check to Set Static IP'
$OverrideDHCPcheckBox.UseVisualStyleBackColor = $true
#
#label23
#
$label23.AutoSize = $true
$label23.Location = (New-Object -TypeName System.Drawing.Point -ArgumentList @([System.Int32]15,[System.Int32]541))
$label23.Name = 'label23'
$label23.Size = (New-Object -TypeName System.Drawing.Size -ArgumentList @([System.Int32]80,[System.Int32]13))
$label23.TabIndex = [System.Int32]51
$label23.Text = 'Override DHCP'
$label23.add_Click($label23_Click)
#
#IPTextBox
#
$IPTextBox.Location = (New-Object -TypeName System.Drawing.Point -ArgumentList @([System.Int32]88,[System.Int32]558))
$IPTextBox.MaxLength = [System.Int32]15
$IPTextBox.Name = 'IPTextBox'
$IPTextBox.Size = (New-Object -TypeName System.Drawing.Size -ArgumentList @([System.Int32]96,[System.Int32]20))
$IPTextBox.TabIndex = [System.Int32]22
#
#SubnetTextBox
#
$SubnetTextBox.Location = (New-Object -TypeName System.Drawing.Point -ArgumentList @([System.Int32]226,[System.Int32]558))
$SubnetTextBox.MaxLength = [System.Int32]15
$SubnetTextBox.Name = 'SubnetTextBox'
$SubnetTextBox.Size = (New-Object -TypeName System.Drawing.Size -ArgumentList @([System.Int32]96,[System.Int32]20))
$SubnetTextBox.TabIndex = [System.Int32]23
#
#label24
#
$label24.AutoSize = $true
$label24.Location = (New-Object -TypeName System.Drawing.Point -ArgumentList @([System.Int32]70,[System.Int32]561))
$label24.Name = 'label24'
$label24.Size = (New-Object -TypeName System.Drawing.Size -ArgumentList @([System.Int32]17,[System.Int32]13))
$label24.TabIndex = [System.Int32]54
$label24.Text = 'IP'
#
#label25
#
$label25.AutoSize = $true
$label25.Location = (New-Object -TypeName System.Drawing.Point -ArgumentList @([System.Int32]185,[System.Int32]561))
$label25.Name = 'label25'
$label25.Size = (New-Object -TypeName System.Drawing.Size -ArgumentList @([System.Int32]41,[System.Int32]13))
$label25.TabIndex = [System.Int32]55
$label25.Text = 'Subnet'
#
#DGTextBox
#
$DGTextBox.Location = (New-Object -TypeName System.Drawing.Point -ArgumentList @([System.Int32]349,[System.Int32]558))
$DGTextBox.MaxLength = [System.Int32]15
$DGTextBox.Name = 'DGTextBox'
$DGTextBox.Size = (New-Object -TypeName System.Drawing.Size -ArgumentList @([System.Int32]96,[System.Int32]20))
$DGTextBox.TabIndex = [System.Int32]24
#
#label26
#
$label26.AutoSize = $true
$label26.Location = (New-Object -TypeName System.Drawing.Point -ArgumentList @([System.Int32]325,[System.Int32]561))
$label26.Name = 'label26'
$label26.Size = (New-Object -TypeName System.Drawing.Size -ArgumentList @([System.Int32]23,[System.Int32]13))
$label26.TabIndex = [System.Int32]57
$label26.Text = 'DG'
#
#label27
#
$label27.AutoSize = $true
$label27.Location = (New-Object -TypeName System.Drawing.Point -ArgumentList @([System.Int32]52,[System.Int32]586))
$label27.Name = 'label27'
$label27.Size = (New-Object -TypeName System.Drawing.Size -ArgumentList @([System.Int32]36,[System.Int32]13))
$label27.TabIndex = [System.Int32]58
$label27.Text = 'DNS1'
#
#DNS1TextBox
#
$DNS1TextBox.Location = (New-Object -TypeName System.Drawing.Point -ArgumentList @([System.Int32]87,[System.Int32]583))
$DNS1TextBox.MaxLength = [System.Int32]15
$DNS1TextBox.Name = 'DNS1TextBox'
$DNS1TextBox.Size = (New-Object -TypeName System.Drawing.Size -ArgumentList @([System.Int32]96,[System.Int32]20))
$DNS1TextBox.TabIndex = [System.Int32]25
#
#label28
#
$label28.AutoSize = $true
$label28.Location = (New-Object -TypeName System.Drawing.Point -ArgumentList @([System.Int32]189,[System.Int32]586))
$label28.Name = 'label28'
$label28.Size = (New-Object -TypeName System.Drawing.Size -ArgumentList @([System.Int32]36,[System.Int32]13))
$label28.TabIndex = [System.Int32]60
$label28.Text = 'DNS2'
#
#DNS2TextBox
#
$DNS2TextBox.Location = (New-Object -TypeName System.Drawing.Point -ArgumentList @([System.Int32]226,[System.Int32]583))
$DNS2TextBox.Name = 'DNS2TextBox'
$DNS2TextBox.Size = (New-Object -TypeName System.Drawing.Size -ArgumentList @([System.Int32]96,[System.Int32]20))
$DNS2TextBox.TabIndex = [System.Int32]26
#
#label8
#
$label8.AutoSize = $true
$label8.Location = (New-Object -TypeName System.Drawing.Point -ArgumentList @([System.Int32]14,[System.Int32]627))
$label8.Name = 'label8'
$label8.Size = (New-Object -TypeName System.Drawing.Size -ArgumentList @([System.Int32]50,[System.Int32]13))
$label8.TabIndex = [System.Int32]62
$label8.Text = 'VM Tags'
#
#VMTagCheckedListBox
#
$VMTagCheckedListBox.FormattingEnabled = $true
$VMTagCheckedListBox.HorizontalScrollbar = $true
$VMTagCheckedListBox.Location = (New-Object -TypeName System.Drawing.Point -ArgumentList @([System.Int32]106,[System.Int32]606))
$VMTagCheckedListBox.Name = 'VMTagCheckedListBox'
$VMTagCheckedListBox.Size = (New-Object -TypeName System.Drawing.Size -ArgumentList @([System.Int32]339,[System.Int32]49))
$VMTagCheckedListBox.TabIndex = [System.Int32]27
#
#DatacentercomboBox
#
$DatacentercomboBox.FormattingEnabled = $true
$DatacentercomboBox.Location = (New-Object -TypeName System.Drawing.Point -ArgumentList @([System.Int32]106,[System.Int32]245))
$DatacentercomboBox.Name = 'DatacentercomboBox'
$DatacentercomboBox.Size = (New-Object -TypeName System.Drawing.Size -ArgumentList @([System.Int32]339,[System.Int32]21))
$DatacentercomboBox.TabIndex = [System.Int32]10
#
#label29
#
$label29.AutoSize = $true
$label29.Location = (New-Object -TypeName System.Drawing.Point -ArgumentList @([System.Int32]15,[System.Int32]248))
$label29.Name = 'label29'
$label29.Size = (New-Object -TypeName System.Drawing.Size -ArgumentList @([System.Int32]60,[System.Int32]13))
$label29.TabIndex = [System.Int32]65
$label29.Text = 'Datacenter'
#
#MainForm
#
$MainForm.AutoScroll = $true
$MainForm.AutoSize = $true
$MainForm.AutoSizeMode = [System.Windows.Forms.AutoSizeMode]::GrowAndShrink
$MainForm.ClientSize = (New-Object -TypeName System.Drawing.Size -ArgumentList @([System.Int32]457,[System.Int32]735))
$MainForm.Controls.Add($label29)
$MainForm.Controls.Add($DatacentercomboBox)
$MainForm.Controls.Add($VMTagCheckedListBox)
$MainForm.Controls.Add($label8)
$MainForm.Controls.Add($DNS2TextBox)
$MainForm.Controls.Add($label28)
$MainForm.Controls.Add($DNS1TextBox)
$MainForm.Controls.Add($label27)
$MainForm.Controls.Add($label26)
$MainForm.Controls.Add($DGTextBox)
$MainForm.Controls.Add($label25)
$MainForm.Controls.Add($label24)
$MainForm.Controls.Add($SubnetTextBox)
$MainForm.Controls.Add($IPTextBox)
$MainForm.Controls.Add($label23)
$MainForm.Controls.Add($OverrideDHCPcheckBox)
$MainForm.Controls.Add($AppCheckedListBox)
$MainForm.Controls.Add($label22)
$MainForm.Controls.Add($label20)
$MainForm.Controls.Add($NSXTagCheckedListBox)
$MainForm.Controls.Add($label19)
$MainForm.Controls.Add($VMTemplateComboBox)
$MainForm.Controls.Add($Cancelbutton)
$MainForm.Controls.Add($OKbutton)
$MainForm.Controls.Add($label18)
$MainForm.Controls.Add($OwnersTextBox)
$MainForm.Controls.Add($label17)
$MainForm.Controls.Add($NotesTextBox)
$MainForm.Controls.Add($label16)
$MainForm.Controls.Add($FolderPathComboBox)
$MainForm.Controls.Add($label15)
$MainForm.Controls.Add($VMTypeComboBox)
$MainForm.Controls.Add($label14)
$MainForm.Controls.Add($OSCustomizationComboBox)
$MainForm.Controls.Add($label13)
$MainForm.Controls.Add($DatastoreComboBox)
$MainForm.Controls.Add($label12)
$MainForm.Controls.Add($PortGroupComboBox)
$MainForm.Controls.Add($label11)
$MainForm.Controls.Add($HostComboBox)
$MainForm.Controls.Add($label10)
$MainForm.Controls.Add($ClusterComboBox)
$MainForm.Controls.Add($label9)
$MainForm.Controls.Add($SiteComboBox)
$MainForm.Controls.Add($label7)
$MainForm.Controls.Add($DMZcheckBox)
$MainForm.Controls.Add($PCIcheckBox)
$MainForm.Controls.Add($DEVcheckBox)
$MainForm.Controls.Add($RAMnumericUpDown)
$MainForm.Controls.Add($label6)
$MainForm.Controls.Add($CPUnumericUpDown)
$MainForm.Controls.Add($label5)
$MainForm.Controls.Add($label4)
$MainForm.Controls.Add($label3)
$MainForm.Controls.Add($VMNameBox)
$MainForm.Controls.Add($label2)
$MainForm.Controls.Add($label1)
$MainForm.Controls.Add($NSXManagerTextBox)
$MainForm.Controls.Add($vCenterTextBox)
$MainForm.Controls.Add($ReplaceVMGroupBox)
$MainForm.Name = 'MainForm'
$MainForm.StartPosition = [System.Windows.Forms.FormStartPosition]::CenterScreen
$MainForm.Text = 'VM Configuration'
$MainForm.TopMost = $true
$MainForm.add_Load($MainForm_Load)
([System.ComponentModel.ISupportInitialize]$CPUnumericUpDown).EndInit()
([System.ComponentModel.ISupportInitialize]$RAMnumericUpDown).EndInit()
$ReplaceVMGroupBox.ResumeLayout($false)
$ReplaceVMGroupBox.PerformLayout()
$MainForm.ResumeLayout($false)
$MainForm.PerformLayout()
Add-Member -InputObject $MainForm -Name base -Value $base -MemberType NoteProperty
Add-Member -InputObject $MainForm -Name label1 -Value $label1 -MemberType NoteProperty
Add-Member -InputObject $MainForm -Name label2 -Value $label2 -MemberType NoteProperty
Add-Member -InputObject $MainForm -Name label3 -Value $label3 -MemberType NoteProperty
Add-Member -InputObject $MainForm -Name label4 -Value $label4 -MemberType NoteProperty
Add-Member -InputObject $MainForm -Name label5 -Value $label5 -MemberType NoteProperty
Add-Member -InputObject $MainForm -Name label6 -Value $label6 -MemberType NoteProperty
Add-Member -InputObject $MainForm -Name label7 -Value $label7 -MemberType NoteProperty
Add-Member -InputObject $MainForm -Name label9 -Value $label9 -MemberType NoteProperty
Add-Member -InputObject $MainForm -Name label10 -Value $label10 -MemberType NoteProperty
Add-Member -InputObject $MainForm -Name label11 -Value $label11 -MemberType NoteProperty
Add-Member -InputObject $MainForm -Name label12 -Value $label12 -MemberType NoteProperty
Add-Member -InputObject $MainForm -Name VMNameBox -Value $VMNameBox -MemberType NoteProperty
Add-Member -InputObject $MainForm -Name CPUnumericUpDown -Value $CPUnumericUpDown -MemberType NoteProperty
Add-Member -InputObject $MainForm -Name RAMnumericUpDown -Value $RAMnumericUpDown -MemberType NoteProperty
Add-Member -InputObject $MainForm -Name DEVcheckBox -Value $DEVcheckBox -MemberType NoteProperty
Add-Member -InputObject $MainForm -Name PCIcheckBox -Value $PCIcheckBox -MemberType NoteProperty
Add-Member -InputObject $MainForm -Name DMZcheckBox -Value $DMZcheckBox -MemberType NoteProperty
Add-Member -InputObject $MainForm -Name SiteComboBox -Value $SiteComboBox -MemberType NoteProperty
Add-Member -InputObject $MainForm -Name ClusterComboBox -Value $ClusterComboBox -MemberType NoteProperty
Add-Member -InputObject $MainForm -Name HostComboBox -Value $HostComboBox -MemberType NoteProperty
Add-Member -InputObject $MainForm -Name PortGroupComboBox -Value $PortGroupComboBox -MemberType NoteProperty
Add-Member -InputObject $MainForm -Name label13 -Value $label13 -MemberType NoteProperty
Add-Member -InputObject $MainForm -Name DatastoreComboBox -Value $DatastoreComboBox -MemberType NoteProperty
Add-Member -InputObject $MainForm -Name label14 -Value $label14 -MemberType NoteProperty
Add-Member -InputObject $MainForm -Name OSCustomizationComboBox -Value $OSCustomizationComboBox -MemberType NoteProperty
Add-Member -InputObject $MainForm -Name label15 -Value $label15 -MemberType NoteProperty
Add-Member -InputObject $MainForm -Name VMTypeComboBox -Value $VMTypeComboBox -MemberType NoteProperty
Add-Member -InputObject $MainForm -Name label16 -Value $label16 -MemberType NoteProperty
Add-Member -InputObject $MainForm -Name FolderPathComboBox -Value $FolderPathComboBox -MemberType NoteProperty
Add-Member -InputObject $MainForm -Name label17 -Value $label17 -MemberType NoteProperty
Add-Member -InputObject $MainForm -Name label18 -Value $label18 -MemberType NoteProperty
Add-Member -InputObject $MainForm -Name OKbutton -Value $OKbutton -MemberType NoteProperty
Add-Member -InputObject $MainForm -Name Cancelbutton -Value $Cancelbutton -MemberType NoteProperty
Add-Member -InputObject $MainForm -Name vCenterTextBox -Value $vCenterTextBox -MemberType NoteProperty
Add-Member -InputObject $MainForm -Name NSXManagerTextBox -Value $NSXManagerTextBox -MemberType NoteProperty
Add-Member -InputObject $MainForm -Name NotesTextBox -Value $NotesTextBox -MemberType NoteProperty
Add-Member -InputObject $MainForm -Name OwnersTextBox -Value $OwnersTextBox -MemberType NoteProperty
Add-Member -InputObject $MainForm -Name label19 -Value $label19 -MemberType NoteProperty
Add-Member -InputObject $MainForm -Name VMTemplateComboBox -Value $VMTemplateComboBox -MemberType NoteProperty
Add-Member -InputObject $MainForm -Name NSXTagCheckedListBox -Value $NSXTagCheckedListBox -MemberType NoteProperty
Add-Member -InputObject $MainForm -Name label20 -Value $label20 -MemberType NoteProperty
Add-Member -InputObject $MainForm -Name label21 -Value $label21 -MemberType NoteProperty
Add-Member -InputObject $MainForm -Name ReplaceVMCheckBox -Value $ReplaceVMCheckBox -MemberType NoteProperty
Add-Member -InputObject $MainForm -Name ReplacementVMTextBox -Value $ReplacementVMTextBox -MemberType NoteProperty
Add-Member -InputObject $MainForm -Name ReplaceVMGroupBox -Value $ReplaceVMGroupBox -MemberType NoteProperty
Add-Member -InputObject $MainForm -Name label22 -Value $label22 -MemberType NoteProperty
Add-Member -InputObject $MainForm -Name OverrideDHCPcheckBox -Value $OverrideDHCPcheckBox -MemberType NoteProperty
Add-Member -InputObject $MainForm -Name label23 -Value $label23 -MemberType NoteProperty
Add-Member -InputObject $MainForm -Name IPTextBox -Value $IPTextBox -MemberType NoteProperty
Add-Member -InputObject $MainForm -Name SubnetTextBox -Value $SubnetTextBox -MemberType NoteProperty
Add-Member -InputObject $MainForm -Name label24 -Value $label24 -MemberType NoteProperty
Add-Member -InputObject $MainForm -Name label25 -Value $label25 -MemberType NoteProperty
Add-Member -InputObject $MainForm -Name label26 -Value $label26 -MemberType NoteProperty
Add-Member -InputObject $MainForm -Name DGTextBox -Value $DGTextBox -MemberType NoteProperty
Add-Member -InputObject $MainForm -Name AppCheckedListBox -Value $AppCheckedListBox -MemberType NoteProperty
Add-Member -InputObject $MainForm -Name label27 -Value $label27 -MemberType NoteProperty
Add-Member -InputObject $MainForm -Name DNS1TextBox -Value $DNS1TextBox -MemberType NoteProperty
Add-Member -InputObject $MainForm -Name label28 -Value $label28 -MemberType NoteProperty
Add-Member -InputObject $MainForm -Name DNS2TextBox -Value $DNS2TextBox -MemberType NoteProperty
Add-Member -InputObject $MainForm -Name label8 -Value $label8 -MemberType NoteProperty
Add-Member -InputObject $MainForm -Name VMTagCheckedListBox -Value $VMTagCheckedListBox -MemberType NoteProperty
Add-Member -InputObject $MainForm -Name DatacentercomboBox -Value $DatacentercomboBox -MemberType NoteProperty
Add-Member -InputObject $MainForm -Name label29 -Value $label29 -MemberType NoteProperty
Add-Member -InputObject $MainForm -Name button1 -Value $button1 -MemberType NoteProperty
}
. InitializeComponent
