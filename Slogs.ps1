###Header##
$defpath = "D:\Archive\Chat Logs" # Change this to the root directory of your chat log archive

### Initialize Form ###
# This is the basis of the main window for the form
Add-Type -assembly System.Windows.Forms,PresentationCore,PresentationFramework
$main_form = New-Object System.Windows.Forms.Form
$main_form.Text = 'Slogs'
$main_form.Width = 400
$main_form.Height = 30
$main_form.BackColor = "Gray"
$main_form.AutoSize = $true

###Year Text Box###
# The first directories after the root directory are named after the year; e.g. "2021"
# This renders the text box that accepts the input for the year from the user.
# By default, this will fill with the current year.
$yearBox = New-Object System.Windows.Forms.TextBox
$yearBox.Multiline = $true
$yearBox.Size = New-Object System.Drawing.Size(45,21)
$yearBox.Location = New-Object System.Drawing.Point(10,10)
$yearBox.Font = 'Microsoft Sans Serif, 10'
$yearBox.BackColor = 'LightGray'
$yearBox.Text = "$(Get-Date -Format 'yyyy')"
$main_form.Controls.Add($yearBox)

###Month ComboBox###
# The directories after the year are named after months, but has a little extra formatting, which is addressed in the "yearSearch" function at the bottom of this page. e.g. "01 - Jan"
# Autofills by default to the current month.
$monthBox = New-Object System.Windows.Forms.ComboBox
$monthBox.Location = New-Object System.Drawing.Point(60, 10)
$monthBox.Size = New-Object System.Drawing.Size(80, 30)
$monthBox.DropDownStyle = [System.Windows.Forms.ComboBoxStyle]::DropDownList
$monthBox.Items.AddRange(@('', 'January', 'February', 'March', 'April', 'May', 'June', 'July', 'August', 'September', 'October', 'November', 'December'))
$monthBox.SelectedItem = $monthBox.Items[(Get-Date -Format 'MM')]
$main_form.Controls.Add($monthBox)

###Key Word Text###
# This input accepts a string from the user that will be used as a keyword to search for in log files.
# I beleive this is case sensitive
$keyWord = New-Object System.Windows.Forms.TextBox
$keyWord.Multiline = $true
$keyWord.Size = New-Object System.Drawing.Size(155,21)
$keyWord.Location = New-Object System.Drawing.Point(145,10)
$keyWord.Font = 'Microsoft Sans Serif, 10'
$keyWord.BackColor = 'LightGray'
$keyWord.Text = ''
$main_form.Controls.Add($keyWord)

###Search Button###
# When clicked, this is call the "Results" function, and after some time, will output all lines in files that contain the keyword along with the file path to that file.
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
    
    ### This is where most of the magic happens ###
    # This will recursively retreive all .log files underneath the target directory, which is assembled from the "$defpath" variable and the returns from the yearSearch and monthSearch functions.
    # Then it iterates through the found .log files, and if the keyword is found in the contents of any of the .log files, it will output the line the keyword was in and the file path of the .log file it came from.
    Get-ChildItem -Path "$defpath$($(yearSearch) + $(monthSearch))" -Recurse | Foreach-Object {
        if ((Select-String $_.FullName -Pattern "$($keyWord.Text)").Length -gt 0) {
            $product += "$("="*100)[FROM: $($_.FullName)]$("="*100)`r`n $(Get-Content $_ -Delimiter "`r`n" | Select-String "$($keyWord.Text)")`r`n"
        }
    }

    ### Initialize Results Window ###
    $resultsWindow = New-Object System.Windows.Forms.Form
    $resultsWindow.text = 'Slog Results'
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

### Format the year input ###
# This simply adds a "\" to the four digit year
# If there isn't input in the text box, it won't add anything to the target file path.
# Example output: "\2021"
Function yearSearch {
    if ($yearBox.TextLength -gt 0) {
        return "\$($yearBox.Text)"
    } else {
        return ""
    }
}

### Format the month input ###
# The month input will only be formatted if there was input in the year text box.
# If there isn't input in the year text box, it will return "\*.log", which is meant to retrieve all .log files underneath the target directory path.
# Example output: "\10 - Oct\*.log"
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
