
<#
.SYNOPSIS
Script is checking is new version of google play application is available.
.DESCRIPTION
Script is checking is new version of google play application is available.
.EXAMPLE
Get-AppUpdateDate "https://play.google.com/store/apps/details?id=com.whatsapp"
.NOTES
autor: hajdus 2018
#>



Function Get-AppUpdateDate {

    Param(
        [Parameter(Mandatory = $true)] [String]$url
    )

    $Response = Invoke-WebRequest $url

    #Get app name from google play store
    $AppName = $Response.AllElements | Where id -eq "main-title" | Select -First 1 -ExpandProperty innerText   
    $AppName = $AppName.Split()
    $AppName = $AppName[0]

    #Get app update date form google play store
    $UpdateDate = $Response.AllElements | Where Class -eq "htlgb" | Select -First 1 -ExpandProperty innerText    

    #Copy previous new data to old.txt file
    Copy-Item -Path "$AppName new.txt" -Destination "$AppName old.txt"

    #Save present data to new.txt file
    $UpdateDate | Out-File -FilePath "$AppName new.txt"

    #Compare old and new data from txt files
    If ( Compare-Object -ReferenceObject $(Get-Content "$AppName old.txt") -DifferenceObject $(Get-Content "$AppName new.txt"))
    #Find app update and sand email {  
    $MyEmail = "ExampleMail@gmail.com"
    $Password = 'PASSWORD' 
    $SMTP = "smtp.gmail.com"
    $To = "ExampleMail@gmail.com"
    $Subject = "$AppName new update"
    $Body = "$AppName has been updated! Last version is from $UpdateDate. Available at the $url"
    
    $SecurePassword = ConvertTo-SecureString $Password -AsPlainText -Force  
    $Creds = New-Object "System.Management.Automation.PSCredential" -ArgumentList $MyEmail, $SecurePassword

    Send-MailMessage -To $To -From $MyEmail -Subject $Subject -Body $Body -SmtpServer $SMTP -Credential $Creds -UseSsl -Port 587 -DeliveryNotificationOption never
}

#No app update
Else {}
 
}

#Calling function
Get-AppUpdateDate "https://play.google.com/store/apps/details?id=com.whatsapp"
Get-AppUpdateDate "https://play.google.com/store/apps/details?id=com.yammer.v1&hl=pl"

