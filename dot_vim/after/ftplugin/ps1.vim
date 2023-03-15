setlocal tabstop=4 shiftwidth=4 noexpandtab foldmethod=syntax


let b:undo_ftplugin = (exists('b:undo_ftplugin')? b:undo_ftplugin . '|': '')
      \ . "setlocal tabstop< shiftwidth< expandtab< foldmethod<"
