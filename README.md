* tf-aws-instances


Test lambda function. Call using
```
 (Invoke-LMFunction CHKP_Test_Lambda_Function -LogType Tail -Payload ( @{key1 = "aaa"}|ConvertTo-Json) ).LogResult  | wsl base64 -d
 ```