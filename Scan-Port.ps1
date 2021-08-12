#requires -Version 5.0

function Scan-Port {
    Param(
        [Parameter(Mandatory=$true,Position=0)]
        [Alias("IP")]
        [string]$IPAddress,

        [Alias("p")]
        $Ports = (1..1000)
    )
    BEGIN{
        $multipleports = $false
        if ($Ports.length -gt 1) {$multipleports = $true}
    }

    PROCESS{
        if($multipleports){
            Foreach ($port in $Ports){
                Test-NetConnection -ComputerName $IPAddress -Port $port
            }
        } else{
            Test-NetConnection -ComputerName $IPAddress -Port $Ports
        }
    }

    END{

    }
}