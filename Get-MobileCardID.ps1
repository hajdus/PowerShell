
<#
.SYNOPSIS
Script finds all mobile card ICC_ID in computer 
.DESCRIPTION
Run a scrpit on multiple computer via Group Policy to get all mobile card icc_id from computers.
.EXAMPLE

.NOTES
autor: hajdus 2018
#>


#
$outfile = "\\server.adress\share_folder\ICCID.txt"

$get_meid = cmd /c "netsh mbn sh interface"
$get_iccid = cmd /c "netsh mbn sh read i=*"
$comp = $env:COMPUTERNAME
$user = $env:USERNAME

if ($get_meid -match "not running." ) {
    
    Exit
}

if ($get_meid -match "was not found." ) {
    Exit
}

else {
    if (Get-Content $outfile | Select-String  $comp) {
        Exit   
    }
    else {
        $IMEI = $get_iccid | Where {$_ -Match "Sim ICC Id"}
        $IMEI = $IMEI.Substring($IMEI.get_Length() - 13)
        "$comp , $user , $IMEI " | Out-File $outfile -Append
    }

}

