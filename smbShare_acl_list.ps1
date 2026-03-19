$strarry = Get-Content -Path 'C:\temp\serverslist.txt'


$strarry | foreach { 
$shares = net view $_ /all | select -Skip 7 | ?{$_ -match 'Dysk*'} | %{$_ -match '^(.+?)\s+Dysk*'|out-null;$matches[1]} 
$ip = $_

$shares | foreach {"\\$ip\$_" | Out-File -Append -FilePath 'C:\temp\ip_share.txt' }
}


$sharearry = Get-Content -Path 'C:\temp\ip_share.txt'



$sharearry | foreach { $FolderPath = Get-ChildItem -Directory -Path $_  -Force #-Recurse 1
$Output = @() 
ForEach ($Folder in $FolderPath) { 
    echo $Folder.FullName
    $Acl = Get-Acl -Path $Folder.FullName 
    ForEach ($Access in $Acl.Access) { 
$Properties = [ordered]@{'Folder Name'=$Folder.FullName;'Group/User'=$Access.IdentityReference;'Permissions'=$Access.FileSystemRights;'Inherited'=$Access.IsInherited} 
$Output += New-Object -TypeName PSObject -Property $Properties 
    } 
} 
 $Output | Export-Csv -Append -Path 'C:\temp\acl_list_recurse1.csv' -NoTypeInformation -Encoding UTF8
}



#$shares = net view \\ip /all | select -Skip 7 | ?{$_ -match 'Dysk*'} | %{$_ -match '^(.+?)\s+Dysk*'|out-null;$matches[1]}
