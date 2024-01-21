function Invoke-OfficeRemovalTool {
    param (
        [switch]$UseSetupRemoval
    )

    if (-not (Test-Path -Path $OfficeUtilPath -PathType Container)) {
        New-Item -Path $OfficeUtilPath -ItemType Directory | Out-Null
    }

    if ($UseSetupRemoval.IsPresent) {
        $Command = "powershell -ExecutionPolicy Bypass -File $OfficeRemovalToolPath -SuppressReboot -UseSetupRemoval"
    }
    else {
        $Command = "powershell -ExecutionPolicy Bypass -File $OfficeRemovalToolPath -SuppressReboot"
    }

    Invoke-WebRequest -Uri $OfficeRemovalToolUrl -OutFile $OfficeRemovalToolPath
    Invoke-Expression $Command
}

function Invoke-OfficeScrubber {
    try {
        Extract-OfficeScrubber
    }
    catch {
        Write-Host "Error occurred: $_" -ForegroundColor Red
    }
    finally {
        Write-Host "Select [R] Remove all Licenses option in OfficeScrubber." -ForegroundColor Yellow
    }

    Start-Process -Verb runas -FilePath "cmd.exe" -ArgumentList "/C $ScrubberCmdPath"
}

function Invoke-MAS {
    # Start-Process -Verb runas -FilePath powershell.exe -ArgumentList "Invoke-WebRequest -useb https://massgrave.dev/get | Invoke-Expression" -Wait
    Invoke-RestMethod https://massgrave.dev/get | Invoke-Expression
  }
  