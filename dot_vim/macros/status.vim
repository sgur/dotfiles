scriptencoding utf-8

if exists('g:loaded_status') && g:loaded_status
  finish
endif
let g:loaded_status = 1


let s:save_cpo = &cpo
set cpo&vim

function! s:init() abort "{{{
  let s:sid = matchstr(expand('<sfile>'), '<SNR>\d\+_')
endfunction "}}}

" Status {{{1
function! s:status() "{{{
  " alternative buffers
  let altstat = s:get_alternative()
  if !empty(altstat) | return altstat | endif
  " line / column
  let len = 0
  if &l:signcolumn is# 'yes' || (&l:signcolumn is# 'auto' && !empty(get(getbufinfo('%')[0], 'signs', [])))
    let len += 2
  endif
  if &l:foldcolumn
    let len += &l:foldcolumn
  endif
  let line_column = max([strlen(line('$')), 3])
  if &l:number || &l:relativenumber
    let len += line_column + 1
  endif
  let stat = ['%#CursorLineNr#%'] + [len-1]
        \ + [&l:number || &l:relativenumber ? 'v' : 'l']
        \ + ['%* '] + [bufname('%')] + ['%< <- '] + [pathshorten(getcwd(winnr()))]

  " spell/paste
  let substats = []
  if &spell | let substats += ['Spell'] | endif
  if &paste | let substats += ['Paste'] | endif

  let stat += ['::%Y%M%R%H%W', empty(substats) ? '' : ',' . join(substats, ',')]
  " git/hg branch
  let stat += ['%{' . s:sid . 'get_branchname()}']

  " additional
  let stat += ['%=']
  let stat += [' %1* %{&fenc}:%{&ff}%a %*']
  let trailings = s:format_trailingspace(s:count_trailingspaces())
  if !empty(trailings)
    let stat += ['%#Error#' . trailings . '%*']
  endif
  if s:has_proxy()
    let stat += ['%2*⛓%*']
  endif
  return join(stat, '')
endfunction "}}}

" Highlight trailing spaces {{{1
function! s:format_trailingspace(nrs) "{{{
  return empty(a:nrs) ? '' : printf('[trail:%d%s]', a:nrs[0], empty(a:nrs) ? '' : '+')
endfunction "}}}

function! s:count_trailingspaces() "{{{
  return (&readonly || !&modifiable || line('$') > 5000)
        \ ? []
        \ : filter(range(1, line('$')), 'getline(v:val) =~# "\\s\\+$"')
endfunction "}}}

" Git/Hg branches {{{1
function! s:get_branchname() "{{{
  if !exists('b:sy') || empty(b:sy.vcs)
    return ''
  endif
  return '  <- ' . b:sy.vcs[0] . printf('[+%d, !%d, -%d]', b:sy.stats[0], b:sy.stats[1], b:sy.stats[2])
endfunction "}}}

" Alternative buffers {{{1
function! s:get_alternative() "{{{
  let bufnum = bufnr('%')
  let bufname = bufname('%')
  let buftype = &buftype
  let filetype = &filetype

  if buftype is# 'help'
    let lang = fnamemodify(bufname, ':e')
    return ' HELP ' . fnamemodify(bufname, ':t:r') . (lang[2] is# 'x' ? '@' . lang[:1] : '')
  elseif filetype is# 'netrw'
    return ' NETRW ' . fnamemodify(bufname, ':p')
  elseif buftype is# 'quickfix'
    return ' %q (' . max([len(getqflist()), len(getloclist(winnr()))]) . ')'
  elseif bufname is# '__Gundo__'
    return ' Gundo'
  elseif bufname is# '__Gundo_Preview__'
    return ' Gundo Preview'
  endif
  return ''
endfunction "}}}

" Proxy envrionment {{{1
function! s:has_proxy() abort "{{{
  return !empty(filter(['$ALL_PROXY', '$HTTP_PROXY', '$http_proxy', '$HTTPS_PROXY', '$https_proxy'], 'exists(v:val)'))
endfunction "}}}


" Update status {{{1
function! s:refresh_status() abort "{{{
  let &l:statusline = s:status()
endfunction "}}}

augroup vimrc_status "{{{
  autocmd!
  " BufEnter は WinEnter,BufWinEnter の後に発生
  autocmd WinEnter,BufWinEnter *  call s:refresh_status()
  if exists('##DirChanged')
    autocmd DirChanged *  call s:refresh_status()
  endif
  autocmd OptionSet spell,paste,signcolumn,number,relativenumber,foldcolumn nested  call s:refresh_status()
  autocmd User Signify  call s:refresh_status()
augroup END "}}}
" 1}}}

call s:init()

let &cpo = s:save_cpo

