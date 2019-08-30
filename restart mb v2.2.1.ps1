If (-NOT ([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator))
{
  # Relaunch as an elevated process:
  Start-Process powershell.exe "-File",('"{0}"' -f $MyInvocation.MyCommand.Path) -verb RunAs
  exit
}

Add-Type -AssemblyName System.Windows.Forms
$form = New-Object Windows.Forms.Form
$form.Size = New-Object Drawing.Size @(250, 250)
$form.StartPosition = "CenterScreen"

$box1 = New-Object System.windows.Forms.Textbox
$box1.Location = New-Object System.Drawing.Size(20,50)
$box1.Size = New-Object System.Drawing.Size(200,180)
$box1.text = "Enter Computer Names"


$btn1 = New-Object System.Windows.Forms.Button
$btn1.Location = New-Object System.Drawing.Size(150,150)
$btn1.Size = New-Object System.Drawing.Size(50,50)
$btn1.add_click{
  $computerNames = $box1.text.split(',') ## This splits your input string on commas into a list

  forEach ($computerName in $computerNames) { ## This loops through your list so you can take action with each list item
    ## do your previous action, once for each $computerName in the list
    $stop_results = (Get-WmiObject Win32_Service -filter "name='mbendpointagent'" -ComputerName $computerName).StopService() | format-list ReturnValue | out-string
	write-host "$stop_results"
	
  }
}
$btn1.Text = "Stop"

$btn2 = New-Object System.Windows.Forms.Button
$btn2.Location = New-Object System.Drawing.Size(90,150)
$btn2.Size = New-Object System.Drawing.Size(50,50)
$btn2.add_click{
  $computerNames = $box1.text.split(',') ## This splits your input string on commas into a list

  forEach ($computerName in $computerNames) { ## This loops through your list so you can take action with each list item
    ## do your previous action, once for each $computerName in the list
    $start_results = (Get-WmiObject Win32_Service -filter "name='mbendpointagent'" -ComputerName $computerName).StartService() | format-list ReturnValue | out-string
	write-host "$start_results"
  }
}
$btn2.Text = "Start"

$btn3 = New-Object System.Windows.Forms.Button
$btn3.Location = New-Object System.Drawing.Size(30,150)
$btn3.Size = New-Object System.Drawing.Size(50,50)
$btn3.add_click{
  $computerNames = $box1.text.split(',') ## This splits your input string on commas into a list

  forEach ($computerName in $computerNames) { ## This loops through your list so you can take action with each list item
    ## do your previous action, once for each $computerName in the list
	
	#had to pipe my ping command to out-string to get it to format correctly. Used the following spiceworks article as help: 
	#https://community.spiceworks.com/topic/79399-output-formatted-powershell-command-to-variable
  $ping_results = ping $computerName |format-list | out-string
  write-host "$ping_results"
  }
}
$btn3.Text = "Ping"

#This button (btn2) is used to clear the output screen if it gets too cluttered.
$btn4 = New-Object System.Windows.Forms.Button
$btn4.Location = New-Object System.Drawing.Size(90,90)
$btn4.Size = New-Object System.Drawing.Size(50,50)
$btn4.add_click{Clear}
$btn4.Text = "Clear"

$btn5 = New-Object System.Windows.Forms.Button
$btn5.Location = New-Object System.Drawing.Size(30,90)
$btn5.Size = New-Object System.Drawing.Size(50,50)
$btn5.add_click{
  $computerNames = $box1.text.split(',') ## This splits your input string on commas into a list

  forEach ($computerName in $computerNames) { ## This loops through your list so you can take action with each list item
    ## do your previous action, once for each $computerName in the list
	
	#had to pipe my ping command to out-string to get it to format correctly. 
  $status_results = (Get-WmiObject Win32_Service -filter "name='mbendpointagent'" -ComputerName $computerName | Format-table PSComputerName, Name, State, Status | out-string )
  write-host "$status_results"
  }
}
$btn5.Text = "Get status"

$form.Controls.Add($btn1)
$form.Controls.Add($btn2)
$form.Controls.Add($btn3)
$form.Controls.Add($btn4)
$form.Controls.Add($btn5)
$form.Controls.Add($box1)
$drc = $form.ShowDialog()