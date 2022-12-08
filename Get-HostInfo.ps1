
#get information from a host possibly in bulk
function Get-HostInfo 
{
    [CmdletBinding()]
     param (
        [Parameter(Mandatory=$true, ValueFromPipeline = $true, ValueFromPipelineByPropertyName)]
        [string[]]$DNSHost 
        )
    process{    
    foreach ($computer in $DNShost) {
       
    $os = Get-CimInstance -classname Win32_operatingsystem -ComputerName $computer 
    $uptime = $os.LocalDateTime - $os.LastBootUpTime

    $drivespace = Get-CimInstance -classname Win32_logicaldisk -ComputerName $computer -filter "DeviceID='C:'"
    

    $properties = [ordered]@{     
            'hostname' = [string]$computer; 
            'OS' = $os.Caption;
            'LastBootTime' = $os.LastBootUpTime;
            'UptimeHours' = $uptime;
            'CDriveFreeSpaceGB' = ($drivespace.FreeSpace / 1GB -as [int]);
            }
     $obj = New-Object -TypeName psobject -Property $properties
     Write-Output $obj
     $obj | Select-Object -property hostname, OS, LastBootUpTime,UptimeHours,CDriveFreeSpaceGB | Export-Csv -Path C:\Testing\Export-Csv -notypeinformation -append
    } 
    }
}

