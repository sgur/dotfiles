function Set-Foo
{
    [CmdletBinding()]
    param(
        [parameter(ValueFromPipeLine=$true, Mandatory=$true, Position=0)]
        [PSObject[]]
        $InputObject,
        [parameter(Position=1)]
        [string]
        $Property,
        [parameter(Position=2)]
        [PSObject]
        $Value,
        [switch]
        $PassThru
    )
    process
    {
        foreach($o in $InputObject)
        {
            $o.$Property = $Value
            if($PassThru)
            {
                $o
            }
        }
    }
}
