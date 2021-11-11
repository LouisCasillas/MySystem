" TODO: function to send the selection to the clipboard with xsel -b
" TODO: create keys to allow quickly switching to other tmux window
" TODO: create function to shuffle the lines of a file

" do not force vim to behave in a vi-compatible way
set nocompatible

" set the <Leader> key
let mapleader = ','

" keywordprg - program run on the current keyword when default:{ctrl+k} is pressed

" if the mkdir function is available create vim central directories and
" set the vim directories
if exists("*mkdir")
	call mkdir($HOME . "/.vim/swap/", "p", 0700)
	call mkdir($HOME . "/.vim/undo/", "p", 0700)
	call mkdir($HOME . "/.vim/backup/", "p", 0700)
	call mkdir($HOME . "/.vim/view/", "p", 0700)
	call mkdir($HOME . "/.vim/ftdetect/", "p", 0700)

	" set the directories to store all vim swap, undo, backup, and view files rather than having files wherever the corresponding files are
	set dir=~/.vim/swap/
	set undodir=~/.vim/undo/
	set backupdir=~/.vim/backup/
	set viewdir=~/.vim/view/
endif

" if this build version of vim has the autochdir option turn it on
if exists("+autochdir")
	set autochdir
endif

" my command
augroup myautocommands
	autocmd!

	"autocmd CursorHoldI * call feedkeys("\<Esc>")

	" restore the file cursor position upon re-opening the file
	autocmd BufReadPost * if (line("'\"") > 1) && (line("'\"") <= line("$")) | silent exe "silent! normal g'\"zO" | endif

	" remove trailing whitespace before saving a file
	"autocmd BufWritePre * :exe "%s/\\s*$" | ''

	" before quitting Vim check to see if the buffer has a filename and if
	" not allow Vim to quit normally without asking me for a filename
	" this has the effect of not saving the unnamed buffer which is what I
	" want as I often use a quick vim instance as a scratchpad and don't
	" want to save whatever is left
	autocmd QuitPre * let filename=expand("%") | if filename == "" | set nomodified | endif

	" make all buffer windows of equal size when the larger vim window is resized
	" TODO: keep window ratio sizes when resizing rather than using the
	" equal resize
	autocmd VimResized * :exe "normal \<C-w>="

augroup END


let g:insert_mode_auto_off = 1

function! InvertPasteMode()
	set paste!

	if g:insert_mode_auto_off == 0
		" if in insert mode and nothing is typed after 'updatetime' this will
		" exit insert mode automatically
		"autocmd myautocommands CursorHoldI * call feedkeys("\<Esc>")
		let g:insert_mode_auto_off = 1
	else
		"autocmd! myautocommands CursorHoldI
		let g:insert_mode_auto_off = 0
	endif
endfunction

" toggle paste mode
nnoremap <Leader>p :call InvertPasteMode()<Enter>

function! OpenWord()
	" get the whole word the cursor is on
	let current_Word = expand("<cWORD>")
	" try to open the word with xdg-open
	exe "!xdg-open " . current_Word
endfunction

"set wrapmargin=2
set linebreak

" have vim save a copy of a file before writing and saving the file
set backup

" have vim save the undo history of edited files so you can undo changes from previous editing session
set undofile

" tell vim to save the entire buffer into the undo history while reloading the file IF the file is less than this number of line
set undoreload=100000

" make vim write to the swap file every 20 characters vs the 200 default
set updatecount=20
" make vim write to the swap file every 2 seconds vs the 4 second default
"set updatetime=2000

" when joining multiple lines only move the cursor to the end of the first
" sentence
set cpoptions+=q

" TODO: add dictionary and thesaurus
" set dictionary=...
" set thesaurus=...

" set window options to be the same as if the window was opened with vimdiff
function! SetupDiffOptions()
	setlocal diff
	setlocal scrollbind
	setlocal cursorbind
	setlocal nowrap
	setlocal scrollopt+=hor,ver
	setlocal foldmethod=diff
	" default value, but I don't like it so leave it alone
	":set foldcolumn=2
endfunction
" create a tab with a diff of the current file and the file saved to disk
function! CreateDiffTab()
	tabnew %
	let n_filetype = &filetype
	call SetupDiffOptions()
	let n_filename = getcwd() . "/" . expand("%")
	let tmpfile = tempname()
	" sp for horizontal splits, vsp for vertical splits
	exe "sp " . tmpfile
	call SetupDiffOptions()
	exe "setlocal filetype=" . n_filetype
	exe "silent read " . n_filename
	exe "normal 0ggdd"
	set readonly
	exe "normal \<C-w>\<C-w>"
endfunction
nnoremap <silent> <Leader>d :call CreateDiffTab()<Enter>

" toggle folds recursively 
noremap <Space> zA

" toggle the whitespace symbol display
nnoremap <silent> <Leader>w :set list!<Enter>

" let vim automatically set the indentation for the whole document
nnoremap <silent> <Leader>f gg=G''

" turn off highlighting of the current search
nnoremap <silent> <Leader><Leader> :noh<Enter>

" make the q macro easier to execute and also avoid hitting Q and entering Ex
" mode
nnoremap Q @q
" make it easy to execute a macro over a visual selection
vnoremap Q :normal Q<Enter>

" make it easier to move through tab
nnoremap <S-l> gt
nnoremap <S-h> gT

" make it quicker to change pane
nnoremap <C-l> <C-w>l
nnoremap <C-h> <C-w>h
nnoremap <C-k> <C-w>W
nnoremap <C-j> <C-w>w

" make it so that movement keys treat each visible line, created by wrapping, separately rather than each actual line
noremap j gj
noremap k gk
noremap 0 g0
noremap $ g$

" make it so the tab key indents lines as in most text editors
nnoremap <Tab> >>
nnoremap <S-Tab> <<
vnoremap <Tab> >
vnoremap <S-Tab> <

" make a quick forceful save and quit
nnoremap <silent> <Leader>q :wqall!<Enter>

" make a quick save file command
nnoremap <Leader>s :w!<Enter>

" make a wordcount command
nnoremap <Leader>c :echo wordcount()<Enter>

" make it so that vim doesn't see a leading 0 as an instance of an octal
" number
set nrformats-=octal
" allow {ctrl-A} and {ctrl-X} to increment/decrement letters
"set nrformats+=alpha

" enable colorful syntax highlighting
syntax enable
" make syntax colors brighter so they are easier to see on a black background
highlight Normal ctermbg=Black ctermfg=White

" allow vim to determine what type of file is being opened and allow rules for
" that specific filetype
filetype plugin on
" allow vim to use and/or correct any indentation rules for specific file
filetype indent on

" automatically create folds based on indentation level
set foldmethod=indent

" allow the file search feature to search all sub-directories recursively so files outside the immediate directory can easily be opened
set path+=**

" netrw file browser option
" disable header banner
let g:netrw_banner=0
" open selected files in a vertical split window
let g:netrw_browse_split=1
" set the file listing to tree style
let g:netrw_liststyle=3
" end netrw file browser option

" keep context lines while scrolling
set scrolloff=5

" at the bottom of the screen show when certain commands are typed
set showcmd

" show a menu with possible options while trying to tab complete an option/filename
set wildmenu

" highlight the current line
set cursorline

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

" TODO: create keys to allow quickly switching to other tmux window

" turn off vim mouse support, I prefer letting tmux control the mouse text selection
set mouse=""

" allow vim to try writing to any file regardless of the file status, no need
" to override the writing by using !
set writeany

" always display the status bar
set laststatus=2
" setup the status line
" full file path
set statusline=%F\ 
" start printing the status line on the right
"set statusline+=%=
" show the current line number out of the total lines
set statusline+=%p%%\ 
" if the file type is set show it
set statusline+=%(%y\ %)
" if the modified and/or read-only flags are set show them
set statusline+=%(%m\ %r\ %)

" turn on line numbering
set number
" turn on relative line numbering, numbering will show the absolute line number of the current line and relative line numbers of the other line
set norelativenumber

" incremental searches - start highlighting search term after each letter typed
set incsearch
" highlight search result
set hlsearch
" string searches are case-insensitive
set ignorecase
" if a search string contains an upper-case character then the search will be case-sensitive
set smartcase

" set the bracket pairs to be used by bracket matching % and highlighting
set matchpairs={:},(:),[:],<:>

" when go to the next line keep the previous lines' indentation level
set autoindent
" tries to determine when a new code block is being started or ended and tries to maintain a proper indentation level, generally built to workwell for C
set smartindent

" show the current row and column position in the bottom right of the buffer as well as the percentage row location of the current buffer view
set ruler

" if tab is used in the first column a normal tab character will be placed
" if tab is used any other place then a symbol lookup will be performed
function! InsertTabWrapper()
	" column position starts at 1
	let column_pos = col('.')
	" getline array starts at 0, get the previous character 
	let current_char = getline('.')[column_pos - 2]
	if (column_pos > 1) && (current_char =~ '\k')
		return "\<C-n>"
	else
		return "\<Tab>"
	endif
endfunction

inoremap <silent> <Tab> <C-r>=InsertTabWrapper()<Enter>
inoremap <silent> <S-Tab> <C-p>

" Create a shortcut to quickly add templates to the current file
"nnoremap ,html :-1read $HOME/.vim/skeleton-files/html.skeleton<CR>

" while in insert mode a double space will take you to the next <++> in the document while also erasing that position holder
"inoremap <Ctrl-Space> <Escape>/<++><Enter>"_c4l

" setup HTML auto tag creation
augroup HTML_TAG
augroup END

" idea taken from: https://www.drbunsen.org/writing-in-vim/
" this function should setup vim to be in word processing mode
" :WP
"func! WordProcessorMode()
"	setlocal formatoptions=1
"	setlocal noexpandtab
"	map j gj
"	map k gk
"	setlocal spell spelllang=en_u
"	"set thesaurus+=/Users/sbrown/.vim/thesaurus/mthesaur.txt
"	set complete+=
"	set formatprg=par
"	setlocal wrap
"	setlocal linebreak
"endfu
"com! WP call WordProcessorMode()

"
"	let counter = 0
"	inoremap <expr> <C-L> ListItem()
"	inoremap <expr> <C-R> ListReset()
"
"	func ListItem()
"	  let g:counter += 1
"	  return g:counter . '. '
"	endfunc
"
"	func ListReset()
"	  let g:counter = 0
"	  return ''
"	endfunc
" on all system
