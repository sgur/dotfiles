setlocal commentstring=//\ %s
setlocal comments=fl:////,://,fn:*,fn:.
setlocal formatoptions=tcqjnro
let &formatlistpat="^\\s*\\d\\+[\\]:.)}\\t\ ]\\s*"
setlocal nospell
setlocal spelllang& spelllang+=cjk
setlocal include=^include::


let b:undo_ftplugin = (exists('b:undo_ftplugin')? b:undo_ftplugin . '|': '')
      \ . 'setlocal commentstring< comments< formatoptions< spell< spelllang< include<'
