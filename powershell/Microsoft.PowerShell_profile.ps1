# Powershell 7.X Profile File

# Move to where your PS profile needs to be

# Required: 
# PSReadLine https://github.com/PowerShell/PSReadLine
# Winget-Command-Not-Found https://github.com/microsoft/winget-command-not-found


# Aliases:
Set-Alias -Name pwd -Value Better-pwd


# Functions:

# ls with hidden files
function ll {
	ls -Force
}

function Better-pwd{
	(Get-Location).Path
}

# Custom prompt
function prompt {
	$lastCommandStatus = $?
	$user = [System.Security.Principal.WindowsIdentity]::GetCurrent().Name.split('\')[1]
	$hostName = [System.Net.Dns]::GetHostName()

	Write-Host "╭─" -NoNewline
	Write-Host "$user" -ForegroundColor Green -NoNewline
	Write-Host "@" -NoNewline
	Write-Host "$hostName " -ForegroundColor Cyan -NoNewline
	Write-Host "on " -ForegroundColor White -NoNewline
	Write-Host "$(Better-pwd) " -ForegroundColor Yellow -NoNewline
	
	# Display branch if current or parent directory is a git repo
	if (Find-GitRoot) {
		Write-Host "on " -ForegroundColor White -NoNewline
		Write-Host "$((git branch --show-current --quiet | Out-String).Trim())" -ForegroundColor DarkYellow -NoNewline
		
		# Check for dirty or clean git repo
		Write-Host "(" -ForegroundColor White -NoNewline
		if (git status -z | Out-String) {
			Write-Host "XXX" -ForegroundColor Red -NoNewline
		} else {
			Write-Host "✓" -ForegroundColor Green -NoNewline
		}
		Write-Host ")" -ForegroundColor White -NoNewline
	}
	
	Write-Host "" # New line
	Write-Host "╰──" -ForegroundColor White -NoNewline
	
	if ($lastCommandStatus) {
		Write-Host "➤ " -ForegroundColor Green -NoNewline
	} else {
		Write-Host "➤ " -ForegroundColor Red -NoNewline
	}

	return " " # One space in String to prevent 'PS >'
}

# Helper
function Find-GitRoot {
    param(
        [string]$StartPath = (Get-Location)
    )

    $currentPath = (Resolve-Path $StartPath).ProviderPath

    while ($true) {
        if (Test-Path -Path (Join-Path -Path $currentPath -ChildPath ".git")) {
            return $currentPath
        }

        $parentPath = (Get-Item $currentPath).Parent

        if (-not $parentPath) {
            # We've reached the root and did not find a .git folder.
            return $null
        }

        $currentPath = $parentPath.FullName
    }
}
