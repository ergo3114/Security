function Get-WifiProfiles {
    $profiles = netsh wlan show profiles
    $userProfiles = $profiles | Select-String -Pattern 'All User Profile' -Raw
    $results = New-Object System.Collections.ArrayList
    foreach($userProfile in $userProfiles){
        $obj = [PSCustomObject]@{
            Wifi = $userProfile.Split(':')[1].Trim()
        }
        $null = $results.Add($obj)
    }
    $results
}

function Get-SavedWifi{
    Param(
        [Parameter(Mandatory=$true)]
        [string]
        $Wifi
    )
    $wifiInfo = netsh wlan show profile name="$Wifi" key=clear
    $pas = ($wifiInfo | Select-String -Pattern 'Key Content' -Raw).Split(':')[1].Trim()
    $pas
}
#netsh wlan show profile name="NETWORK" key=clear