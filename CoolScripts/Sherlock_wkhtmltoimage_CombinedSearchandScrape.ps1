<#
REQUIREMENTS/Utilizes:

https://wkhtmltopdf.org/docs.html
https://github.com/sherlock-project/sherlock

GUIDE:

1. Create the following empty file in the same dir as the script : "logs.txt"
2. Create the following empty file in the same dir as the script : "input-namesList.txt"
3. Populate "input-namesList.txt" with names/usernames you wish to hunt for.
4. Run the script and check the "sherlockoutput" folder for output. This folder will be generated in the same location as the executed script.
5. Use responsibly...

#>

$outputFolder = ".\sherlockoutput\"
$date = Get-Date -format dd/MM/yy_HH:mm:ss
$logfile = ".\logs.txt"
$ScraperExecutable = "PATH TO *\ wkhtmltoimage.exe"
$sherlockEXE = "PATH TO  *\ Python\Python312\Scripts\Sherlock.exe"
 

 #URL Scrape Component
try {
    # Read the list of names from the file
    $names = Get-Content ".\input-namesList.txt"
    
    # Iterate over each name
    foreach ($name in $names) {
        $arg1 = $name
        $arg2 = "-fo"
        $arg3 = $outputFolder
        
        # Combine the arguments into a single string
        $arguments = "$arg1 $arg2 $arg3"
        
        # Use Start-Process to run Sherlock.exe with arguments
        Start-Process -FilePath $sherlockEXE -ArgumentList $arguments -NoNewWindow -Wait
    }   
}
catch {
    # Log any errors
    "$date : $_" | Out-File $logfile -Append
}

#Screenshot Component
try{
# Define the path to the folder containing the text files
$folderPath = ".\sherlockoutput\"

# Get all text files from the folder
$textFiles = Get-ChildItem -Path $folderPath -Filter *.txt

# Loop through each text file
foreach ($file in $textFiles) {
    # Get the file name without extension to use as the folder name
    $fileName = [System.IO.Path]::GetFileNameWithoutExtension($file.FullName)
    
    # Create a folder for the output using the file name
    $outputFolder = "$folderPath\$fileName"
    if (-not (Test-Path -Path $outputFolder)) {
        New-Item -ItemType Directory -Path $outputFolder
    }

    # Read the content of the text file
    $lines = Get-Content -Path $file.FullName
    
    # Process each line (you can customize this section as per your needs)
    foreach ($line in $lines) {
        # Example action: write each line to a separate file within the folder
        #$outputFile = "$outputFolder\Output_$(Get-Random).txt"
        #Set-Content -Path $outputFile -Value $line
        $args1 = "$line"
        $arguments2 = "$args1 $outputFolder"

  Start-Process $ScraperExecutable -ArgumentList $arguments2 -NoNewWindow -Wait
  
     }
}

Write-Host "Processing complete!"

}
catch
{
    "$date : $_" | Out-File $logfile -Append
}

