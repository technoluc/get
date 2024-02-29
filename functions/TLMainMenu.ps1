function Show-TLMainMenu {
    Invoke-Logo
    Write-Host "Main Menu" -ForegroundColor Green
    Write-Host ""
    Write-Host "1. Winutil: Install and Tweak Utility" -ForegroundColor DarkGreen
    Write-Host "2. BinUtil: Recycle Bin Themes" -ForegroundColor Magenta
    Write-Host "3. BinUtil GUI: Recycle Bin Themes" -ForegroundColor Magenta
    Write-Host "4. OfficeUtil: Install/Remove/Activate Office & Windows" -ForegroundColor Cyan
    Write-Host "5. AdvancedSystemTroubleshoot: Run CHKDSK/SFC/DISM commands" -ForegroundColor Red
    Write-Host "Q. Exit" -ForegroundColor Red
    Write-Host ""
    # $choice = Read-Host "Select an option (0-4)"
    Write-Host -NoNewline "Select option: "
    $choice = [System.Console]::ReadKey().KeyChar
    Write-Host ""
    Process-TLMainMenu-Choice $choice
}

function Process-TLMainMenu-Choice {
    param (
        [string]$choice
    )

    switch ($choice) {
        'q' {
            Write-Host "Exiting..."
        }
        '0' {
            Write-Host "Exiting..."
        }
        '1' {
            Start-Process -Verb runas -FilePath powershell.exe -ArgumentList "Invoke-RestMethod `"$WinUtilUrl`" | Invoke-Expression" -Wait
            Show-TLMainMenu
        }
        '2' {
            # Check if script was run as Administrator, relaunch if so
            if (!([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)) {
                Clear-Host
                Start-Process -FilePath powershell.exe -ArgumentList "Invoke-RestMethod `"$BinUtilUrl`" | Invoke-Expression" -Wait -NoNewWindow
                Show-TLMainMenu
            }
            else {
                Write-Host "BinUtil can't  run as Administrator..."
                Write-Host "Re-running this script in a non-admin PowerShell window..."
                Read-Host "Press Enter to continue..."
                runas /trustlevel:0x20000 "powershell -Command Invoke-Expression (Invoke-RestMethod -Uri $BinUtilUrl)"
                # break
            }

        }
        '3' {
            # Check if script was run as Administrator, relaunch if so
            if (!([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)) {
                Clear-Host
                Start-Process -FilePath powershell.exe -ArgumentList "Invoke-RestMethod `"$BinUtilGUIUrl`" | Invoke-Expression" -NoNewWindow
                Show-TLMainMenu
            }
            else {
                Write-Host "BinUtil GUI can't run as Administrator..."
                Write-Host "Re-running this script in a non-admin PowerShell window..."
                Read-Host "Press Enter to continue..."
                runas /trustlevel:0x20000 "powershell -Command Invoke-Expression (Invoke-RestMethod -Uri '$BinUtilGUIUrl')"
                # break
            }

        }
        '4' {
            # Check if script was run as Administrator, relaunch if not
            if (!([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)) {
                Write-Output "OfficeUtil needs to be run as Administrator. Attempting to relaunch."
                Start-Process -Verb runas -FilePath powershell.exe -ArgumentList "Invoke-RestMethod `"$ScriptUrl`" | Invoke-Expression" 
                break
            }
            Show-OfficeMainMenu
        }
        '5' {
            # Check if script was run as Administrator, relaunch if not
            if (!([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)) {
                Write-Output "AdvancedSystemTroubleshoot.ps1 needs to be run as Administrator. Attempting to relaunch."
                Start-Process -Verb runas -FilePath powershell.exe -ArgumentList "Invoke-RestMethod `"$ScriptUrl`" | Invoke-Expression" 
                break
            }
            Start-Process -FilePath powershell.exe -ArgumentList "Invoke-RestMethod `"https://raw.githubusercontent.com/technoluc/scripts/main/win/AdvancedSystemTroubleshoot.ps1`" | Invoke-Expression" -NoNewWindow
        }
        default {
            # Read-Host "Press Enter to continue..."
            # Write-Host "Invalid option. Please try again."
            Write-Host -NoNewLine "Invalid option. Press any key to try again... "
            $x = [System.Console]::ReadKey().KeyChar
            Show-TLMainMenu
        }
    }
}
