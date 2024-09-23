" Have j and k navigate visual lines rather than logical ones
noremap j gj
noremap k gk

"  Go to beginning/end of line
noremap gs 0
noremap gh ^
noremap gl $

" Redo on 'U'
noremap U <C-r>

" Cycle between tabs
exmap tabprev obcommand workspace:previous-tab
exmap tabnext obcommand workspace:next-tab
nmap gT :tabprev
nmap gt :tabnext

" Y consistent with D and C to the end of line
nnoremap Y y$


" Have to unmap space to use it
unmap <Space>

" Yank to system clipboard
" set clipboard=unnamed
nmap <Space>y "+y
vmap <Space>y "+y
nmap <Space>d "_d
vmap <Space>d "_d


" Focus on splits
exmap fleft obcommand editor:focus-left
exmap fbottom obcommand editor:focus-bottom
exmap ftop obcommand editor:focus-top
exmap fright obcommand editor:focus-right
nmap <Space>wh :fleft
nmap <Space>wj :fbottom
nmap <Space>wk :ftop
nmap <Space>wl :fright
nmap <C-w>h :fleft
nmap <C-w>j :fbottom
nmap <C-w>k :ftop
nmap <C-w>l :fright

" Comment selection
exmap comment obcommand editor:toggle-comment
vmap gc :comment


" Splits
exmap vsplit obcommand workspace:split-vertical
exmap hsplit obcommand workspace:split-horizontal
exmap only obcommand workspace:close-others
nmap <Space>wv :vsplit
nmap <C-w>v :vsplit
nmap <C-w>s :hsplit
nnoremap <C-w>o :only

" Go to link
exmap follow obcommand editor:follow-link
nmap gf :follow

" Rename title
exmap rename obcommand workspace:edit-file-title
nmap <Space>r :rename

" Insert templates
exmap ins_temp obcommand templater-obsidian:insert-templater
nmap <Space>t :ins_temp

" Toggle file explorer
exmap tleftbar obcommand app:toggle-left-sidebar
nmap <Space>e :tleftbar

" Toggle calendar
exmap trightbar obcommand app:toggle-right-sidebar
nmap <Space>E :trightbar

" Open today's note
" exmap daily obcommand periodic-notes:open-daily-note
" nmap <Space>d :daily

" Open cmd palette
exmap cmd obcommand command-palette:open
nmap <Space>sc :cmd

" Open file search
exmap fileSearch obcommand switcher:open
nmap <Space>ff :fileSearch

exmap comment obcommand editor:toggle-comment
nmap gcc :comment
vmap gc :comment

" Focus on global search input
exmap globalSearch obcommand global-search:open
nmap <Space>fg :globalSearch

exmap wq obcommand workspace:close
exmap q obcommand workspace:close

" Maps pasteinto to Alt-p
map <A-p> :pasteinto

" Quickly remove search highlights
nmap <Space>h :nohl

" Surround
exmap surround_wiki surround [[ ]]
exmap surround_double_quotes surround " "
exmap surround_single_quotes surround ' '
exmap surround_backticks surround ` `
exmap surround_brackets surround ( )
exmap surround_square_brackets surround [ ]
exmap surround_curly_brackets surround { }
exmap surround_math surround $ $
exmap surround_italics surround * *

map [[ :surround_wiki
nunmap s
vunmap s
map s" :surround_double_quotes
map s' :surround_single_quotes
map s` :surround_backticks
map sb :surround_brackets
map s( :surround_brackets
map s) :surround_brackets
map s[ :surround_square_brackets
map s[ :surround_square_brackets
map s{ :surround_curly_brackets
map s} :surround_curly_brackets
map s$ :surround_math
map s* :surround_italics

exmap unfoldall obcommand editor:unfold-all
exmap togglefold obcommand editor:toggle-fold
exmap foldall obcommand editor:fold-all
exmap foldless obcommand editor:fold-less
exmap foldmore obcommand editor:fold-more
nmap zo :togglefold
nmap zc :togglefold
nmap za :togglefold
nmap zm :foldmore
nmap zM :foldall
nmap zr :foldless
nmap zR :unfoldall

" spell check
exmap contextMenu obcommand editor:context-menu
nmap z= :contextMenu
vmap z= :contextMenu

" colemak dh
vnoremap m h
vnoremap n j
vnoremap e k
vnoremap i l
vnoremap h m
vnoremap j e
vnoremap k n
vnoremap l i
vnoremap M H
vnoremap N J
vnoremap E K
vnoremap I L
vnoremap H M
vnoremap J E
vnoremap K N
vnoremap L I
vnoremap M ^
vnoremap I $

nnoremap m h
nnoremap n j
nnoremap e k
nnoremap i l
nnoremap h m
nnoremap j e
nnoremap k n
nnoremap l i
nnoremap M H
nnoremap N J
nnoremap E K
nnoremap I L
nnoremap H M
nnoremap J E
nnoremap K N
nnoremap L I
nnoremap M ^
nnoremap I $

nmap <Space>wm :fleft
nmap <Space>wn :fbottom
nmap <Space>we :ftop
nmap <Space>wi :fright
nmap <C-w>m :fleft
nmap <C-w>n :fbottom
nmap <C-w>e :ftop
nmap <C-w>i :fright
