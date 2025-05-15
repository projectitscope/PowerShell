param ($param1)
#Get WMI Process objects
$WMIProcs = Get-WmiObject Win32_Process -Filter "Name='Chrome.exe'" | Select-Object -Property CommandLine,ProcessId,ProcessName,Handle,WS | Where-Object {$_.CommandLine -like "*\$param1*"} 
#Get Get-Process object
$GPProcs = Get-Process
#Convert Get-Process objects to a hashtable for easy lookup
$GPHT = @{}
$GPProcs | ForEach-Object {$GPHT.Add($_.ID.ToString(),$_)}
#Add PrivateWorkingSet and UserID to WMI objects
$WMIProcs|ForEach-Object{ 
    $_ | Add-Member "Mem Usage(MB)" $([math]::round($GPHT[$_.ProcessId.ToString()].PrivateMemorySize64/1mb,2))
    #$_ | Add-Member "UserID" $($_.getowner().Domain+"\"+$_.getowner().user)
}
#Output to screen
if ($WMIProcs -eq $null)
{
    "0"
}
else
{
    $WMIProcs | Format-Table ProcessId, ProcessName, "Mem Usage(MB)" #, CommandLine -AutoSize
}
