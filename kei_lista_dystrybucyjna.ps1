<#
.SYNOPSIS
   Tworzenie listy dystrybucyjnej na poczcie kai na podstawie danych z msdb
.DESCRIPTION
    
Niezbede do doinstalowania:
Install-Module -Name SqlServer


.NOTES
    autor: hajduk 2019
#>


$sql = "SELECT [IDR]
      ,[Nazwisko]
      ,[Imie]
      ,[Status]
      ,[Wirtualny]
      ,[login]
      ,[Pracuje]
      ,[EmailSluzbowy]
	  ,[Telefon]
	  ,[WTrakcieWypowiedzenia]
	  ,[WTrakcieWypowiedzeniaData]
	  
FROM [db].[dbo].[Pracownik] 
WHERE AktualizujeIDR is NULL 
 and pracuje = '1'
 and (EmailSluzbowy like '%mail1%' or EmailSluzbowy like '%mail2%')
 and login not like 'NULL'
 and WTrakcieWypowiedzenia = 0 
 and WTrakcieWypowiedzeniaData is NULL
 and (Status = '106' or Status = '107' or Status = '108' )"

 

  $server = "server"
  #$database = ""
  $username = "user"
  $password = "pass"

  try {

   $AccountToBlock = Invoke-Sqlcmd -Query $sql -ServerInstance $server -QueryTimeout 30 -ErrorAction 'Stop'  -username $username -password $password
   
} catch {

Write-Error "Failure database connection" -EA Stop

}



$maile =@()
$AccountToBlock | % {
  
  if ($_.EmailSluzbowy -ne ""){
  $login = $_.EmailSluzbowy

  $podzielone = $login.Split("{@}")
  $nazwa_konta = $podzielone[0]
  $domena = "@mial1.pl"
  
  $mail = $nazwa_konta + $domena
  $maile += $mail
  }
  else{}

  }


 

  
$headers = New-Object "System.Collections.Generic.Dictionary[[String],[String]]"
$headers.Add("Accept", '*/*')
$headers.Add("UserAgent", 'API-CLIENT')
$headers.Add("ContentType", 'application/json')
$headers.Add("KeepAlive", 'true')
$headers.Add("Authorization", 'Basic ????')                                



$params = @{

'description' ="Lista zaktualizowana przez skrypt: $(Get-Date -format 'u')" 
 
 'accounts' = $maile
}

$params = $params | ConvertTo-Json


$url = "https://as23123.e-kei.pl/v1/mailinglists/mail1.pl/lista"


 try {

   Invoke-RestMethod -Uri $url -Headers $headers -Method 'PUT' -Body $params -ContentType "application/json"
   
} catch {

Write-Error "Failure kei API connection" -EA Stop

}