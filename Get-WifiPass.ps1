<#
.SYNOPSIS
   Get all wifi password store in pc
.DESCRIPTION
   Get all wifi password store in pc
.EXAMPLE
    Get-WiFiPass.ps1
.NOTES
    autor: hajdus 2018
#>


netsh wlan show profile | Select-Object -Skip 3| Where-Object -FilterScript {($_ -like '*:*')} | ForEach-Object -Process {
    $NetworkName = $_.Split(':')[-1].trim()
    $PasswordDetection = $(netsh wlan show profile name =$NetworkName key=clear) | Where-Object -FilterScript {($_ -like '*key content*')}

    $output = New-Object -TypeName PSObject -Property @{
        NetworkName = $NetworkName
        Password = if($PasswordDetection){$PasswordDetection.Split(':')[-1].Trim()}else{'Unknown'}
    } -ErrorAction SilentlyContinue 

     '{0,10}{1,30}' -f ($output.NetworkName,$output.Password)
}
