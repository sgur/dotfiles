setlocal keywordprg=:help


let b:undo_ftplugin = (exists('b:undo_ftplugin')? b:undo_ftplugin . '|': '')
      \ . "setlocal keywordprg<"
