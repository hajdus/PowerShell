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