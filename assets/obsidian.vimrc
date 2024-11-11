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
nmap gT :tabprev<CR>
nmap gt :tabnext<CR>

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
nmap <Space>wh :fleft<CR>
nmap <Space>wj :fbottom<CR>
nmap <Space>wk :ftop<CR>
nmap <Space>wl :fright<CR>
nmap <C-w>h :fleft<CR>
nmap <C-w>j :fbottom<CR>
nmap <C-w>k :ftop<CR>
nmap <C-w>l :fright<CR>

" Comment selection
exmap comment obcommand editor:toggle-comment
vmap gc :comment<CR>


" Splits
exmap vsplit obcommand workspace:split-vertical
exmap hsplit obcommand workspace:split-horizontal
exmap only obcommand workspace:close-others
nmap <Space>wv :vsplit<CR>
nmap <C-w>v :vsplit<CR>
nmap <C-w>s :hsplit<CR>
nnoremap <C-w>o :only<CR>

" Go to link
exmap follow obcommand editor:follow-link
nmap gf :follow<CR>

" Rename title
exmap rename obcommand workspace:edit-file-title
nmap <Space>r :rename<CR>

" Insert templates
exmap ins_temp obcommand templater-obsidian:insert-templater
nmap <Space>t :ins_temp<CR>

" Toggle file explorer
exmap tleftbar obcommand app:toggle-left-sidebar
nmap <Space>e :tleftbar<CR>

" Toggle calendar
exmap trightbar obcommand app:toggle-right-sidebar
nmap <Space>E :trightbar<CR>

" Open today's note
" exmap daily obcommand periodic-notes:open-daily-note
" nmap <Space>d :daily

" Open cmd palette
exmap cmd obcommand command-palette:open
nmap <Space>sc :cmd<CR>

" Open file search
exmap fileSearch obcommand switcher:open
nmap <Space>ff :fileSearch<CR>

exmap comment obcommand editor:toggle-comment
nmap gcc :comment<CR>
vmap gc :comment<CR>

" Focus on global search input
exmap globalSearch obcommand global-search:open
nmap <Space>fg :globalSearch<CR>

exmap wq obcommand workspace:close
exmap q obcommand workspace:close

" Maps pasteinto to Alt-p
map <A-p> :pasteinto<CR>

" Quickly remove search highlights
nmap <Space>h :nohl<CR>

exmap back obcommand app:go-back
nmap <C-o> :back<CR>
exmap forward obcommand app:go-forward
nmap <C-i> :forward<CR>

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

map [[ :surround_wiki<CR>
nunmap s
vunmap s
map s" :surround_double_quotes<CR>
map s' :surround_single_quotes<CR>
map s` :surround_backticks<CR>
map sb :surround_brackets<CR>
map s( :surround_brackets<CR>
map s) :surround_brackets<CR>
map s[ :surround_square_brackets<CR>
map s[ :surround_square_brackets<CR>
map s{ :surround_curly_brackets<CR>
map s} :surround_curly_brackets<CR>
map s$ :surround_math<CR>
map s* :surround_italics<CR>

exmap unfoldall obcommand editor:unfold-all
exmap togglefold obcommand editor:toggle-fold
exmap foldall obcommand editor:fold-all
exmap foldless obcommand editor:fold-less
exmap foldmore obcommand editor:fold-more
nmap zo :togglefold<CR>
nmap zc :togglefold<CR>
nmap za :togglefold<CR>
nmap zm :foldmore<CR>
nmap zM :foldall<CR>
nmap zr :foldless<CR>
nmap zR :unfoldall<CR>

" spell check
exmap contextMenu obcommand editor:context-menu
nmap z= :contextMenu<CR>
vmap z= :contextMenu<CR>

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

nmap <Space>wm :fleft<CR>
nmap <Space>wn :fbottom<CR>
nmap <Space>we :ftop<CR>
nmap <Space>wi :fright<CR>
nmap <C-w>m :fleft<CR>
nmap <C-w>n :fbottom<CR>
nmap <C-w>e :ftop<CR>
nmap <C-w>i :fright<CR>
