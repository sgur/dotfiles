setlocal tabstop=2 shiftwidth=2 expandtab
setlocal foldmethod=syntax foldlevel=1


let b:undo_ftplugin = (exists('b:undo_ftplugin') ? b:undo_ftplugin . ' | ': '')
      \ . 'setlocal tabstop< shiftwidth< expandtab< foldmethod< foldlevel<'
