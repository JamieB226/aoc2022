class CycleResults
{
    [int]$CycleNumber
    [int]$RegisterValue
    [int]$FinalValue
    [string]$Command
}

function Process-Cycle
{
    [CmdletBinding()]
    param (
        [Parameter()]
        [string]
        $Command,
        [Parameter()]
        [int]
        $CurrentCycle,
        [Parameter()]
        [int]
        $RegisterValue
    )

    $Results=[System.Collections.ArrayList]::new()

    switch -Regex ($Command)
    {
        "addx ([-]*[0-9]+)" {
            $Results.Add((New-Object -TypeName CycleResults -Property @{CycleNumber=$CurrentCycle;RegisterValue=$RegisterValue;FinalValue=$RegisterValue;Command=$command})) | Out-Null
            $Results.Add((New-Object -TypeName CycleResults -Property @{CycleNumber=($CurrentCycle+1);RegisterValue=$RegisterValue;FinalValue=$RegisterValue+$matches[1];Command=$command})) | Out-Null
        }
        "noop" {
            $Results.Add((New-Object -TypeName CycleResults -Property @{CycleNumber=$CurrentCycle;RegisterValue=$RegisterValue;FinalValue=$RegisterValue;Command=$command})) | Out-Null
        }
    }

    $Results
}

function Get-SignalStrength
{
    [CmdletBinding()]
    param (
        [Parameter()]
        [string]
        $GameInput
    )

    $lines=$GameInput -split "`r`n"

    $CurrentCycle=1
    $RegisterValue=1

    $SignalStrength=0
    $InstructionCounter=0

    foreach($line in $lines)
    {
        $InstructionCounter++
        $CycleResults=Process-Cycle -Command $line -CurrentCycle $CurrentCycle -RegisterValue $RegisterValue
        foreach ($CycleResult in $CycleResults)
        {
            if($CycleResult.CycleNumber -in @(20,60,100,140,180,220))
            {
                $SignalStrength+=$CycleResult.CycleNumber * $CycleResult.RegisterValue
            }
            $CurrentCycle=$CycleResults[$CycleResults.count-1].CycleNumber+1
            $RegisterValue=$CycleResults[$CycleResults.count-1].FinalValue
        }
    }

    $SignalStrength
}

Get-SignalStrength -GameInput @"
noop
noop
addx 5
addx 29
addx -28
addx 5
addx -1
noop
noop
addx 5
addx 12
addx -6
noop
addx 4
addx -1
addx 1
addx 5
addx -31
addx 32
addx 4
addx 1
noop
addx -38
addx 5
addx 2
addx 3
addx -2
addx 2
noop
addx 3
addx 2
addx 5
addx 2
addx 3
noop
addx 2
addx 3
noop
addx 2
addx -32
addx 33
addx -20
addx 27
addx -39
addx 1
noop
addx 5
addx 3
noop
addx 2
addx 5
noop
noop
addx -2
addx 5
addx 2
addx -16
addx 21
addx -1
addx 1
noop
addx 3
addx 5
addx -22
addx 26
addx -39
noop
addx 5
addx -2
addx 2
addx 5
addx 2
addx 23
noop
addx -18
addx 1
noop
noop
addx 2
noop
noop
addx 7
addx 3
noop
addx 2
addx -27
addx 28
addx 5
addx -11
addx -27
noop
noop
addx 3
addx 2
addx 5
addx 2
addx 27
addx -26
addx 2
addx 5
addx 2
addx 4
addx -3
addx 2
addx 5
addx 2
addx 3
addx -2
addx 2
noop
addx -33
noop
noop
noop
noop
addx 31
addx -26
addx 6
noop
noop
addx -1
noop
addx 3
addx 5
addx 3
noop
addx -1
addx 5
addx 1
addx -12
addx 17
addx -1
addx 5
noop
noop
addx 1
noop
noop
"@