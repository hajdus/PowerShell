<#
.SYNOPSIS
Get all user mobilephone numbers
.DESCRIPTION
Create csv file on curent user desktop which conteins all users phone numbers and logins
.EXAMPLE
Get-UsersPhoneNumber.ps1 
.NOTES
autor: hajdus 2018
#>

#Find desktop directory
$desktop = [Environment]::GetFolderPath("Desktop")
$file = get-aduser -Filter * -SearchBase "DC=DC,DC=pl"  -properties name, MobilePhone | 
Where-Object {$_.MobilePhone -ne $null} |
Select name, MobilePhone | 
ConvertTo-Csv -NoTypeInformation

#Format output file
$file = $file.replace('"', "").replace('+48 ','0').replace(' ','').replace(',', " kom,") |
out-file $desktop\phone_numbers.csv -fo -en UTF8 
