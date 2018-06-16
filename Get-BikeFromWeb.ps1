
$url = "http://www.bikez.com/brands/index.php"
$i = 0

$Response = Invoke-WebRequest $url 

$Response.Links | where {$_.href -like "/brand/*"} | select -ExpandProperty href | % {
    $url2 = "http://www.bikez.com$_"
    $Response2 = Invoke-WebRequest $url2
    $UpdateDate2 = $Response2.Links | where {$_.href -like "../motorcycles/*"} | select -ExpandProperty href | % {

        $url3 = "http://www.bikez.com$_"
        $url3 = $url3.Replace("..", "")
        $Response3 = Invoke-WebRequest $url3
        $UpdateDate3 = $Response3.AllElements | where name -eq "keywords" | select -ExpandProperty content 

        $array = $UpdateDate3.split(",")
        $i++
        $output = [PSCustomObject]@{ID = $i; Producent = $array[1]; Model = $array[2]; Rok = $array[0]}


        $output | Export-Csv -Append -Path "C:\temp\bike.csv" -NoTypeInformation
    }

    $next = $Response2.Links | where {$_.outerText -like "Next >>"}
 
    while ($next) {
 
        $url3 = $Response2.Links | where {$_.outerText -like "Next >>"} | select -ExpandProperty href
        $Response2 = Invoke-WebRequest "$url2/$url3"
        $UpdateDate2 = $Response2.Links | where {$_.href -like "../motorcycles/*"} | select -ExpandProperty href | % {

            $url3 = "http://www.bikez.com$_"
            $url3 = $url3.Replace("..", "")
            $Response3 = Invoke-WebRequest $url3
            $UpdateDate3 = $Response3.AllElements | where name -eq "keywords" | select -ExpandProperty content 

            $array = $UpdateDate3.split(",")
            $i++
            $output = [PSCustomObject]@{ID = $i; Producent = $array[1]; Model = $array[2]; Rok = $array[0]}


            $output | Export-Csv -Append -Path "C:\temp\bike.csv" -NoTypeInformation



            $next = $Response2.Links | where {$_.outerText -like "Next >>"}
        }
    }
 

}
 


 
