date

 $port= new-Object System.IO.Ports.SerialPort COM6,9600,None,8,one
 $port.Open()
 $port.WriteLine(“ en”)
 $port.WriteLine(“ terminal length 0”)
 $port.WriteLine(“ sh run”)

 $message = ""
 
 while ($message -notlike "end*") {   
  $message=$port.ReadLine()  
  Write-Output $message 
  $port.WriteLine("") 
}  
 
 
 
 
 $port.Close()


 date


