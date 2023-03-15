vim9script


# Interface {{{1

export def Apply(events: list<string>)
  var target_events: list<string> = []
  if empty(events)
    call map(values(predefined_events), (k, v) => extend(target_events, v))
    call sort(target_events)
  else
    for event in events
      if event =~ '\[.\+\]'
        target_events += predefined_events[event]
      else
        target_events += [event]
      endif
    endfor
  endif

  if log_bufnr != -1
    execute 'bwipeout' log_bufnr
    log_bufnr = -1
  endif
  botright :40vnew
  set buftype=nofile
  log_bufnr = bufnr('%')
  wincmd p

  for event in target_events
    execute 'autocmd' 'plugin-autocmds' event '*' 'call Log(' .. string(event) .. ')'
  endfor
enddef

export def Complete(arglead: string, cmdline: string, cursorpos: number): list<string>
  var categories = filter(keys(predefined_events), (k, v) => stridx(v, arglead) == 0)
  var events = getcompletion(arglead, 'event')
  return categories + events
enddef


# Internal {{{1

augroup plugin-autocmds
  autocmd!
augroup END

def Log(event: string)
  appendbufline(log_bufnr, 1, printf('[%s] %s / %s', event, expand('<amatch>'), expand('<afile>')))
enddef


# Initialization {{{1

var log_bufnr = -1
# Removed:
#   'FileReadCmd', 'FileWriteCmd', 'FileAppendCmd', 'SourceCmd',
#   'SafeState', 'SafeStateAgain',
var predefined_events = {
      \ '[Reading]': [
      \   'BufNewFile', 'BufReadPre', 'BufRead', 'BufReadPost',
      \   'FileReadPre', 'FileReadPost',
      \   'FilterReadPre', 'FilterReadPost',
      \   'StdinReadPre', 'StdinReadPost'
      \ ],
      \ '[Writing]': [
      \   'BufWrite', 'BufWritePre', 'BufWritePost',
      \   'FileWritePre', 'FileWritePost',
      \   'FileAppendPre', 'FileAppendPost',
      \   'FilterWritePre', 'FilterWritePost'
      \ ],
      \ '[Buffers]': [
      \   'BufAdd', 'BufCreate', 'BufDelete', 'BufWipeout',
      \   'BufFilePre', 'BufFilePost',
      \   'BufEnter', 'BufLeave', 'BufWinEnter', 'BufWinLeave',
      \   'BufUnload', 'BufHidden', 'BufNew',
      \   'SwapExists'
      \ ],
      \ '[Options]': [
      \   'FileType', 'Syntax', 'Syntax', 'TermChanged', 'OptionSet'
      \ ],
      \ '[Startup and Exit]': [
      \   'VimEnter', 'GUIEnter', 'GUIFailed', 'TermResponse',
      \   'QuitPre', 'ExitPre', 'VimLeavePre', 'VimLeave'
      \ ],
      \ '[Terminal]': [
      \   'TerminalOpen', 'TerminalWinOpen'
      \ ],
      \ '[Various]': [
      \   'FileChangedShell', 'FileChangedShellPost', 'FileChangedRO',
      \   'DiffUpdated', 'DirChanged',
      \   'ShellCmdPost', 'ShellFilterPost',
      \   'CmdUndefined',
      \   'FuncUndefined',
      \   'SpellFileMissing', 'SourcePre', 'SourcePost',
      \   'VimResized', 'FocusGained', 'FocusLost', 'CursorHold', 'CursorHoldI', 'CursorMoved', 'CursorMovedI',
      \   'WinNew', 'TabNew', 'TabClosed', 'WinEnter', 'WinLeave', 'TabEnter', 'TabLeave', 'CmdwinEnter', 'CmdwinLeave',
      \   'CmdlineChanged', 'CmdlineEnter', 'CmdlineLeave',
      \   'InsertEnter', 'InsertChange', 'InsertLeave', 'InsertCharPre',
      \   'TextChanged', 'TextChangedI', 'TextChangedP', 'TextYankPost',
      \   'ColorSchemePre', 'ColorScheme',
      \   'RemoteReply',
      \   'QuickFixCmdPre', 'QuickFixCmdPost',
      \   'SessionLoadPost',
      \   'MenuPopup', 'CompleteChanged', 'CompleteDonePre', 'CompleteDone',
      \   'User',
      \ ]
      \}
