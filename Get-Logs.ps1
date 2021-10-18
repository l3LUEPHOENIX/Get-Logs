echo "=============================="
echo "|         GET-LOGS           |"
echo "=============================="
echo "`r`n"

$searchPath = Read-Host -Prompt "Search Path"
$keyWord = Read-Host -Prompt "Keyword"

Get-ChildItem -Path $searchPath -Recurse | Foreach-Object {
    if ((Select-String $_.FullName -Pattern $keyWord).Length -gt 0) {
        echo "$("="*100)`r`n[FROM: $($_.FullName)]`r`n$("="*100)`r`n $(Get-Content $_ -Delimiter "`r`n" | Select-String $keyWord)`r`n"
    }
}

echo "########## DONE ##########"
