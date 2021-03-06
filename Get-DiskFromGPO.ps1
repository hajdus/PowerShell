<#
.SYNOPSIS
    Find and create bat file to map disk for user
.DESCRIPTION
    Find and create bat file to map disk for user
.EXAMPLE
    Get-DiskFromGPO.ps1 -jsmith
   .\Get-DiskFromGPO.ps1 -user jsmith
.NOTES
    autor: hajdus 2018
#>

Param(
    [Parameter(Mandatory = $true)] [String]$user
)
 
$UserExist = Get-ADUser -LDAPFilter "(sAMAccountName=$user)"
If ($UserExist -eq $Null) {
    Write-Host -ForegroundColor RED "Użytkownik nie istnieje w AD!!"
    Exit 
}

Else { 
    Write-Host -ForegroundColor GREEN "Użytkownik istnieje w AD"

    [xml]$xml = Get-GPOReport -Name "USR#CONF#Mapowanie_Dyskow" -ReportType XML
    $grups = Get-ADPrincipalGroupMembership $user | ? name -Match "Centrala-" | select name 
   
    $FilePath = "$env:HOMEPATH\Desktop"
   
    #Check if output file exist
    if (Test-Path "$FilePath\$user.bat" -PathType Leaf) {
        Remove-Item "$FilePath\$user.bat" 
    }

    Clear-Host
    Write-Host -ForegroundColor Green "Utworzono plik bat $FilePath\$user.bat"
    Write-Host -ForegroundColor Yellow "Zawartość:"
    $grups | % {  
        $name = $_.name   
        $xml.GPO.User.ExtensionData.Extension.DriveMapSettings.Drive  |
            % { if ($_.Filters.FilterGroup.name -match $name ) {
                $Tekst = "net use " + $_.name + " " + $_.Properties.path + " /persistent:yes"  
       
                $Tekst | Out-File -Append -FilePath "$FilePath\$user.bat" -Encoding ascii
    
                $Tekst
    
            } 

   
        } 
    }  
}
