function Get-ElfWithMostFood
{
    [CmdletBinding()]
    param (
        [Parameter()]
        [string]
        $foodString
    )

    $foodstring=$foodString -replace "`r`n","`n"
    Write-Verbose "FoodString=`n$foodString"
    $ElfFoodString=$foodString -split "`n`n"
    Write-Verbose "ElfFoodString=`n$elffoodstring"

    $counter=0
    $ElfFoodTotal=@()
    ForEach ($elf in $ElfFoodString)
    {
        $counter++
        $elfTotal=0
        $foodvalues=$elf -split "`n"
        foreach($foodvalue in $foodvalues)
        {
            $elfTotal+=$foodvalue
        }
        $ElfFoodTotal+=New-Object -TypeName psobject -Property @{ElfNumber=$Counter;TotalCalories=$elfTotal}
    }
    Write-Verbose "$ElfFoodTotal"

    $ElfFoodTotal | Sort-Object -Descending TotalCalories | Select-Object -first 1 TotalCalories
}

Get-ElfWithMostFood -foodString @"
1000
2000
3000

4000

5000
6000

7000
8000
9000

10000
"@