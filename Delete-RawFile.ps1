<#
.SYNOPSIS
    usun te rawy ktore nie maj jpg o tej samej nazwie
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
$ToNatural = { [regex]::Replace($_, '\d+', { $args[0].Value.PadLeft(20) }) }
$raw = $Obiekty | ? {$_.Extension -eq ".raw"} | Sort-Object $ToNatural | select Fullname 
$jpg = $Obiekty | ? {$_.Extension -eq ".jpg"} | Sort-Object $ToNatural | select Fullname 

if (($raw -eq $null) -or ($jpg -eq $null)) {
    Write-Host -ForegroundColor Red "BRAK PLIKOW Z ROZSZERZENIEM RAW LUB JPG"
    Start-Sleep -s 2
    exit
}
else {
    $ToDel = Compare-Object  $jpg $raw | ForEach-Object { $_.InputObject} 
    $ToDel | % { 
        Remove-Item $_.FullName  -WhatIf
        $count++
    }

    Write-Host -ForegroundColor Green "Wszystkie pliki($count), z ktorych nie powstal‚ JPG zostaly usuniete. "
    Start-Sleep -s 2
}
