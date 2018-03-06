$label23_Click = {

}

$checkedListBox1_SelectedIndexChanged = {

}

$ReplaceVMCheckBox_CheckedChanged = {

}

$textBox1_TextChanged = {

}

$DEVcheckBox_CheckedChanged = {

}


$comboBox1_SelectedIndexChanged_1 = {

}

$label19_Click = {

}

$comboBox1_SelectedIndexChanged = {

}

$OKbutton_Click = {

}

$Cancelbutton_Click = {
	Disconnect-VIServer -Confirm $false
	Disconnect-NSXServer -Confirm $false
	Stop-Transcript
}

$MainForm_Load = {

}

$folderBrowserDialog1_HelpRequest = {

}

. (Join-Path $PSScriptRoot 'Form1.designer.ps1')

$MainForm.ShowDialog()