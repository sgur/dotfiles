setlocal tabstop=4 shiftwidth=4 expandtab
setlocal foldmethod=syntax


let b:undo_ftplugin = (exists('b:undo_ftplugin') ? b:undo_ftplugin . ' | ': '')
      \ . 'setlocal tabstop< shiftwidth< expandtab< foldmethod<
