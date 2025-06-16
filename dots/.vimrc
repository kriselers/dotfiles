"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" To use it, copy it to
"              for Unix: ~/.vimrc
"        for MS-Windows: $VIM\_vimrc
"
" Sections:
"    -> Plugins
"    -> General
"    -> VIM user interface
"    -> Colors and Fonts
"    -> Files and Backups
"    -> Text, tab and indent related
"    -> Visual mode related
"    -> Moving around, tabs and buffers
"    -> Editing mappings
"    -> vimgrep searching and cope displaying
"    -> Spell checking
"    -> Misc
"    -> Plugin configuration
"    -> Helper functions
"
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""


"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Plugins
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Be improved, required
set nocompatible

" Required
filetype off

" Set the runtime path to include Vundle and initialize
set rtp+=~/.vim/bundle/Vundle.vim
call vundle#begin()

" Let Vundle manage Vundle, required
Plugin 'VundleVim/Vundle.vim'

" Essential plugins
Plugin 'airblade/vim-gitgutter'
Plugin 'editorconfig/editorconfig-vim'
Plugin 'mg979/vim-visual-multi'
Plugin 'tpope/vim-fugitive'
Plugin 'scrooloose/nerdcommenter'
Plugin 'scrooloose/nerdtree'
Plugin 'machakann/vim-highlightedyank'

" UI enhancements
Plugin 'vim-airline/vim-airline'
Plugin 'vim-airline/vim-airline-themes'

" Color schemes
Plugin 'joshdick/onedark.vim'
Plugin 'morhetz/gruvbox'

" Language-specific enhancements
Plugin 'octol/vim-cpp-enhanced-highlight'

" All Plugins must be added before this line
call vundle#end()


"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => General
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
filetype plugin indent on

" Number of commands to remember in history
set history=500
" Faster completion and GitGutter refresh
set updatetime=100
" Auto reload file changes outside of Vim
set autoread
au FocusGained,BufEnter * silent! checktime
" Enable mouse support in all modes
set mouse=a
" Show absolute number on the current line
set number
" Show relative line numbers on other lines
set relativenumber
let mapleader = "\\"
" Fast save with <leader>w
nnoremap <leader>w :update<CR>


"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => VIM user interface
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Keep 7 lines above/below cursor
set so=7
" Enable enhance command-line completion
set wildmenu
set wildignore=*.o,*~,*.pyc

if has("win16") || has("win32")
    set wildignore+=.git\*,.hg\*,.svn\*
else
    set wildignore+=*/.git/*,*/.hg/*,*/.svn/*,*/.DS_Store
endif

" Show the cursor position
set ruler
" Height of the command bar
set cmdheight=1
" Allow hidden buffers
set hidden
" Backspace through everything
set backspace=indent,eol,start
" Cursor keys move to next/previous line
set whichwrap+=<,>,h,l
" Case-insensitive search...
set ignorecase
" ... unless uppercase used
set smartcase
" Highlight matches
set hlsearch
" Search as you type
set incsearch
" Don't redraw during macros
set lazyredraw
" Use 'magic' regex behavior
set magic
" Hightlight matching parens
set showmatch
" Blink duration for match
set matchtime=2
set noerrorbells novisualbell
set t_vb=
" Time to wait for mapped sequences
set timeoutlen=500
" Don't show fold column
set foldcolumn=0


"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Colors and fonts
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Enable syntax highlighting and set encoding
syntax enable
set encoding=utf-8
set fileformats=unix,dos,mac
" Set background preference
set background=dark
" Regular expression engine (0 = auto select best)
set regexpengine=0
" Gruvbox theme config
let g:gruvbox_italic='1'
let g:gruvbox_contrast_dark='medium'
" Onedark fallback config
let g:onedark_hide_endofbuffer=1
let g:onedark_terminal_italics=0

" Theme fallback logic
try
    colorscheme gruvbox
    let g:airline_theme='gruvbox'
catch /^Vim\%((\a\+)\)\=:E185/
    colorscheme onedark
    let g:airline_theme='onedark'
endtry

" GUI-specific settings
if has('gui_running')
    " Remove toolbar
    set guioptions-=T
    " Remove scrollbar
    set guioptions-=e
    " Ensure 256 color support
    set t_Co=256
    set guitablabel=%M\ %t
endif


"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Files, backups and undo
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Enable backup files
set backup
" Store backups here (// = use full path)
set backupdir=~/.vim/backups//
" Backup before overwriting a file
set writebackup
" Enable swap files (disable if using Git a lot)
set swapfile
" Store swap files here
set directory=~/.vim/swaps//
set undofile
" Store undo history here
set undodir=~/.vim/undos//
" Don't enable spell checking by default
set nospell
" Disable annoying .swp prompts when editing the same file
set shortmess+=A
" Don't create backups when editing certain files (like temp files or commits)
autocmd BufWritePre /tmp/* setlocal noundofile nobackup nowritebackup
autocmd FileType gitcommit,gitrebase setlocal noundofile nobackup nowritebackup


"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Text, tab and indent related
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Use spaces instead of tabs
set expandtab
" Number of spaces a tab counts for
set tabstop=4
" Number of spaces for autoindent
set shiftwidth=4
" Treat tab as 4 spaces while editing
set softtabstop=4
" Tab respects 'tabstop', 'shiftwidth', etc.
set smarttab
" Auto-indent new lines
set autoindent
" Smart indent based on syntax
set smartindent
" Enable filetype-based indentation
filetype plugin indent on
" Don't wrap long lines
set wrap
" Wrap lines at word boundaries (for display only)
set linebreak
" Keep indent when wrapping lines visually
set breakindent
" Character shown at the start of wrapped lines
set showbreak=↳\
" Show invisible characters (tabs, trailing spaces)
set list
set listchars=tab:»·,trail:·,extends:>,precedes:<
" Makefiles use actual tabs
autocmd FileType make setlocal noexpandtab
" 1 tab == 2 spaces for certain file types
autocmd Filetype cmake setlocal tabstop=2 shiftwidth=2
autocmd Filetype markdown setlocal tabstop=2 shiftwidth=2
autocmd Filetype json setlocal tabstop=2 shiftwidth=2
autocmd Filetype yaml setlocal tabstop=2 shiftwidth=2


"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Visual mode related
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Search for selected text using * or # (like normal mode)
vnoremap <silent> * :<C-u>let @/ = escape(@", '\\/.*$^~[]')<CR> :set hlsearch<CR>
vnoremap <silent> # :<C-u>let @/ = escape(@", '\\/.*$^~[]')<CR> :set hlsearch<CR>


"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Moving around, tabs, windows and buffers
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Map <Space> to / (search) and Ctrl-<Space> to ? (backwards search)
nnoremap <space> /
nnoremap <C-space> ?
" Disable highlight with <leader><CR>
nnoremap <silent> <leader><CR> :noh<CR>
" Smart window navigation
nnoremap <C-j> <C-W>j
nnoremap <C-k> <C-W>k
nnoremap <C-h> <C-W>h
nnoremap <C-l> <C-W>l
" Buffer management
nnoremap <leader>bd :bp\|bd #<CR>
nnoremap <leader>l :bnext<CR>
nnoremap <leader>h :bprevious<CR>
" Don't close window, when deleting a buffer
command! Bclose call <SID>BufcloseCloseIt()
" Tab management
nnoremap <leader>tn :tabnew<CR>
nnoremap <leader>to :tabonly<CR>
nnoremap <leader>tc :tabclose<CR>
nnoremap <leader>tm :tabmove
nnoremap <leader>t<leader> :tabnext<CR>
" Toggle last used tab with <leader>tl
let g:lasttab = 1
nnoremap <leader>tl :exe "tabn ".g:lasttab<CR>
au TabLeave * let g:lasttab = tabpagenr()
" Open new tab with current file's directory
nnoremap <leader>te :tabedit <C-r>=escape(expand('%:p:h'), ' ')<CR>/
" Change CWD to current buffer's directory
nnoremap <leader>cd :cd %:p:h<CR>:pwd<CR>
" Smooth buffer switching experience
set switchbuf=useopen,usetab,newtab
set stal=2
" Restore last edit position on file open
au BufReadPost * if line("'\"") > 1 && line("'\"") <= line("$") |
    \ exe "normal! g'\"" | endif


"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Editing mappings
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Remap 0 to move to first non-blank character (more intuitive)
nnoremap 0 ^

" Trim trailing whitespaces on save
if has('autocmd')
    augroup trim_whitespace_on_save
        autocmd!
        autocmd BufWritePre * call CleanExtraSpaces()
    augroup END
endif


"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Spell checking
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Pressing ,ss will toggle and untoggle spell checking
nnoremap <leader>ss :setlocal spell!<CR>
" Shortcuts using <leader>
nnoremap <leader>sn ]s
nnoremap <leader>sp [s
nnoremap <leader>sa zg
nnoremap <leader>s? z=


"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Misc
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Remove the Windows ^M - when the encoding gets messed up
noremap <leader>m mmHmt:%s/<C-V><CR>//ge<CR>'tzt'm
" Quickly open a buffer for scribble
nnoremap <leader>q :e ~/buffer<CR>
" Quickly open a markdown buffer for scribble
nnoremap <leader>x :e ~/buffer.md<CR>
" Toggle past mode on and off
nnoremap <leader>pp :setlocal paste!<CR>


"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Plugin Configuration
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"""""""""""""""""""""""""""""
" Airline
"""""""""""""""""""""""""""""
" Enable 256-color support (important for theme fidelity)
set t_Co=256
" Airline basic settings
let g:airline_powerline_fonts = 1
let g:airline_theme = 'gruvbox'
" Enable showing the current branch (requires vim-fugitive)
let g:airline#extensions#branch#enabled = 1
" Enable tabline to show open buffers at the top
let g:airline#extensions#tabline#enabled = 1
let g:airline#extensions#tabline#formatter = 'unique_tail'
let g:airline_section_b_branch = '%{airline#extensions#branch#get_head()}'
let g:airline_section_b_encoding = '%{&fileencoding}[%{&fileformat}]'
let g:airline_section_b_modified = '%m'
let g:airline_section_b = g:airline_section_b_branch . ' ' .
                        \ g:airline_section_b_modified . ' ' .
                        \ g:airline_section_b_encoding
let g:airline_section_x = '%{&filetype}'
let g:airline_section_y = ''
let g:airline_section_z = '%l:%c'


"""""""""""""""""""""""""""""
" GitGutter
"""""""""""""""""""""""""""""
nmap ]h <Plug>(GitGutterNextHunk)
nmap [h <Plug>(GitGutterPrevHunk)

"""""""""""""""""""""""""""""
" NERDTree
"""""""""""""""""""""""""""""
" Toggle NERDTree with <leader>n
nnoremap <silent> <leader>n :NERDTreeToggle<CR>

" Automatically close Vim if NERDTree is the only window left
autocmd bufenter * if (winnr("$") == 1 && &filetype == 'nerdtree') | q | endif

" Start NERDTree automatically when Vim starts without a file
autocmd StdinReadPre * let s:std_in=1
autocmd VimEnter * if argc() == 0 && !exists("s:std_in") | NERDTree | endif

" Show hidden files
let NERDTreeShowHidden=1

" Ignore files/folders (like .pyc or node_modules)
let NERDTreeIgnore = ['\.pyc$', '\~$', '\.swp$', '\.swo$', '^node_modules$', '.git', '.hg', '.svn', '\.DS_Store$']

" Enable file highlighting (requires a powerline font)
let NERDTreeMinimalUI=1
let NERDTreeDirArrows=1

"""""""""""""""""""""""""""""
" NERDCommenter
"""""""""""""""""""""""""""""
" Add spaces after comment delimiters by default
let g:NERDSpaceDelims = 1

" Allow commenting and inverting empty lines (useful when commenting a region)
let g:NERDCommentEmptyLines = 1

" Enable trimming of trailing whitespace when uncommenting
let g:NERDTrimTrailingWhitespace = 1

"""""""""""""""""""""""""""""
" EditorConfig-Vim
"""""""""""""""""""""""""""""
" Ensure plugin plays nicely with the 'fugitive' plugin
let g:EditorConfig_exclue_patterns = ['fugitive://.*']

" Disable plugin for 'gitcommit's
au FileType gitcommit let b:EditorConfig_disable = 1

"""""""""""""""""""""""""""""
" Highlightedyank
"""""""""""""""""""""""""""""
let g:highlightedyank_highlight_duration = 200

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Helper functions
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
function! <SID>BufcloseCloseIt()
    let l:currentBufNum = bufnr("%")
    let l:alternateBufNum = bufnr("#")

    if buflisted(l:alternateBufNum)
        buffer #
    else
        bnext
    endif

    if bufnr("%") == l:currentBufNum
        new
    endif

    if buflisted(l:currentBufNum)
        execute("bdelete! ".l:currentBufNum)
    endif
endfunction

" Delete trailing whitespace on save
function! CleanExtraSpaces()
    let l:save_cursor = getpos(".")
    let l:old_search = getreg('/')
    silent! %s/\s\+$//e
    call setpos('.', l:save_cursor)
    call setreg('/', l:old_search)
endfunction
