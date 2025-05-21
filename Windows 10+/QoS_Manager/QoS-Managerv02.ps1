# QoS Rule Manager GUI Application for Windows 10+

# Requires PowerShell with .NET Framework and administrative privileges

Add-Type -AssemblyName System.Windows.Forms
Add-Type -AssemblyName System.Drawing

# Main Form Setup
$form = New-Object System.Windows.Forms.Form
$form.Text = "QoS Rule Manager"
$form.Size = New-Object System.Drawing.Size(800, 600) # Set the form size
$form.StartPosition = "CenterScreen"

# DataGridView Setup
$dataGridView = New-Object System.Windows.Forms.DataGridView
$dataGridView.Dock = 'Fill' # Dock the DataGridView to fill the form
$dataGridView.AutoSizeColumnsMode = 'AllCells'
$dataGridView.ReadOnly = $false
$dataGridView.AllowUserToAddRows = $true
$dataGridView.ColumnHeadersVisible = $true
$dataGridView.RowHeadersVisible = $true

# Create DataTable with typed columns
$dataTable = New-Object System.Data.DataTable
$dataTable.Columns.Add("Name", [string]) | Out-Null # Add a column for the rule name
$dataTable.Columns.Add("AppPathName", [string]) | Out-Null # Add a column for the application path name
$dataTable.Columns.Add("NetworkProfile", [string]) | Out-Null # Add a column for the network profile
$dataTable.Columns.Add("IPProtocol", [string]) | Out-Null # Add a column for the IP protocol
$dataTable.Columns.Add("DSCPValue", [int]) | Out-Null # Add a column for the DSCP value

# Correct DataGridview DataSource assignment
$dataGridView.DataSource = $dataTable.DefaultView

# Row numbering implementation
$dataGridView.RowHeadersVisible = $true
$dataGridView.RowHeadersWidth = 50
$dataGridView.RowHeadersDefaultCellStyle.BackColor = [System.Drawing.Color]::FromArgb(240, 240, 240)
$dataGridView.RowHeadersDefaultCellStyle.ForeColor = [System.Drawing.Color]::Black
$dataGridView.RowHeadersDefaultCellStyle.Font = $dataGridView.Font

# Correct RowPostPaint event handler with error handling
$dataGridView.add_RowPostPaint({
    param($sender, $e)
    try {
        $textBrush = [System.Drawing.Brushes]::Black
        $rowIndex = $e.RowIndex + 1
        $text = $rowIndex.ToString()

        # Calculate text size
        $textSize = $e.Graphics.MeasureString($text, $sender.Font)

        # Calculate right-aligned position with 5px padding
        $xPosition = $sender.RowHeadersWidth - $textSize.Width - 5
        $yPosition = $e.RowBounds.Location.Y + ($e.RowBounds.Height / 2) - ($textSize.Height / 2)

        # Draw row number
        $e.Graphics.DrawString(
            $text,
            $sender.Font,
            $textBrush,
            $xPosition,
            $yPosition
        )
    } catch {
        Write-Host "Row numbering error: $_"
    }
})

# Button Panel
$buttonPanel = New-Object System.Windows.Forms.Panel
$buttonPanel.Dock = 'Top'
$buttonPanel.Height = 50
$buttonPanel.Padding = New-Object System.Windows.Forms.Padding(10, 10, 10, 10)
$buttonPanel.BackColor = [System.Drawing.Color]::WhiteSmoke

# Buttons Flow Layout
$flowLayout = New-Object System.Windows.Forms.FlowLayoutPanel
$flowLayout.AutoSize = $false  # Fix: Prevents layout conflict with Dock
$flowLayout.Dock = 'Fill'
$flowLayout.FlowDirection = 'LeftToRight'
$flowLayout.WrapContents = $false

# Buttons
$btnRead = New-Object System.Windows.Forms.Button
$btnRead.Text = "Read Rules from OS"
$btnRead.AutoSize = $true

$btnExport = New-Object System.Windows.Forms.Button
$btnExport.Text = "Export to CSV"
$btnExport.AutoSize = $true

$btnImport = New-Object System.Windows.Forms.Button
$btnImport.Text = "Import CSV"
$btnImport.AutoSize = $true

$btnSave = New-Object System.Windows.Forms.Button
$btnSave.Text = "Save Rules to OS"
$btnSave.AutoSize = $true

$btnPurge = New-Object System.Windows.Forms.Button
$btnPurge.Text = "Purge QOS Rules From OS"
$btnPurge.AutoSize = $true
$btnPurge.BackColor = [System.Drawing.Color]::Red
$btnPurge.ForeColor = [System.Drawing.Color]::White

$btnExit = New-Object System.Windows.Forms.Button
$btnExit.Text = "Exit"
$btnExit.AutoSize = $true

# Add buttons to flow layout
$flowLayout.Controls.AddRange(@($btnRead, $btnExport, $btnImport, $btnSave, $btnPurge, $btnExit))

# Add flow layout to panel
$buttonPanel.Controls.Add($flowLayout)

# Add controls to form (DataGridView **first** to allow proper docking)
$form.Controls.Add($dataGridView)
$form.Controls.Add($buttonPanel)

# Event Handler: Read Rules from OS
$btnRead.Add_Click({
    # Clear the data table
    $dataTable.Clear()

    try {
        # Get all QoS policies
        $policies = Get-NetQosPolicy -ErrorAction Stop
        $validCount = 0

        # Iterate through each policy
        foreach ($policy in $policies) {
            # Validate policy properties
            if ($policy.Name.Length -notin 1..63) { continue }
            if ($policy.AppPathName.Length -notin 1..254) { continue }
            if ($policy.NetworkProfile.Length -notin 1..16) { continue }

            $ipProtocol = ($policy.IPProtocol -as [string]).ToUpper()
            if ($ipProtocol -notin @("TCP", "UDP", "BOTH")) { continue }

            $dscpValue = $policy.DSCPValue
            if ($null -eq $dscpValue -or $dscpValue -notin 0..63) { continue }

            # Add the policy to the data table
            $dataTable.Rows.Add(
                $policy.Name,
                $policy.AppPathName,
                $policy.NetworkProfile,
                $ipProtocol,
                $dscpValue
            ) | Out-Null
            $validCount++
        }

        # Show a success message
        [System.Windows.Forms.MessageBox]::Show(
            "Successfully loaded $validCount valid QoS rules.",
            "Success",
            'OK',
            'Information'
        )
    } catch {
        # Show an error message
        [System.Windows.Forms.MessageBox]::Show(
            "Error reading QoS rules: $_",
            "Error",
            'OK',
            'Error'
        )
    }
})

# Event Handler: Export to CSV
$btnExport.Add_Click({
    # Create a SaveFileDialog to allow the user to choose a file path
    $saveDialog = New-Object System.Windows.Forms.SaveFileDialog
    $saveDialog.Filter = "CSV Files (*.csv)|*.csv" # Set the filter to only show CSV files

    # Show the SaveFileDialog
    if ($saveDialog.ShowDialog() -eq 'OK') {
        try {
            # Export the data table to a CSV file
            $dataTable | Export-Csv -Path $saveDialog.FileName -NoTypeInformation -Force
            # Show a success message
            [System.Windows.Forms.MessageBox]::Show(
                "Exported $($dataTable.Rows.Count) rules to CSV successfully.",
                "Success",
                'OK',
                'Information'
            )
        } catch {
            # Show an error message
            [System.Windows.Forms.MessageBox]::Show(
                "Error exporting to CSV: $_",
                "Error",
                'OK',
                'Error'
            )
        }
    }
})

# Event Handler: Import CSV
$btnImport.Add_Click({
    # Create an OpenFileDialog to allow the user to select a CSV file
    $openDialog = New-Object System.Windows.Forms.OpenFileDialog
    $openDialog.Filter = "CSV Files (*.csv)|*.csv" # Set the filter to only show CSV files

    # Show the OpenFileDialog
    if ($openDialog.ShowDialog() -eq 'OK') {
        # Clear the data table
        $dataTable.Clear()
        $invalidCount = 0

        try {
            # Import the CSV data
            $csvData = Import-Csv -Path $openDialog.FileName

            # Iterate through each row in the CSV data
            foreach ($row in $csvData) {
                # Validate the Name property
                if (-not $row.Name -or $row.Name.Length -notin 1..63) {
                    $invalidCount++
                    continue
                }

                # Validate the AppPathName property
                if (-not $row.AppPathName -or $row.AppPathName.Length -notin 1..254) {
                    $invalidCount++
                    continue
                }

                # Validate the NetworkProfile property
                if (-not $row.NetworkProfile -or $row.NetworkProfile.Length -notin 1..16) {
                    $invalidCount++
                    continue
                }

                # Validate the IPProtocol property
                $ipProto = $row.IPProtocol.ToUpper()
                if ($ipProto -notin @("TCP", "UDP", "BOTH")) {
                    $invalidCount++
                    continue
                }

                # Validate the DSCPValue property
                if (-not ($row.DSCPValue -match '^\d+$')) {
                    $invalidCount++
                    continue
                }

                $dscpValue = [int]$row.DSCPValue
                if ($dscpValue -notin 0..63) {
                    $invalidCount++
                    continue
                }

                # Add the valid row to the data table
                $dataTable.Rows.Add(
                    $row.Name,
                    $row.AppPathName,
                    $row.NetworkProfile,
                    $ipProto,
                    $dscpValue
                ) | Out-Null
            }

            # Show a message indicating the number of invalid entries skipped
            if ($invalidCount -gt 0) {
                [System.Windows.Forms.MessageBox]::Show(
                    "Import completed with $invalidCount invalid entries skipped.",
                    "Warning",
                    'OK',
                    'Exclamation'
                )
            } else {
                # Show a success message
                [System.Windows.Forms.MessageBox]::Show(
                    "Successfully imported $($dataTable.Rows.Count) rules.",
                    "Success",
                    'OK',
                    'Information'
                )
            }
        } catch {
            # Show an error message
            [System.Windows.Forms.MessageBox]::Show(
                "Error importing CSV: $_",
                "Error",
                'OK',
                'Error'
            )
        }
    }
})

# Event Handler: Save Rules to OS
$btnSave.Add_Click({
    # Show a confirmation message box to the user
    if ([System.Windows.Forms.MessageBox]::Show(
        "This will remove all existing QoS rules and apply the current configuration. Continue?",
        "Confirm Save",
        'YesNo',
        'Warning'
    ) -ne 'Yes') { return } # If the user cancels, exit the event handler

    try {
        # Remove all existing QoS policies
        Remove-NetQosPolicy -Name "*" -Confirm:$false -ErrorAction Stop

        # Iterate through each row in the data table
        foreach ($row in $dataTable.Rows) {
            # Create a new QoS policy
            New-NetQosPolicy -Name $row.Name `
                            -AppPathName $row.AppPathName `
                            -NetworkProfile $row.NetworkProfile `
                            -IPProtocol $row.IPProtocol `
                            -DSCPValue $row.DSCPValue `
                            -ErrorAction Stop | Out-Null
        }

        # Apply the changes immediately by running gpupdate.exe
        Start-Process -FilePath "gpupdate.exe" -ArgumentList "/force" -Wait -NoNewWindow

        # Show a success message
        [System.Windows.Forms.MessageBox]::Show(
            "Successfully saved rules to the system.",
            "Success",
            'OK',
            'Information'
        )
    } catch {
        # Show an error message
        [System.Windows.Forms.MessageBox]::Show(
            "Error saving rules: $_",
            "Error",
            'OK',
            'Error'
        )
    }
})

# Event Handler: Purge Rules
$btnPurge.Add_Click({
    # Show a confirmation message box to the user
    if ([System.Windows.Forms.MessageBox]::Show(
        "This will permanently delete all QoS rules from the system. Continue?",
        "Confirm Purge",
        'YesNo',
        'Error'  #   'Error'
    ) -ne 'Yes') { return } # If the user cancels, exit the event handler

    try {
        # Remove all QoS policies
        Remove-NetQosPolicy -Name "*" -Confirm:$false -ErrorAction Stop
        # Show a success message
        [System.Windows.Forms.MessageBox]::Show(
            "All QoS rules have been purged successfully.",
            "Success",
            'OK',
            'Information'
        )
    } catch {
        # Show an error message
        [System.Windows.Forms.MessageBox]::Show(
            "Error purging rules: $_",
            "Error",
            'OK',
            'Error'
        )
    }
})

# Event Handler: Exit Application
$btnExit.Add_Click({ $form.Close() }) # Close the application window

# Run Application
[System.Windows.Forms.Application]::EnableVisualStyles()
[System.Windows.Forms.Application]::Run($form)
