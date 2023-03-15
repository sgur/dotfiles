if !(exists('g:indentLine_loaded') && g:indentLine_loaded)
  setlocal cursorcolumn
  let b:undo_ftplugin = (exists('b:undo_ftplugin')? b:undo_ftplugin . '|': '')
        \ . "setlocal cursorcolumn<"
endif
