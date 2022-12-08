#Moving files from one location to another

function Copy-MyFiles {
 #The source of the files to be moved and their destination
[CmdletBinding()]
param(
    [string]$source="c:\source",[string]$destination="c:\destination"
    )

begin { 
#Creating function to check if required folders exist
function Check-Folder([string]$path, [switch]$create){
        $exists = Test-Path $path
        if (!$exists -and $create) {
        #Creating the destination folder if it does not exist
        mkdir $path | Out-Null
        $exists = Test-Path $path
        }
        return $exists
        }

#Creating function to display folder stats to be referenced at the end
    function Display-FolderStats([string]$path) {
        $files = Get-ChildItem $path -Recurse | Where-Object {!$_.PSIsContainer} 
        $totals = $files | Measure-Object -Property Length -Sum   
        $stats = "" | Select-Object path,count,size 
        $stats.path = $path
        $stats.count = $totals.Count
        $stats.size = [math]::round($totals.Sum/1MB,2)
        return $stats
        }

#Does the source folder exist? 
    $sourceexists = Check-Folder $source
        if (!$sourceexists){
        Write-Host "Source directory not found"
        Exit 
        }
#In case creation failed earlier
    $destinationexists = Check-Folder $destination -create
        if (!$destinationexists){
        Write-Host "Destination directory not found"
        Exit 
        }
}    
#Moving the files
process{
    $files = Get-ChildItem $source -Recurse | Where-Object {!$_.PSIsContainer} 
        foreach ($file in $files){
        $ext = $file.Extension.Replace(".",".")
        $extdestdir = "$destination\$ext"
#Create folder if needed
    $extdestdirexists = Check-Folder $extdestdir -create 
        if (!$extdestdirexists) {
        Write-host "The desired destination directory can't be created"
        Exit
        }
#Copying our files
    Copy-Item $file.FullName $extdestdir 
    }
}    
#Displaying destination folder info
end{
    $dirs = Get-ChildItem $destination | Where-Object {$_.PSIsContainer}

    $allstats = @()
        foreach($dir in $dirs) {
        $allstats += Display-FolderStats $dir.FullName 
        }

    $allstats | Sort-Object size -Descending
}
}