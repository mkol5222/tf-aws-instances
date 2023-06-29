function Get-Base64Decoded {
    param (
        [Parameter(Mandatory)]
        [string]$Base64Encoded
    )
    $bytes = [System.Convert]::FromBase64String($Base64Encoded)
    $decoded = [System.Text.Encoding]::UTF8.GetString($bytes)
    return $decoded
}

$res = Invoke-LMFunction CHKP_Test_Lambda_Function -LogType Tail -Payload ( @{key1 = "aaa"}|ConvertTo-Json)
$res 
Get-Base64Decoded $res.LogResult

$StreamReader = [System.IO.StreamReader]::new($res.Payload)
$resp = $StreamReader.ReadToEnd() | ConvertFrom-Json
$resp.sgs.objects