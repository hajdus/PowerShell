<#
.SYNOPSIS
    Get print spooler up time
.DESCRIPTION
  Get print spooler up time
.EXAMPLE
    Get-Print_spooler_up_time.ps1  
.NOTES
    autor: hajdus 2018
#>



$computer = "localhost"

Enter-PSSession -ComputerName $computer -Credential username
(Get-EventLog  -LogName “System” -Source “Service Control Manager” -EntryType “Information” -Message “*Print Spooler service*running*” -Newest 1).TimeGenerated
