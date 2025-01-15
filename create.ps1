try {
    $ConfigFile = Join-Path -Path "$PSScriptRoot" -ChildPath "config.ps1"

    if (-Not (Test-Path -Path "$ConfigFile" -PathType Leaf)) {
        Write-Host "Config File Not Found in '$ConfigFile'"
        exit 1
    }

    . "$ConfigFile"

    if (-Not $Env:Name `
            -Or -Not $Env:DisplayName `
            -Or -Not $Env:Action `
            -Or -Not $Env:Direction `
            -Or -Not $Env:Enabled `
            -Or -Not $Env:LocalPort `
            -Or -Not $Env:Protocol) {
        Write-Host "Firewall Rule Variables Not Set in '$ConfigFile'"
        exit 1
    }
}
catch {
    Write-Host "Create Error: $($PsItem.Exception.Message)"
    exit 1
}
