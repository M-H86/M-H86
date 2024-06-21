##V1.0
##AUTHOR: MH86
##LICENSE - NONE :) -  FREE TO USE / DISTRIBUTE / MODIFY / DISSEMINATE - ALWAYS


# YaraScan.ps1
$rulesFolder = ".\Rules\"	# Drop all you .yar rule files in this folder
$yaraExec = ".\yara64.exe"	# Put your yara64.exe file Here - Obtainable from : https://github.com/VirusTotal/yara/releases/
$outputFolder = ".\Output"  	# Assuming you want output files in a specific folder

# Create the output folder if it doesn't exist
if (-not (Test-Path $outputFolder)) {
    New-Item -ItemType Directory -Path $outputFolder | Out-Null
}

$ProgressPreference = "SilentlyContinue"

function ScanProcesses {
    Clear-Host
    Write-Host "Scanning Processes"
    $host.UI.RawUI.ForegroundColor = "Red"
    $host.UI.RawUI.BackgroundColor = "Black"

    # Loop through each YARA rule file in the Rules folder
    Get-ChildItem -Path $rulesFolder -Filter "*.yar" | ForEach-Object {
        $ruleFile = $_.FullName
        $outputFileName = Join-Path -Path $outputFolder -ChildPath "$($_.BaseName)_$(get-date -f yyyyMMddhhmmss).txt"

        # Start scanning processes for the current rule file
        Write-Host "Processing rule file: $ruleFile"

        Get-Process | ForEach-Object {
            if ($result = & $yaraExec $ruleFile $_.ID -D -p 10) {
                Write-Output "The following rule matched the following process:" $result
                Get-Process -Id $_.ID | Format-Table -Property Id, ProcessName, Path
            }
        } 2>&1 | Tee-Object -FilePath $outputFileName
    }

    $host.UI.RawUI.ForegroundColor = "White"
    $host.UI.RawUI.BackgroundColor = "DarkMagenta"

    # Display summary message
    $matchedFiles = @(Get-ChildItem -Path $outputFolder -Filter "*.txt" | Where-Object { $_.Length -gt 0 })
    if ($matchedFiles.Count -eq 0) {
        Write-Output "No Processes were found matching any YARA rule in $rulesFolder"
    } else {
        Write-Host "Processes that matched YARA rules are saved in the following files:"
        $matchedFiles | ForEach-Object { Write-Host $_.FullName }
    }
}

try {
    ScanProcesses
} catch {
    Write-Host "Error occurred: $_"
}
