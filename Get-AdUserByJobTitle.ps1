<#
.SYNOPSIS
    Get all AD User by job title
.DESCRIPTION
    Get all AD user with specyfic job title and save it in desktop in output.csv file.
.EXAMPLE
    Get-AdUserByJobTitle.ps1
.NOTES
    autor: hajdus 2018
#>


Param(
  [Parameter(Mandatory=$true)] [String]$JobTitle 
)

#$JobTitle = "manager"
$Desktop = [Environment]::GetFolderPath("Desktop")



Get-ADUser -Filter * -SearchBase "DC=dc,DC=corp"  -properties name, title | 
Where-Object {$_.title -like "*$JobTitle*"} |
Select name, Title  |
Out-File $Desktop\output.csv -fo -en UTF8 


