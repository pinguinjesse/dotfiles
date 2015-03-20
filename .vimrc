set nocompatible
syn on
set ignorecase
set smartcase
set modeline
set modelines=5
set wildmode=longest:full
set wildmenu
set hlsearch
set pastetoggle=<F10>
set tw=0
set backspace=eol,indent,start
set number
"set mouse=a "Disabled
set grepprg=grep\ -nH\ $*
let g:tex_flavor = "latex"
set path=$PWD/**
" in visual mode, show count
set showcmd
set scrolloff=3

if ! has("gui_win32")

" persistent-undo
set undodir=~/.vim/undodir
set undofile

set runtimepath+=~/.vim/bundle/neobundle.vim/

" remove toolbar
set guioptions-=T
" remove menu
set guioptions-=m

let mapleader="\<Space>"

imap jj <Esc>

"if has("autocmd") && exists("+omnifunc")
	"autocmd Filetype *
	"\   if &omnifunc == "" |
	"\     setlocal omnifunc=syntaxcomplete#Complete |
	"\   endif
"endif

call neobundle#begin(expand('~/.vim/bundle/'))

" Let NeoBundle manage NeoBundle
NeoBundleFetch 'Shougo/neobundle.vim'

" Recommended to install
" After install, turn shell ~/.vim/bundle/vimproc, (n,g)make -f your_machines_makefile
NeoBundle 'Shougo/vimproc'

NeoBundle 'mileszs/ack.vim.git'
noremap <Leader>a :Ack --cpp --cc <cword><CR>

NeoBundle 'motemen/git-vim.git'

"Show + - ~ in the margin for vim modification
NeoBundle "airblade/vim-gitgutter"
let g:gitgutter_eager = 0 " only update on read/write


NeoBundle 'kien/ctrlp.vim' "amazing search with ctrl p
NeoBundle 'JazzCore/ctrlp-cmatcher'

" Also search tags
let g:ctrlp_extensions = ['tag']
noremap <Leader>t :CtrlPTag<CR>

"let g:ctrlp_working_path_mode = 'a'

NeoBundle 'git-time-lapse'
NeoBundle 'Rip-Rip/clang_complete.git'
let g:clang_snippets = 1
let g:clang_snippets_engine = 'clang_complete'
noremap <Leader>c :call g:ClangUpdateQuickFix()<cr>

"NeoBundle 'Valloric/YouCompleteMe.git'

NeoBundle 'tpope/vim-surround.git'
NeoBundle 'taglist.vim'
NeoBundle 'ifdef-highlighting'
NeoBundle 'tpope/vim-speeddating' " can do C-A and C-X on dates!
NeoBundle 'ciaranm/detectindent' "adapts tabstop and this shit automagically

NeoBundle "scrooloose/nerdtree"

" Nice tabulation
NeoBundle 'godlygeek/tabular'
"http://vimcasts.org/episodes/aligning-text-with-tabular-vim/

let g:Powerline_symbols = 'unicode'

NeoBundle 'Tag-Signature-Balloons'

function! ToggleFullScreen()
    call system("wmctrl -i -r ".v:windowid." -b toggle,fullscreen")
    redraw
endfunction

if has("gui_running")
    colorscheme bramwombat

    if has("gui_gtk2")
        set guifont=Inconsolata\ Medium\ 12
    elseif has("gui_win32")
        set guifont=Lucida_Console:h10:cANSI
    endif

    nnoremap <Leader><F11> :call ToggleFullScreen()<CR>

    set cursorline
else
    colorscheme desert
endif

"set a sudo vim
cmap w!! w !sudo tee % > /dev/null

hi scalaNew gui=underline
hi scalaMethodCall gui=italic
hi scalaValName gui=underline
hi scalaVarName gui=underline
"folding
set foldcolumn=2
set foldmethod=marker

" tabs are 4 space by default
set shiftwidth=4
set tabstop=4
set expandtab

"What highlighting group is the current cursor on ?
function! SyntaxItem()
  return synIDattr(synID(line("."),col("."),1),"name")
endfunction

"Nice statusbar
set laststatus=2
set statusline=
set statusline+=%-3.3n\                             " buffer number
set statusline+=%f\                                 " file name
set statusline+=%h%m%r%w                            " flags
set statusline+=\[%{strlen(&ft)?&ft:'none'},        " filetype
set statusline+=%{&fileencoding},                   " encoding
set statusline+=%{&fileformat},                     " file format
set statusline+=%{((exists(\"+bomb\")\ &&\ &bomb)?\"B,\":\"\")}]\  " BOM
set statusline+=%{strftime('%a\ %b\ %e\ %H:%M')}\   " hour
"set statusline+=%{SyntaxItem()}                     " syntax highlight group under cursor
set statusline+=%=                                  " right align
set statusline+=0x%-8B\                             " current char
set statusline+=%-14.(%l,%c%V%)\ %<%P               " offset

"tags
set tags=tags,./tags,../tags,../../tags

"C syntax for ellisys files
autocmd BufNewFile,BufRead *.usbs set filetype=c

"C syntax for ARM Scatterfiles
autocmd BufNewFile,BufRead *.scat set filetype=c

"ARM Assembler for .s files
autocmd BufNewFile,BufRead *.s set filetype=armasm

"Markdown, not modula2
autocmd BufNewFile,BufRead *.md set filetype=markdown

set nostartofline

"F4 switches from C source .c to header .h file
function! MPB_LoadFile(filename)
	let s:bufname = bufname(a:filename)
	if (strlen(s:bufname)) > 0
		" File already in a buffer
		exe ":buffer" s:bufname
	else
		" Must open file first
		exe ":e " a:filename
	endif
endfun


function! MPB_Flip_Ext()
	" Switch editing between .c(XYZ) and .h(XYZ) files.
	if match(expand("%"),'\.c') > 0
		let s:flipname = substitute(expand("%"),'\.c\(.*\)','.h\1',"")
		exe ":call MPB_LoadFile(s:flipname)"
	elseif match(expand("%"),'\.h') > 0
		let s:flipname = substitute(expand("%"),'\.h\(.*\)','.c\1',"")
		exe ":call MPB_LoadFile(s:flipname)"
	endif
endfun

function! MPB_Flip_Cpp_H()
	" Switch editing between .c(XYZ) and .h(XYZ) files.
	if match(expand("%"),'\.cpp') > 0
		let s:flipname = substitute(expand("%"),'\.cpp','.h',"")
		exe ":call MPB_LoadFile(s:flipname)"
	elseif match(expand("%"),'\.h') > 0
		let s:flipname = substitute(expand("%"),'\.h','.cpp',"")
		exe ":call MPB_LoadFile(s:flipname)"
	endif
endfun

noremap <F4> :call MPB_Flip_Ext()<CR>
noremap <F3> :call MPB_Flip_Cpp_H()<CR>

"Show trailing whitespace
highlight ExtraWhitespace ctermbg=darkgreen guibg=#344011
autocmd BufEnter * exe ':2match ExtraWhitespace /\s\+$\| \+\ze\t\|\t\+\ze /'

" F5 sets the search register to the word under cursor, without moving
" the cursor
noremap <F5> :let @/ = expand('<cword>')<CR>:3match none<CR>

" F6: Highlight the word under cursor in darkcyan
highlight ManualHighlight ctermbg=darkcyan guibg=darkcyan
noremap <F6> :exe printf('match ManualHighlight /%s/', escape(expand('<cword>'), '/\'))<CR>

"if has("gui_running")
"    " auto highlight word under cursor
"    highlight WordUnderCursor ctermbg=darkred guibg=#552211
"    autocmd CursorMoved * exe printf('3match WordUnderCursor /\V\<%s\>/', escape(expand('<cword>'), '/\'))
"endif

"Show tabs
set listchars=tab:›\ ,trail:␣
set list

"clang_complete options
set completeopt=menu,menuone,longest
"let g:clang_complete_copen=1

"some CScope maps
noremap <Leader>fs :cscope f s <cword><Enter>

if has("cscope")
    " add any database in current directory
    if filereadable("cscope.out")
        cs add cscope.out
        " else add database pointed to by environment
    elseif $CSCOPE_DB != ""
        cs add $CSCOPE_DB
    endif
endif

"short tag and tselect
noremap <Leader>[ :tselect <C-r><C-w><CR>
noremap <Leader>] :tag <C-r><C-w><CR>

"I use bnext and bprev a lot
noremap [b :bprev<CR>
noremap ]b :bnext<CR>

"Same for location list
noremap [l :lprev<CR>
noremap ]l :lnext<CR>

"Error list
noremap [e :cNext<CR>
noremap ]e :cnext<CR>

noremap [h :GitGutterPrevHunk<CR>
noremap ]h :GitGutterNextHunk<CR>

"GIT timelapse
noremap <Leader>gt :call TimeLapse()<cr>

noremap <Leader>e :NERDTreeToggle<CR>

noremap <Leader>T :set expandtab!<CR>

" Vim. Live it.
noremap <up> <nop>
noremap <down> <nop>
noremap <left> <nop>
noremap <right> <nop>
inoremap <down> <nop>
inoremap <left> <nop>
inoremap <right> <nop>
inoremap <up> <nop>

"very magic search
noremap <Leader>/ /\v

call neobundle#end()

filetype plugin indent on

NeoBundleCheck

else
    set guifont=Lucida_Console:h10:cANSI
    colorscheme bramwombat
    set cursorline
endif " not windows

