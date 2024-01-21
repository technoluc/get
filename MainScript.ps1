# MainScript.ps1

$functionsFolderPath = ".\functions"  # Replace with the actual path to your folder

# Get all .ps1 files in the folder
$functionFiles = Get-ChildItem -Path $functionsFolderPath -Filter *.ps1

# Import each function from the files
foreach ($file in $functionFiles) {
    . $file.FullName
}

while ($true) {
  Show-TLMainMenu
  $userChoice = [System.Console]::ReadKey().KeyChar

  # Validate input: Accept any alphanumeric character
  if ($userChoice -match '^[a-zA-Z\d]$') {
      Perform-Action -choice $userChoice
  } else {
      Write-Host "Invalid input. Please enter a valid alphanumeric character."
  }
}
