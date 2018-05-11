<#
.SYNOPSIS
Start or stop ethernet adapter
.DESCRIPTION
Run a scrpit to turn on/off ethernet adapter
.NOTES
autor: hajdus 2018
#>


$eth = Get-NetAdapter -name "Ethernet" 
if ($eth.Status -Match "Up")
{
Disable-NetAdapter -name "Ethernet" -Confirm:$false
Exit
}

if ($eth.Status -Match "Disabled")
{
Enable-NetAdapter -name "Ethernet" -Confirm:$false
Exit
}
