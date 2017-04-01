" Maintainer: Huang Wenwen <huangww87@gmail.com>
" Version: 2.0
" Last Change: Thu Mar 16 17:56:44 CET 2017
"
" Tip:
" If you find anything that you can't understand than do this:
" help keyword OR helpgrep keyword
" Example:
" Go into command-line mode and type helpgrep nocompatible, ie.
" :helpgrep nocompatible
" then press <leader>c to see the results, or :botright cw
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

""""""""""""""""""""""""""""""""""""""""""
" => vim-plug, the plugin manager, add plugins
""""""""""""""""""""""""""""""""""""""""""
" Automatic installation if not installed
if empty(glob('~/.vim/autoload/plug.vim'))
  silent !curl -fLo ~/.vim/autoload/plug.vim --create-dirs
    \ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
  autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
endif

" plugin installed
call plug#begin('~/.vim/plugged')
Plug 'altercation/vim-colors-solarized'
Plug 'bling/vim-airline'
Plug 'w0rp/ale'
Plug 'kien/ctrlp.vim'
Plug 'tomtom/tcomment_vim'
Plug 'SirVer/ultisnips'
Plug 'honza/vim-snippets'
Plug 'tpope/vim-surround'
Plug 'LaTex-Box-Team/LaTex-Box'
Plug 'majutsushi/tagbar'
Plug 'xolox/vim-misc'
Plug 'xolox/vim-easytags'
Plug 'easymotion/vim-easymotion'
Plug 'Valloric/YouCompleteMe', { 'do': './install.py --clang-completer' }

call plug#end()

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => General
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

" Sets how many lines of history VIM has to remember
set history=100

" Set the character encoding
set encoding=utf-8

"Turn backup off
set nobackup
set nowb

" auto save when change buffer
set autowriteall

" use the system clipboard
set clipboard+=unnamed

" Have the mouse enabled all the time:
set mouse=n

" set tab expanding and width
set expandtab tabstop=8 shiftwidth=4 softtabstop=4

"Set mapleader
let mapleader = ","
let g:mapleader = ","

"Set to auto read when a file is changed from the outside
set autoread
nmap <silent> <leader>e :edit!<CR>

"Fast editing of .vimrc
map <silent> <leader>ee :tabnew ~/.vimrc<cr>
"When .vimrc is edited, reload it
autocmd! bufwritepost $MYVIMRC source %

"Jump to the last position when reopening a file
if has("autocmd")
    au BufReadPost * if line("'\"") > 1 && line("'\"") <= line("$") | exe "normal! g'\"" | endif
endif

"set the location of .swp file
if has("win32") || has("win64")
    set directory=$TMP
else
    set directory=~/tmp
end 

""""""""""""""""""""""""""""
" => Colors and Font
""""""""""""""""""""""""""""
"Enable syntax hl
syntax on

"Enable search hl and incremental search
set hlsearch
set incsearch
set ignorecase
set smartcase
" Map <Alt-/> for search in visual mode
vnoremap <A-/> <Esc>/\%V
" for mac
vnoremap ÷ <Esc>/\%V

"Highlight cursor line
set cursorline

" color scheme
set background=light
colorscheme solarized
let g:solarized_termcolors= 256
let g:solarized_termtrans = 1

" set guifont
set guifont=Monaco:h16

""""""""""""""""""""""""""""
" => VIM user interface
""""""""""""""""""""""""""""
"Set 7 lines to the cursors - when moving vertical..
set so=7

"Turn on WiLd menu
set wildmenu

"Always show current position
set ruler

"Set backspace
set backspace=eol,start,indent

" Set line number
set number
set relativenumber

"show matching bracket
set showmatch


"""""""""""""""""""""""""""
" => Folding
"""""""""""""""""""""""""""
"Enable folding
set foldenable
set foldlevel=99
set foldmethod=syntax
" au BufReadPre * setlocal foldmethod=syntax
" au BufWinEnter * if &fdm == 'syntax' | setlocal foldmethod=manual | endif
" au BufWinLeave * mkview
" au BufWinEnter * silent loadview


"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Filetype generic
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

""""""""""""""""""""""""""""""
" => Fortran 
""""""""""""""""""""""""""""""
let s:extfname = expand("%:e")
if s:extfname ==? "f"
    let fortran_fixed_source=1
    unlet! fortran_free_source
else
    let fortran_free_source=1
    unlet! fortran_fixed_source
endif

" let fortran_free_source=1
let fortran_more_precise=1
let fortran_do_enddo=1
let fortran_have_tabs=1

" " Fold settings
let fortran_fold=1
" "set foldlevelstart=99

" set error format for gfortran
set efm+=%E%f:%l.%c:,%E%f:%l:,%C,%C%p%*[0123456789^],%ZError:\ %m,%C%.%#

""""""""""""""""""""""""""""""
" => Map to run single file
""""""""""""""""""""""""""""""
autocmd FileType python nnoremap <silent> <leader>rr :w<CR> :!python  %<CR>
autocmd FileType sh nnoremap <silent> <leader>rr :w<CR> :!./%<CR>


"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Plugin configuration
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
""""""""""""""""""""""""""""""
" => LaTeX-Box settings
""""""""""""""""""""""""""""""
let g:tex_flavor = "latex"
let maplocalleader = ","
autocmd BufNewFile,BufRead *.tex nnoremap <buffer> <LocalLeader>ll :update!<CR>:Latexmk!<CR>

autocmd BufNewFile,BufRead *.tex set spell 
" if !exists("*SetTexYcm")
function! SetTexYcm()
    if !exists('g:ycm_semantic_triggers')
        let g:ycm_semantic_triggers = {}
    endif
                " \ 're!\\[A-Za-z]*(ref|cite)[A-Za-z]*([^]]*])?{([^}]*,?)*',
    let g:ycm_semantic_triggers.tex = [
                \ 're!\\[A-Za-z]*ref[A-Za-z]*([^]]*])?{([^}]*,?)*',
                \ 're!\\includegraphics([^]]*])?{[^}]*',
                \ 're!\\(include|input){[^}]*'
                \ ]
endfunction
" endif
autocmd BufNewFile,BufRead *.tex call SetTexYcm()
let g:LatexBox_show_warnings=0

let g:LatexBox_viewer = "open -a Skim"
" To enable Inverse Search
let g:LatexBox_latexmk_options =
            \ '-pdflatex="pdflatex -synctex=1 %O %S"'
map <silent> <Leader>ls :silent
            \ !/Applications/Skim.app/Contents/SharedSupport/displayline
            \ <C-R>=line('.')<CR> "<C-R>=LatexBox_GetOutputFile()<CR>"
            \ "%:p" <CR>
" cmd+shift+click for inverse search in skim

""""""""""""""""""""""""""""""
" => A.L.E. settings
""""""""""""""""""""""""""""""
" navigate between errors quickly
nmap <silent> <C-k> <Plug>(ale_previous_wrap)
nmap <silent> <C-j> <Plug>(ale_next_wrap)
" format for echo messagesg
let g:ale_echo_msg_error_str = 'E'
let g:ale_echo_msg_warning_str = 'W'
let g:ale_echo_msg_format = '[%linter%] %s [%severity%]'


""""""""""""""""""""""""""""""
" => ctrlp settings
""""""""""""""""""""""""""""""
" open file in new tab by default
let g:ctrlp_prompt_mappings = {
            \ 'AcceptSelection("e")': ['<c-t>'],
            \ 'AcceptSelection("t")': ['<cr>', '<2-LeftMouse>'],
            \ }

" Exclude files 
" MacOSX/Linux
set wildignore+=*/tmp/*,*.so,*.swp,*.zip,*.out,*.o,*.mod,*.pyc,*.pdf,*.gz,*.aux,*.blg,*.fls,*.png,*.jpg

" Windows
set wildignore+=*\\tmp\\*,*.swp,*.zip,*.exe,*.pdf

" Exclude files only for ctrlp
if exists("g:ctrlp_custom_ignore")
    unlet g:ctrlp_custom_ignore
endif
let g:ctrlp_custom_ignore = {
            \ 'dir':  '\v[\/](data/.*)$',
            \ 'file': '\v\.(exe|so|dll)$',
            \ 'link': 'SOME_BAD_SYMBOLIC_LINKS',
            \ }
" shortcut map for ctrlp
nnoremap <silent> <Leader>t :ClearCtrlPCache<cr>\|:CtrlP<cr>

""""""""""""""""""""""""""""""
" => UltiSnips settings
""""""""""""""""""""""""""""""
" Trigger configuration. Do not use <tab> if you use
" https://github.com/Valloric/YouCompleteMe.
let g:UltiSnipsExpandTrigger="<c-j>"
let g:UltiSnipsJumpForwardTrigger="<c-j>"
let g:UltiSnipsJumpBackwardTrigger="<c-k>"

" If you want :UltiSnipsEdit to split your window.
let g:UltiSnipsEditSplit="vertical"

""""""""""""""""""""""""""""""
" => YouCompleteMe settings
""""""""""""""""""""""""""""""
let g:ycm_global_ycm_extra_conf = '~/.vim/plugged/YouCompleteMe/.ycm_extra_conf.py'
let g:ycm_autoclose_preview_window_after_completion = 1
let g:ycm_collect_identifiers_from_tags_files = 1

let g:ycm_key_invoke_completion = '<C-Tab>'
" use omnicomplete whenever there's no completion engine in youcompleteme
set omnifunc=syntaxcomplete#Complete

nnoremap <silent> <leader>jj :YcmCompleter GoTo<CR>
nnoremap <silent> <leader>hh :YcmCompleter GetDoc<CR>

""""""""""""""""""""""""""""""
" airline settings
" """""""""""""""""""""""""""""
set laststatus=2
" let g:airline_theme = 'solarized light'
" let g:airline_powerline_fonts = 1
" let g:airline#extensions#tabline#enabled = 1
let g:airline#extensions#tabline#show_buffers = 1
  let g:airline#extensions#syntastic#enabled = 1

" unicode symbols
if !exists('g:airline_symbols')
    let g:airline_symbols = {}
endif

let g:airline_left_sep = '»'
let g:airline_left_sep = '▶'
let g:airline_right_sep = '«'
let g:airline_right_sep = '◀'
let g:airline_symbols.crypt = '🔒'
let g:airline_symbols.linenr = '␊'
let g:airline_symbols.linenr = '␤'
let g:airline_symbols.linenr = '¶'
let g:airline_symbols.branch = '⎇'
let g:airline_symbols.paste = 'ρ'
let g:airline_symbols.paste = 'Þ'
let g:airline_symbols.paste = '∥'
let g:airline_symbols.whitespace = 'Ξ'

""""""""""""""""""""""""""""""
" tagbar & easytags
" """""""""""""""""""""""""""""
nmap <leader>g :TagbarToggle<CR>
nmap <leader>gg :UpdateTags -R expand('%:p:h') <CR>
let g:easytags_file = expand('%:p:h').'/.tags'
let g:easytags_dynamic_files = 1
let g:easytags_async = 1
