
[xml]$xaml = @"
<Window 
    xmlns="http://schemas.microsoft.com/winfx/2006/xaml/presentation"
    xmlns:x="http://schemas.microsoft.com/winfx/2006/xaml"
    x:Name="Window" Title="Konwerter Hex na Dec" WindowStartupLocation = "CenterScreen" ResizeMode="NoResize"
    Width = "313" Height = "280" ShowInTaskbar = "True" Background = "lightgray"> 
    <StackPanel >
        <Label Content='Wpisz wartość:' />
        <TextBox x:Name="InputBox" Height = "50" AcceptsTab="True" AcceptsReturn="False" TextWrapping="Wrap" VerticalScrollBarVisibility = "Auto"/>
        <StackPanel Orientation = 'Horizontal'>  
            <Button x:Name = "button1" Height = "75" Width = "100" Content = 'Oblicz i kopiuj' />
        </StackPanel>
        <Label Content='Wynik po konwersji i skopiowaniu:' />
       <TextBox x:Name="OutputBox" IsReadOnly = "True" Height = "75" TextWrapping="Wrap" VerticalScrollBarVisibility = "Auto" Background="lightgray" /> 
    </StackPanel>
</Window>
"@
 
$reader=(New-Object System.Xml.XmlNodeReader $xaml)
$Window=[Windows.Markup.XamlReader]::Load( $reader )


$button1 = $Window.FindName('button1')
$button2 = $Window.FindName('button2')
$OutputBox = $Window.FindName('OutputBox')
$InputBox = $Window.FindName('InputBox')
$InputBox.Focus()


$button1.Add_Click({
  
    $Hex = $InputBox.Text.Substring(2)
    $Hex = [convert]::toint64($Hex,16)
    

    Set-Clipboard -Value $Hex
    $OutputBox.Text = "Wartość: "+$InputBox.Text+" przerobiono na "+$Hex
    $InputBox.Clear()
})



$Window.ShowDialog() | Out-Null