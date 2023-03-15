function s:SID() "{{{
  return matchstr(expand('<sfile>'), '\zs<SNR>\d\+_\zeSID$')
endfun "}}}
