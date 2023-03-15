setlocal commentstring=<!--\ %s\ -->
setlocal expandtab tabstop=4

if exists('loaded_matchit')
  let b:match_words = '(:),{:},\[:],' . b:match_words
endif

command! -buffer ToggleCheck keeppattern substitute/^\s*- \[\zs.\ze\]/\=[' ','x'][submatch(0)==' ']/

let b:undo_ftplugin = (exists('b:undo_ftplugin')? b:undo_ftplugin . '|': '')
      \ . 'setlocal commentstring< expandtab< tabstop<'
