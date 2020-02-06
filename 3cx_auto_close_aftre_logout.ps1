$login = $env:UserName
$fileserver = "\\fileserver\3CX"
$location = "$HOME\AppData\Local\3CX VoIP Phone"


 
if ( Test-Path "$fileserver\konfigi\$login.ini" -PathType Leaf) {
    if (!(Test-Path -path $location)) {
    New-Item $location -Type Directory
    }
        Copy-Item "$fileserver\konfigi\$login.ini" -Destination "$location\3CXVoipPhone.ini" -Recurse 
        Copy-Item "$fileserver\3CXPhoneSoftKeys.ini" -Destination "$location\3CXPhoneSoftKeys.ini" -Recurse 
        Copy-Item "$fileserver\3CX Phone.lnk" -Destination "$HOME\Desktop\3CX Phone.lnk" -Recurse 


Remove-Item -Path "C:\Users\$username\3CX_on.bat" -Force


if(Test-Path "C:\Users\$username\3CX_on.bat" -PathType Leaf) {
   echo "istnieje" 
} else {
   

$username = $login




#3CX_on zawartość pliku":

#$3CX_on_Script = ' @ECHO OFF
#
#SETLOCAL EnableExtensions
#set EXE=3CXPhone.exe
#FOR /F %%x IN ('tasklist /NH /FI "IMAGENAME eq %EXE%"') DO IF %%x == %EXE% goto FOUND
#echo Not running
#START "" "C:\Program Files (x86)\3CXPhone\3CXPhone.exe" 
#goto FIN
#:FOUND
#echo Running
#:FIN
#
#' 
#$3CX_on_Script | Out-File -Append -FilePath "C:\Users\$username\3CX_on.bat" -Encoding ascii


#3CX_on script
Copy-Item "$fileserver\3CX_on.bat" -Destination "C:\Users\$username\3CX_on.bat" -Recurse 

#3CX_off script
$3CX_off_Script = ' taskkill /f /im "3CXPhone.exe"  ' 
$3CX_off_Script | Out-File -Append -FilePath "C:\Users\$username\3CX_off.bat" -Encoding ascii


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
    <URI>\3CX\3CX_$username_off</URI>
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
      <Command>C:\Users\$username\3CX_off.bat</Command>
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
    <URI>\3CX\3CX_$username_on</URI>
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
      <Command>C:\Users\$username\3CX_on.bat</Command>
    </Exec>
  </Actions>
</Task>

"@

Register-ScheduledTask -Xml $xml_on -TaskName "3CX_on_$username" -TaskPath "\3CX\"
Register-ScheduledTask -Xml $xml_off -TaskName "3CX_off_$username" -TaskPath "\3CX\"


}



    }



