" Vim compiler file
" Compiler:     {{_expr_:expand("%:t:r")}}
" Maintainer:   {{_expr_:get(g:,"sonictemplate_author","")}}
" Last Change:  {{_expr_:strftime("%Y %b %d")}}

if exists('current_compiler')
  finish
endif
let current_compiler = '{{_expr_:expand("%:t:r")}}'

if exists(':CompilerSet') != 2
  command -nargs=* CompilerSet setlocal <args>
endif

let s:save_cpo = &cpo
set cpo&vim

CompilerSet makeprg={{_cursor_}}

CompilerSet errorformat&		" use the default 'errorformat'

let &cpo = s:save_cpo
unlet s:save_cpo
