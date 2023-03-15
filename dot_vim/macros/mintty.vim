scriptencoding utf-8

" in termcap mode
set t_ti& t_ti+=[1\ q
" out termcap mode
set t_te& t_te+=[0\ q
" start insert mode
set t_SI& t_SI+=[6\ q
" start replace mode
set t_SR& t_SR+=[2\ q
" End insert or replace mode
set t_EI& t_EI+=[1\ q
