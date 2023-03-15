" vspec helper functions. see vspec#hint() {{{
" call vspec#hint({'scope': '{{_name_}}#scope()', 'sid': '{{_name_}}#sid()'})
function! {{_name_}}#scope()  "{{{
  return s:
endfunction "}}}

function! {{_name_}}#sid()  "{{{
  return maparg('<SID>', 'n')
endfunction "}}}
nnoremap <SID>  <SID>

" }}}
