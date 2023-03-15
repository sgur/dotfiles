let s:save_cpo = &cpoptions
set cpoptions&vim
{{_cursor_}}

let &cpoptions = s:save_cpo
unlet s:save_cpo

