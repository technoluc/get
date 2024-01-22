$OFS = "`r`n"
$scriptname = "get.ps1"

if (Test-Path -Path "$($scriptname)")
{
    Remove-Item -Force "$($scriptname)"
}

Write-output '
####################################################################
###                                                              ###
### WARNING: This file is automatically generated by Compile.ps1 ###
###                                                              ###
####################################################################
' | Out-File ./$scriptname -Append -Encoding ascii

(Get-Content .\scripts\variables.txt).replace('#{replaceme}',"$(get-date -format yy.MM.dd)") | Out-File ./$scriptname -Append -Encoding ascii

Get-ChildItem .\functions -Recurse -File | ForEach-Object {
    Get-Content $psitem.FullName | Out-File ./$scriptname -Append -Encoding ascii
}

Get-Content .\scripts\main.ps1 | Out-File ./$scriptname -Append -Encoding ascii
