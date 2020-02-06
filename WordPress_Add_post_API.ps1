



$base64AuthInfo = [Convert]::ToBase64String([Text.Encoding]::ASCII.GetBytes(("user:pass"))) 
$header = @{ 
Authorization=("Basic {0}" -f $base64AuthInfo) 
} 



$params = @{ 
    title = "test Rest API post 5" 
    content = "test Rest API post content" 
    status = 'publish'
    featured_media = '12'
  
} 

$params1=$params|ConvertTo-Json 
$response = Invoke-RestMethod -Method post -Uri http://wordpress_page.pl/wp-json/wp/v2/posts -ContentType "application/json" -Body $params1  -Headers $header -UseBasicParsing 
  


 
#Opublikuj na glownej
$params_meta = @{ 
  key = "ex_show_in_homepage"
  value = "Yes"
 } 
$params_meta1=$params_meta|ConvertTo-Json 

$id = $response.id

$url = "http://wordpress_page.pl/wp-json/wp/v2/posts/$id/meta"

Invoke-RestMethod -Method post -Uri $url -ContentType "application/json" -Body $params_meta1  -Headers $header -UseBasicParsing 


