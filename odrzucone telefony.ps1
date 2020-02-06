
$string = "486 Busy here"



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

Remove-Item -Path $Folder\* -Include *.log.7z


cd $Folder
Expand-Archive  $Folder

set-alias sz "$env:ProgramFiles\7-Zip\7z.exe"
$7zf = "$Folder\*"
$7zp = "" #password
# -aoa This switch overwrites all destination files. Use it when the new versions are preferred.
# -aos Skip over existing files without overwriting. Use this for files where the earliest version is most important.
# -aou Avoid name collisions. New files extracted will have a number appending to their names. You will have to deal with them later.
# -aot Rename existing files. This will not rename the new files, just the old ones already there.
$7zo = "-aoa"

sz x $7zf "-p$7zp" $7zo




Remove-Item -Path $Folder\* -Include *.7z
Remove-Item -Path $Folder\* -Include *.log

Get-ChildItem -Path $Folder -recurse |  Select-String $string  -Context 6 | % {  $_.line + $_.Context.PostContext } |  out-file "$Folder\Results.txt"

(get-content "$Folder\Results.txt")  | % { 
    if ($_ -match "To: <sip:10(.*)") { 
        $name = $matches[1]
        echo $name
    }
} |  out-file "$Folder\Result2.txt"

if (Test-Path -path "$Folder\Results.txt" -PathType Leaf) {
   Remove-Item "$Folder\Results.txt"
   }


get-content "$Folder\Result2.txt"  |% { "10"+$_.Substring(0, 2) } | out-file "$Folder\Do exela.txt"
if (Test-Path -path "$Folder\Result2.txt" -PathType Leaf) {
   Remove-Item "$Folder\Result2.txt"
   }