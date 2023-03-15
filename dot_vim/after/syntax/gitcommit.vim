" http://chris.beams.io/posts/git-commit/ {{{1

syntax match ErrorMsg /^\%2l.\+$/ contains=TOP
syntax match WarningMsg /\.$/ contained containedin=gitcommitSummary,gitcommitFirstLine
syntax match WarningMsg /^\l/ contained contains=@Spell containedin=gitcommitSummary
highlight link gitcommitOverflow WarningMsg

" 1}}}
