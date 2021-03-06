#requires -Version 5.0

<#
.SYNOPSIS
    Scans port(s) on given IP Address
.DESCRIPTION
    Queries a provided list file for directories against a provided URL. Returns the
    HTTP Status code of each result. The list file does not have to have extensions
    such as .asp or .html as the script will enumerate them.
.PARAMETER URL
    The URL for the target. Provide the full http://www.* or https://www.* for best results.
.PARAMETER PathList
    The list of directories to tack onto the end of the URL.
.PARAMETER ShowNonHits
    A switch parameter that; by default, filters our directory queries that did not provide
    infomation. Provide this parameter to show the attempts that did not return an HTTP Status
    Code.
.PARAMETER AllowAutoRedirect
    A switch parameter that; by default, restricts the HTTP Request from redirecting. Provide
    this paramter to show the redirects and their URLS.
.EXAMPLE
    ScanDir -URL 'http://www.google.com/' -List '.\dirpath.list'
.EXAMPLE
    ScanDir -URL 'http://www.google.com/' -List '.\dirpath.list' -AllowsAutoRedirect
.EXAMPLE
    ScanDir -URL 'http://www.google.com/' -List '.\dirpath.list' -ShowNonHits
.OUTPUTS
    PSCUSTOMOBJECT
.NOTES
    Author: ergo
#>
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