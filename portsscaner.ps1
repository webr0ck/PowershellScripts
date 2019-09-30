#function scan {
    Param (
            [String] $address, 
            [String] $ports = $null
        )  
    if (!$address) {Write-Host "To use this script touch: portsscaner.ps1 -address addres_for_scan -ports 1..65535"}
    if (!$ports) { $Ports = 1 .. 65535}
    else {$Ports = $ports}
    Write-Host "Here"
    Write-Host $Ports
    Write-Host $address
    $TimeOut = 20
    $ping = New-Object System.Net.Networkinformation.Ping
    $pingStatus = $ping.Send($address,$TimeOut)
    if($pingStatus.Status -eq "Success"){$openPorts = @()
    for($i = 1; $i -le $ports.Count;  $i++) {$port = $Ports[($i-1)]
    write-progress -activity PortScan -status $address -percentcomplete (($i/($Ports.Count)) * 100) -Id 2
        $client = New-Object System.Net.Sockets.TcpClient
    $beginConnect = $client.BeginConnect($pingStatus.Address,$port,$null,$null)
    if($client.Connected){
        $openPorts += $port
    } else { Start-Sleep -Milli $TimeOut
    if($client.Connected) { $openPorts += $port
    $Message = "dsec_search_port----------------------------------port=$port"
    $socket = new-object System.Net.Sockets.TcpClient($address, $port)
    $data = [System.Text.Encoding]::ASCII.GetBytes($message)
    $stream = $socket.GetStream()
    $stream.Write($data, 0, $data.Length)
    }}$client.Close()}
    New-Object PSObject -Property @{Ports = $openPorts} | Select-Object  Ports | Out-File -filepath .\out.txt
    
    }    
#}
