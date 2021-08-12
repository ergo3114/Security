BeforeAll{
    $sut = ($PSCommandPath -split '\\')[-1].Replace('.Tests','')
    Set-Location $PSScriptRoot
    Set-Location ..
    . .\$sut
}

Describe "SNMPCheck"{
    $Script:envHost = '192.168.1.8'
    $Script:badHost = 'servername'
    $Script:communitystring = 'public'
    $Script:blankcommunitystring = ''
    
    BeforeEach{
        Mock Get-SNMPInfo {
            $result = New-Object System.Collections.ArrayList
            $obj = [pscustomobject]@{
                SysName = "raspberrypi"
                Description = "Linux raspberrypi 5.10.17-v7+ #1403 SMP Mon Feb 22 11:29:51 GMT 2021 armv7l"
                Location = "Sitting on the dock of the bay"
                Contact = "Admin <admin@email.com>"
                UpTime = "117.78 days"
            }
            $null = $result.Add($obj)
            $result
        }
    }

    It "Should not throw when parameters are privided"{
        { Get-SNMPInfo -Device $envHost -CommunityString $communitystring } | Should -Not -Throw
    }

    It "Should throw when a non IPAdress is provided"{
        { Get-SNMPInfo -Device $badHost -CommunityString $communitystring } | Should -Throw
    }

    It "Should throw when no Community String is provided"{
        { Get-SNMPInfo -Device $badHost -CommunityString $blankcommunitystring } | Should -Throw
    }
}