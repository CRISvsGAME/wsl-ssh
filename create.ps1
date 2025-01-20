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

    $NetFirewallRule = Get-NetFirewallRule -Name $Env:Name -ErrorAction SilentlyContinue

    if ($NetFirewallRule) {
        $NetFirewallPortFilter = $NetFirewallRule | Get-NetFirewallPortFilter

        if ($NetFirewallRule.DisplayName -ne $Env:DisplayName) {
            Set-NetFirewallRule -Name $Env:Name -DisplayName $Env:DisplayName
            Write-Host "Updated DisplayName to '$Env:DisplayName'"
        }

        if ($NetFirewallRule.Action -ne $Env:Action) {
            Set-NetFirewallRule -Name $Env:Name -Action $Env:Action
            Write-Host "Updated Action to '$Env:Action'"
        }

        if ($NetFirewallRule.Direction -ne $Env:Direction) {
            Set-NetFirewallRule -Name $Env:Name -Direction $Env:Direction
            Write-Host "Updated Direction to '$Env:Direction'"
        }

        if ($NetFirewallRule.Enabled -ne $Env:Enabled) {
            Set-NetFirewallRule -Name $Env:Name -Enabled $Env:Enabled
            Write-Host "Updated Enabled to '$Env:Enabled'"
        }

        if ($NetFirewallPortFilter.LocalPort -ne $Env:LocalPort) {
            Set-NetFirewallRule -Name $Env:Name -LocalPort $Env:LocalPort
            Write-Host "Updated LocalPort to '$Env:LocalPort'"
        }

        if ($NetFirewallPortFilter.Protocol -ne $Env:Protocol) {
            Set-NetFirewallRule -Name $Env:Name -Protocol $Env:Protocol
            Write-Host "Updated Protocol to '$Env:Protocol'"
        }

        Write-Host "Firewall Rule '$Env:Name' Configured Correctly"
    }
    else {
        Write-Host "Firewall Rule '$Env:Name' Not Found. Creating..."

        New-NetFirewallRule -Name "$Env:Name" -DisplayName "$Env:DisplayName" `
            -Action "$Env:Action" -Direction "$Env:Direction" -Enabled "$Env:Enabled" `
            -LocalPort "$Env:LocalPort" -Protocol "$Env:Protocol"

        Write-Host "Firewall Rule '$Env:Name' Created Successfully"
    }

    if (-Not $Env:ListenAddress `
            -Or -Not $Env:ListenPort `
            -Or -Not $Env:ConnectAddress `
            -Or -Not $Env:ConnectPort) {
        Write-Host "Portproxy Rule Variables Not Set in '$ConfigFile'"
        exit 1
    }
}
catch {
    Write-Host "Create Error: $($PsItem.Exception.Message)"
    exit 1
}
