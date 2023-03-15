vim9script


# Internal {{{1

# Return list of line numbers for current buffer found in quickfix list.
def FilterQuickfix(qfs: list<dict<any>>): list<number>
  return deepcopy(qfs)->filter((k, v) => v.valid && v.bufnr == bufnr("%"))->map((k, v) => v.lnum)
enddef

# Return list of line numbers in hlsearch.
def FilterHlsearch(): list<number>
  return range(1, line('$'))->filter((k, v) => getline(v) =~ @/)
enddef

# Add manual fold from line1 to line2, inclusive.
def Fold(line1: number, line2: number)
  if line1 < line2
    execute printf(':%d,%dfold', line1, line2)
  endif
enddef

def FoldGap(context: number, lnums: list<number>)
  var last = -context
  for lnum in lnums
    Fold(last + 1 + context, lnum - 1 - context)
    last = lnum
  endfor
  Fold(last + 1 + context, line('$'))
enddef


# Fold non-matched lines.
def FoldMiss(context: number, lnums: list<number>)
  setlocal foldlevel=0
  setlocal foldmethod=manual
  normal! zE
  FoldGap(context, lnums)
enddef


# Interface {{{1

export def Quickfix(): list<number>
  return FilterQuickfix(getqflist())
enddef


export def Loclist(): list<number>
  return FilterQuickfix(getloclist(0))
enddef


export def Hlsearch(): list<number>
  return FilterHlsearch()
enddef


export def Filter(context: number, num: list<number>)
  if empty(get(w:, 'foldmiss', {}))
    if empty(num)
      echohl ErrorMsg | echo "Foldmiss: no matches!" | echohl Normal | return
    endif
    w:foldmiss = {
      'foldmethod': &l:foldmethod,
      'foldlevel': &l:foldlevel
    }
    FoldMiss(context, num)
    autocmd WinEnter,BufWinEnter <buffer>  if !empty(get(w:, 'foldmiss', {}))
          \ | ResetFoldmiss()
          \ | endif
  else
    ResetFoldmiss()
  endif
enddef

def ResetFoldmiss()
  &l:foldmethod = w:foldmiss.foldmethod
  &l:foldlevel = w:foldmiss.foldlevel
  unlet w:foldmiss
enddef
