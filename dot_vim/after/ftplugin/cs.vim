setlocal shiftwidth=4 tabstop=4 foldmethod=indent foldlevel=2


let b:undo_ftplugin = (exists('b:undo_ftplugin')? b:undo_ftplugin . '|': '')
      \ . "setlocal shiftwidth< tabstop<"
