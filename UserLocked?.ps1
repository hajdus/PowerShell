for ($i=0; $i -le 100; $i++ ){
Get-ADUser -Identity user -Properties *| select "*lock*"
Start-Sleep -s 60
}
