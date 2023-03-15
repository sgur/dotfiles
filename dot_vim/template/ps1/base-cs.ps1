# C#によるクラス定義
Add-Type -TypeDefinition @"
using System;
namespace Winscript
{
    public class Foo2
    {
        private string _name;
        private int _no;
        public Foo2(string name)
        {
            _name = name;
            _no = 0;
        }
        public string Name
        {
            get{
              return _name;
            }
            set{
               _name = value;
            }
        }
        public int No
        {
            get{
              return _no;
            }
            set{
               _no = value;
            }
        }
    }
}
"@

function Get-Foo2
{
    [CmdletBinding()]
    param([string[]]$Name)
    end
    {
        foreach($n in $name)
        {
           New-Object Winscript.Foo2 $n
        }
    }
}

function Set-Foo2
{
    [CmdletBinding()]
    param(
        [parameter(ValueFromPipeLine=$true, Mandatory=$true, Position=0)]
        [Winscript.Foo2[]]
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
