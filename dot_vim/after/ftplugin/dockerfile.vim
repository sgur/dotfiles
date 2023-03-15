setlocal omnifunc=syntaxcomplete#Complete

let b:undo_ftplugin = (exists('b:undo_ftplugin')? b:undo_ftplugin . '|': '')
      \ . 'setlocal omnifunc<'
