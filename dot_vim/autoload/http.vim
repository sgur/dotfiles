vim9script
# http://... のバッファを curl/wget を使って読み込む


# Interface {{{1

export def OnBufReadCmd(path: string)
  HttpGet(path, BufReadCb)
enddef

export def OnFileReadCmd(path: string)
  HttpGet(path, FileReadCb)
enddef


# Internal {{{1

def HttpGet(path: string, Fn: func)
  var view = winsaveview()
  try
    # if has('job')
    #   return webapi#http#stream({'url': a:path, 'out_cb': a:fn})
    # endif
    var ret = webapi#http#get(path)
    call(Fn, [ret])
  finally
    winrestview(view)
  endtry
enddef

def BufReadCb(response: dict<any>)
  if str2nr(response.status) != 200
    echoerr response.status response.message
  endif
  set buftype=nofile
  append(0, split(response.content, "\n"))
  if getline(1)[1] =~ '[[{]'
    setfiletype json
  endif
  if tolower(getline(1)[ : 20]) =~ '<!doctype html>'
    setfiletype html
  endif
enddef

def FileReadCb(response: dict<any>)
  if str2nr(response.status) != 200
    echoerr response.status response.message
  endif
  call append(0, split(response.content, "\n"))
enddef


# Initialization {{{1


# 1}}}
