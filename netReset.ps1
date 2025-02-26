$ethernetInterface = "以太网"

$threshold = 10

while ($true) {
    
    $adapter = Get-NetAdapter -Name $ethernetInterface
    if ($adapter.Status -eq 'Up') {
        $linkSpeed = $adapter.LinkSpeed

        
        if ($linkSpeed -match "(\d+)\s*(\w+)") {
            $speedValue = [int]$matches[1]
            $speedUnit = $matches[2]

            
            if ($speedUnit -eq "Mbps") {
                $currentSpeedMB = $speedValue / 8
            } elseif ($speedUnit -eq "Gbps") {
                $currentSpeedMB = $speedValue * 125
            } else {
                $currentSpeedMB = 0
            }

            
            Write-Host "Current Speed: $currentSpeedMB MB/s"

            
            if ($currentSpeedMB -lt $threshold) {
                Write-Host "Speed lt $threshold MB/s, rebooting..."

                
                $timestamp = Get-Date -Format "yyyy-MM-dd HH:mm:ss"

                
                Disable-NetAdapter -Name $ethernetInterface -Confirm:$false
                Start-Sleep -Seconds 5

                
                Enable-NetAdapter -Name $ethernetInterface -Confirm:$false
                Write-Host "Ethernet Rebooted"

                
                $logMessage = "$timestamp Ethernet Rebooted"
                Add-Content -Path D:\VSCwork\NetReset\log.txt -Value $logMessage
            }
        } else {
            Write-Host "Cannot Get Net Info"
        }
    } else {
        Write-Host "$ethernetInterface disconnected"
    }

    
    Start-Sleep -Seconds 30
}
