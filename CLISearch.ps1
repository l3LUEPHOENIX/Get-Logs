Function Get-Logs {
    <#
    .DESCRIPTION
    By: BluePhoenix
    
    THE GENERAL PURPOSE TOOL
    Search the contents of all files for the keyword under the path provided by the user. 
    Output the full path of the source document and all lines containing the keyword.

    Accepts multiple paths separated by commas.
    
    .EXAMPLE
    Get-Logs -Path 'C:\Users\User\Documents\*.txt' -Word 'keyword'
    
    .NOTES
    Install Instructions:
        ### Requires Admin Privelages ###
        1.) Save this document as a Get-Logs.psm1 file.
        2.) In Program Files\WindowsPowerShell\Modules, create a folder called Get-Logs
        3.) If you had a powershell window already open, close it and reopen it.
        4.) Cheers!

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

    Get-ChildItem -Path $searchPath -Recurse | Foreach-Object {
        if ((Select-String $_.FullName -Pattern $keyWord).Length -gt 0) {
            echo "$("="*100)`r`n[FROM: $($_.FullName)]`r`n$("="*100)`r`n $(Get-Content $_ -Delimiter "`r`n" | Select-String $keyWord)`r`n"
        }
    }

    echo "########## DONE ##########"
}
Export-ModuleMember -Function 'Get-Logs'
