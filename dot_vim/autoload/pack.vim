vim9script


# Interface {{{1

export def Add(plugin: string, ...hooks: list<func>)
  if !argc(-1)
    plugins += len(hooks) == 0 ? [{'name': plugin}] : [{'name': plugin, 'hook': hooks[0]}]
    return
  endif

  try
    execute 'packadd!' plugin
  catch /^Vim\%((\a\+)\)\=:E919/
    echomsg v:errmsg
    return
  endtry
  if len(hooks) > 0
    RunHook({'hook': hooks[0]})
  endif
enddef

export def Remove(plugin: string)
  filter(plugins, (k, v) => v.name != plugin)
enddef

# Internal {{{1

def Emit(plugin: dict<any>)
  try
    execute 'packadd' plugin.name
  catch /^Vim\%((\a\+)\)\=:E919/
    echomsg v:errmsg
    return
  endtry
  if !has_key(plugin, 'hook') || stridx(&runtimepath, plugin.name) == -1
    return
  endif
  RunHook(plugin)
enddef

def RunHooks()
  for plugin in plugins
    if has_key(plugin, 'hook')
      RunHook(plugin)
    endif
  endfor
enddef

def RunHook(plugin: dict<any>)
  if type(plugin.hook) == v:t_func
    call plugin.hook()
  else
    execute plugin.hook
  endif
enddef

def RunDelayed()
  timer_start(10,
    (t) => empty(plugins) ? timer_stop(t) : Emit(remove(plugins, 0)),
    { repeat: -1 })
enddef

# Initialization {{{1

var plugins = []

augroup vimrc_pack_defer
  autocmd!
  autocmd VimEnter *  if !argc(-1)
        \ |   RunDelayed()
        \ | endif
augroup END

# 1}}}
