Function Get-Logs {
    <#
    .SYNOPSIS
    #
    
    .DESCRIPTION
    THE GENERAL PURPOSE TOOL
    Search the contents of all files of the specified extension under the path provided by the user for the keyword. 
    Output the full path of the source document and all lines containing the keyword.
    
    .EXAMPLE
    Get-Logs -Path 'C:\Users\User\Documents' -Word 'keyword'
    
    .NOTES
    The narrower your search is, the faster you'll get your results.
    #>
    
    ### Parameters ###
    [CmdletBinding()]
    param (
        [Parameter(Mandatory)]
        [Alias("Path")]
        [string[]]$searchPath,

        [Parameter(Mandatory)]
        [Alias("Word")]
        [string[]]$keyWord
    )
    ###Header##
    #$defpath = ""
    #$defext = ".txt"
    #$extSet = ""
    #$keyWord = ""
    #$product = "";

    ### This is where most of the magic happens ###
    # This will recursively retreive all .log files underneath the target directory, which is assembled from the "$defpath" variable and the returns from the yearSearch and monthSearch functions.
    # Then it iterates through the found .log files, and if the keyword is found in the contents of any of the .log files, it will output the line the keyword was in and the file path of the .log file it came from.
    Get-ChildItem -Path "$searchPath" -Recurse | Foreach-Object {
        if ((Select-String $_.FullName -Pattern "$keyWord").Length -gt 0) {
            Write-Host "$("="*100)`r`n[FROM: $($_.FullName)]`r`n$("="*100)`r`n $(Get-Content $_ -Delimiter "`r`n" | Select-String "$keyWord")`r`n"
        }
    }

    ### Ideas ###
    # Have an option to export to text file. Dyanmic name like the date, or test for a name with a number, and if it exists, add one to that number.
}
