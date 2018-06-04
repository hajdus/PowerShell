<#
.SYNOPSIS
    Get lenovo computer warranty from csv file 
.DESCRIPTION
    For all serialnumber form csv file create html output with Product Name, Serial Number,
    Warranty End Date. If computer dont have warranty then it will be in red backgroud in output file.
.EXAMPLE
    Get-LenovoWarranty.ps1
.NOTES
    autor: hajdus 2018
#>


$FilePath = "C:\temp"
$csv = Import-Csv "$FilePath\lenovowarranty.csv" -Delimiter ";" 
$date = Get-Date -UFormat "%Y-%m-%d"

#Check if output file exist
if (Test-Path "$FilePath\Lenovo.html" -PathType Leaf) {
    Remove-Item "$FilePath\Lenovo.html" 
}


ConvertTo-Html -Body "
Generated: $date
<Table border=1>
<TR>
<TD width=250px ><font face=verdana color=Black><H3> Product Name</H3></font></TD>
<TD width=250px ><font face=verdana color=Black><H3>Serial Number</H3></font></TD>
<TD width=250px ><font face=verdana color=Black><H3>Warranty End Date</H3></font></TD>
</TR>
</table>" -Title "Lenovo Warranty" | 
    Out-File -Append "$FilePath\Lenovo.html" 

$csv | ForEach-Object {

    #Dont need to define model
    #$Model = $_.Model

    #Get sn form csv file
    $SerialNumber = $_.SerialNumber

    $body =
@"
xml=<wiInputForm source='ibase'>
<id>LSC3</id>
<pw>IBA4LSC3</pw>
<product>Model</product>
<serial>$SerialNumber</serial>
<wiOptions><machine/>
<parts/><service/><upma/>
<entitle/></wiOptions>
</wiInputForm>
"@

    $searchResults = Invoke-RestMethod -Method Post https://ibase.lenovo.com/POIRequest.aspx -ContentType application/x-www-form-urlencoded -Body $body

    [xml]$xml = $searchResults 
    #Product Name
    $ProductName = $xml.wiOutputForm.warrantyInfo.machineinfo.productName 
    #Serial number
    $SerialNumber = $xml.wiOutputForm.warrantyInfo.machineinfo.serial  
    #Warranty end date
    $WED = $xml.wiOutputForm.warrantyInfo.serviceinfo.wed

    #if current date is lower then warranty end date then color row green
    if ($date -lt $WED[0]) {
       $color = "green"
    }

    #if current date is grater then warranty end date then color row red
    else {
        $color = "red"
         
    }
    ConvertTo-Html -Body "<Table border=1>
    <TR>
    <TD width=250px bgcolor=$color>$ProductName</TD>
    <TD width=250px bgcolor=$color>$SerialNumber</TD>
    <TD width=250px bgcolor=$color>$WED</TD>
    </TR>
    </table>" | Out-File -Append "$FilePath\Lenovo.html"
}
