scriptencoding utf-8



" Interface {{{1

function! doge#dependencies#install() abort
  let options = #{
        \ term_rows: 8,
        \ term_finish: 'close'
        \}
  if has('win32')
    call term_start(join(['powershell', '-NoLogo', '-NoProfile', '-NonInteractive', '-ExecutionPolicy', 'RemoteSigned',
          \ g:doge_dir .. '\scripts\install.ps1']), options)
  else
    call term_start(g:doge_dir .. '/scripts/install.sh', options)
  endif
endfunction


" Internal {{{1


" Initialization {{{1

packadd vim-doge

if !get(g:, 'loaded_doge', 0)
  echoerr 'kkoomen/vim-doge: Not installed.'
  finish
endif


" 1}}}
