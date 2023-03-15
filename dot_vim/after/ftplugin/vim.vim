if !filereadable(expand('%:p'))
  setlocal fileformat=unix
  setlocal nomodified
endif


setlocal
      \ keywordprg=:help
      \ expandtab
      \ shiftwidth=2
      \ softtabstop=2
      \ foldmethod=marker


let b:undo_ftplugin = (exists('b:undo_ftplugin')? b:undo_ftplugin . '|': '')
      \ . 'setlocal commentstring< keywordprg< expandtab< shiftwidth< softtabstop< foldmethod<'
