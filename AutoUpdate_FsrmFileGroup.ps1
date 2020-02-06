
Function ConvertFrom-Json20
{
    # Deserializes JSON input into PowerShell object output
    Param (
        [Object] $obj
    )
    Add-Type -AssemblyName System.Web.Extensions
    $serializer = New-Object System.Web.Script.Serialization.JavaScriptSerializer
    return ,$serializer.DeserializeObject($obj)
}


$jsonStr = Invoke-WebRequest -Uri https://fsrm.experiant.ca/api/v1/get
$monitoredExtensions = @(ConvertFrom-Json20 $jsonStr | ForEach-Object { $_.filters })



Set-FsrmFileGroup -Name "Ransomware Files" -IncludePattern $monitoredExtensions


#(Get-FsrmFileGroup -Name "Ransomware Files").IncludePattern.count

