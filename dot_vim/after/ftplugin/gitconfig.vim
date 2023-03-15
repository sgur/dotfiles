setlocal tabstop=4 shiftwidth=0 noexpandtab


let b:undo_ftplugin = (exists('b:undo_ftplugin')? b:undo_ftplugin . '|': '')
      \ . 'setlocal tabstop< shiftwidth< expandtab<'
