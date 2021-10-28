#---------------------------------------------------------[Initialisations]--------------------------------------------------------
# Init PowerShell Gui
Add-Type -AssemblyName System.Windows.Forms
Add-Type -AssemblyName System.Drawing


#---------------------------------------------------------[Form]--------------------------------------------------------

[System.Windows.Forms.Application]::EnableVisualStyles()

$StatusForm                    = New-Object system.Windows.Forms.Form
$StatusForm.ClientSize         = '520,300'
$StatusForm.text               = "Status"
$StatusForm.BackColor          = "#ffffff"
$StatusForm.TopMost            = $false

$Title                           = New-Object system.Windows.Forms.Label
$Title.text                      = "System Status Manager"
$Title.AutoSize                  = $true
$Title.width                     = 25
$Title.height                    = 10
$Title.location                  = New-Object System.Drawing.Point(20,20)
$Title.Font                      = 'Microsoft Sans Serif,13'

$Description                     = New-Object system.Windows.Forms.Label
$Description.text                = "Current Status"
$Description.AutoSize            = $false
$Description.width               = 450
$Description.height              = 50
$Description.location            = New-Object System.Drawing.Point(20,50)
$Description.Font                = 'Microsoft Sans Serif,10'

$ChosenFile                     = New-Object system.Windows.Forms.Label
$ChosenFile.text                = "Chosen Upload File"
$ChosenFile.AutoSize            = $false
$ChosenFile.width               = 450
$ChosenFile.height              = 50
$ChosenFile.location            = New-Object System.Drawing.Point(20,100)
$ChosenFile.Font                = 'Microsoft Sans Serif,10'

$GetStatusBtn                   = New-Object system.Windows.Forms.Button
$GetStatusBtn.BackColor         = "#ff7b00"
$GetStatusBtn.text              = "Get Status"
$GetStatusBtn.width             = 90
$GetStatusBtn.height            = 30
$GetStatusBtn.location          = New-Object System.Drawing.Point(220,250)
$GetStatusBtn.Font              = 'Microsoft Sans Serif,10'
$GetStatusBtn.ForeColor         = "#ffffff"
$GetStatusBtn.Visible           = $true

$SelectNewBtn                   = New-Object system.Windows.Forms.Button
$SelectNewBtn.BackColor         = "#ff7b00"
$SelectNewBtn.text              = "Select New"
$SelectNewBtn.width             = 90
$SelectNewBtn.height            = 30
$SelectNewBtn.location          = New-Object System.Drawing.Point(310,250)
$SelectNewBtn.Font              = 'Microsoft Sans Serif,10'
$SelectNewBtn.ForeColor         = "#ffffff"
$SelectNewBtn.Visible           = $true

$UploadNewBtn                   = New-Object system.Windows.Forms.Button
$UploadNewBtn.BackColor         = "#ff7b00"
$UploadNewBtn.text              = "Upload New"
$UploadNewBtn.width             = 90
$UploadNewBtn.height            = 30
$UploadNewBtn.location          = New-Object System.Drawing.Point(400,250)
$UploadNewBtn.Font              = 'Microsoft Sans Serif,10'
$UploadNewBtn.ForeColor         = "#ffffff"
$UploadNewBtn.Visible           = $true

$closeBtn                       = New-Object system.Windows.Forms.Button
$closeBtn.BackColor             = "#ffffff"
$closeBtn.text                  = "Close"
$closeBtn.width                 = 90
$closeBtn.height                = 30
$closeBtn.location              = New-Object System.Drawing.Point(130,250)
$closeBtn.Font                  = 'Microsoft Sans Serif,10'
$closeBtn.ForeColor             = "#000"
$closeBtn.DialogResult          = [System.Windows.Forms.DialogResult]::Cancel
$StatusForm.CancelButton   = $closeBtn
$StatusForm.Controls.Add($closeBtn)

$StatusForm.controls.AddRange(@($Title,$Description,$ChosenFile,$GetStatusBtn,$SelectNewBtn,$UploadNewBtn,$cancelBtn))

#-----------------------------------------------------------[Functions]------------------------------------------------------------

function UpdateStatus {
  $status = getStatus
  DialogStatusUpdate $status
}

function DialogStatusUpdate {
    param (
      [Object]$status
    )

    $Description.text = "Size $($status.entropySize) Bytes"
  
    if ( $status.entropyStatus -eq "NORMAL" ) {
      $Description.BackColor = "green"
    } elseif ($status.entropyStatus -eq "WARNING") {
      $Description.BackColor = "orange"
    } elseif ($status.entropyStatus -eq "CRITICAL") {
      $Description.BackColor = "red"
    } else {
      $Description.BackColor = "#ff0000"
      $Description.text = "Status Not Available"
    }
}
function getStatus {
   # Call the rest endpoint to get the current status 
   return Invoke-RestMethod -Uri http://localhost:3000/entropy-status
}

function SelectNew {
  $FileBrowser = New-Object System.Windows.Forms.OpenFileDialog -Property @{ InitialDirectory = [Environment]::GetFolderPath('Desktop') }
  $FileBrowser.ShowDialog();

  $ChosenFile.text = $FileBrowser.FileName;
}

function UploadNew {
  # Call the rest endpoint to sned the new filename
  $Url = 'http://localhost:3000/send-new'
  $Body = @{
    newfile = $ChosenFile.text
  }
  $status = Invoke-RestMethod -Method 'Post' -Uri $Url -Body $Body
  DialogStatusUpdate $status
}


#---------------------------------------------------------[Script]--------------------------------------------------------

$SelectNewBtn.Add_Click({ SelectNew })
$UploadNewBtn.Add_Click({ UploadNew })
$GetStatusBtn.Add_Click({ UpdateStatus })

[void]$StatusForm.ShowDialog()