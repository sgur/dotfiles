scriptencoding utf-8



" Interface {{{1
function! lightline_colorscheme#select(colorscheme) abort
  let g:lightline = get(g:, 'lightline', {})
  let g:lightline.colorscheme = a:colorscheme
  call lightline#disable()
  call lightline#enable()
endfunction

function! lightline_colorscheme#complete(arglead, cmdline, cursorpos) abort
  return join(sort(map(globpath(&rtp, 'autoload/lightline/colorscheme/*', 1, 1), {k, v -> fnamemodify(v, ':t:r')})), "\n")
endfunction

" Internal {{{1


" Initialization {{{1



" 1}}}
