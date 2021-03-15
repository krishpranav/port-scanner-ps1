[CmdletBinding()]
param(
    [Parameter(
        Position=0,
        Mandatory=$true,
        HelpMessage='ComputerName or IPv4-Address of the device which you want to scan')]
    [String]$ComputerName,

    [Parameter(
        Position=1,
        HelpMessage='First port which should be scanned (Default=1)')]
    [ValidateRange(1,65535)]
    [Int32]$StartPort=1,

    [Parameter(
        Position=2,
        HelpMessage='Last port which should be scanned (Default=65535)')]
    [ValidateRange(1,65535)]
    [ValidateScript({
        if($_ -lt $StartPort)
        {
            throw "Invalid Port-Range!"
        }
        else 
        {
            return $true
        }
    })]
    [Int32]$EndPort=65535,

    [Parameter(
        Position=3,
        HelpMessage='Maximum number of threads at the same time (Default=500)')]
    [Int32]$Threads=500,

    [Parameter(
        Position=4,
        HelpMessage='Execute script without user interaction')]
    [switch]$Force
)

Begin{
    Write-Verbose -Message "Script started at $(Get-Date)"

    $PortList_Path = "$PSScriptRoot\Resources\ports.txt"
}

Process{
    if(Test-Path -Path $PortList_Path -PathType Leaf)
    {
        $PortsHashTable = @{ }

        Write-Verbose -Message "Read ports.txt and file has table..."

        foreach($Line in Get-Content -Path $PortList_Path)
        {
            if (-not([String]::IsNullOrEmpty($Line)))
            {
                try{
                    $HashTableData = $Line.Split('|')

                    if($HashTableDate[1] -eq "tcp")
                    {
                        $PortsHashTable.Add([int]$HashTableData[0], [String]::Format("{0}|{1}", $HashTableData[3]))
                    }
                }
                catch [System.ArgumentException] { } #Catch if port is already
            }
        }
    }
}