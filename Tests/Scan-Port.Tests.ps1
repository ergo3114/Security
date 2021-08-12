BeforeAll{
    $sut = ($PSCommandPath -split '\\')[-1].Replace('.Tests','')
    Set-Location $PSScriptRoot
    Set-Location ..
    . .\$sut
}

Describe "Scan-Port"{
    $Script:IPAddress = '192.168.1.8'
    $Script:port = '80'

    BeforeEach{
        Mock Test-NetConnection {
            $result = New-Object System.Collections.ArrayList
            $obj = [pscustomobject]@{
                ComputerName = "192.168.1.8"
                RemoteAddress = "192.168.1.8"
                RemotePort = "80"
                InterfaceAlias = "Ethernet"
                SourceAddress = "192.168.1.218"
                TcpTestSucceeded = "True"
            }
            $null = $result.Add($obj)
            $result
        }
    }

    It "Should not throw against a known IPAddress and Port" {
        { Scan-Port -IPAddress $IPAddress -Ports $port } | Should -Not -Throw
    }
}