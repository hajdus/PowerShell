<#
.SYNOPSIS
   
.DESCRIPTION
    Raport podłączonych do Outlooka plików archiwów pst. Konieczne zmienienie zmieniaj $server !!

.NOTES
    autor: hajduk 2021
#>


#!!!!!! zmień lokalizacje serwera gdzie ma zapisywać się raport !!!!!!
#przykładowy wygląd lokalizacji “\\fileserver\mhajduk_testy"

$server = "\\fileserver\mhajduk_testy"


$wyniki = "$server\Raport_Outlook_PST.csv”
$outlook = New-Object -comobject Outlook.Application 
 
$userAdress = ($outlook.Session.Accounts | select SmtpAddress  | ft -hidetableheaders | Out-String).Trim()
$csvArray = @()
#$csvArray += $userAdress  
 
 
$User_All_PST_Files = $outlook.Session.Stores | where {($_.FilePath -like '*.PST')} | %{
     $csvArray += [pscustomobject]@{
     Mail =$userAdress 
     PST = $_.FilePath
     Wielkosc_GB = ((Get-ChildItem -Path $_.FilePath).Length)/1GB
      }
 }
 
$csvArray |Export-Csv -Path $wyniki -NoTypeInformation -Delimiter ';' -Append

