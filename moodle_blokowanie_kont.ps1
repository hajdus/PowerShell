<#
.SYNOPSIS
    Blokowanie kont z moodla na podstawie danych z db
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
  $username = "user"
  $password = "password"

  try {
   $AccountToBlock = Invoke-Sqlcmd -Query $sql -ServerInstance $server -QueryTimeout 30 -ErrorAction 'Stop'  -username $username -password $password



} catch {

$From = "mail@mail.pl"
$To = "mail@mail.pl"
$Subject = "Blad blokowania kont moodle"
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


    $token = "token"
    $auth = "manual"
    $functionname_get = "core_user_get_users"
    $functionname_block = "core_user_update_users"
    $suspended = 1  # BLOKOWANIE USEROW
    
    $AccountToBlock | % {
    
    $login = $_.login
    $url = "https://moodleaddress.pl/webservice/rest/server.php?wsfunction=$functionname_get&wstoken=$token&criteria[0][key]=username&criteria[0][value]=$login"
    
    $response = Invoke-RestMethod -Method 'Post' -Uri $url | select OuterXml
    [xml]$xml = $response.OuterXml
    $id = $xml.RESPONSE.SINGLE.KEY[0].MULTIPLE.SINGLE.KEY[0].VALUE
    
    
    $url = "https://moodleaddress.pl/webservice/rest/server.php?wsfunction=$functionname_block&wstoken=$token&moodlewsrestformat=json&users[0][id]=$id&users[0][suspended]=$suspended"
    
    Invoke-RestMethod -Method 'Post' -Uri $url
    
    }
    