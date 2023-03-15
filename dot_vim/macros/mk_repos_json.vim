scriptencoding utf-8 

let vimson = {}
echo json_encode(vimson)
echo 'BEFORE:'

let bases = glob('~/.vim/pack/*', 1, 1) 
for basedir in bases
  if !isdirectory(basedir)
    continue
  endif
  let root = fnamemodify(basedir, ':t')
  let vimson[root] = {}
  let subdir = globpath(basedir, '*', 1, 1)
  for dir in subdir
    let node = fnamemodify(dir, ':t')
    let vimson[root][node] = []
    let repos = globpath(dir, '*', 1, 1)
    for repo in repos
      lcd `=repo`
      let url = system('git remote get-url origin')
      let vimson[root][node] += [join(split(url, '[/\n]')[-2:], '/')]
    endfor
  endfor
endfor

" call extend(vimson, {fnamemodify(dir, ':t'): {}})
echo 'AFTER:'
echo json_encode(vimson)
