scriptencoding utf-8



" Interface {{{1

function! openable#start(url, ...) abort
  call s:start(a:0 && has_key(a:1, 'cmd') ? a:1.cmd : s:default_cmd(), a:url)
endfunction

function! openable#parse(mode, ...) abort
  if a:mode is# 'n'
    let match = matchstr(getline('.'), '\S*\%' . col('.') . 'c\S*')
  elseif a:mode is# 'v'
    let match = join(s:selected_area())
  else
    let match =''
  endif
  call s:parse(match, {})
endfunction


" Internal {{{1

function! s:parse(line, opt) abort "{{{
  let [start, end, _] = s:extract_scheme(a:line, 0)
  let results = s:uri.new_from_seq_string(a:line[start :], [], s:pattern_set)
  if !empty(results)
    let [uri, parsed; others] = results
    call openable#start(parsed, !empty(a:opt) ? a:opt : {})
  endif
endfunction "}}}

function! s:extract_scheme(line, initial) abort "{{{
  let pattern = s:pattern_set.scheme() . ':'
  let start = match(a:line, pattern, a:initial)
  let end = matchend(a:line, pattern, start + 1)
  return [start, end, a:line[start : end-1]]
endfunction "}}}

function! s:start(cmd, url) abort "{{{
  call job_start(join(a:cmd + [a:url]))
endfunction "}}}

function! s:shellescape(arg) abort "{{{
  try
    let ssl = &shellslash
    set noshellslash
    return shellescape(a:arg)
  finally
    let &shellslash = ssl
  endtry
endfunction "}}}

function! s:default_cmd() abort "{{{
  if s:is_win || s:is_win32unix
    " Which is better between 'OpenURL' and 'FileProtocolHandler'?
    return ['cmd', '/c', 'start', '""']
  elseif s:is_mac
    return ['open']
  elseif s:is_wsl
    return ['wslview']
  else
    return get(filter([['xdg-open'], ['kioclient', 'exec'], ['gnome-open'], ['exo-open']], 'vimrc#executable(v:val[0])'), 0, [])
  endif
endfunction "}}}

"null
function! s:selected_area() abort "{{{
  " [bufnum, lnum, col, off]
  let start = getpos('''<')
  let end = getpos('''>')
  let lines = []
  if start[1] == end[1] " 同じ行
    let lines += [getline(start[1])[start[2]-1 : end[2]-1]]
  else
    let lines += [getline(start[1])[start[2]-1 :]]
    if end[1] - start[1] == 1
      let lines += getline(start[1]+1, end[1]-1)
    endif
    let lines += [getline(end[1])[: end[2]-1]]
  endif
  return lines
endfunction "}}}

" Initialization {{{1

let s:is_win = has('win32') || has('win64')
let s:is_win32unix = has('win32unix')
let s:is_mac = has('mac') || has('osx')
let s:is_wsl = has('unix') && filereadable('/proc/sys/kernel/osrelease') &&
      \ get(readfile('/proc/sys/kernel/osrelease'), 0, '') =~# '\cmicrosoft'

let s:uri = vital#vimrc#new().import('Web.URI')
let s:pattern_set = s:uri.new_default_pattern_set()
function! s:pattern_set.sub_delims() abort "{{{
  return '[!$&*+,;=]'
endfunction "}}}



" 1}}}
