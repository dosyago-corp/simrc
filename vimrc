"-------------------------------------------------------------
" Options
"-------------------------------------------------------------

" 1 important
set nocompatible
set nopaste

" 2 moving around, searching and patterns
set startofline
set incsearch
set magic
set ignorecase
set smartcase

" 3 tags

" 4 displaying text
set scrolloff=8
set sidescrolloff=10
set fillchars=
" set lazyredraw
set number
set relativenumber

" 5 syntax, highlighting and spelling
syntax on
set background=dark
set hlsearch
set nocursorline

" 6 multiple windows
set laststatus=2
set hidden

" 7 multiple tab pages

" 8 terminal
set term=xterm-256color
set ttyfast

" 9 using the mouse
set mouse-=a

" 10 printing

" 11 messages and info
set shortmess=atIq
set showcmd
set showmode
set ruler
set report=0

" 12 selecting text
set clipboard=unnamed

" 13 editing text
set undolevels=1024
set noundofile
set backspace=indent,eol,start
set matchpairs=(:),{:},[:]

" 14 tabs and indenting
set tabstop=4
set shiftwidth=4
set smarttab
set softtabstop=4
set shiftround
set expandtab
set autoindent
set smartindent

" 15 folding
" 16 diff mode
" 17 mapping

" 18 reading and writing files
set write
set writebackup
set nobackup
set noautowrite
set nowriteany
set autoread
set fsync

" 19 the swap file
set noswapfile

" 20 command line editing
set history=1024
set wildignore=*.o,*.obj,*.swp,*.pyc,*.bak,*.tmp
set wildmenu

" 21 executing external commands
" 22 running make and jumping to errors
" 23 language specific

" 24 multi-byte characters
set encoding=utf-8
set ambiwidth=single

" 25 various
set loadplugins
set viminfo='64,\"128,:64,%,n~/.viminfo

" terms options
set t_ti=
set t_te=
set ffs=unix,dos,mac
set scrolljump=5

"-------------------------------------------------------------
" KeyMaps
"-------------------------------------------------------------

let mapleader = ','
filetype plugin indent on

" Key Maps
nnoremap <Leader>w <Esc>:w<CR>
nnoremap <Leader>q <Esc>:q<CR>
inoremap <Leader>w <Esc>:w<CR>
inoremap <Leader>q <Esc>:q<CR>

inoremap <C-a> <Esc><S-i>
nnoremap <C-a> <Esc><S-i>
cnoremap <C-a> <Home>
inoremap <C-e> <Esc><S-a>
nnoremap <C-e> <Esc><S-a>
cnoremap <C-e> <End>

nnoremap <C-f> <Right>
nnoremap <C-b> <Left>
inoremap <C-f> <Right>
inoremap <C-b> <Left>
cnoremap <C-f> <Right>
cnoremap <C-b> <Left>

nnoremap <C-o> o
inoremap <C-o> <Esc>o
nnoremap <C-j> O
inoremap <C-j> <Esc>O

vnoremap > >gv
vnoremap < <gv
xnoremap p pgvy

nnoremap ; :!
nnoremap H ^
nnoremap L $
nnoremap U <C-r>
nnoremap <Leader>/ :nohls<CR>

function! BufferCount() abort
    return len(filter(range(1, bufnr('$')), 'buflisted(v:val)'))
endfunction

function! LocationListWindonwToggle() abort
    let buffer_count_before = BufferCount()
    silent! lclose
    silent! lclose

    if BufferCount() == buffer_count_before
        execute "silent! lopen"
    endif
endfunction

nnoremap <Leader>tl :call LocationListWindonwToggle()<CR>
nnoremap <Leader>jj :lnext<CR>
nnoremap <Leader>kk :lpre<CR>

"-------------------------------------------------------------
" Events
"-------------------------------------------------------------

augroup highlight_overlength
    autocmd!
    autocmd BufEnter * highlight OverLength ctermbg=15
    autocmd BufEnter,BufWrite,TextChanged,TextChangedI,InsertEnter,InsertLeave * match OverLength /\%<81v.\%>80v/
augroup END

function! RestoreCursor()
    if line("'\"") <= line("$")
        normal! g`"
        return 1
    endif
endfunction

augroup restoreCursor
    autocmd!
    autocmd BufWinEnter * call RestoreCursor()
augroup END

"-------------------------------------------------------------
" Plugins
"-------------------------------------------------------------

if empty(glob('~/.vim/autoload/plug.vim'))
    silent !curl -fLo ~/.vim/autoload/plug.vim --create-dirs
        \ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
    autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
endif

call plug#begin('~/.vim/bundle')

" Efficiency
Plug 'w0rp/ale'
Plug 'Valloric/YouCompleteMe', {'dir': '~/.vim/bundle/YouCompleteMe', 'do': './install.py'}
Plug '/usr/local/opt/fzf' | Plug 'junegunn/fzf.vim'
Plug 'scrooloose/nerdcommenter'
Plug 'tpope/vim-repeat' | Plug 'tpope/vim-surround'
Plug 'easymotion/vim-easymotion'
Plug 'Raimondi/delimitMate'
Plug 'bronson/vim-trailing-whitespace'

" Display
Plug 'altercation/vim-colors-solarized'
Plug 'tpope/vim-fugitive' | Plug 'vim-airline/vim-airline' | Plug 'vim-airline/vim-airline-themes'
Plug 'scrooloose/nerdtree' | Plug 'jistr/vim-nerdtree-tabs' | Plug 'Xuyuanp/nerdtree-git-plugin'
Plug 'kien/rainbow_parentheses.vim'

" Languages
Plug 'fatih/vim-go', {'for': 'go', 'do': ':GoInstallBinaries'}
Plug 'shiyanhui/vim-slash'

call plug#end()

function! AleConfig()
    let g:ale_linters = {
    \   'go': ['gofmt', 'go build'],
    \   'c': ['clang'],
    \}
    let g:ale_lint_on_text_changed = 'never'
    let g:ale_lint_on_enter = 0
    let g:ale_c_clang_options = "std=c11 -Wno-everything"
    let g:ale_cpp_clang_options = "-std=c++14 -Wno-everything"

    nnoremap <Leader>ta :ALEToggle<CR>
endfunction

function! YouCompleteMeConfig()
    let g:ycm_complete_in_comments = 1
    let g:ycm_collect_identifiers_from_comments_and_strings = 1
    let g:ycm_collect_identifiers_from_tags_files = 1
    let g:ycm_add_preview_to_completeopt = 1
    let g:ycm_autoclose_preview_window_after_completion = 1
    let g:ycm_autoclose_preview_window_after_insertion = 1
    let g:ycm_seed_identifiers_with_syntax = 1

    nnoremap <Leader>gd :YcmCompleter GoToDeclaration<CR>
endfunction

function! FzfConfig()
    nnoremap <Leader>f :Files<CR>
    nnoremap <Leader>b :Buffers<CR>
    nnoremap <Leader>ag :Ag<CR>
    nnoremap <Leader>t :Tags<CR>

    let g:fzf_history_dir = '~/.local/share/fzf-history'
    let g:fzf_layout = { 'down': '~40%' }
    let g:fzf_buffers_jump = 1
    let g:fzf_commits_log_options = '--graph --color=always --format="%C(auto)%h%d %s %C(black)%C(bold)%cr"'
    let g:fzf_tags_command = 'ctags -R'
    let g:fzf_commands_expect = 'alt-enter,ctrl-x'

    command! -bang -nargs=* Ag
    \    call fzf#vim#ag(
    \        <q-args>,
    \        <bang>0 ? fzf#vim#with_preview('up:60%') : fzf#vim#with_preview('right:50%:hidden', '?'),
    \        <bang>0)

    command! -bang -nargs=* Rg
    \    call fzf#vim#grep(
    \        'rg --column --line-number --no-heading --color=always --smart-case '.shellescape(<q-args>), 1,
    \        <bang>0 ? fzf#vim#with_preview('up:60%') : fzf#vim#with_preview('right:50%:hidden', '?'),
    \        <bang>0)

    command! -bang -nargs=? -complete=dir Files
    \    call fzf#vim#files(<q-args>, fzf#vim#with_preview(), <bang>0)
endfunction

function! NERDCommenterConfig()
    let g:NERDSpaceDelims = 1
    let g:NERDTrimTrailingWhitespace = 1
    let g:NERDToggleCheckAllLines = 1
endfunction

function! EasyMotionConfig()
    let g:EasyMotion_smartcase = 1

    nmap <Leader>h <Plug>(easymotion-linebackward)
    nmap <Leader>j <Plug>(easymotion-j)
    nmap <Leader>k <Plug>(easymotion-k)
    nmap <Leader>l <Plug>(easymotion-lineforward)
endfunction

function! DelimitMateConfig()
    let g:delimitMate_expand_cr = 1
    let g:delimitMate_expand_space = 1
endfunction

function! TrailingWhiteSpaceConfig()
    nnoremap <Leader><Space> :FixWhitespace<CR>
endfunction

function! SolarizedConfig()
    silent! colorscheme solarized
    let g:solarized_contrast = "normal"
    let g:solarized_visibility = "normal"

    highlight LineNr ctermbg=NONE guibg=NONE
    highlight SignColumn ctermbg=NONE guibg=NONE
endfunction

function! AirlineConfig()
    let g:airline_powerline_fonts = 1
    let g:airline_solarized_bg = 'dark'
    let g:airline_theme = 'solarized'
    let g:airline_skip_empty_sections = 1
endfunction

function! NERDTreeConfig()
    nnoremap <Leader><Tab> :NERDTreeToggle<CR>
    let g:NERDTreeIgnore = []
    let g:NERDTreeCascadeSingleChildDir = 0
    let g:NERDTreeSortHiddenFirst = 1
    let g:NERDTreeAutoDeleteBuffer = 1
endfunction

function! RainbowParenthesesConfig()
    let g:rbpt_max = 16
    let g:rbpt_loadcmd_toggle = 0
    let g:rbpt_colorpairs = [
        \ ['brown',       'RoyalBlue3'],
        \ ['Darkblue',    'SeaGreen3'],
        \ ['darkgray',    'DarkOrchid3'],
        \ ['darkgreen',   'firebrick3'],
        \ ['darkcyan',    'RoyalBlue3'],
        \ ['darkred',     'SeaGreen3'],
        \ ['darkmagenta', 'DarkOrchid3'],
        \ ['brown',       'firebrick3'],
        \ ['gray',        'RoyalBlue3'],
        \ ['darkmagenta', 'DarkOrchid3'],
        \ ['Darkblue',    'firebrick3'],
        \ ['darkgreen',   'RoyalBlue3'],
        \ ['darkcyan',    'SeaGreen3'],
        \ ['darkred',     'DarkOrchid3'],
        \ ['red',         'firebrick3'],
        \ ]

    augroup rainbow_parentheses
        autocmd!
        autocmd VimEnter * silent! RainbowParenthesesToggle
        autocmd Syntax * silent! RainbowParenthesesLoadRound
        autocmd Syntax * silent! RainbowParenthesesLoadSquare
        autocmd Syntax * silent! RainbowParenthesesLoadBraces
    augroup END
endfunction

function! VimGoConfig()
    let g:go_highlight_extra_types = 1
    let g:go_highlight_operators = 1
    let g:go_highlight_functions = 1
    let g:go_highlight_function_arguments = 1
    let g:go_highlight_function_calls = 1
    let g:go_highlight_types = 1
    let g:go_highlight_fields = 1
    let g:go_highlight_build_constraints = 1
    let g:go_highlight_generate_tags = 1
    let g:go_highlight_format_strings = 1

    filetype detect
endfunction

call AleConfig()
call YouCompleteMeConfig()
call FzfConfig()
call NERDCommenterConfig()
call EasyMotionConfig()
call DelimitMateConfig()
call TrailingWhiteSpaceConfig()
call SolarizedConfig()
call AirlineConfig()
call NERDTreeConfig()
call RainbowParenthesesConfig()
call VimGoConfig()
