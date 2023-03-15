try
  let t = reltime()
  {{_cursor_}}
finally
  echomsg reltimestr(reltime(t))
endtry
