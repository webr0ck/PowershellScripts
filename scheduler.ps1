$dt= ([DateTime]::Now)
$timespan = $dt.AddYears(1) -$dt;
$Action = New-ScheduledTaskAction -Execute 'powershell.exe' -Argument '-exec bypass c:\temp\_your_scrip.ps1'
$Trigger = New-ScheduledTaskTrigger -Once -At 01am -RandomDelay (New-TimeSpan -Minutes 1) -RepetitionDuration $timespan -RepetitionInterval (New-TimeSpan -Minutes 1)
$Task = New-ScheduledTask -Action $Action -Trigger $Trigger -Settings (New-ScheduledTaskSettingsSet)
$Task | Register-ScheduledTask -TaskName 'RedTeamSched'
