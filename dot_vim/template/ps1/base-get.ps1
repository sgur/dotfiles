function Get-{{_cursor_}}
{
    [CmdletBinding()]
    param([string[]]$Name)
    end
    {
        foreach($n in $name)
        {
            $out = [pscustomobject]@{
                Name = $n
                No = 0
            }
            # PSCustomObjectのインスタンスに型名を付ける
            $out.PSTypeNames.Insert(0, "Winscript.Foo")
            $out
        }
    }
}
