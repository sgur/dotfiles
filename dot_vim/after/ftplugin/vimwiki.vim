setlocal ts=2 sw=2 et


let b:undo_ftplugin = (exists('b:undo_ftplugin')? b:undo_ftplugin . '|': '')
      \ . 'setlocal ts< sw< et<'
