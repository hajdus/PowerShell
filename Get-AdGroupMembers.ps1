

$grupy = get-adgroup -Filter * | where {$_.name -Match "Hurtownia"} 

foreach ($grupa in $grupy){

echo ---- $grupa.name 
$grupa | Get-ADGroupMember | select name

}





