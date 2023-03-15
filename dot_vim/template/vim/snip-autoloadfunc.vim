function! {{_expr_:substitute(matchstr(expand('%:p:r'), 'autoload[\\/]\zs.\+$'),'[\\/]', '#', 'g')}}#{{_cursor_}}() abort
  throw 'not implemented yet!'
endfunction
