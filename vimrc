" ~/.vimrc — plugin-free Vim setup (Vim 9.0, macOS)
" Uses only what ships with Vim: built-in options, netrw, bundled packages.

" ---------------------------------------------------------------- Base
unlet! skip_defaults_vim
source $VIMRUNTIME/defaults.vim   " sane defaults: syntax, filetype, incsearch, scrolloff…
set nocompatible
set encoding=utf-8
set fileformats=unix,mac,dos
set hidden                        " switch buffers without saving
set autoread                      " reload files changed outside vim
set updatetime=300
set ttimeoutlen=10                " snappy <Esc>
set belloff=all
set mouse=a
set clipboard=unnamed             " yank/paste uses the macOS clipboard

" Bundled packages (no plugin manager needed)
packadd! matchit                  " % jumps between if/else, html tags…
packadd! editorconfig             " honour .editorconfig files
packadd! cfilter                  " :Cfilter /pat/ to narrow quickfix lists

" ---------------------------------------------------------------- UI
set number relativenumber
set cursorline
set signcolumn=yes
set laststatus=2
set showcmd showmode
set wildmenu wildoptions=pum
set wildmode=longest:full,full
set wildignore+=*/.git/*,*/node_modules/*,*/__pycache__/*,*.pyc,*.o,.DS_Store
set splitbelow splitright
set scrolloff=5 sidescrolloff=8
set nowrap
set linebreak breakindent         " nicer wrapping when :set wrap is on
set list listchars=tab:»\ ,trail:·,nbsp:␣,extends:›,precedes:‹
let &fillchars = 'vert:│,eob: '
set shortmess+=c
set colorcolumn=+1                " show a guide at textwidth (when set)

if has('termguicolors') && ($COLORTERM ==# 'truecolor' || $COLORTERM ==# '24bit')
  set termguicolors
endif
set background=dark

" Current-row highlight: stronger than the scheme default, re-applied on any colorscheme change
augroup vimrc_cursorline
  autocmd!
  autocmd ColorScheme * highlight CursorLine guibg=#3a3a4a ctermbg=237 cterm=underline gui=underline
        \ | highlight CursorLineNr guifg=#ffaf5f ctermfg=215 gui=bold cterm=bold
  " Only highlight the row in the active window
  autocmd WinEnter,BufWinEnter * setlocal cursorline
  autocmd WinLeave * setlocal nocursorline
augroup END

silent! colorscheme habamax

" Cursor: bar in insert, underline in replace, block in normal (iTerm/most terminals)
let &t_SI = "\e[6 q"
let &t_SR = "\e[4 q"
let &t_EI = "\e[2 q"

" Statusline: mode | file flags | filetype · encoding · format | line:col pct
function! StatusMode() abort
  return get({'n':'NORMAL','i':'INSERT','R':'REPLACE','v':'VISUAL','V':'V-LINE',
        \ "\<C-v>":'V-BLOCK','c':'COMMAND','t':'TERMINAL','s':'SELECT'}, mode(), mode())
endfunction
set statusline=\ %{StatusMode()}\ │\ %f\ %m%r%h%w
set statusline+=%=
let &statusline .= '%y %{&fenc!=""?&fenc:&enc} %{&ff} │ %l:%c %p%% '

" ---------------------------------------------------------------- Editing
set expandtab tabstop=4 softtabstop=4 shiftwidth=4 shiftround
set autoindent smartindent
set backspace=indent,eol,start
set nojoinspaces
set formatoptions+=j              " remove comment leader when joining
set virtualedit=block
set nrformats-=octal

" ---------------------------------------------------------------- Search
set ignorecase smartcase
set hlsearch incsearch
if executable('rg')
  set grepprg=rg\ --vimgrep\ --smart-case
  set grepformat=%f:%l:%c:%m
else
  set grepprg=grep\ -rnI\ --exclude-dir=.git\ --exclude-dir=node_modules\ $*\ .
endif

" ---------------------------------------------------------------- Files
" Keep swap/backup/undo out of project dirs; persistent undo across sessions
for s:d in ['undo', 'swap', 'backup']
  if !isdirectory(expand('~/.vim/' . s:d))
    call mkdir(expand('~/.vim/' . s:d), 'p', 0700)
  endif
endfor
set undofile undodir=~/.vim/undo//
set directory=~/.vim/swap//
set backup backupdir=~/.vim/backup//
set viminfo='200,<1000,s100,h

" Find files recursively with :find <name><Tab>
set path=.,**
" ---------------------------------------------------------------- netrw
let g:netrw_banner = 0
let g:netrw_liststyle = 3         " tree view
let g:netrw_winsize = 25
let g:netrw_browse_split = 0
let g:netrw_altv = 1
let g:netrw_list_hide = '\(^\|\s\s\)\zs\.\S\+,\.DS_Store'
let g:netrw_home = expand('~/.vim')

" ---------------------------------------------------------------- Keymaps
let mapleader = ' '
let maplocalleader = ','

" Files & buffers
nnoremap <leader>w :update<CR>
nnoremap <leader>q :quit<CR>
nnoremap <leader>e :Lexplore<CR>
nnoremap <leader>f :find<Space>
nnoremap <leader>b :ls<CR>:buffer<Space>
nnoremap <leader>g :silent grep!<Space>
nnoremap <leader><leader> <C-^>
nnoremap [b :bprevious<CR>
nnoremap ]b :bnext<CR>
nnoremap [q :cprevious<CR>
nnoremap ]q :cnext<CR>

" Clear search highlight
nnoremap <silent> <Esc><Esc> :nohlsearch<CR>
nnoremap <silent> <leader>/ :nohlsearch<CR>

" Window navigation
nnoremap <C-h> <C-w>h
nnoremap <C-j> <C-w>j
nnoremap <C-k> <C-w>k
nnoremap <C-l> <C-w>l

" Move by display line when wrapping, unless a count is given
nnoremap <expr> j v:count ? 'j' : 'gj'
nnoremap <expr> k v:count ? 'k' : 'gk'

" Keep cursor centered when jumping through search results
nnoremap n nzzzv
nnoremap N Nzzzv

" Y yanks to end of line (consistent with D, C)
nnoremap Y y$

" Keep selection when indenting; move selected lines
xnoremap < <gv
xnoremap > >gv
xnoremap J :move '>+1<CR>gv=gv
xnoremap K :move '<-2<CR>gv=gv

" Paste over selection without clobbering the register
xnoremap <leader>p "_dP

" Toggles
nnoremap <leader>tw :set wrap!<CR>
nnoremap <leader>tn :set relativenumber!<CR>
nnoremap <leader>ts :setlocal spell!<CR>
nnoremap <leader>tl :set list!<CR>

" Edit / reload this file
nnoremap <leader>ve :edit $MYVIMRC<CR>
nnoremap <leader>vr :source $MYVIMRC<CR>:echo 'vimrc reloaded'<CR>

" Save with sudo
cnoremap w!! w !sudo tee % >/dev/null

" Terminal: <Esc> to normal mode
tnoremap <Esc><Esc> <C-\><C-n>

" ---------------------------------------------------------------- Autocmds
augroup vimrc
  autocmd!
  " 2-space indent for these filetypes
  autocmd FileType yaml,json,javascript,typescript,typescriptreact,javascriptreact,html,css,scss,vue,ruby,lua,terraform,markdown
        \ setlocal tabstop=2 softtabstop=2 shiftwidth=2
  " Real tabs where required
  autocmd FileType make,go setlocal noexpandtab tabstop=4 shiftwidth=4
  " Prose
  autocmd FileType markdown,text,gitcommit setlocal wrap spell
  autocmd FileType gitcommit setlocal textwidth=72
  autocmd FileType python setlocal textwidth=88
  " Strip trailing whitespace on save (not for markdown, where it can be meaningful)
  autocmd BufWritePre * if &ft !~# '^\(markdown\|diff\)$' |
        \ let s:v = winsaveview() | keeppatterns %s/\s\+$//e | call winrestview(s:v) | endif
  " Open quickfix after :grep / :make
  autocmd QuickFixCmdPost [^l]* cwindow
  autocmd QuickFixCmdPost l* lwindow
  " Check for external changes when focus returns
  autocmd FocusGained,BufEnter * silent! checktime
  " Equalize splits when the terminal is resized
  autocmd VimResized * wincmd =
  " Briefly highlight yanked text
  if exists('##TextYankPost')
    autocmd TextYankPost * silent! call s:FlashYank()
  endif
augroup END

function! s:FlashYank() abort
  if v:event.operator !=# 'y' | return | endif
  let l:id = matchaddpos('IncSearch', range(line("'["), line("']")))
  call timer_start(150, {-> execute('silent! call matchdelete(' . l:id . ')')})
endfunction

" Local machine overrides
if filereadable(expand('~/.vimrc.local'))
  source ~/.vimrc.local
endif
