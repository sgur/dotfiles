setlocal tabstop=4 noexpandtab


let b:undo_ftplugin = (exists('b:undo_ftplugin')? b:undo_ftplugin . '|': '')
      \ . 'setlocal tabstop< expandtab<'
