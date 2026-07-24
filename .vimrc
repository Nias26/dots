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
  \ foldmethod=expr
  \ foldexpr=lsp#ui#vim#folding#foldexpr()
  \ foldtext=lsp#ui#vim#folding#foldtext()
  \ completeopt=menuone,noinsert,noselect,preview

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
Plug 'prabirshrestha/vim-lsp'
Plug 'mattn/vim-lsp-settings'
Plug 'prabirshrestha/asyncomplete.vim'
Plug 'prabirshrestha/asyncomplete-lsp.vim'

call plug#end()

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
inoremap <expr> <Tab>   pumvisible() ? "\<C-n>" : "\<Tab>"
inoremap <expr> <S-Tab> pumvisible() ? "\<C-p>" : "\<S-Tab>"
inoremap <expr> <cr>    pumvisible() ? asyncomplete#close_popup() : "\<cr>"

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
    let l:match = a:1
    let l:pattern = get(a:000, 1, '')

    if a:bang
        if empty(l:pattern)
            let l:pattern = '%'
        endif
        execute 'silent vimgrep /\v' . l:match . '/gj ' . l:pattern
    else
        execute 'silent grep! ' . shellescape(l:match) . ' ' . l:pattern
    endif

    copen
endfunction

command! -nargs=+ -bang -complete=history Grep call s:GrepCmd(<bang>0, <f-args>)

function! s:MakeCmd(...) abort
    if a:0 > 0
        let &makeprg = join(a:000, ' ')
    endif
    make
endfunction

command! -nargs=* -complete=history Make call s:MakeCmd(<f-args>)

function! Qftf(info) abort
    let l:items = a:info.quickfix
                \ ? getqflist({'id': a:info.id, 'items': 0}).items
                \ : getloclist(a:info.winid, {'id': a:info.id, 'items': 0}).items

    let l:ret = []
    let l:limit = 31
    let l:fnamefmt = '%-' . l:limit . 's'
    let l:validfmt = '%s │%5d:%-3d│%s %s'

    for l:e in l:items[a:info.start_idx - 1 : a:info.end_idx - 1]
        if l:e.valid
            if l:e.bufnr > 0
                let l:fname = fnamemodify(bufname(l:e.bufnr), ':~')

                if empty(l:fname)
                    let l:fname = '[No Name]'
                endif

                let l:len = strlen(l:fname)

                if l:len <= l:limit
                    let l:fname = printf(l:fnamefmt, l:fname)
                else
                    let l:fname = '…' . strpart(l:fname, l:len - l:limit + 1)
                endif
            else
                let l:fname = ''
            endif

            let l:lnum = l:e.lnum > 99999 ? -1 : l:e.lnum
            let l:col = l:e.col > 999 ? -1 : l:e.col
            let l:qtype = empty(l:e.type) ? '' : ' ' . toupper(l:e.type[0])

            call add(l:ret, printf(
                        \ l:validfmt,
                        \ l:fname,
                        \ l:lnum,
                        \ l:col,
                        \ l:qtype,
                        \ l:e.text))
        else
            call add(l:ret, l:e.text)
        endif
    endfor

    return l:ret
endfunction

" set quickfixtextfunc=Qftf
