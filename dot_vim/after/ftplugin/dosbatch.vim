setlocal commentstring=@REM\ %s
setlocal omnifunc=dosbatch_complete#omnifunc


let b:undo_ftplugin = (exists('b:undo_ftplugin')? b:undo_ftplugin . '|': '')
      \ . 'setlocal commentstring< omnifunc<'
