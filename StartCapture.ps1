param($PropertyFile)

function ReadProperties($file)
{
    $content = Get-Content -Path $file
    $properties = @{}
    foreach($line in $content)
    {
        if($line.Contains("="))
        {
            $key = $line.Substring(0, $line.IndexOf("="))
            $property = $line.Substring($line.IndexOf("=") + 1)
            $properties.Add($key, $property)
        }
    }
    return $properties
}

function GetWireSharkCommand($wiresharkLocation)
{
    $wireSharkCommmand = ".\dumpcap.exe"
    return $wireSharkCommmand
}

function GetLogFileName()
{
    $fileName = Get-Date -Format ("MMdd-HHmmss")
    return "$($fileName)log.pcapng"
}

function SetCaptureFilter($command, $filter)
{
    if($filter)
    {
        $filter = "-f `"$filter`""
    }
    return "$command $filter"
}

function SetCaptureLocation($command, $logLocation)
{
    $logName = GetLogFileName
    $newCommand = "$command -w $logLocation\$logName"
    return $newCommand
}

$properties = ReadProperties $PropertyFile

$wireSharkCommand = GetWireSharkCommand $properties["wiresharkLocation"]
$wireSharkCommand = SetCaptureLocation $wireSharkCommand $properties["logLocation"]
$wireSharkCommand = SetCaptureFilter $wireSharkCommand $properties["filter"]
Write-Host "Command: $wireSharkCommand" -ForegroundColor Green

Set-Location $properties["wiresharkLocation"]
Invoke-Expression -Command $wireSharkCommand
