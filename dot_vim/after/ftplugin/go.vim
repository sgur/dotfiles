highlight clear GoErr
highlight link GoErr Special
match GoErr /\<err\>/
compiler go

setlocal tabstop=3 noexpandtab


let b:undo_ftplugin = (exists('b:undo_ftplugin')? b:undo_ftplugin . '|': '')
      \ . 'setlocal tabstop< expandtab< | highlight clear GoErr'
