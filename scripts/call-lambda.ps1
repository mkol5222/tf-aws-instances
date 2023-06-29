function Get-Base64Decoded {
    param (
        [Parameter(Mandatory)]
        [string]$Base64Encoded
    )
    $bytes = [System.Convert]::FromBase64String($Base64Encoded)
    $decoded = [System.Text.Encoding]::UTF8.GetString($bytes)
    return $decoded
}

# https://www.techtarget.com/searchaws/tutorial/Follow-this-step-by-step-guide-to-use-AWS-Lambda-with-PowerShell

$res = Invoke-LMFunction CHKP_Test_Lambda_Function -LogType Tail -Payload ( @{key1 = "aaa"}|ConvertTo-Json)
$res 
Get-Base64Decoded $res.LogResult

# logs
Get-CWLFilteredLogEvent -LogGroupName /aws/lambda/CHKP_Test_Lambda_Function | Foreach-Object Events

#
Write-Host

$StreamReader = [System.IO.StreamReader]::new($res.Payload)
$resp = $StreamReader.ReadToEnd() | ConvertFrom-Json
$resp.sgs.objects