[Console]::OutputEncoding = [System.Text.Encoding]::GetEncoding("utf-8")
function Log([string]$logline){ 
    $time = (Get-Date -f o)
    $logline = "[" + $time + "] - " + $logline
    Write-host $logline
}

function StartProcess{
    <#
        .SYNOPSIS
            Start process
        .DESCRIPTION
            Function start process and return result object
        .PARAMETER  path
            Path to executable file
        .PARAMETER  arguments
            Process arguments
        .PARAMETER  rediroutput
            Redirect output
        .EXAMPLE
            all parameters are set by user
            PS C:\> 
        .EXAMPLE
            use default values for storageName and storageFolder
            PS C:\> 
        .INPUTS
            System.String,System.String,System.Boolean,System.Boolean
        .OUTPUTS
            Powershell object with properties: process exitcode, output, error
    #>
    Param (
        [String] $path, 
        [String] $arguments = $null,
        [bool] $wait = $true,
        [bool] $rediroutput = $true,
        [bool] $writeResultToLog = $true
    )    
    #create log files
    $guid = [System.Guid]::NewGuid().ToString() 
    $log = "$Env:TEMP\$guid.log"
    $elog = "$Env:TEMP\err$guid.log"
    "" | Out-File $log 
    "" | Out-File $elog 
    $exec = "Start-Process `"$path`"  -PassThru "
    if($rediroutput -eq $true){$exec = $exec + " -RedirectStandardOutput $log -RedirectStandardError $elog -NoNewWindow:`$true "}
    #Start-Process -ArgumentList
    if($arguments -ne $null){$exec = $exec + " -ArgumentList '" + $arguments + "'"}
    if($wait -eq $true){$exec = $exec + " -wait"}   
    $p = Invoke-Expression $exec
    $pr = @{}
    $pr.exitcode = $p.ExitCode
    $pr.output = [IO.File]::ReadAllText($log)
    $pr.error = [IO.File]::ReadAllText($elog)
    $pr.pid = $p.id 

    #remove log files
    Remove-Item $log
    Remove-Item $elog
    if($writeResultToLog){
        Log ("Exite code: " + $pr.exitcode)
        Log ("Output: " + $pr.output)
        Log ("ErrOutput: " + $pr.error)
    }
    #Clear-Host
    return $pr
}

$res = StartProcess -path ping -arguments "8.8.8.8" 

log($res)
log("pid = " + $res.pid)