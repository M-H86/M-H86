#Variable Declaraion
$date = Get-Date -Format dd/mm/yy_hh:mm:ss
$ScraperExecutable = "PATH TO *\wkhtmltopdf\bin\wkhtmltoimage.exe"
$folderPath = ".\sherlockoutput"
$sherlockEXE = "PATH TO *\AppData\Local\Programs\Python\Python310\Scripts\Sherlock.exe"
$namesfile = ".\input-namesList.txt"
$errorlog = ".\errorlog.txt"
$number = 0

#SCRIPT START


try{
 $names = Get-Content $namesfile
 foreach ($name in $names) 
 {
 $sherlockArgs = "--fo $folderPath --print-found --local $name"
  Start-Process $sherlockEXE -ArgumentList $sherlockArgs -NoNewWindow -Wait
 }
 }
catch{
    write-host $date $_ | Out-file -Append $errorlog
        }
 
try
{
$textFiles = Get-ChildItem -Path $folderPath -Filter *.txt
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
    $number = $number + 1
    $arg = $line
    $outputfilename = "$line.jpg"
    $arguments = "$arg $folderPath\$fileName\$fileName$number.jpg"
    try{
    Start-Process $ScraperExecutable -ArgumentList $arguments -NoNewWindow -Wait
    }
    catch{
    write-host $date $_ | Out-file -Append $errorlog
        }
        }
        }
}
catch{
    write-host $date $_ | Out-file -Append $errorlog
        }
