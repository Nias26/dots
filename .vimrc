" Autoload vim-plug
let data_dir = has('nvim') ? stdpath('data') . '/site' : '~/.vim'
if empty(glob(data_dir . '/autoload/plug.vim'))
  silent execute '!curl -fLo '.data_dir.'/autoload/plug.vim --create-dirs  https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim'
  autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
endif

" Options
set clipboard=unnamedplus
      \ scrolloff=4
      \ updatetime=250
      \ timeoutlen=250
      \ noshowmode
      \ splitbelow
      \ splitright
      \ undofile
      \ termguicolors
      \ tabstop=2
      \ softtabstop=2
      \ shiftwidth=2
      \ expandtab
      \ noautochdir
      \ wrap
      \ magic
      \ laststatus=3
      \ grepprg=rg\ --smart-case\ --vimgrep

let mapleader = " "
let maplocalleader = ","

" Plug
call plug#begin()

Plug 'tpope/vim-sensible'
Plug 'tpope/vim-vinegar'
Plug 'tpope/vim-fugitive'
Plug 'tpope/vim-unimpaired'
Plug 'junegunn/fzf'
Plug 'mg979/vim-visual-multi', {'branch': 'master'}
Plug 'romainl/vim-cool'
Plug 'menisadi/kanagawa.vim'
Plug 'mbbill/undotree'
Plug 'kshenoy/vim-origami'
Plug 'ervandew/supertab'

call plug#end()

" Plugins config
let g:SuperTabDefaultCompletionType = "context"
autocmd FileType *
      \ if &omnifunc != '' |
      \   call SuperTabChain(&omnifunc, "<Tab>") |
      \ endif

" Keymaps
nnoremap Q <cmd>bd!<CR>
nnoremap <C-h> <C-w>h
nnoremap <C-j> <C-w>j
nnoremap <C-k> <C-w>k
nnoremap <C-l> <C-w>l
nnoremap n nzzzv
nnoremap N Nzzzv
nmap <Tab> <cmd>bnext<CR>
nmap <S-Tab> <cmd>bprevious<CR>
nmap [t <cmd>tabprevious<CR>
nmap ]t <cmd>tabnext<CR>
tnoremap <Esc> <C-\><C-n>
xnoremap <Esc>j :move '>+1<CR>gv=gv
xnoremap <Esc>k :move '<-2<CR>gv=gv
nnoremap <silent> <C-c> :if empty(filter(getwininfo(), 'v:val.quickfix')) \| copen \| else \| cclose \| endif<CR>
nnoremap <leader>0 <cmd>Ex<CR>
nmap U <cmd>UndoTreeToggle<CR>
nnoremap == mzggVG=`zzz

" Autocmd
colorscheme kanagawa
hi normal guibg=NONE

command! W w !sudo tee % >/dev/null

augroup HelpFileKeymaps
  autocmd!
  autocmd FileType help,man nnoremap <silent> <buffer> <CR> <C-]>
  autocmd FileType help,man nnoremap <silent> <buffer> <BS> <C-T>
  autocmd FileType help,man nnoremap <silent> <buffer> o /'\l\{2,}'<CR>
  autocmd FileType help,man nnoremap <silent> <buffer> O ?'\l\{2,}'<CR>
  autocmd FileType help,man nnoremap <silent> <buffer> s /\|\zs\S\+\ze\|<CR>
  autocmd FileType help,man nnoremap <silent> <buffer> S ?\|\zs\S\+\ze\|<CR>
  autocmd FileType help,man setlocal colorcolumn=0
augroup END

function! s:GrepCmd(bang, ...) abort
  let l:match = get(a:000, 0, '')
  let l:pattern = get(a:000, 1, '')

  if a:bang
    if empty(l:pattern)
      let l:pattern = '%'
    endif
    execute 'silent vimgrep /\v' . l:match . '/gj ' . l:pattern
  else
    execute 'silent grep! -- ' . shellescape(l:match) . ' ' . l:pattern
  endif

  copen
endfunction

command! -bang -nargs=+ -complete=history Grep call s:GrepCmd(<bang>0, <f-args>)
command! -nargs=+ -bang -complete=history Grep call s:GrepCmd(<bang>0, <f-args>)

function! s:MakeCmd(...) abort
  if a:0 > 0
    let &makeprg = join(a:000, ' ')
  endif
  make
endfunction

command! -nargs=* -complete=history Make call s:MakeCmd(<f-args>)
