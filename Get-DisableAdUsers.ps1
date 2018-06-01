<#
.SYNOPSIS
Get all disable AD users
.DESCRIPTION
Create txt file on curent user desktop which conteins all disable users and last log-on date
.EXAMPLE
Get-DisableAdUsers.ps1 
.NOTES
autor: hajdus 2018
#>

$desktop = [Environment]::GetFolderPath("Desktop")

get-aduser -Filter * -SearchBase "DC=DC,DC=corp"  -properties name, LastLogonDate, Enabled |
    Where-Object {$_.Enabled -like "False"} |
    Select name, LastLogonDate |
    out-file $desktop\DisableUsers.txt -fo -en UTF8 

