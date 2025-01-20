# WSL SSH

## Config

### config.ps1

```powershell
# Firewall Rule Variables
$Env:Name = "Allow_Inbound_SSH"
$Env:DisplayName = "Allow Inbound SSH"
$Env:Action = "Allow"
$Env:Direction = "Inbound"
$Env:Enabled = "True"
$Env:LocalPort = "22"
$Env:Protocol = "TCP"

# Portproxy Rule Variables
$Env:ListenAddress = "0.0.0.0"
$Env:ListenPort = $Env:LocalPort
$Env:ConnectAddress = (wsl hostname -I).Split(" ")[0].Trim()
$Env:ConnectPort = "22"
```

## Create

### PowerShell

```powershell
powershell -ExecutionPolicy Bypass -File "create.ps1"
```

## Remove

### PowerShell

```powershell
powershell -ExecutionPolicy Bypass -File "remove.ps1"
```
