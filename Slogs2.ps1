###Header##
$defpath = ""
$defext = ".txt"

### Initialize Form ###
# This is the basis of the main window for the form
Add-Type -assembly System.Windows.Forms,PresentationCore,PresentationFramework
$main_form = New-Object System.Windows.Forms.Form
$main_form.Text = 'Slogs'
$main_form.Width = 400
$main_form.Height = 30
$main_form.BackColor = "Gray"
$main_form.AutoSize = $true

### Default Path Button ###
$pathButton = New-Object System.Windows.Forms.Button
$pathButton.Size = New-Object System.Drawing.Size(130,21)
$pathButton.Location = New-Object System.Drawing.Point(10,10)
$pathButton.Font = 'Microsoft Sans Serif, 10'
$pathButton.BackColor = 'LightGray'
$pathButton.Text = "Set Path"

### Folder Browsing Dialog ###
$pathButton.Add_Click({
    [System.Reflection.Assembly]::LoadWithPartialName("System.windows.forms")|Out-Null

    $foldername = New-Object System.Windows.Forms.FolderBrowserDialog
    $foldername.Description = "Select a folder"
    $foldername.rootfolder = "MyComputer"
    $foldername.SelectedPath = ""

    if($foldername.ShowDialog() -eq "OK")
    {
        $global:defpath = $foldername.SelectedPath
    }
    $pathDesc.Text = $global:defpath
})

### Display selected Path ###
$pathDesc = New-Object System.Windows.Forms.Label
$pathDesc.BackColor = "LightGray"
$pathDesc.Text = ""
$pathDesc.autosize = $true
$pathDesc.Font = "Microsoft Sans Serif, 10"
$pathDesc.Size = New-Object System.Drawing.Size(145,20)
$pathDesc.Location = New-Object System.Drawing.Point(10,40)

$main_form.Controls.Add($pathDesc)
$main_form.Controls.Add($pathButton)

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

### File Extension Input ###
$extSet = New-Object System.Windows.Forms.TextBox
$extSet.Multiline = $true
$extSet.Size = New-Object System.Drawing.Size(35,21)
$extSet.Location = New-Object System.Drawing.Point(305,10)
$extSet.Font = 'Microsoft Sans Serif, 10'
$extSet.BackColor = 'LightGray'
$extSet.Text = $defext
$main_form.Controls.Add($extSet)

###Search Button###
# When clicked, this is call the "Results" function, and after some time, will output all lines in files that contain the keyword along with the file path to that file.
$searchButton = New-Object System.Windows.Forms.Button
$searchButton.text = "Search"
$searchButton.BackColor = "LightGray"
$searchButton.Font = 'Microsoft Sans Serif,10'
$searchButton.Size = New-Object System.Drawing.Size(60,21)
$searchButton.location = New-Object System.Drawing.Point(345, 10)
$main_form.Controls.Add($searchButton)

###Functions###
$searchButton.Add_Click({ Results })

Function Results {
    ### Retrieve and Format Output ###
    $product = "";
    
    ### This is where most of the magic happens ###
    # This will recursively retreive all .log files underneath the target directory, which is assembled from the "$defpath" variable and the returns from the yearSearch and monthSearch functions.
    # Then it iterates through the found .log files, and if the keyword is found in the contents of any of the .log files, it will output the line the keyword was in and the file path of the .log file it came from.
    Get-ChildItem -Path "$defpath\*$($extSet.Text)" -Recurse | Foreach-Object {
        if ((Select-String $_.FullName -Pattern "$($keyWord.Text)").Length -gt 0) {
            $product += "$("="*100)`r`n[FROM: $($_.FullName)]`r`n$("="*100)`r`n $(Get-Content $_ -Delimiter "`r`n" | Select-String "$($keyWord.Text)")`r`n"
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

#Render Form
$main_form.ShowDialog()
