#release and renew dhcp addresses

param (
    $computername = 'localhost'
)

$dhcp = Get-WmiObject -Class Win32_networkadapterconfiguration -ComputerName $computername| Where-Object {($_.IpEnabled -eq $true) -and ($_.DhcpEnabled -eq $true) } 
foreach ($lan in $dhcp) {
    Write-Host "Now renewing IP addresses"
    $lan.RenewDHCPLease() |Out-Null
    Write-Host "The New IP Address is "$lan.IPAddress" and..." -foregroundcolor Yellow
    Write-Host "...the Subnet "$lan.IPSubnet" and" -ForegroundColor Cyan
    Write-Host "...the Default Gateway is "$lan.defaultIPgateway"" -ForegroundColor DarkMagenta
}

