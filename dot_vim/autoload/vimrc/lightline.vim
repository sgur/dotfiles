scriptencoding utf-8

" let g:airline_symbols = extend(get(g:, 'airline_symbols', {}), {
"       \ 'branch': '',
"       \ 'readonly': '',
"       \ 'linenr': '☰',
"       \ 'maxlinenr': '',
"       \ 'dirty': '⚡'
"       \ },
"       \ 'keep')

" Interface {{{1

function! vimrc#lightline#modified() abort
  return &modified ?  (s:emoji_enabled ? ' ⚡' : '+ ') : ''
endfunction

function! vimrc#lightline#filename() abort
  return pathshorten(expand('%:.'))
endfunction

function! vimrc#lightline#readonly() abort
  return &readonly ?  (s:emoji_enabled ? '' : 'RO '): ''
endfunction

function! vimrc#lightline#branchname() abort
  if !exists('b:branchname')
    return ''
  endif
  return (s:emoji_enabled ? ' ' : '@' ) . b:branchname
endfunction

function! vimrc#lightline#vcs_stat() abort
  if !get(g:, 'loaded_signify', 0) || !exists('b:sy') || !has_key(b:sy, 'vcs') || &readonly
    return ''
  endif
  return printf('+%d,!%d,-%d', b:sy.stats[0], b:sy.stats[1], b:sy.stats[2])
endfunction

function! vimrc#lightline#getcwd() abort
  return pathshorten(getcwd())
endfunction

function! vimrc#lightline#lsp() abort
  if !get(g:, 'lsp_loaded', 0)
    return ''
  endif

  let counts = lsp#get_buffer_diagnostics_counts()
  let result = []
  if counts.error
    let result += ['E:' . counts.error]
  endif
  if counts.warning
    let result += ['W:' . counts.warning]
  endif
  if counts.information
    let result += ['I:' . counts.information]
  endif
  if counts.hint
    let result += ['H:' . counts.hint]
  endif
  return join(result)
endfunction

function! vimrc#lightline#tab_title(nr) abort
  return s:tabnum(a:nr) .. s:bufname(a:nr) .. s:winnrs(a:nr)
endfunction

" Internal {{{1

function! s:detect(basedir) abort "{{{
  if !isdirectory(a:basedir)
    return
  endif

  let dir = getcwd()
  try
    execute 'lcd' a:basedir
    unlet! b:branchname
    call job_start(s:cmd, {
          \ 'out_cb': {ch, msg -> setbufvar('%', 'branchname', msg) || lightline#update()}
          \ })
  finally
    execute 'lcd' dir
  endtry
endfunction "}}}

function! s:tabnum(nr) abort
  return get(s:superscripts, a:nr, '⁺')
endfunction

function! s:winnrs(nr) abort
  let winnrs = tabpagewinnr(a:nr, '$')
  return winnrs > 1 ? '/' . get(s:subscripts, winnrs, '₊') : ' '
endfunction

function! s:bufname(nr) abort "{{{
  let bufnr = tabpagebuflist(a:nr)[tabpagewinnr(a:nr) - 1] " winnr is 1 origin
  let name = bufname(bufnr)
  return !empty(name) ? fnamemodify(name, ':t') : '[No Name]'
endfunction "}}}

" Initialization {{{1

let s:cmd = 'git symbolic-ref --short HEAD'

let s:emoji_enabled = get(get(g:, 'lightline', {}), 'emoji', v:true)

let s:superscripts = ['⁰', '¹', '²', '³', '⁴', '⁵', '⁶', '⁷', '⁸', '⁹']
let s:subscripts = ['₀', '₁', '₂', '₃', '₄', '₅', '₆', '₇', '₈', '₉']

augroup vimrc_plugin_lightline
  autocmd!
  autocmd BufNewFile,BufReadPost * call s:detect(expand('<amatch>:p:h'))
  autocmd BufEnter * call s:detect(expand('%:p:h'))
  " autocmd User Signify  call lightline#update()
augroup END


" 1}}}
