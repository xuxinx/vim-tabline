```
  _____________
 < vim-tabline >
  -------------
         \   ^__^
          \  (oo)\_______
             (__)\       )\/\
                 ||----w |
                 ||     ||
```
# vim-tabline
Vim custom tab line with tab number.  
![vim-tabline](_assets/tabline.png)  
# Features
- tab number
- base file name(full path if has same basename tab)
- modified flag
- windows count(default disabled)

If you want more custom content like format and colors, please consider forking to modify.
See `:h setting-tabline` in vim or visit http://vimdoc.sourceforge.net/htmldoc/tabpage.html#setting-tabline for more informations.
# Installation
Vundle `Plugin 'xuxinx/vim-tabline'`
# Settings
```vim
let g:tabline_show_wins_count = 1 " show windows count, default is disabled
```
