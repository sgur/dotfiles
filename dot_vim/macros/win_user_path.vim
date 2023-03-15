vim9script

if !has('win32')
  finish
endif

job_start('reg query HKCU\Environment /v Path', {
  mode: 'nl',
  close_cb: (ch: channel) => {
    var line = ''
    while index(['open', 'buffered'], ch_status(ch)) != -1
      line ..= ch_read(ch)
    endwhile
    final tokens = split(line)
    if len(tokens) == 4
      final path = tokens[3]
      $PATH = path .. ';' .. $PATH
    endif
  }
})
