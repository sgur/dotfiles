setlocal
      \ cinwords+=elif,try,except,finally,def,class
      \ expandtab
      \ textwidth=80

if get(g:, 'loaded_matchit', 0)
  let b:match_words='\<if\>:\<elif\>:\<else\>,\<try\>:\<except\>'
endif

let b:undo_ftplugin = (exists('b:undo_ftplugin')? b:undo_ftplugin . '|': '')
      \ . 'setlocal cinwords< expandtab< textwidth<'
