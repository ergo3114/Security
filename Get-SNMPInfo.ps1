<#
.SYNOPSIS
    Brute forces a list of web site directories and returns the ones that are successful
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
function Get-SNMPInfo{
    Param(
        [Parameter(Mandatory=$true)]
        [Alias('Host')]
        [ipaddress]
        $Device,

        [Parameter(Mandatory=$true)]
        [string]
        $CommunityString
    )
    $SNMP = New-object -ComObject olePrn.OleSNMP
    $SNMP.open($Device,$CommunityString,2,1000)
    $sysDescr = $SNMP.get('.1.3.6.1.2.1.1.1.0')
    $contact = $SNMP.get('.1.3.6.1.2.1.1.4.0')
    $sysname = $SNMP.get('.1.3.6.1.2.1.1.5.0')
    $location = $SNMP.get('.1.3.6.1.2.1.1.6.0')
    $uptime = $SNMP.get('.1.3.6.1.2.1.25.1.1.0')
    $SNMP.Close()
    $obj = [pscustomobject]@{
        SysName = $sysname
        Description = $sysDescr
        Location = $location
        Contact = $contact
        UpTime = "$([math]::Round($($uptime/8640000),2)) days"
    }
    $result = New-Object System.Collections.ArrayList
    $null = $result.Add($obj)
    $result
}