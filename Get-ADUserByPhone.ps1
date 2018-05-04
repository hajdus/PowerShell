<#
.SYNOPSIS
Script to find AD users by phone number
.DESCRIPTION
Script to find AD users by phone number
Enter the pohone number without any other characters e.g.123456789
.EXAMPLE
Get-ADUserByPhone.ps1 -Phone_number 123456789
.EXAMPLE
Get-ADUserByPhone.ps1 123456789
.NOTES
autor: hajdus 2018

#>


Param(
    [Parameter(Mandatory = $true)] [String]$Phone_number
)

#Making 3 substrings from entered phone number        
$Part1 = $Phone_number.Substring(0, 3)
$Part2 = $Phone_number.Substring(3, 3)
$Part3 = $Phone_number.Substring(6, 3)


$phone0 = $Phone_number
$phone1 = "+48" + $Part1 + $Part2 + $Part3
$phone2 = "+48" + " " + $Part1 + $Part2 + $Part3
$phone3 = "+48" + " " + $Part1 + " " + $Part2 + " " + $Part3
$phone4 = $Part1 + " " + $Part2 + " " + $Part3
$phone5 = $Part1 + "-" + $Part2 + "-" + $Part3


for ($i = 0; $i -le 5; $i++ ) {
      
    $phonetxt = Get-Variable -Name "phone$i" -ValueOnly
    echo "Looking for account for number: $phonetxt" 
    
    Get-ADUser -Filter * -Properties name, MobilePhone, OfficePhone |
        Where-Object {$_.MobilePhone -eq (Get-Variable -Name "phone$i" -ValueOnly) -or $_.OfficePhone -eq (Get-Variable -Name "phone$i" -ValueOnly)} 
}


