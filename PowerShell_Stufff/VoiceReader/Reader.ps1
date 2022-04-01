Add-Type -AssemblyName System.speech
$voice = New-Object System.Speech.Synthesis.SpeechSynthesizer

$date = Get-Date -format yyMMdd


$story=(Get-Content "$PSScriptRoot\story.txt")
$intro = (Get-Content "$PSScriptRoot\intro.txt")
$endoff = (Get-Content "$PSScriptRoot\endoff.txt")
$filename = ("$PSScriptRoot\" +"$date") + ".wav"

function ConvertTo-WaveFile {

  Add-Type -AssemblyName System.Speech 
  $voice=New-Object -TypeName System.Speech.Synthesis.SpeechSynthesizer 
  $voice.SelectVoice('Microsoft Zira Desktop')
  $voice.Rate = 0
  $voice.SetOutputToWaveFile($filename)
  echo ("Writing file " + $filename)
  $voice.Speak($intro)
  $voice.Speak($story)
  $voice.Speak($endoff)
  
  echo ("Writing file Done")
  pause
}


ConvertTo-WaveFile
