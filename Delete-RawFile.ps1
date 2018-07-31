<#
.SYNOPSIS
    usuń te rawy ktore nie maj jpg o tej samej nazwie
.DESCRIPTION
    
.EXAMPLE
    
.NOTES
    autor: hajdus 2018
#>

Write-Host -ForegroundColor Yellow "Wybiesz folder"
Add-Type -AssemblyName System.Windows.Forms
$FolderBrowser = New-Object System.Windows.Forms.FolderBrowserDialog
$result = $FolderBrowser.ShowDialog((New-Object System.Windows.Forms.Form -Property @{TopMost = $true }))

if ($result -eq [Windows.Forms.DialogResult]::OK) {
    $Folder = $FolderBrowser.SelectedPath
}
else {
    exit
}
 
$Obiekty = Get-ChildItem -Path $Folder
$count = 0
$raw = $Obiekty | ? {$_.Extension -eq ".raw"} | select Fullname
$jpg = $Obiekty | ? {$_.Extension -eq ".jpg"} | select Fullname

if (($raw -eq $null) -or ($jpg -eq $null)) {
    Write-Host -ForegroundColor Red "BRAK PLIKÓW Z ROZSZERZENIEM RAW LUB JPG"
    Start-Sleep -s 2
    exit
}
else {
    $ToDel = Compare-Object $raw $jpg | ForEach-Object { $_.InputObject} 
    $ToDel | % { 
        Remove-Item $_.FullName -WhatIf 
        $count++
    }

    Write-Host -ForegroundColor Green "Wszystkie pliki($count), z których nie powstał JPG zostały usunięte. "
    Start-Sleep -s 2
}
