Function Get-LocalGroup  {
  [Cmdletbinding()] 
  Param( 
  [Parameter(ValueFromPipeline=$True, ValueFromPipelineByPropertyName=$True)] 
  [String[]]$Computername,
  [parameter()]
  [string[]]$Group
  )
  Begin {
    Function  ConvertTo-SID {
    Param([byte[]]$BinarySID)
    (New-Object  System.Security.Principal.SecurityIdentifier($BinarySID,0)).Value
    }
        Function  Get-LocalGroupMember {
        Param  ($Group)
        $group.Invoke('members')  | ForEach {
            $_.GetType().InvokeMember("Name",  'GetProperty',  $null,  $_, $null)
        }
        }
    }
    Process  {
        ForEach  ($Computer in  $Computername) {
            Try  {
                    Write-Verbose  "Connecting to $($Computer)"
                    $adsi  = [ADSI]"WinNT://$Computer"
                    If  ($PSBoundParameters.ContainsKey('Group')) {
                        Write-Verbose  "Scanning for groups: $($Group -join ',')"
                        $Groups  = ForEach  ($item in  $group) {                        
                            $adsi.Children.Find($Item, 'Group')
                            }
                    } Else  {
                        Write-Verbose  "Scanning all groups"
                        $groups  = $adsi.Children | where {$_.SchemaClassName -eq  'group'}
                    }
                    If  ($groups) {
                        $groups  | ForEach {
                            [pscustomobject]@{
                                Computername = $Computer
                                Name = $_.Name[0]
                                Members = ((Get-LocalGroupMember  -Group $_))  -join ', '
                                SID = (ConvertTo-SID -BinarySID $_.ObjectSID[0])
                            }
                        }
                    } Else  {
                        Throw  "No groups found!"
                        }
                } Catch  {
                    Write-Warning  "$($Computer): $_"
                }
                }
            }
    }
Get-LocalGroup -Computername  $env:COMPUTERNAME 