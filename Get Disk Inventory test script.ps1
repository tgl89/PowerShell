#get disk space on a remote computer
function Get-StorageSpace {
    [CmdletBinding()]
     param (
        [Parameter(Mandatory=$true, ValueFromPipeline = $true, ValueFromPipelineByPropertyName)]
        [string[]]$computername 
        )
Write-Host "Analyzing Disk Space"
Get-WmiObject -Class Win32_logicalDisk -ComputerName $computername -Filter "drivetype=3" | 
Sort-Object -Property DeviceID | 
Format-Table -Property DeviceID,
@{label='UsedSpace(MB)';expression={$_.Size / 1MB - $_.FreeSpace / 1MB -as [int]}},
@{label='FreeSpace(MB)';expression={$_.FreeSpace / 1MB -as [int]}},
@{label='Size(GB)';expression={$_.Size / 1GB -as [int]}},
@{label='%Free';expression={$_.FreeSpace / $_.Size * 100 -as [int]}}
}
