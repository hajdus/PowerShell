<#
.SYNOPSIS
Find all outlook archivs in pc and add it to outlook
.DESCRIPTION
Script finds all outlook archivs (.pst files) and add it to your outlook profile. 
No need to close outlook to add pst file.
.EXAMPLE
Get-OutlookArchivs.ps1
.NOTES
autor: hajdus 2018

#>


Add-type -assembly "Microsoft.Office.Interop.Outlook" | out-null
$outlook = new-object -comobject outlook.application
$namespace = $outlook.GetNameSpace("MAPI")
$i = 1
#Find all archives in C drive and create varible for each 
Get-ChildItem -Path C:\ -Recurse  -Filter *.pst -ErrorAction SilentlyContinue |
    ForEach-Object {Set-Variable -Name "arch$i" -Value $_.FullName  ; $i++ }
$HowManyArch = $i

#Diplay all archives
for ($i = 1; $i -lt $HowManyArch ; $i++ ) {
      
    $archiveTxt = Get-Variable -Name "arch$i" -ValueOnly
    Write-Host $i". "$archiveTxt -ForegroundColor Green
    
}

Write-Host "A. Add all archives" -ForegroundColor Green
Write-Host "Q. Quit" -ForegroundColor Green

#Select which archives wanna add
do {
    Write-Host "Please make a selection(number): " -ForegroundColor Yellow -NoNewline
    $input = Read-Host 
   
    switch ($input) {

        'a' { 
            for ($i = 1; $i -lt $HowManyArch ; $i++ ) {
                $arch = Get-Variable -name "arch$i" -ValueOnly
                $namespace.AddStore("$arch")
            }
               
            Write-Host "Add all archives" -ForegroundColor Green
            return
        } 
          
        'q' { return  }
     
        $input {
            if ($input -gt $HowManyArch - 1 -or $input -like "") {
                Write-Host "Error: $input is not on the list " -ForegroundColor Red
            }
            else {
                
                $arch = Get-Variable -name "arch$input" -ValueOnly
                            
                $namespace.AddStore("$arch")
                Write-Host "Add archive $arch" -ForegroundColor Green
            }
        } 
                         
    }
    pause
}
until ($input -eq 'q') 
    
