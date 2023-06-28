
# take output of Get-EC2NetworkInterface and convert it to custom DC integration JSON feed


function inputNics() {
    
    if ($MyInvocation.ExpectingInput) {
        $myInput = $input 
        # Write-Host "Input is available"
    } else {
        # Write-Host "Input is not available"
        $myInput = gc "./data/ec2-interfaces.json"     
    }
    $nics = $myInput | ConvertFrom-Json
    return $nics
}

$nics = inputNics

$groupToIpsMap = @{}

function Clear-GroupToIpsMap {
    $groupToIpsMap = @{}
}
function Add-GroupToIpsMapItem {
    param (
        [Parameter(Mandatory)]
        [string]$Ip,
   
        [Parameter(Mandatory)]
        [string]$Group
    )
    
    $existing = $groupToIpsMap[$Group]
    if ($null -eq $existing) {
        $groupToIpsMap[$Group] = @($Ip)
    } else {
        $groupToIpsMap[$Group] += $Ip
    }
}

$nics.NetworkInterfaces | % {
    $nic = $_
    
    $nic.Groups | % { 
        $group = $_

        $nic.PrivateIpAddresses | % {
            $ip = $_.PrivateIpAddress
            # Write-Host $group.GroupId $group.GroupName $ip

            Add-GroupToIpsMapItem -Ip $ip -Group $group.GroupId
            Add-GroupToIpsMapItem -Ip $ip -Group $group.GroupName
        }
    }
}


# $groupToIpsMap




@{
    version = "1.0"
    description = "Generic Data Center file example"
    objects = @(
        $groupToIpsMap.Keys | % {
            $group = $_
            @{
                name = $group
                id = $group
                description = $group
                ranges = $groupToIpsMap[$group]
            }
        }
    )
} | ConvertTo-Json -Depth 100 

# Example output per https://support.checkpoint.com/results/sk/sk167210:
# {
#     "version": "1.0",     
#     "description": "Generic Data Center file example",
#     "objects": [
#                         {
#                              "name": "Object A name",
#                              "id": "e7f18b60-f22d-4f42-8dc2-050490ecf6d5",
#                              "description": "Example for IPv4 addresses",
#                              "ranges": [
#                                                    "91.198.174.192",
#                                                    "20.0.0.0/24",                        
#                                                    "10.1.1.2-10.1.1.10"
#                              ]              
#                         },
#                         {
#                               "name": "Object B name",
#                               "id": "a46f02e6-af56-48d2-8bfb-f9e8738f2bd0",
#                               "description": "Example for IPv6 addresses",
#                               "ranges": [
#                                                    "2001:0db8:85a3:0000:0000:8a2e:0370:7334",
#                                                    "0064:ff9b:0000:0000:0000:0000:1234:5678/96",
#                                                    "2001:0db8:85a3:0000:0000:8a2e:2020:0-2001:0db8:85a3:0000:0000:8a2e:2020:5"                                        
#                               ]
#                         }
#    ]
# }