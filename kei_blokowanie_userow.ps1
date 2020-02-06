<#
.SYNOPSIS
    Blokowanie kont na poczcie kai na podstawie danych z msdb
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
      ,[DataRozpoczeciaWspolpracy]
      ,[DataZakonczeniaWspolpracy]
	  ,[EmailSluzbowy]
	  ,[Telefon]
  FROM [db].[dbo].[Pracownik] 
  WHERE AktualizujeIDR is NULL and
  DataZakonczeniaWspolpracy >= DATEADD(day, -360, GETDATE()) 
  AND DataZakonczeniaWspolpracy <= GETDATE()
  Order by DataZakonczeniaWspolpracy DESC" 

  $server = "server"
  #$database = ""
  $username = "db_user"
  $password = "password"

  try {
   $AccountToBlock = Invoke-Sqlcmd -Query $sql -ServerInstance $server -QueryTimeout 30 -ErrorAction 'Stop'  -username $username -password $password



} catch {

$From = "mail@mail.pl"
$To = "mail@mail.pl"
$Subject = "Blad blokowania kont pocztowych"
$Body = $error
$SMTPServer = "smtp.office365.com"
$SMTPPort = "587"

$User = "mail@mail.pl"
$password_mail = "Password" | ConvertTo-SecureString -asPlainText -Force

$cred=New-Object -TypeName System.Management.Automation.PSCredential($User,$password_mail)

$SMTPMessage = New-Object System.Net.Mail.MailMessage($From,$To,$Subject,$Body)
$SMTPClient = New-Object Net.Mail.SmtpClient($SMTPServer, $SMTPPort) 
$SMTPClient.EnableSsl = $true 
$SMTPClient.Credentials = New-Object System.Net.NetworkCredential($cred.UserName, $cred.Password); 
$SMTPClient.Send($SMTPMessage)

Write-Error "Job Failure" -EA Stop
}


 $AccountToBlock | % {
  
  $login = $_.EmailSluzbowy

  $podzielone = $login.Split("{@}")
  $nazwa_konta = $podzielone[0]
  $domena = "mail1.pl"
  
$headers = New-Object "System.Collections.Generic.Dictionary[[String],[String]]"
$headers.Add("Accept", '*/*')
$headers.Add("UserAgent", 'API-CLIENT')
$headers.Add("ContentType", 'application/json')
$headers.Add("KeepAlive", 'true')


if ($domena -eq "mail1.pl"){
$headers.Add("Authorization", 'Basic ????')  
}                                    

if ($domena -eq "mail2.pl"){
$headers.Add("Authorization", 'Basic ????')
}



$params = @{
"description" = "Zablokowane przez skrypt"
 "capacity" = 50
  "blocked" = 1
}

$url = "https://as23123.e-kei.pl/v1/emails/$domena/$nazwa_konta"

Invoke-RestMethod -Uri $url -Headers $headers -Method 'PUT' -Body $params




