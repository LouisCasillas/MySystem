" TODO:
" If saving a file in a directory that doesn't exist then create it first
" before saving the file

""" Set options
" do not force vim to behave in a vi-compatible way
set nocompatible

" set the <Leader> key
let mapleader = ','

" set tab to 2 spaces
set tabstop=2
set shiftwidth=2
set noexpandtab

" have vim save a copy of a file before writing and saving the file
set backup

" have vim save the undo history of edited files so you can undo changes from previous editing sessions
set undofile

" tell vim to save the entire buffer into the undo history while reloading the file IF the file is less than this number of line
set undoreload=100000

" allow this many changes to be undone
set undolevels=100000

" make vim write to the swap file every 20 characters vs the 200 default
set updatecount=20

" when joining multiple lines only move the cursor to the end of the first
" sentence
set cpoptions+=q

" make it so that vim doesn't see a leading 0 as an instance of an octal
" number
set nrformats-=octal
" allow {ctrl-A} and {ctrl-X} to increment/decrement letters
"set nrformats+=alpha

" allow vim to determine what type of file is being opened and allow rules for
" that specific filetype
filetype plugin on
" allow vim to use and/or correct any indentation rules for specific file
filetype indent on

""" netrw file browser options
" disable header banner
let g:netrw_banner=0
" open selected files in a horizontal split window
let g:netrw_browse_split=1
" set the file listing to tree style
let g:netrw_liststyle=3
" end netrw file browser option
""" end netrw file browser options

" keep context lines while scrolling
set scrolloff=5

" turn off vim mouse support, I prefer letting tmux control the mouse text selection
set mouse=""

" allow vim to try writing to any file regardless of the file status, no need
" to override the writing by using !
set writeany

" always display the status bar
set laststatus=2

" turn on line numbering
set number
" turn on relative line numbering, numbering will show the absolute line number of the current line and relative line numbers of the other line
set norelativenumber

" string searches are case-insensitive
set ignorecase
" if a search string contains an upper-case character then the search will be case-sensitive
set smartcase

" set the bracket pairs to be used by bracket matching % and highlighting
set matchpairs={:},(:),[:],<:>

" when going to the next line keep the previous lines' indentation level
set autoindent

" incremental searches - start highlighting search term after each letter typed
set incsearch
" highlight search results
set hlsearch

" allow the file search feature to search all sub-directories recursively so files outside the immediate directory can easily be opened
set path+=**

" do not show when certain commands are typed nor the size of visual selections
set noshowcmd

" if this build version of vim has the autochdir option turn it on
if exists("+autochdir")
    set autochdir
endif

if exists("+linebreak")
    " vim will automatically break lines and wrap them to the next line
    "set linebreak
    " if possible vim starts wrapping the line when within 2 characters of the edge
    "set wrapmargin=2
    " the hard character limit for wrapping lines
    "set textwidth=80
endif

if exists("+syntax")
    " enable colorful syntax highlighting
    syntax enable
    " make syntax colors brighter so they are easier to see on a black background
    highlight Normal ctermbg=Black ctermfg=White

    " highlight the current line
    set cursorline
endif

if exists("+foldmethod")
    " automatically create folds based on indentation level
    set foldmethod=indent
endif

" do not show the current row and column position in the status line because I
" set my own rules below
set noruler

if exists("+wildmenu")
    " show a menu above the command line with possible file navigation options
    set wildmenu
endif

if exists("+statusline")
    " set the status line
    " full file path
    set statusline=%F\ 
    " show the current line number out of the total lines
    set statusline+=%l\ of\ %L\ 
    " if the file type is set show it
    set statusline+=%(%y\ %)
    " if the modified and/or read-only flags are set show them
    set statusline+=%(%m\ %r\ %)
endif

if exists("+smartindent")
    " tries to determine when a new code block is being started or ended and
    " tries to maintain a proper indentation level, generally built to work well for C
    set smartindent
endif
""" End set options

""" Commands
" if the mkdir function is available create vim central directories and
" set the vim directories
if exists("*mkdir")
    call mkdir($HOME . "/.vim/swap/", "p", 0700)
    call mkdir($HOME . "/.vim/undo/", "p", 0700)
    call mkdir($HOME . "/.vim/backup/", "p", 0700)
    call mkdir($HOME . "/.vim/view/", "p", 0700)
    call mkdir($HOME . "/.vim/ftdetect/", "p", 0700)

    " set standard directories to store all vim swap, undo, backup, and view files
    set dir=~/.vim/swap/
    set undodir=~/.vim/undo/
    set backupdir=~/.vim/backup/
    set viewdir=~/.vim/view/
endif

" auto commands that are run during certain stages of file editing
augroup myautocommands
    autocmd!

    " open all folds when opening a file
    autocmd BufReadPost * silent :exe "normal zR"

    " restore the file cursor position upon re-opening the file
    autocmd BufReadPost * if (line("'\"") > 1) && (line("'\"") <= line("$")) | silent exe "silent! normal g'\"zO" | endif

    " make all buffer windows of equal size when the larger vim window is resized
    autocmd VimResized * :exe "normal \<C-w>="
augroup END
""" End commands

""" Functions
" set window options to be the same as if the window was opened with vimdiff
function! SetupDiffOptions()
    setlocal diff
    setlocal scrollbind
    setlocal cursorbind
    setlocal nowrap
    setlocal scrollopt+=hor,ver
    setlocal foldmethod=diff
endfunction

" create a tab with a diff of the current file and the file saved to disk
function! CreateDiffTab()
    tabnew %
    let n_filetype = &filetype
    call SetupDiffOptions()
    let n_filename = getcwd() . "/" . expand("%")
    let tmpfile = tempname()
    " sp for horizontal splits, vsp for vertical splits
    exe "vsp " . tmpfile
    call SetupDiffOptions()
    exe "setlocal filetype=" . n_filetype
    exe "silent read " . n_filename
    exe "setlocal readonly"
    exe "normal 0ggdd"
    exe "w!"
    exe "normal \<C-w>\<C-w>"
endfunction
""" End functions

"" Remaps
" TODO: create help screen that shows my key commands
nnoremap <silent> <Leader>d :call CreateDiffTab()<Enter>

" toggle folds on the current line recursively 
noremap <Space> zA

" toggle the whitespace symbol display
nnoremap <silent> <Leader>w :set list!<Enter>

" let vim automatically set the indentation for the whole document
nnoremap <silent> <Leader>i gg=G''

" turn off highlighting of the current search
nnoremap <silent> <Leader><Leader> :noh<Enter>

" avoid hitting Q and entering Ex
nnoremap Q <Nop>

" make it easier to move through tabs
nnoremap <S-l> gt
nnoremap <S-h> gT

" make it quicker to change panes
nnoremap <C-l> <C-w>l
nnoremap <C-h> <C-w>h
nnoremap <C-k> <C-w>W
nnoremap <C-j> <C-w>w

" make it so that movement keys treat each visible line, created by wrapping, separately rather than each actual line
noremap j gj
noremap k gk
noremap 0 g0
noremap $ g$

" create a quick map to go back to the last edited line
noremap gl '.

" make a quick forceful quit
nnoremap <silent> <Leader>Q :qall!<Enter>
" make a quick forceful save and quit
nnoremap <silent> <Leader>q :wqall!<Enter>

" make a quick save file command
nnoremap <Leader>s :w!<Enter>

" make a wordcount command
nnoremap <Leader>c :echo wordcount()<Enter>

" turn off arrow keys except while in insert mode
map <Left> <NOP>
map <Right> <NOP>
map <Up> <NOP>
map <Down> <NOP>

" make the arrow keys resize the current buffer
nmap <silent> <Left> :vertical resize -5<Enter>
nmap <silent> <Right> :vertical resize +5<Enter>
nmap <silent> <Up> :resize +5<Enter>
nmap <silent> <Down> :resize -5<Enter>

" paste the yank register, nice to use if you yanked text and then deleted
" other text before you wanted to use the yanked text
nmap <C-P> "0P
" toggle paste mode
nnoremap <silent> <Leader>p :set paste! <Enter>

" delete a whole word under the cursor or directly in-front of the cursor
nnoremap <silent> <Leader>x daW
"" End remaps
