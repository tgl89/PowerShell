#delete contents of folder older than 60 days
#test folder
$Folder = "$home\Downloads"

#Delete files older than 15 days
Get-ChildItem $Folder -Recurse -Force -ea 0 |
Where-Object {!$_.PsIsContainer -and $_.LastWriteTime -lt (Get-Date).AddDays(-15)} |
ForEach-Object {
   $_ | Remove-Item -Force
   $_.FullName | Out-File C:\logs\deletedlog.txt -Append
}