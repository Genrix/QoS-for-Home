#requires -Version 5.1

Add-Type -AssemblyName System.Windows.Forms
Add-Type -AssemblyName System.Drawing

function LoadRules {
    try {
        # Temporarily disable adding new rows and clear any existing rows.
        $dataGridView.AllowUserToAddRows = $false
        $dataGridView.Rows.Clear()

        # Retrieve only the five required properties.
        $rules = Get-NetQosPolicy | Select-Object Name, AppPathName, NetworkProfile, IPProtocol, DSCPValue

        if ($rules) {
            # Convert to DataTable for proper binding
            $dataTable = New-Object System.Data.DataTable
            $columns = @("Name", "AppPathName", "NetworkProfile", "IPProtocol", "DSCPValue")

            foreach ($col in $columns) {
                $dataTable.Columns.Add($col) | Out-Null
            }

            foreach ($rule in $rules) {
                $row = $dataTable.NewRow()
                foreach ($col in $columns) {
                    $row[$col] = $rule.$col
                }
                $dataTable.Rows.Add($row)
            }

            $dataGridView.DataSource = $dataTable
        }
    }
    catch {
        [System.Windows.Forms.MessageBox]::Show("Error reading QoS policies: $_", "Error",
            [System.Windows.Forms.MessageBoxButtons]::OK, [System.Windows.Forms.MessageBoxIcon]::Error)
    }
    finally {
        # Re-enable the ability to add new rows.
        $dataGridView.AllowUserToAddRows = $true
    }
}

function SaveRulesToOS {
    $result = [System.Windows.Forms.MessageBox]::Show("Are you sure you want to save QoS policies? This will remove all existing ones and then create new ones based on the grid.",
        "Confirm Save", [System.Windows.Forms.MessageBoxButtons]::YesNo, [System.Windows.Forms.MessageBoxIcon]::Warning)
    if ($result -eq 'Yes') {
        try {
            # Remove all existing QoS policies without confirmation
            Remove-NetQosPolicy -Name "*" -Confirm:$false -ErrorAction Stop

            foreach ($row in $dataGridView.Rows) {
                if (-not $row.IsNewRow) {
                    $name = $row.Cells["Name"].Value
                    $appPathName = $row.Cells["AppPathName"].Value
                    $networkProfile = $row.Cells["NetworkProfile"].Value
                    $ipProtocol = $row.Cells["IPProtocol"].Value
                    $dscpValue = $row.Cells["DSCPValue"].Value

                    if ($name) {
                        New-NetQosPolicy -Name $name `
                                         -AppPathName $appPathName `
                                         -NetworkProfile $networkProfile `
                                         -IPProtocol $ipProtocol `
                                         -DSCPValue $dscpValue -ErrorAction Stop
                    }
                }
            }

            # Force a group policy update.
            Start-Process -FilePath "gpupdate.exe" -ArgumentList "/force" -Wait

            [System.Windows.Forms.MessageBox]::Show("QoS policies saved successfully.", "Success",
                [System.Windows.Forms.MessageBoxButtons]::OK, [System.Windows.Forms.MessageBoxIcon]::Information)
        }
        catch {
            [System.Windows.Forms.MessageBox]::Show("Error saving QoS policies: $_", "Error",
                [System.Windows.Forms.MessageBoxButtons]::OK, [System.Windows.Forms.MessageBoxIcon]::Error)
        }
    }
}

function PurgeRules {
    $result = [System.Windows.Forms.MessageBox]::Show("Are you sure you want to purge (delete) all QoS policies from the system?",
        "Confirm Purge", [System.Windows.Forms.MessageBoxButtons]::YesNo, [System.Windows.Forms.MessageBoxIcon]::Warning)
    if ($result -eq 'Yes') {
        try {
            # Remove all QoS policies without confirmation
            Remove-NetQosPolicy -Name "*" -Confirm:$false -ErrorAction Stop
            Start-Process -FilePath "gpupdate.exe" -ArgumentList "/force" -Wait

            [System.Windows.Forms.MessageBox]::Show("All QoS policies purged successfully.", "Success",
                [System.Windows.Forms.MessageBoxButtons]::OK, [System.Windows.Forms.MessageBoxIcon]::Information)
        }
        catch {
            [System.Windows.Forms.MessageBox]::Show("Error purging QoS policies: $_", "Error",
                [System.Windows.Forms.MessageBoxButtons]::OK, [System.Windows.Forms.MessageBoxIcon]::Error)
        }
    }
}

function ExportRules {
    $sfd = New-Object System.Windows.Forms.SaveFileDialog
    $sfd.Filter = "CSV Files (*.csv)|*.csv"
    if ($sfd.ShowDialog() -eq 'OK') {
        try {
            $data = @()
            foreach ($row in $dataGridView.Rows) {
                if (-not $row.IsNewRow) {
                    $obj = New-Object PSObject -Property @{
                        Name = $row.Cells["Name"].Value
                        AppPathName = $row.Cells["AppPathName"].Value
                        NetworkProfile = $row.Cells["NetworkProfile"].Value
                        IPProtocol = $row.Cells["IPProtocol"].Value
                        DSCPValue = $row.Cells["DSCPValue"].Value
                    }
                    $data += $obj
                }
            }
            $data | Export-Csv -Path $sfd.FileName -NoTypeInformation -Force

            [System.Windows.Forms.MessageBox]::Show("QoS policies exported successfully.", "Success",
                [System.Windows.Forms.MessageBoxButtons]::OK, [System.Windows.Forms.MessageBoxIcon]::Information)
        }
        catch {
            [System.Windows.Forms.MessageBox]::Show("Error exporting QoS policies: $_", "Error",
                [System.Windows.Forms.MessageBoxButtons]::OK, [System.Windows.Forms.MessageBoxIcon]::Error)
        }
    }
}

function ImportRules {
    $ofd = New-Object System.Windows.Forms.OpenFileDialog
    $ofd.Filter = "CSV Files (*.csv)|*.csv"
    if ($ofd.ShowDialog() -eq 'OK') {
        try {
            $importedData = Import-Csv -Path $ofd.FileName
            # Convert to DataTable for proper binding
            $dataTable = New-Object System.Data.DataTable
            $columns = @("Name", "AppPathName", "NetworkProfile", "IPProtocol", "DSCPValue")

            foreach ($col in $columns) {
                $dataTable.Columns.Add($col) | Out-Null
            }

            foreach ($item in $importedData) {
                $row = $dataTable.NewRow()
                foreach ($col in $columns) {
                    $row[$col] = $item.$col
                }
                $dataTable.Rows.Add($row)
            }

            $dataGridView.DataSource = $dataTable

            [System.Windows.Forms.MessageBox]::Show("QoS policies imported successfully.", "Success",
                [System.Windows.Forms.MessageBoxButtons]::OK, [System.Windows.Forms.MessageBoxIcon]::Information)
        }
        catch {
            [System.Windows.Forms.MessageBox]::Show("Error importing QoS policies: $_", "Error",
                [System.Windows.Forms.MessageBoxButtons]::OK, [System.Windows.Forms.MessageBoxIcon]::Error)
        }
    }
}

# Create the main form.
$form = New-Object System.Windows.Forms.Form
$form.Text = "QoS Policy Manager"
$form.Size = New-Object System.Drawing.Size(800,600)
$form.StartPosition = "CenterScreen"

# Use a TableLayoutPanel to arrange controls: top row for buttons, bottom for DataGridView.
$tableLayoutPanel = New-Object System.Windows.Forms.TableLayoutPanel
$tableLayoutPanel.Dock = [System.Windows.Forms.DockStyle]::Fill

# Create the button panel in the top row.
$buttonPanel = New-Object System.Windows.Forms.FlowLayoutPanel
$buttonPanel.Dock = [System.Windows.Forms.DockStyle]::Top
$buttonPanel.Height = 40
$buttonPanel.FlowDirection = "LeftToRight"

$btnRead = New-Object System.Windows.Forms.Button
$btnRead.Text = "Read QoS Rules"
$btnRead.AutoSize = $true

$btnExport = New-Object System.Windows.Forms.Button
$btnExport.Text = "Export CSV"
$btnExport.AutoSize = $true

$btnImport = New-Object System.Windows.Forms.Button
$btnImport.Text = "Import CSV"
$btnImport.AutoSize = $true

$btnSave = New-Object System.Windows.Forms.Button
$btnSave.Text = "Save to OS"
$btnSave.AutoSize = $true

# The Purge button is red with white text.
$btnPurge = New-Object System.Windows.Forms.Button
$btnPurge.Text = "Purge All QoS Rules"
$btnPurge.AutoSize = $true
$btnPurge.BackColor = [System.Drawing.Color]::Red
$btnPurge.ForeColor = [System.Drawing.Color]::White

$btnClose = New-Object System.Windows.Forms.Button
$btnClose.Text = "Close"
$btnClose.AutoSize = $true

# Add buttons in the specified order.
$buttonPanel.Controls.Add($btnRead) | Out-Null
$buttonPanel.Controls.Add($btnExport) | Out-Null
$buttonPanel.Controls.Add($btnImport) | Out-Null
$buttonPanel.Controls.Add($btnSave) | Out-Null
$buttonPanel.Controls.Add($btnPurge) | Out-Null
$buttonPanel.Controls.Add($btnClose) | Out-Null

$tableLayoutPanel.Controls.Add($buttonPanel, 0, 0)

# Create the DataGridView.
$dataGridView = New-Object System.Windows.Forms.DataGridView
$dataGridView.Dock = [System.Windows.Forms.DockStyle]::Fill
$dataGridView.AutoSizeColumnsMode = [System.Windows.Forms.DataGridViewAutoSizeColumnsMode]::Fill

# Define columns and explicitly set DataPropertyName.
$columns = @("Name", "AppPathName", "NetworkProfile", "IPProtocol", "DSCPValue")
foreach ($col in $columns) {
    $columnObj = New-Object System.Windows.Forms.DataGridViewTextBoxColumn
    $columnObj.Name = $col
    $columnObj.HeaderText = $col
    $columnObj.DataPropertyName = $col
    $dataGridView.Columns.Add($columnObj)
}

# Allow the user to add new rows.
$dataGridView.AllowUserToAddRows = $true

$tableLayoutPanel.Controls.Add($dataGridView, 0, 1)

$form.Controls.Add($tableLayoutPanel)

# Button event handlers.
$btnRead.Add_Click({ LoadRules })
$btnExport.Add_Click({ ExportRules })
$btnImport.Add_Click({ ImportRules })
$btnSave.Add_Click({ SaveRulesToOS })
$btnPurge.Add_Click({ PurgeRules })
$btnClose.Add_Click({ $form.Close() })

[System.Windows.Forms.Application]::Run($form)
