vim9script

packadd! scope.vim

import autoload 'scope/popup.vim'
import autoload 'scope/util.vim'
import autoload 'scope/fuzzy.vim'

export def Zoxide(path: string = "")
  const path_e = path->empty() ? "" : $" {path}"
  const zoxide_cmd = 'zoxide query --list'
  const zoxide_list = systemlist($'{zoxide_cmd}{path_e}')->mapnew((_, v) => {
    return {text: v}
  })
  var menu: popup.FilterMenu
  menu = popup.FilterMenu.new("Zoxide Location", zoxide_list,
    (res, key) => {
      if !util.Send2Qickfix(key, menu.items_dict, menu.filtered_items[0], 'Zoxide',
          (v: dict<any>) => {
            return {filename: v.text}
          })
        execute 'cd' res.text
      endif
    },
    (winid, _) => {
      win_execute(winid, "syn match ScopeMenuDirectorySubtle '^.*[\\/]'")
      hi def link ScopeMenuSubtle Comment
      hi def link ScopeMenuDirectorySubtle ScopeMenuSubtle
    })
enddef

