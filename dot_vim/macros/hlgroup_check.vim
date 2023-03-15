scriptencoding utf-8

function! s:main() abort "{{{
  let current = s:current_highliht()
  let default = s:default_highlight()
  let common = s:common_highlight()

  echo filter(default + common, {k,v -> index(current, v) > -1})
endfunction "}}}

function! s:common_highlight() abort "{{{
  return ['Comment',
        \ 'Constant', 'String', 'Character', 'Number', 'Boolean', 'Float',
        \ 'Identifier', 'Function',
        \ 'Statement', 'Conditional', 'Repeat', 'Label', 'Operator', 'Keyword', 'Exception',
        \ 'PreProc', 'Include', 'Define', 'Macro', 'PreCondit',
        \ 'Type', 'StorageClass', 'Structure', 'Typedef',
        \ 'Special', 'SpecialChar', 'Tag', 'Delimiter', 'SpecialComment', 'Debug',
        \ 'Underlined',
        \ 'Ignore',
        \ 'Error',
        \ 'Todo'
        \ ]
endfunction "}}}
function! s:current_highliht() abort "{{{
  return map(filter(split(execute('highlight'), "\n"), {k,v -> v =~ 'cleared'}), {k,v -> matchstr(v, '^\S\+')})
endfunction "}}}

function! s:default_highlight() abort "{{{
  return map(split(&highlight, ','), {k,v -> split(v, ':')[1]})
endfunction "}}}

call s:main()

