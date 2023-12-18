vim9script


# Interface {{{1

# Enter巻き込み事故を防ぐ (http://goo.gl/XxVfPk) {{{2
export def OnBufWriteCmdAvoidEnterAccident(file: string)
  if !empty(&buftype)
    return
  endif
  var prompt = "Typo: really want to write to '" .. file .. "'?"
  if confirm(prompt, "yes\nno", 2) == 1
    execute 'write' file
  endif
enddef

# 保存時に空ファイルを削除する {{{2
export def OnBufWritePostDeleteEmpty(bufname: string)
  if getfsize(bufname) == 0 && bufname !~ '__init__\.py$' && confirm(printf('Delete "%s"?', bufname), "&Yes\n&No", 2) == 1
    if !delete(expand(bufname))
      execute 'bwipeout' bufname
    endif
  endif
enddef

# 保存時に自動的にディレクトリを作成する (http://goo.gl/gPl49j) {{{2
export def OnBufWriteMkdirAsNecessary(dir: string, force: bool)
  if !isdirectory(dir) && (force || confirm(printf('"%s" does not exist. Create?', dir), "&Yes\n&No", 2) == 1)
    mkdir(iconv(dir, &encoding, &termencoding), 'p')
  endif
enddef

# .git/.hg 以下のときに lcd {{{2
export def OnBufreadLcdRepoDir(dir: string)
  if tolower(dir) == tolower(fnamemodify(dir, ':h'))
    return
  endif
  var result = copy(root_pattern)->map((k, v) => join([dir, v], '/'))->filter((k, v) => !empty(glob(v, 1)))
  if !empty(result)
    lcd `=dir`
    return
  endif
  OnBufreadLcdRepoDir(fnamemodify(dir, ':h'))
enddef

# InsertLeave 時に &diff == 1 だったら表示を更新する {{{2
export def OnOptionSetDiffUpdate()
    augroup vimrc_on_insertleave_diffupdate
      autocmd!
      if v:option_new == '1'
        autocmd InsertLeave *  diffupdate
      endif
    augroup END
enddef

# 最後に編集した位置にジャンプする
export def OnBufReadPostJumpLastpos()
  if line('''"') >= 1 && line('''"') <= line('$') && &filetype != 'commit'
    normal! g`"
  endif
enddef


# Internal {{{1


# Initialization {{{1

var root_pattern = ['package.json', 'tsconfig.json', '.git', '.git/', '.hg/', '\$tf/', '*.csproj', '*.sln']


# 1}}}
