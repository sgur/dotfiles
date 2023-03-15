if get(g:, 'loaded_{{_var_:name}}', 0)
  finish
endif

let g:loaded_{{_var_:name}} = 1
{{_cursor_}}
{{_define_:name:substitute(matchstr(expand('%:p:r'), '\%(autoload\|plugin\)[\\/]\zs.\+$'),'[\\/]', '_', 'g')}}
