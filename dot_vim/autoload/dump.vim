scriptencoding utf-8


function! dump#var(var, ...) abort
  try
    let values = eval(a:var)
  catch /^Vim\%((\a\+)\)\=:E\%(15\|121\)/
    let values = eval('&' .. a:var)
  endtry

  let splitter = a:000 + (has('win32') || has('win64') ? [',', ';'] : [',', ':'])
  let split_pattern = '[' . join(uniq(sort(splitter)), '') .. ']'
  echo join(type(values) == type({})
        \ ? map(sort(items(values)), {k, v -> v[0] .. ":\n  " .. string(v[1])})
        \ : type(values) != type([])
        \   ? filter(split(values, split_pattern), {k, v -> len(v) > 1})
        \   : values
        \ , "\n")
endfunction

function! dump#complete(arglead, cmdline, cursorpos) abort
  let pos = len(split(a:cmdline[: a:cursorpos], '\S\+'))
  if pos == 1
    if a:arglead[0] is# '&'
      return map(getcompletion(a:arglead[1:], 'option'), {k, v -> '&' .. v})
    endif
    if a:arglead[0] is# '$'
      return map(getcompletion(a:arglead[1:], 'environment'), {k, v -> '$' .. v})
    endif
    if a:arglead[0:1] =~# '^[bwtglsav]:$'
      return getcompletion(a:arglead, 'var')
    endif
    try
      let wop = &wildoptions
      set wildoptions&
      let pattern = printf('*%s*', a:arglead)
      return map(getcompletion(pattern, 'option'), {k, v -> '&' .. v})
            \ + map(getcompletion(pattern, 'environment'), {k, v -> '$' .. v})
            \ + getcompletion('b:' .. pattern, 'var')
            \ + getcompletion('w:' .. pattern, 'var')
            \ + getcompletion('t:' .. pattern, 'var')
            \ + getcompletion('g:' .. pattern, 'var')
            \ + getcompletion('l:' .. pattern, 'var')
            \ + getcompletion('s:' .. pattern, 'var')
            \ + getcompletion('a:' .. pattern, 'var')
            \ + getcompletion('v:' .. pattern, 'var')
    finally
      let &wildoptions = wop
    endtry
  elseif pos == 2
    return [',', ';', ':', '/', '|', '\n']
  endif
  return []
endfunction

