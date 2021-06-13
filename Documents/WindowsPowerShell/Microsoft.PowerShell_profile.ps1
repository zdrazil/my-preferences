Import-Module posh-git
Import-Module PSReadLine
Import-Module ZLocation

Set-PSReadLineKeyHandler -Key Tab -Function Complete
Set-PSReadLineKeyHandler -Key UpArrow -Function HistorySearchBackward
Set-PSReadLineKeyHandler -Key DownArrow -Function HistorySearchForward

$ChocolateyProfile = "$env:ChocolateyInstall\helpers\chocolateyProfile.psm1"
if (Test-Path($ChocolateyProfile)) {
  Import-Module "$ChocolateyProfile"
}

# https://technet.microsoft.com/en-us/magazine/hh241048.aspx
$MaximumHistoryCount = 10000

function edit {
	& "$env:ProgramFiles\Notepad++\notepad++.exe" -g @args
}

function subl {
	& "$env:ProgramFiles\Sublime Text 3\subl.exe" @args
}


function touch($file) {
	"" | Out-File $file -Encoding ASCII
}

