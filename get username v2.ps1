#This appplcation is used to get the username of the logged in user based on the computer names you enter in.
#
# Get Uptime
#

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
	
$login_username = Get-WmiObject -Class win32_computersystem -ComputerName $ComputerNames | select username

write-host "$ComputerNames"		
write-host  "$login_username"
  }
  }
  $btn1.Text = "Get User"

$form.Controls.Add($btn1)
$form.Controls.Add($box1)
$drc = $form.ShowDialog()
