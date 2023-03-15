" {{_expr_:expand("%:p:t:r")}}
" Version: 0.0.1
" Author: {{_expr_:get(g:,"sonictemplate_author","")}}
" License: {{_expr_:get(g:,"sonictemplate_license","")}}

if exists('g:loaded_{{_expr_:expand("%:p:t:r")}}')
  finish
endif
let g:loaded_{{_expr_:expand("%:p:t:r")}} = 1

let s:save_cpo = &cpoptions
set cpoptions&vim

{{_cursor_}}

let &cpoptions = s:save_cpo
unlet s:save_cpo

" vim:set et:
