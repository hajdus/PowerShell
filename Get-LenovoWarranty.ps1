<#
.SYNOPSIS

.DESCRIPTION

.EXAMPLE
    Get-LenovoWarranty.ps1
.NOTES
autor: hajdus 2018
#>



$csv = Import-Csv C:\Users\mhajduk1\Desktop\lenovowarranty.csv -Delimiter ";" 
$FilePath = "C:\Users\mhajduk1\Desktop\"
$date = Get-Date -Format g

if (Test-Path "$FilePath\Lenovo.html" -PathType Leaf){
Remove-Item "$FilePath\Lenovo.html" }



 



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



$csv |ForEach-Object{

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

 
ConvertTo-Html -Body "<Table border=1>
<TR>
<TD width=250px >$ProductName</TD>
<TD width=250px >$SerialNumber</TD>
<TD width=250px >$WED</TD>
</TR>
</table>" | Out-File -Append "$FilePath\Lenovo.html" 

   
   }
