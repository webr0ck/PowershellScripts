# PowershellScripts #

**Useful scripts for pwn Windows AD**

**Runas.ps1** - Easy script for start anything from cmd

``Example: powershell -exec bypass ./psrunas.ps1 -username user -password password -command cmd.exe -argument "/c whoami > test.txt"``

**startprocess.ps1** - An example of how to redirect output when launching a third-party application.

**getlocalgroups.ps1** - Get the list of groups (if you cant use net group...)

**getadmin.ps1** - Add user to group Administrators or Администраторы on localmachine

``Example: powershell -exec bypass ./getadmin.ps1 -Account username``