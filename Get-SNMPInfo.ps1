<#
.SYNOPSIS
    Performs an SNMP query of a device.
.DESCRIPTION
    Creates a new COMObject of type olePrn.OleSNMP. Opens a connection to the given device and
    queries predefined SNMP OIDs.
.PARAMETER Device
    The IP Address of the device in which you are wanting to retrieve SNMP information.
.PARAMETER CommunityString
    The passphrase the device is expecting to receive to grant access to SNMP information.
.EXAMPLE
    Get-SNMPInfo -Device 192.168.1.8 -CommunityString public
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