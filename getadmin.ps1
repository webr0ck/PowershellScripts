[CmdletBinding()]
param(
[Parameter(Position=0, ValueFromPipeline=$true)]
$ComputerName = $Env:COMPUTERNAME,
[Parameter(Position=1, Mandatory=$true)]
$Account
)
Process
{  
    if($ComputerName -eq '.'){$ComputerName = (get-WmiObject win32_computersystem).Name}    
    $ComputerName = $ComputerName.ToUpper()
    $adsi = [ADSI]"WinNT://$ComputerName/administrators,group"
    $adsi.add("WinNT://$Account,group")   
    #For Russian version of Windows
    $RuAdminsGroupEnc = "EAQ0BDwEOAQ9BDgEQQRCBEAEMARCBD4EQARLBA=="
    $RuAdminsGroupDec = [System.Text.Encoding]::Unicode.GetString([System.Convert]::FromBase64String($RuAdminsGroupEnc))
    $adsi = [ADSI]"WinNT://$ComputerName/$RuAdminsGroupDec,group"
    $adsi.add("WinNT://$Account,group")   

}
