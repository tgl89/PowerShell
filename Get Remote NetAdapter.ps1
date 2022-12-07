#retrieve network adapter properties for remote computers
function Get-RemoteNetAdapter {
    param (
        [Parameter(Mandatory=$true)]$computername 
    )
    Invoke-command -ComputerName $computername -ScriptBlock {Get-NetAdapter}
}
#end function
#example use: Get-RemoteNetAdapter LON-DC1
