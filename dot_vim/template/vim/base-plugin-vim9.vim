if !has('vim9script')
  finish
endif
vim9script
# {{_expr_:expand("%:p:t:r")}}
# Version: 0.0.1
# Author: {{_expr_:get(g:,"sonictemplate_author","")}}
# License: {{_expr_:get(g:,"sonictemplate_license","")}}

if exists('g:loaded_{{_expr_:expand("%:p:t:r")}}')
  finish
endif
g:loaded_{{_expr_:expand("%:p:t:r")}} = 1


{{_cursor_}}


# vim:set et:
