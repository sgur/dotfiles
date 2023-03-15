setlocal spell

let b:undo_ftplugin = (exists('b:undo_ftplugin')? b:undo_ftplugin . '|': '')
      \ . "setlocal spell< colorcolumn<"
