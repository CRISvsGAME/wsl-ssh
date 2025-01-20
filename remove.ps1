try {
    $ConfigFile = Join-Path -Path "$PSScriptRoot" -ChildPath "config.ps1"

    if (-Not (Test-Path -Path "$ConfigFile" -PathType Leaf)) {
        Write-Host "Config File Not Found in '$ConfigFile'"
        exit 1
    }

    . "$ConfigFile"

    if (-Not $Env:Name `
            -Or -Not $Env:ListenAddress `
            -Or -Not $Env:ListenPort) {
        Write-Host "Required Variables Not Set in '$ConfigFile'"
        exit 1
    }

    $NetFirewallRule = Get-NetFirewallRule -Name $Env:Name -ErrorAction SilentlyContinue

    if ($NetFirewallRule) {
        Remove-NetFirewallRule -Name $Env:Name
        Write-Host "Firewall Rule '$Env:Name' Removed Successfully"
    }
    else {
        Write-Host "Firewall Rule '$Env:Name' Not Found"
    }

    netsh interface portproxy delete v4tov4 listenaddress=$Env:ListenAddress listenport=$Env:ListenPort

    Write-Host "Portproxy Rule '${Env:ListenAddress}:${Env:ListenPort}' Removed Successfully"
}
catch {
    Write-Host "Remove Error: $($PsItem.Exception.Message)"
    exit 1
}
