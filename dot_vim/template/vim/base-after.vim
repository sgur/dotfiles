setlocal {{_cursor_}}


let b:undo_ftplugin = (exists('b:undo_ftplugin')? b:undo_ftplugin . '|': '')
      \ . 'setlocal '
