vim9script


# Interface {{{1

export def Modified(): string
  return &modified ? (emoji_enabled ? ' ⚡' : '+ ') : ''
enddef

export def Filename(): string
  return pathshorten(expand('%:.'))
enddef

export def Readonly(): string
  return &readonly ? (emoji_enabled ? ' 🔒' : 'RO') : ''
  # return &readonly ? (emoji_enabled ? '' : 'RO '): ''
enddef

export def Branchname(): string
  if !exists('b:branchname')
    return ''
  endif
  return (emoji_enabled ? ' ' : '@' ) .. b:branchname
enddef

export def VcsStat(): string
  if get(g:, 'loaded_signify', 0) && exists('b:sy') && has_key(b:sy, 'vcs') && !&readonly
    return printf('+%d,!%d,-%d', b:sy.stats[0], b:sy.stats[1], b:sy.stats[2])
  endif

  if get(g:, 'loaded_gitgutter', 0) && exists('b:gitgutter') && !empty(get(b:gitgutter, 'summary', [])) && !&readonly
    const [added, modified, removed] = gitgutter#hunk#summary(winbufnr(0))
    return printf('+%d,~%d,-%d', added, modified, removed)
  endif

  return ''
enddef

export def Getcwd(): string
  return pathshorten(getcwd())
enddef

export def Lsp(): string
  if !get(g:, 'lsp_loaded', 0)
    return ''
  endif

  const counts = lsp#get_buffer_diagnostics_counts()
  var result = []
  if counts.error
    result += ['E:' .. counts.error]
  endif
  if counts.warning
    result += ['W:' .. counts.warning]
  endif
  if counts.information
    result += ['I:' .. counts.information]
  endif
  if counts.hint
    result += ['H:' .. counts.hint]
  endif
  return join(result)
enddef

export def TabTitle(nr: number): string
  return Tabnum(nr) .. Bufname(nr) .. Winnrs(nr)
enddef


# Internal {{{1

def Detect(basedir: string) #{{{
  if !isdirectory(basedir)
    return
  endif

  const dir = getcwd()
  try
    execute 'lcd' basedir
    unlet! b:branchname
    job_start(cmd, {
      'out_cb': (ch, msg) => {
        setbufvar('%', 'branchname', msg)
        lightline#update()
      }
    })
  finally
    execute 'lcd' dir
  endtry
enddef #}}}

def Tabnum(nr: number): string
  return get(superscripts, nr, '⁺')
enddef

def Winnrs(nr: number): string
  const winnrs = tabpagewinnr(nr, '$')
  return winnrs > 1 ? '/' .. get(subscripts, winnrs, '₊') : ' '
enddef

def Bufname(nr: number): string #{{{
  const bufnr = tabpagebuflist(nr)[tabpagewinnr(nr) - 1] # winnr is 1 origin
  const name = bufname(bufnr)
  return !empty(name) ? fnamemodify(name, ':t') : '[No Name]'
enddef #}}}


# Initialization {{{1

const cmd = 'git symbolic-ref --short HEAD'

const emoji_enabled = get(get(g:, 'lightline', {}), 'emoji', v:true)

const superscripts = ['⁰', '¹', '²', '³', '⁴', '⁵', '⁶', '⁷', '⁸', '⁹']
const subscripts = ['₀', '₁', '₂', '₃', '₄', '₅', '₆', '₇', '₈', '₉']

augroup vimrc_plugin_lightline_9
  autocmd!
  autocmd BufNewFile,BufReadPost * call Detect(expand('<amatch>:p:h'))
  autocmd BufEnter * call Detect(expand('%:p:h'))
augroup END

defcompile

# 1}}}
