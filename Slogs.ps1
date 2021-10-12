###Header##
$defpath = "M:\Default\Path"

#Initialize Form
Add-Type -assembly System.Windows.Forms,PresentationCore,PresentationFramework
$main_form = New-Object System.Windows.Forms.Form
$main_form.Text = 'SmIRC Logs'
$main_form.Width = 400
$main_form.Height = 30
$main_form.BackColor = "Gray"
$main_form.AutoSize = $true

###Year Text Box###
$yearBox = New-Object System.Windows.Forms.TextBox
$yearBox.Multiline = $true
$yearBox.Size = New-Object System.Drawing.Size(45,21)
$yearBox.Location = New-Object System.Drawing.Point(10,10)
$yearBox.Font = 'Microsoft Sans Serif, 10'
$yearBox.BackColor = 'LightGray'
$yearBox.Text = "$(Get-Date -Format 'yyyy')"
$main_form.Controls.Add($yearBox)

###Month ComboBox###
$monthBox = New-Object System.Windows.Forms.ComboBox
$monthBox.Location = New-Object System.Drawing.Point(60, 10)
$monthBox.Size = New-Object System.Drawing.Size(80, 30)
$monthBox.DropDownStyle = [System.Windows.Forms.ComboBoxStyle]::DropDownList
$monthBox.Items.AddRange(@('', 'January', 'February', 'March', 'April', 'May', 'June', 'July', 'August', 'September', 'October', 'November', 'December'))
$monthBox.SelectedItem = $monthBox.Items[(Get-Date -Format 'MM')]
$main_form.Controls.Add($monthBox)

###Key Word Text###
$keyWord = New-Object System.Windows.Forms.TextBox
$keyWord.Multiline = $true
$keyWord.Size = New-Object System.Drawing.Size(155,21)
$keyWord.Location = New-Object System.Drawing.Point(145,10)
$keyWord.Font = 'Microsoft Sans Serif, 10'
$keyWord.BackColor = 'LightGray'
$keyWord.Text = ''
$main_form.Controls.Add($keyWord)

###Search Button###
$searchButton = New-Object System.Windows.Forms.Button
$searchButton.text = "Search"
$searchButton.BackColor = "LightGray"
$searchButton.Font = 'Microsoft Sans Serif,10'
$searchButton.Size = New-Object System.Drawing.Size(60,21)
$searchButton.location = New-Object System.Drawing.Point(305, 10)
$main_form.Controls.Add($searchButton)

###Functions###
$searchButton.Add_Click({ Results })

Function Results {
    ### Retrieve and Format Output ###
    $product = "";

    Get-ChildItem -Path "$defpath$($(yearSearch) + $(monthSearch))" -Recurse | Foreach-Object {
        if ((Select-String $_.FullName -Pattern "$($keyWord.Text)").Length -gt 0) {
            $product += "[From: $($_.FullName)]:`r`n $(Get-Content $_ -Delimiter "`r`n" | Select-String "$($keyWord.Text)")`r`n"
        }
    }

    ### Initialize Results Window ###
    $resultsWindow = New-Object System.Windows.Forms.Form
    $resultsWindow.text = 'SmIRC Log Results'
    $resultsWindow.width = 1200
    $resultsWindow.height = 600
    $resultsWindow.BackColor = "Gray"
    $resultsWindow.autosize = $true

    ### Create and fill Results Window Text Box ###
    $resultsBox = New-Object System.Windows.Forms.TextBox
    $resultsBox.Multiline = $true
    $resultsBox.ScrollBars = "Vertical"
    $resultsBox.ReadOnly = $true
    $resultsBox.text = $product
    $resultsBox.Font = 'Microsoft Sans Serif, 13'
    $resultsBox.BackColor = "LightGray"
    $resultsBox.autosize = $true
    $resultsBox.location = New-Object System.Drawing.Point(10,10)
    $resultsBox.Size = New-Object System.Drawing.Size(1199,599)
    $resultsWindow.controls.Add($resultsBox)

    $resultsWindow.ShowDialog()
   
}

Function yearSearch {
    if ($yearBox.TextLength -gt 0) {
        return "\$($yearBox.Text)"
    } else {
        return ""
    }
}

Function monthSearch {
    if ($yearBox.TextLength -gt 0) {
        if ($monthBox.SelectedIndex -lt 10) {$monthFormat = "0$($monthBox.SelectedIndex)"} else {$monthFormat = "$($monthBox.SelectedIndex)"}
        return "\$monthFormat - $($monthBox.SelectedItem[0]+$monthBox.SelectedItem[1]+$monthBox.SelectedItem[2])\*.log"
    } else {
        return "\*.log"
    }
}


#Render Form
$main_form.ShowDialog()

### Left To Do ###
# Make it to where each line of the content retrieved from individual files gets its own lin
