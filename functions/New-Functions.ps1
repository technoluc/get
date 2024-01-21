function Ensure-Directory {
    param (
        [string]$path
    )

    if (-not (Test-Path -Path $path -PathType Container)) {
        New-Item -Path $path -ItemType Directory -Force | Out-Null
    }
}

function Install-Software {
    param (
        [string]$url,
        [string]$installArgs
    )

    Ensure-Directory $OfficeUtilPath

    if (-not (Test-Path -Path $OfficeUtilPath)) {
        Download-File -url $url -outputPath $OfficeUtilPath
    }
    
    Start-Process -Wait $OfficeUtilPath -ArgumentList $installArgs
}
