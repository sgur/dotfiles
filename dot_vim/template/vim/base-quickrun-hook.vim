scriptencoding utf-8

let s:save_cpo = &cpo
set cpo&vim

let s:hook = {
      \ 'config' : {
      \   'enable' : 0,
      \   }
      \}


" function! s:hook.on_hook_loaded(session, context)
" endfunction
"
" function! s:hook.on_normalized(session, context)
" endfunction
"
" function! s:hook.on_module_loaded(session, context)
" endfunction
"
" function! s:hook.on_ready(session, context)
" endfunction
"
" function! s:hook.on_output(session, context)
" endfunction
"
" function! s:hook.on_success(session, context)
" endfunction
"
" function! s:hook.on_failure(session, context)
" endfunction
"
" function! s:hook.on_finish(session, context)
" endfunction
"
" function! s:hook.on_exit(session, context)
" endfunction


function! quickrun#hook#{{_expr_:expand('%:t:r')}}#new()
    return deepcopy(s:hook)
endfunction

let &cpo = s:save_cpo
unlet s:save_cpo
