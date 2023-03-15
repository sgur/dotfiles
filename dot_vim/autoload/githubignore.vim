scriptencoding utf-8



" Internal {{{1

if exists('*json_decode')
  function! s:json_decode(str) abort "{{{
    return json_decode(a:str)
  endfunction "}}}
else
  function! s:json_decode(str) abort "{{{
    return webapi#json#decode(a:str)
  endfunction "}}}
endif

function! s:repo_get(type) abort "{{{
  let res = webapi#http#get(printf(s:repo_url.pattern, a:type))
  if str2nr(res.status) != 200
    return []
  endif
  let json = s:json_decode(res.content)
  if !has_key(json, 'name') || !has_key(json, 'source') || json.name isnot# a:type
    return []
  endif
  return split(json.source, '\n')
endfunction "}}}

function! s:repo_types() abort "{{{
  let res = webapi#http#get(s:repo_url.list)
  if str2nr(res.status) != 200
    return []
  endif
  return s:json_decode(res.content)
endfunction "}}}

function! s:global_get(type) abort "{{{
  let res = webapi#http#get(printf(s:global_url.pattern, a:type))
  if str2nr(res.status) != 200
    return []
  endif
  return split(res.content, '\n')
endfunction "}}}

function! s:http_get_paths(url) abort "{{{
  let res = webapi#http#get(a:url)
  if str2nr(res.status) != 200
    return []
  endif
  let json = s:json_decode(res.content)
  if !has_key(json, 'tree')
    return []
  endif
  return json.tree
endfunction "}}}

function! s:global_types() abort "{{{
  let paths = filter(s:http_get_paths(s:global_url.list), 'v:val.path is# "Global"')
  if empty(paths)
    return []
  endif
  return map(s:http_get_paths(paths[0].url), 'fnamemodify(v:val.path, ":t:r")')
endfunction "}}}


" Interface {{{1

function! githubignore#repo_types() abort
  return s:repo_types
endfunction

function! githubignore#repo_complete(arglead, cmdline, cursorpos) abort
  return filter(copy(s:repo_types), 'stridx(v:val, a:arglead) == 0')
endfunction

function! githubignore#repo_get(type) abort
  return s:repo_get(a:type)
endfunction

function! githubignore#global_types() abort
  return s:global_types
endfunction

function! githubignore#global_complete(arglead, cmdline, cursorpos) abort
  return filter(copy(s:global_types), 'stridx(v:val, a:arglead) == 0')
endfunction

function! githubignore#global_get(type) abort
  return s:global_get(a:type)
endfunction


" Initialization {{{1

let s:repo_url = {
      \   'list': 'https://api.github.com/gitignore/templates'
      \ , 'pattern': 'https://api.github.com/gitignore/templates/%s'
      \ }

" let s:repo_url = 'https://raw.githubusercontent.com/github/gitignore/master/%s.gitignore'
let s:global_url = {
      \   'list': 'https://api.github.com/repos/github/gitignore/git/trees/master'
      \ , 'pattern': 'https://raw.githubusercontent.com/github/gitignore/master/Global/%s.gitignore'
      \ }

if !exists('s:repo_types')
  let s:repo_types = s:repo_types()
endif

if !exists('s:global_types')
  let s:global_types = s:global_types()
endif


if expand("%:p") == expand("<sfile>:p")
  " Use if necessary
  command! -nargs=1 -complete=customlist,githubignore#repo_complete GitHubRepoIgnore  echo githubignore#repo_get(<q-args>)
  command! -nargs=1 -complete=customlist,githubignore#global_complete GitHubGlobalIgnore  echo githubignore#global_get(<q-args>)
endif

" 1}}}
