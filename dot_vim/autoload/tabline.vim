scriptencoding utf-8

" Internal {{{1

function! s:winnrs(splits) abort "{{{
  return a:splits > 1 ? '/' . get(s:subscripts, a:splits, '₊') : ' '
endfunction "}}}

function! s:tabnr(nr) abort "{{{
  return get(s:superscripts, a:nr, '⁺')
endfunction "}}}

function! s:hlgroup(is_active) abort "{{{
  return a:is_active ? '%#TabLineSel#' : '%#TabLine#'
endfunction "}}}

function! s:bufname(name) abort "{{{
  return !empty(a:name) ? fnamemodify(a:name, ':t') : '[No Name]'
endfunction "}}}

function! s:modified(bufnr) abort "{{{
  return getbufvar(a:bufnr, '&mod') ? '+' : ''
endfunction "}}}

function! s:tabline(nr) abort "{{{
  let bufnr = tabpagebuflist(a:nr)[tabpagewinnr(a:nr) - 1] " winnr is 1 origin
  return ['%'] + [a:nr] + ['T'] + [s:hlgroup(a:nr == tabpagenr())] + [' ']
        \ + [s:tabnr(a:nr)] + [s:bufname(bufname(bufnr))] + [s:modified(bufnr)]
        \ + [s:winnrs(tabpagewinnr(a:nr, '$'))]
endfunction "}}}


" Interface {{{1

function! tabline#format() abort "{{{
  let tablines = []
  for i in range(1, tabpagenr('$'))
    let tablines += s:tabline(i)
  endfor
  return join(tablines, '') . '%#TabLineFill#'
endfunction "}}}


" Initialization {{{1

let s:superscripts = ['⁰', '¹', '²', '³', '⁴', '⁵', '⁶', '⁷', '⁸', '⁹']
let s:subscripts = ['₀', '₁', '₂', '₃', '₄', '₅', '₆', '₇', '₈', '₉']



" 1}}}
