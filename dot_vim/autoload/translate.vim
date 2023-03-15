vim9script


# Interface {{{1

export def Translate(bang: string, start: number, end: number, ...argList: list<string>)
  if !executable('curl')
    throw 'curl: not found'
    return
  endif

  var ln = &fileformat == 'dos' ? "\r\n" : "\n"

  var text = GetLine(start, end, ln, argList)
  if empty(text)
    throw 'text is empty'
    return
  endif

  var cmd = CreateCommand(text, bang)

  echo 'Translating...'
  result = []

  job_start(cmd, {
    out_cb: TranslateOutCb,
    err_cb: TranslateOutCb,
    exit_cb: TranslateExitCb,
  })
enddef


# Internal {{{1

def Echo(msg: string)
  echo msg
enddef

def GetLine(start: number, end: number, ln: string, args: list<string>): string
  var textList = getline(start, end)
  if !empty(args)
    textList = args
  endif

  return join(textList, ln)
enddef

def CreateCommand(text: string, bang: string): list<string>
  var source = get(g:, 'translate_source', 'en')
  var target = get(g:, 'translate_target', 'ja')

  var cmd = ['curl', '-s', '-L', endpoint, '-d']
  if bang == '!'
    var body = json_encode({'source': target, 'target': source, 'text': text})
    cmd = cmd + [body]
  else
    var body = json_encode({'source': source, 'target': target, 'text': text})
    cmd = cmd + [body]
  endif
  return cmd
enddef

def TranslateOutCb(ch: channel, msg: string)
  add(result, msg)
enddef

def TranslateExitCb(job: job, status: number)
  CreateWindow()
enddef

def Filter(id: number, key: string): number
  if key == 'y'
    setreg(v:register, result)
    popup_close(id)
    return 1
  endif
  return 0
enddef

def CreateWindow()
  echo ''
  if empty(result)
    Echo('no translate result')
    return
  endif

  if get(g:, 'translate_popup_window', 1)
    var max_height = len(result)
    var max_width = 10
    for str in result
      var length = strdisplaywidth(str)
      if length > max_width
        max_width = length
      endif
    endfor

    if exists('*popup_atcursor')
      call popup_close(last_popup_window)

      var pos = getpos('.')

      # 2 is border thickness
      var line = 'cursor-' .. printf('%d', max_height + 2)
      if pos[1] < max_height
        line = 'cursor+1'
      endif

      last_popup_window = popup_atcursor(result, {
            \ pos: 'topleft',
            \ border: [1, 1, 1, 1],
            \ line: line,
            \ maxwidth: max_width,
            \ borderchars: ['-', '|', '-', '|', '+', '+', '+', '+'],
            \ moved: 'any',
            \ filter: Filter,
            \ })
    else
      throw 'this version doesn''t support popup or floating window'
    endif
  else
    var current = win_getid()
    var winsize = get(g:, 'translate_winsize', len(result) + 2)

    if !bufexists(translate_bufname)
      # create new buffer
      execute str2nr(winsize) .. 'new' translate_bufname
      set buftype=nofile
      set ft=translate
      nnoremap <silent> <buffer> q :<C-u>bwipeout!<CR>
    else
      # focus translate window
      var tranw = bufnr(translate_bufname)
      var winid = win_findbuf(tranw)
      if empty(winid)
        execute str2nr(winsize) .. 'new | e' translate_bufname
      else
        win_gotoid(winid[0])
      endif
    endif

    # set tranlsate result
    silent :% d _
    setline(1, result)

    win_gotoid(current)
  endif
enddef


# Initialization {{{1

var endpoint: string = get(g:, 'translate_endpoint',
  'https://script.google.com/macros/s/AKfycbywwDmlmQrNPYoxL90NCZYjoEzuzRcnRuUmFCPzEqG7VdWBAhU/exec')
var translate_bufname: string = 'translate://result'
var last_popup_window: number = 0
var result: list<string> = []

# 1}}}
