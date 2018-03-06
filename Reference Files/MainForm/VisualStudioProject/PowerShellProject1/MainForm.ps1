$label14_Click = {

}

$VMNameBox_TextChanged = {

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