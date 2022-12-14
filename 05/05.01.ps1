function Pop 
{
    [CmdletBinding()]
    param (
        [Parameter()]
        [System.Collections.ArrayList]
        $Stack
    )

    if($Stack.count -gt 0)
    {
        $Item=$Stack[$Stack.count - 1]
        $Stack.RemoveAt($Stack.count - 1) | Out-Null
        $Item
    }
    else 
    {
        $null
    }
}

function Get-StartState
{
    [CmdletBinding()]
    param (
        [Parameter()]
        [string]
        $StartInput
    )

    $regexTemplate="(.{3})"
    $columnCount=[Math]::Ceiling(($StartInput -split "`r`n")[0].Length / 4)
    $columns=[System.Collections.ArrayList]@()
    for($i=0;$i -lt $columnCount;$i++)
    {
        $columns.Add([System.Collections.ArrayList]@()) | Out-Null
    }
    $regex=($regexTemplate * $columnCount) -replace "\)\(", ") ("

    foreach($row in ($StartInput -split "`r`n" | select-object -SkipLast 1))
    {
        if($row -match $regex)
        {
            for ($i=0;$i -lt $columnCount;$i++)
            {
                $Item=$matches[$i+1]
                if($Item.trim() -ne "")
                {
                    $Item=$Item -replace "\[",""
                    $Item=$Item -replace "\]",""
                    $columns[$i].Add($Item) | Out-Null
                }
            }
        }
    }

    for($i=0;$i -lt $columnCount;$i++)
    {
        $columns[$i].Reverse()
        # $columns[$i]
        # Write-Output "`n"
    }

    $columns
}

function Get-TopCrate
{
    [CmdletBinding()]
    param (
        [Parameter()]
        [string]
        $GameInput
    )

    $StartState=Get-StartState -StartInput ($GameInput -split "`r`n`r`n")[0]

    $MoveInstructions=($GameInput -split "`r`n`r`n")[1]
    $regex="move ([0-9]*) from ([0-9]*) to ([0-9]*)"

    foreach ($MoveInstruction in ($MoveInstructions -split "`r`n"))
    {
        if($MoveInstruction -match $regex)
        {            
            $Count=$matches[1]
            $From=$matches[2]
            $To=$matches[3]

            #Before
            $PreSourceCount=$StartState[$From -1].count
            $PreDestCount=$StartState[$To -1].count

            for($i=0;$i -lt $Count;$i++)
            {
                If($StartState[$From -1].count -ge 1)
                {
                    $Item=Pop -Stack $StartState[$From-1]
                    $StartState[$To-1].Add($Item) | Out-Null
                }
                else
                {
                    Write-Debug "No Item to Move"
                }
            }

            #After
            #Before
            $PostSourceCount=$StartState[$From -1].count
            $PostDestCount=$StartState[$To -1].count

            If(($PreSourceCount - $PostSourceCount) -ne $Count)
            {
                Write-Debug "Move Counts don't match"
            }
            If(($PostDestCount - $PreDestCount) -ne $Count)
            {
                Write-Debug "Move Counts don't match"
            }
        }
        else 
        {
            Write-Debug "Invalid Move Instruction"
        }
    }

    #Output top of stack
    $order=""
    for($i=0;$i -lt $StartState.count;$i++)
    {
        $order+=Pop -Stack $StartState[$i]
    }

    $order
}

Get-TopCrate -GameInput @"
        [G]         [D]     [Q]    
[P]     [T]         [L] [M] [Z]    
[Z] [Z] [C]         [Z] [G] [W]    
[M] [B] [F]         [P] [C] [H] [N]
[T] [S] [R]     [H] [W] [R] [L] [W]
[R] [T] [Q] [Z] [R] [S] [Z] [F] [P]
[C] [N] [H] [R] [N] [H] [D] [J] [Q]
[N] [D] [M] [G] [Z] [F] [W] [S] [S]
 1   2   3   4   5   6   7   8   9 

move 7 from 6 to 8
move 5 from 2 to 6
move 2 from 4 to 1
move 1 from 4 to 5
move 5 from 7 to 6
move 7 from 6 to 3
move 5 from 9 to 2
move 6 from 2 to 3
move 2 from 7 to 9
move 20 from 3 to 1
move 11 from 1 to 6
move 1 from 9 to 8
move 3 from 8 to 2
move 8 from 1 to 5
move 10 from 8 to 4
move 7 from 6 to 4
move 1 from 8 to 3
move 8 from 1 to 7
move 16 from 4 to 8
move 1 from 9 to 8
move 1 from 5 to 2
move 4 from 7 to 4
move 5 from 6 to 7
move 1 from 6 to 1
move 8 from 7 to 4
move 1 from 6 to 9
move 12 from 4 to 5
move 3 from 2 to 5
move 1 from 6 to 2
move 1 from 3 to 7
move 1 from 3 to 2
move 1 from 9 to 3
move 1 from 7 to 8
move 1 from 7 to 5
move 1 from 3 to 2
move 4 from 5 to 7
move 5 from 5 to 7
move 1 from 4 to 3
move 1 from 3 to 9
move 3 from 1 to 8
move 1 from 9 to 1
move 2 from 2 to 1
move 2 from 2 to 7
move 8 from 8 to 1
move 3 from 5 to 2
move 8 from 7 to 5
move 7 from 1 to 3
move 3 from 1 to 7
move 1 from 1 to 5
move 1 from 3 to 7
move 7 from 5 to 8
move 2 from 2 to 8
move 1 from 3 to 2
move 1 from 2 to 4
move 1 from 4 to 8
move 13 from 8 to 1
move 13 from 5 to 9
move 2 from 5 to 2
move 7 from 9 to 3
move 12 from 8 to 3
move 4 from 9 to 3
move 1 from 3 to 4
move 2 from 2 to 3
move 1 from 1 to 6
move 1 from 2 to 3
move 1 from 5 to 9
move 7 from 7 to 4
move 10 from 1 to 8
move 1 from 1 to 4
move 1 from 9 to 5
move 2 from 5 to 1
move 1 from 6 to 5
move 3 from 8 to 9
move 5 from 4 to 3
move 4 from 4 to 1
move 7 from 1 to 6
move 2 from 5 to 7
move 35 from 3 to 4
move 4 from 9 to 1
move 19 from 4 to 8
move 1 from 7 to 6
move 1 from 9 to 2
move 10 from 4 to 5
move 2 from 4 to 7
move 3 from 4 to 3
move 1 from 2 to 8
move 1 from 1 to 9
move 3 from 3 to 6
move 4 from 8 to 6
move 4 from 5 to 2
move 2 from 8 to 3
move 3 from 5 to 9
move 12 from 6 to 1
move 8 from 8 to 6
move 2 from 9 to 1
move 1 from 4 to 1
move 1 from 3 to 8
move 3 from 7 to 8
move 2 from 9 to 7
move 1 from 6 to 7
move 10 from 6 to 8
move 4 from 2 to 5
move 1 from 3 to 7
move 7 from 5 to 7
move 13 from 8 to 1
move 29 from 1 to 4
move 8 from 7 to 8
move 1 from 1 to 3
move 3 from 7 to 6
move 1 from 1 to 9
move 15 from 4 to 1
move 1 from 3 to 6
move 10 from 1 to 6
move 10 from 6 to 7
move 1 from 4 to 9
move 1 from 9 to 1
move 1 from 9 to 7
move 6 from 7 to 8
move 1 from 1 to 6
move 5 from 6 to 5
move 21 from 8 to 9
move 5 from 1 to 9
move 2 from 9 to 5
move 3 from 5 to 6
move 3 from 7 to 9
move 4 from 4 to 6
move 6 from 8 to 7
move 6 from 6 to 3
move 2 from 7 to 9
move 1 from 7 to 2
move 6 from 3 to 2
move 1 from 6 to 4
move 4 from 5 to 9
move 1 from 4 to 5
move 9 from 4 to 6
move 7 from 6 to 4
move 10 from 9 to 2
move 5 from 7 to 5
move 10 from 2 to 7
move 2 from 5 to 4
move 2 from 5 to 9
move 4 from 9 to 4
move 1 from 8 to 6
move 7 from 7 to 2
move 1 from 5 to 4
move 2 from 7 to 1
move 1 from 5 to 7
move 3 from 6 to 2
move 4 from 4 to 5
move 1 from 2 to 7
move 10 from 4 to 7
move 3 from 7 to 3
move 17 from 9 to 4
move 1 from 1 to 4
move 1 from 1 to 5
move 5 from 2 to 7
move 1 from 9 to 2
move 5 from 4 to 8
move 2 from 9 to 7
move 4 from 8 to 1
move 3 from 4 to 8
move 1 from 2 to 5
move 1 from 9 to 2
move 6 from 4 to 8
move 3 from 7 to 5
move 1 from 4 to 9
move 1 from 9 to 1
move 3 from 1 to 9
move 4 from 8 to 5
move 2 from 9 to 8
move 4 from 2 to 5
move 8 from 7 to 2
move 5 from 8 to 5
move 2 from 7 to 8
move 1 from 3 to 5
move 1 from 1 to 2
move 1 from 1 to 6
move 2 from 3 to 6
move 5 from 2 to 8
move 4 from 7 to 1
move 7 from 8 to 5
move 1 from 1 to 5
move 3 from 8 to 3
move 1 from 9 to 3
move 7 from 2 to 3
move 2 from 2 to 8
move 2 from 4 to 8
move 1 from 8 to 5
move 1 from 1 to 4
move 2 from 4 to 7
move 2 from 7 to 1
move 3 from 2 to 3
move 3 from 5 to 2
move 1 from 8 to 3
move 3 from 3 to 2
move 5 from 2 to 1
move 17 from 5 to 8
move 9 from 8 to 1
move 11 from 3 to 5
move 8 from 8 to 5
move 2 from 8 to 5
move 16 from 1 to 4
move 13 from 4 to 7
move 6 from 5 to 2
move 2 from 4 to 8
move 5 from 7 to 9
move 2 from 1 to 2
move 7 from 7 to 1
move 1 from 1 to 4
move 1 from 9 to 8
move 7 from 2 to 8
move 1 from 4 to 7
move 2 from 9 to 4
move 1 from 4 to 1
move 1 from 3 to 5
move 2 from 9 to 8
move 11 from 8 to 7
move 2 from 6 to 5
move 1 from 6 to 9
move 1 from 1 to 9
move 1 from 9 to 1
move 4 from 1 to 4
move 2 from 1 to 8
move 1 from 1 to 2
move 1 from 9 to 5
move 2 from 4 to 3
move 2 from 2 to 7
move 2 from 3 to 9
move 1 from 9 to 1
move 1 from 9 to 1
move 5 from 5 to 1
move 19 from 5 to 6
move 5 from 1 to 4
move 1 from 2 to 9
move 1 from 1 to 3
move 7 from 5 to 8
move 1 from 3 to 6
move 8 from 7 to 3
move 7 from 4 to 8
move 3 from 8 to 5
move 1 from 4 to 1
move 1 from 9 to 4
move 1 from 4 to 9
move 1 from 5 to 2
move 2 from 5 to 6
move 2 from 8 to 2
move 7 from 8 to 1
move 1 from 1 to 7
move 3 from 6 to 9
move 2 from 3 to 2
move 1 from 2 to 1
move 1 from 8 to 7
move 2 from 9 to 6
move 2 from 9 to 5
move 1 from 5 to 6
move 1 from 2 to 8
move 2 from 1 to 7
move 1 from 4 to 3
move 3 from 2 to 5
move 7 from 1 to 3
move 10 from 3 to 4
move 3 from 5 to 4
move 1 from 3 to 8
move 3 from 3 to 2
move 1 from 8 to 1
move 1 from 1 to 3
move 3 from 8 to 3
move 5 from 4 to 6
move 1 from 2 to 3
move 4 from 6 to 4
move 1 from 5 to 7
move 4 from 3 to 4
move 1 from 2 to 8
move 12 from 7 to 6
move 1 from 8 to 2
move 2 from 2 to 7
move 1 from 8 to 4
move 23 from 6 to 3
move 14 from 3 to 6
move 15 from 4 to 6
move 1 from 8 to 6
move 10 from 3 to 7
move 2 from 4 to 2
move 11 from 7 to 8
move 2 from 2 to 6
move 44 from 6 to 9
move 21 from 9 to 3
move 12 from 3 to 6
move 1 from 7 to 4
move 1 from 4 to 7
move 9 from 3 to 2
move 2 from 8 to 6
move 3 from 2 to 4
move 17 from 9 to 1
move 3 from 4 to 6
move 2 from 2 to 9
move 4 from 9 to 2
move 10 from 6 to 9
move 1 from 7 to 6
move 4 from 9 to 5
move 4 from 2 to 4
move 14 from 1 to 5
move 4 from 4 to 3
move 3 from 2 to 9
move 9 from 9 to 7
move 1 from 2 to 5
move 9 from 8 to 5
move 8 from 7 to 2
move 4 from 3 to 8
move 5 from 6 to 2
move 3 from 1 to 6
move 1 from 7 to 1
move 4 from 2 to 4
move 3 from 6 to 4
move 3 from 8 to 3
move 13 from 5 to 2
move 2 from 3 to 5
move 12 from 5 to 9
move 1 from 3 to 5
move 1 from 5 to 9
move 1 from 8 to 3
move 4 from 9 to 5
move 6 from 4 to 5
move 12 from 9 to 7
move 1 from 9 to 3
move 1 from 3 to 2
move 12 from 5 to 6
move 12 from 7 to 2
move 1 from 3 to 7
move 1 from 4 to 8
move 33 from 2 to 8
move 1 from 7 to 5
move 1 from 1 to 2
move 4 from 5 to 4
move 3 from 2 to 5
move 34 from 8 to 6
move 1 from 4 to 3
move 1 from 5 to 7
move 1 from 7 to 5
move 3 from 4 to 9
move 2 from 9 to 7
move 1 from 9 to 4
move 1 from 3 to 7
move 1 from 5 to 8
move 1 from 5 to 1
move 1 from 5 to 7
move 1 from 4 to 8
move 1 from 1 to 4
move 1 from 4 to 2
move 3 from 7 to 5
move 2 from 8 to 5
move 1 from 2 to 8
move 4 from 6 to 2
move 1 from 8 to 6
move 1 from 7 to 9
move 29 from 6 to 7
move 4 from 2 to 3
move 2 from 5 to 8
move 1 from 9 to 5
move 2 from 8 to 1
move 23 from 7 to 5
move 2 from 6 to 1
move 23 from 5 to 6
move 1 from 3 to 6
move 4 from 5 to 9
move 2 from 1 to 3
move 5 from 3 to 8
move 2 from 6 to 5
move 2 from 1 to 4
move 1 from 9 to 8
move 1 from 9 to 1
move 1 from 4 to 6
move 2 from 5 to 6
move 6 from 7 to 8
move 2 from 9 to 2
move 18 from 6 to 5
move 21 from 6 to 4
move 1 from 1 to 6
move 2 from 6 to 7
move 2 from 7 to 9
move 2 from 2 to 8
move 7 from 4 to 3
move 12 from 5 to 3
move 1 from 9 to 5
move 1 from 9 to 4
move 6 from 5 to 2
move 17 from 3 to 4
move 3 from 4 to 3
move 1 from 2 to 4
move 5 from 2 to 8
move 1 from 5 to 8
move 19 from 8 to 7
move 1 from 3 to 6
move 1 from 8 to 4
move 1 from 6 to 1
move 15 from 4 to 6
move 1 from 1 to 4
move 3 from 3 to 5
move 4 from 6 to 7
move 1 from 4 to 7
move 10 from 6 to 7
move 16 from 4 to 5
move 24 from 7 to 2
move 8 from 7 to 8
move 1 from 4 to 2
move 6 from 8 to 7
move 1 from 8 to 7
move 1 from 6 to 9
move 14 from 5 to 4
move 9 from 7 to 8
move 4 from 5 to 1
move 2 from 1 to 5
move 3 from 8 to 6
move 2 from 6 to 9
move 2 from 2 to 8
move 6 from 2 to 7
move 3 from 4 to 6
move 1 from 3 to 4
move 3 from 5 to 7
move 1 from 6 to 9
move 5 from 7 to 2
move 4 from 9 to 1
move 1 from 7 to 9
move 9 from 8 to 4
move 5 from 1 to 2
move 2 from 6 to 1
move 6 from 4 to 7
move 1 from 7 to 3
move 1 from 3 to 9
move 1 from 9 to 7
move 1 from 6 to 7
move 9 from 4 to 5
move 7 from 7 to 9
move 3 from 7 to 5
move 1 from 9 to 2
move 6 from 9 to 8
move 4 from 4 to 5
move 1 from 4 to 2
move 1 from 4 to 2
move 2 from 1 to 2
move 1 from 9 to 8
move 10 from 2 to 4
move 8 from 2 to 7
move 12 from 2 to 9
move 6 from 7 to 4
move 1 from 1 to 2
move 8 from 9 to 8
move 7 from 5 to 1
move 9 from 4 to 3
move 14 from 8 to 4
move 1 from 8 to 4
move 1 from 1 to 5
move 1 from 5 to 2
move 3 from 2 to 4
move 1 from 7 to 1
move 1 from 7 to 3
move 2 from 1 to 7
move 3 from 5 to 7
move 2 from 7 to 6
move 1 from 6 to 5
move 3 from 7 to 1
move 1 from 6 to 8
move 1 from 8 to 7
move 1 from 3 to 6
move 1 from 7 to 1
move 4 from 1 to 4
move 6 from 3 to 2
move 3 from 1 to 2
move 3 from 3 to 6
move 3 from 2 to 6
move 6 from 6 to 5
move 1 from 1 to 4
move 1 from 9 to 6
move 5 from 2 to 1
move 3 from 1 to 2
move 2 from 9 to 8
move 3 from 1 to 5
move 1 from 9 to 7
move 25 from 4 to 1
move 1 from 1 to 7
move 2 from 8 to 3
move 13 from 1 to 9
move 2 from 3 to 5
move 8 from 5 to 9
move 4 from 2 to 1
move 2 from 6 to 7
move 10 from 5 to 9
move 4 from 7 to 2
move 2 from 2 to 3
move 9 from 9 to 2
move 4 from 4 to 5
move 4 from 5 to 4
move 5 from 1 to 4
move 10 from 4 to 5
move 22 from 9 to 1
move 2 from 2 to 7
move 3 from 2 to 1
move 6 from 2 to 6
move 1 from 7 to 1
move 10 from 5 to 7
move 15 from 1 to 4
move 13 from 1 to 5
move 3 from 6 to 8
move 1 from 8 to 9
"@