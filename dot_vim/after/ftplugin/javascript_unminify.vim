" https://coderwall.com/p/lxajqq/vim-function-to-unminify-javascript
" Simple re-format for minified Javascript
"
scriptencoding utf-8

let s:save_cpo = &cpo
set cpo&vim


command! -buffer UnMinify call s:unminify()

function! s:unminify()
  %s/{\ze[^\r\n]/{\r/g
  %s/){/) {/g
  %s/};\?\ze[^\r\n]/\0\r/g
  %s/;\ze[^\r\n]/;\r/g
  %s/[^\s]\zs[=&|]\+\ze[^\s]/ \0 /g
  normal ggVG=
endfunction



let &cpo = s:save_cpo
unlet s:save_cpo
