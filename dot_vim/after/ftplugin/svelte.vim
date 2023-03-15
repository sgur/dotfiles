setlocal shiftwidth=2 expandtab


let b:undo_ftplugin = (exists('b:undo_ftplugin')? b:undo_ftplugin . '|': '')
      \ . 'setlocal shiftwidth< expandtab<'
