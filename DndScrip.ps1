<#
.SYNOPSIS
    Create Scheduled Task to on or off DND on cisco phone
.DESCRIPTION
    
.EXAMPLE
    DndScrip.ps1 -telefonaddres 1.1.1.1 -username mhajduk
.NOTES
    autor: hajdus 2018
#>


Param(
    [Parameter(Mandatory = $true)] [String]$telefonaddres,
    [Parameter(Mandatory = $true)] [String]$username
)


#DND_on script
$DND_on_Script = 'curl -k -i --raw  -X POST -d "P30959=&29743=DHCP&29935=&29871=&30063=&30703=&30639=&30191=&30127=&51053=0&50989=300&51181=StationTime&60719=1&45359=1&38191=1&31022=1&23854=1&8494=1&1326=1&59694=1&52526=1&37166=1&29997=1&22829=1&42157=1&43693=&43885=&43821=&44013=20&47277=&47469=&47405=&47597=&47533=&48749=&48685=&48877=&41709=1&41645=0&41837=0&41773=1&42605=0&54509=Speaker&20652=24hr&20844=month%%2Fday&42925=1&42093=0&42029=0&43245=8&43181=4&43373=10&43309=10&23276=Auto&23084=Default&20780=8" "http://'+$telefonaddres+'/bcisco.csc" -H "Host: '+$telefonaddres+'" -H "User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:65.0) Gecko/20100101 Firefox/65.0" -H "Accept: text/html,application/xhtml+xml,application/xml;q=0.9,image/webp,*/*;q=0.8" -H "Accept-Language: pl,en-US;q=0.7,en;q=0.3" -H "Accept-Encoding: gzip, deflate" -H "Referer: http://'+$telefonaddres+'/basic" -H "Content-Type: application/x-www-form-urlencoded" -H "Connection: keep-alive" -H "Upgrade-Insecure-Requests: 1"' 
$DND_on_Script | Out-File -Append -FilePath "C:\Users\$username\DND_on.bat" -Encoding ascii


#DND_off script
$DND_off_Script = 'curl -k -i --raw  -X POST -d "P30959=&29743=DHCP&29935=&29871=&30063=&30703=&30639=&30191=&30127=&51053=0&50989=300&51181=StationTime&60719=1&45359=1&38191=1&31022=1&23854=1&8494=1&1326=1&59694=1&52526=1&37166=1&29997=1&22829=1&42157=1&43693=&43885=&43821=&44013=20&47277=&47469=&47405=&47597=&47533=&48749=&48685=&48877=&41709=1&41645=0&41837=0&41773=0&42605=0&54509=Speaker&20652=24hr&20844=month%%2Fday&42925=1&42093=0&42029=0&43245=8&43181=4&43373=10&43309=10&23276=Auto&23084=Default&20780=8" "http://'+$telefonaddres+'/bcisco.csc" -H "Host: '+$telefonaddres+'" -H "User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:65.0) Gecko/20100101 Firefox/65.0" -H "Accept: text/html,application/xhtml+xml,application/xml;q=0.9,image/webp,*/*;q=0.8" -H "Accept-Language: pl,en-US;q=0.7,en;q=0.3" -H "Accept-Encoding: gzip, deflate" -H "Referer: http://'+$telefonaddres+'/basic" -H "Content-Type: application/x-www-form-urlencoded" -H "Connection: keep-alive" -H "Upgrade-Insecure-Requests: 1"' 
$DND_off_Script | Out-File -Append -FilePath "C:\Users\$username\DND_off.bat" -Encoding ascii


#username to ID
$objUser = New-Object System.Security.Principal.NTAccount("domain", $username) 
$strSID = $objUser.Translate([System.Security.Principal.SecurityIdentifier]) 
$userid = $strSID.Value


$xml_on = @"
<?xml version="1.0" encoding="UTF-16"?>
<Task version="1.2" xmlns="http://schemas.microsoft.com/windows/2004/02/mit/task">
  <RegistrationInfo>
    <Date>2019-02-27T07:32:25.8070167</Date>
    <Author>domain\$username</Author>
    <URI>\DND\DND_on1</URI>
  </RegistrationInfo>
  <Triggers>
    <SessionStateChangeTrigger>
      <Enabled>true</Enabled>
      <StateChange>SessionLock</StateChange>
      <UserId>domain\$username</UserId>
    </SessionStateChangeTrigger>
  </Triggers>
  <Principals>
    <Principal id="Author">
      <UserId>$userid</UserId>
      <LogonType>InteractiveToken</LogonType>
      <RunLevel>LeastPrivilege</RunLevel>
    </Principal>
  </Principals>
  <Settings>
    <MultipleInstancesPolicy>IgnoreNew</MultipleInstancesPolicy>
    <DisallowStartIfOnBatteries>true</DisallowStartIfOnBatteries>
    <StopIfGoingOnBatteries>true</StopIfGoingOnBatteries>
    <AllowHardTerminate>true</AllowHardTerminate>
    <StartWhenAvailable>false</StartWhenAvailable>
    <RunOnlyIfNetworkAvailable>false</RunOnlyIfNetworkAvailable>
    <IdleSettings>
      <StopOnIdleEnd>true</StopOnIdleEnd>
      <RestartOnIdle>false</RestartOnIdle>
    </IdleSettings>
    <AllowStartOnDemand>true</AllowStartOnDemand>
    <Enabled>true</Enabled>
    <Hidden>false</Hidden>
    <RunOnlyIfIdle>false</RunOnlyIfIdle>
    <WakeToRun>false</WakeToRun>
    <ExecutionTimeLimit>PT72H</ExecutionTimeLimit>
    <Priority>7</Priority>
  </Settings>
  <Actions Context="Author">
    <Exec>
      <Command>C:\Users\$username\DND_on.bat</Command>
    </Exec>
  </Actions>
</Task>
"@



$xml_off =@" 
<?xml version="1.0" encoding="UTF-16"?>
<Task version="1.2" xmlns="http://schemas.microsoft.com/windows/2004/02/mit/task">
  <RegistrationInfo>
    <Date>2019-02-27T07:34:51.591078</Date>
    <Author>domain\$username</Author>
    <URI>\DND\DND_off1</URI>
  </RegistrationInfo>
  <Triggers>
    <SessionStateChangeTrigger>
      <Enabled>true</Enabled>
      <StateChange>SessionUnlock</StateChange>
      <UserId>domain\$username</UserId>
    </SessionStateChangeTrigger>
    <LogonTrigger>
      <Enabled>true</Enabled>
      <UserId>domain\$username</UserId>
    </LogonTrigger>
  </Triggers>
  <Principals>
    <Principal id="Author">
      <UserId>$userid</UserId>
      <LogonType>InteractiveToken</LogonType>
      <RunLevel>LeastPrivilege</RunLevel>
    </Principal>
  </Principals>
  <Settings>
    <MultipleInstancesPolicy>IgnoreNew</MultipleInstancesPolicy>
    <DisallowStartIfOnBatteries>true</DisallowStartIfOnBatteries>
    <StopIfGoingOnBatteries>true</StopIfGoingOnBatteries>
    <AllowHardTerminate>true</AllowHardTerminate>
    <StartWhenAvailable>false</StartWhenAvailable>
    <RunOnlyIfNetworkAvailable>false</RunOnlyIfNetworkAvailable>
    <IdleSettings>
      <StopOnIdleEnd>true</StopOnIdleEnd>
      <RestartOnIdle>false</RestartOnIdle>
    </IdleSettings>
    <AllowStartOnDemand>true</AllowStartOnDemand>
    <Enabled>true</Enabled>
    <Hidden>false</Hidden>
    <RunOnlyIfIdle>false</RunOnlyIfIdle>
    <WakeToRun>false</WakeToRun>
    <ExecutionTimeLimit>PT72H</ExecutionTimeLimit>
    <Priority>7</Priority>
  </Settings>
  <Actions Context="Author">
    <Exec>
      <Command>C:\Users\$username\DND_off.bat</Command>
    </Exec>
  </Actions>
</Task>

"@

Register-ScheduledTask -Xml $xml_on -TaskName "DND_on1" -TaskPath "\DND\"
Register-ScheduledTask -Xml $xml_off -TaskName "DND_off2" -TaskPath "\DND\"

