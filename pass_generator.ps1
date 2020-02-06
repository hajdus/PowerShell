$array1 = @("krokodyl","zyrafa","pies","slonik","kucyk","kot","rekin","ptak","zaba","niedzwiedz","bawol","motyl","wielblad","gepard","krowa","delfin","kaczka","ryba","lis","goryl","kura","hipopotam","koala","lew","jaszczurka")
$array2 = @("bialy","zolty","zloty","pomaranczowy","czerwony","rozowy","fioletowy","purpurowy","niebieski","granatowy","turkusowy","zielony","brazowy","szary","srebrny","czarny" ,"ciemny","maly","duzy")
$array3 = @(1,2,3,4,5,6,7,8,9,0)



for($i=0; $i -lt 80; $i++){

$pass = $array2[(Get-Random -Maximum ([array]$array2).count)]+$array1[(Get-Random -Maximum ([array]$array1).count)]+$array3[(Get-Random -Maximum ([array]$array3).count)]+$array3[(Get-Random -Maximum ([array]$array3).count)]

$pass
}