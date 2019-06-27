
$computer = "10.110.12.80"

Enter-PSSession -ComputerName $computer -Credential mh
(Get-EventLog  -LogName “System” -Source “Service Control Manager” -EntryType “Information” -Message “*Print Spooler service*running*” -Newest 1).TimeGenerated
