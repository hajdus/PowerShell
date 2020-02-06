
$lastname  = "Testowy"
$firstname = "Test"
$usrname = "testowytest"   # nazwa uzytkownika tylko male litery
$email = "testowy.test@test.pl"
$phone = "123456789"
$password = "password"





$auth = "manual"
$functionname = "core_user_create_users"
$token = "toekn"
$url = "https://moodleaddress/webservice/rest/server.php?wsfunction=$functionname&wstoken=$token&users[0][username]=$usrname&users[0][password]=$password&users[0][firstname]=$firstname&users[0][lastname]=$lastname&users[0][email]=$email&users[0][phone1]=$phone"


<#
$body  = @{
wsfunction = $functionname
wstoken = $token

}
#>

Invoke-RestMethod -Method 'Post' -Uri $url 


#core_user_get_users
 

    $functionname_get = "core_user_get_users"
   
    $login = $usrname
    $url = "https://moodleaddress/webservice/rest/server.php?wsfunction=$functionname_get&wstoken=$token&criteria[0][key]=username&criteria[0][value]=$login"
    
    $response = Invoke-RestMethod -Method 'Post' -Uri $url | select OuterXml
    [xml]$xml = $response.OuterXml
    $id = $xml.RESPONSE.SINGLE.KEY[0].MULTIPLE.SINGLE.KEY[0].VALUE


#enrol_manual_enrol_users

$functionname_enrol = "enrol_manual_enrol_users"
$courseID = "7" # kurs akrualności
$roleID = "5"   # rola student

$url = "https://moodleaddress/webservice/rest/server.php?wsfunction=$functionname_enrol&wstoken=$token&enrolments[0][roleid]=$roleID&enrolments[0][userid]=$id&enrolments[0][courseid]=$courseID"

Invoke-RestMethod -Method 'Post' -Uri $url 
