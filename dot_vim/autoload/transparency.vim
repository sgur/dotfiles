scriptencoding utf-8

function! transparency#set_state(enabled) "{{{
  augroup gvimrc_transparency
    autocmd!
  augroup END
  if a:enabled
    call s:update_transparency(s:tranparencies[&background][0])
    autocmd gvimrc_transparency GuiEnter,ColorScheme,InsertLeave *  call s:update_transparency(s:tranparencies[&background][0])
    autocmd gvimrc_transparency InsertEnter *  call s:update_transparency(s:tranparencies[&background][1])
  else
    call s:update_transparency(100)
    autocmd! gvimrc_transparency
  endif
endfunction "}}}

function! s:update_transparency(percent) "{{{
  if exists('+transparency')
    let &transparency = s:pct2value(a:percent)
  elseif (has('win32') || has('win64')) && filereadable(get(g:, 'vimtweak_dll_path', ''))
    execute 'VimTweakSetAlpha' s:pct2value(a:percent)
  endif
endfunction "}}}

function! s:pct2value(percent) "{{{
  return has('win32') ? (255 * a:percent / 100) : (100 - a:percent)
endfunction "}}}

let s:tranparencies = {'dark': [90, 95], 'light': [92, 97]}
