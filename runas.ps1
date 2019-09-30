Function psrunas{
      [Cmdletbinding()] 
    Param( 
        [Parameter(Position=0, Mandatory=$true)]
        $username,
        [Parameter(Position=1, Mandatory=$true)]
        $password,
        [Parameter(Position=2, Mandatory=$true)]
        $command,
        [Parameter(Position=2, Mandatory=$true)]
        $argument
    )
    Begin
    {
    
        $securePassword = ConvertTo-SecureString $password -AsPlainText -Force
        $credential = New-Object System.Management.Automation.PSCredential $username, $securePassword
        Start-Process $command -ArgumentList $argument -Credential $credential

    }
    
}