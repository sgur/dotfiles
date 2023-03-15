" logファイルを読むときは colorcolumn を無効にする
setlocal colorcolumn&


let b:undo_ftplugin = (exists('b:undo_ftplugin')? b:undo_ftplugin . '|': '')
      \ . 'setlocal colorcolumn<'
