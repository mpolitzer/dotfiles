" global "{{{ ==================================================================
set nocompatible

set completeopt   =menuone,noselect
scriptencoding     utf-8
set encoding      =utf-8
let mapleader     =','
let maplocalleader=','
set statusline    =[%n]\ %<%.99f\ %h%w%m%r%y%=%-16(\ %l,%c-%v\ %)%P
set textwidth     =80
set colorcolumn   =81
set bg            =dark
set nowrap     " keep the line going
"set cedit      " vim mode in ex
set noswapfile

autocmd BufRead,BufNewFile *.vim set foldmethod=marker

" sane ESC on nvim terminal mode
"tnoremap <esc> <C-\><C-n>

colorscheme OceanicNext
"colorscheme campfire
set background=dark

" mark trailing spaces as error
let c_space_errors = 1

" draw special characters
set listchars=tab:·\ ,trail:.,extends:>,precedes:<,nbsp:?
set list

" clear search
map <space> <space>:let @/=""<cr>

" reload .init.vim
map <leader>u :source ~/.config/nvim/init.vim <cr>

" call make (:lw/:cw to see results)
map <leader>m :make<cr><cr>

" vimdiff update
map <leader>du :diffupdate<cr><cr>

" navigate errors
map <leader>ne :lnext<cr>
map <leader>pe :lprev<cr>

" navigate buffers
map <leader>nb :bn<cr>
map <leader>pb :bp<cr>

"noremap <ctrl>j <esc>/<++><enter>"_c4l
"inoremap @if if<space>()<esc>msa<space>{<enter>}<enter><++><esc>`si

" unsorted functions "{{{ ======================================================
function!NeatFoldText()
	let line = ' ' . substitute(getline(v:foldstart), '^\s*"\?\s*\|\s*"\?\s*{{' . '{\d*\s*', '', 'g') . ' '
	let lines_count = v:foldend - v:foldstart + 1
	let lines_count_text = '| ' . printf("%10s", lines_count . ' lines') . ' |'
	let foldchar = matchstr(&fillchars, 'fold:\zs.')
	let foldtextstart = strpart('+' . repeat(foldchar, v:foldlevel*2) . line, 0, (winwidth(0)*2)/3)
	let foldtextend = lines_count_text . repeat(foldchar, 8)
	let foldtextlength = strlen(substitute(foldtextstart . foldtextend, '.', 'x', 'g')) + &foldcolumn
	return foldtextstart . repeat(foldchar, winwidth(0)-foldtextlength) . foldtextend
endfunction
set foldtext=NeatFoldText()

function!Reduce(funcname, list)
    let F = function(a:funcname)
    let acc = a:list[0]
    for value in a:list[1:]
        let acc = F(acc, value)
    endfor
    return acc
endfun
function!Count(list)
	return Reduce({acc, x -> acc+1}, a:list)
endfunction
function!Sum(list)
	return Reduce({acc, x -> acc+x}, a:list)
endfunction
function!Average(list)
  return Sum(a:list)/len(a:list)
endfunction

"}}}
"}}}

" plug "{{{ ====================================================================
"call plug#begin('~/.vim/vim-plug')
call plug#begin('~/.config/nvim/plug')
"Plug 'Shougo/deoplete.nvim', { 'do': ':UpdateRemotePlugins' } | Plug 'zchee/deoplete-clang'
"Plug 'Valloric/YouCompleteMe', { 'do': './install.py --clang-completer --system-libclang --system-boost' }
Plug 'maralla/completor.vim'
Plug 'maralla/completor-neosnippet'
"Plug 'jeaye/color_coded'            " C better hi (too slow!)
Plug 'Shougo/echodoc.vim'
Plug 'Shougo/neosnippet' | Plug 'Shougo/neosnippet-snippets'
"Plug 'junegunn/vim-easy-align'
"Plug 'godlygeek/tabular'
Plug 'junegunn/vim-plug'
"Plug 'scrooloose/syntastic'
Plug 'elentok/plaintasks.vim'
"Plug 'jceb/vim-orgmode'
"Plug 'tpope/vim-speeddating'
Plug 'dhruvasagar/vim-table-mode'
"Plug 'tikhomirov/vim-glsl'
call plug#end()
"}}}
" plug-conf "{{{ ===============================================================
" vim-latex "{{{----------------------------------------------------------------
filetype plugin on
"set grepprg=grep\ -nH\ $*
"let g:tex_flavor='latex'
"}}}
" echodoc "{{{------------------------------------------------------------------
set noshowmode
let g:echodoc_enable_at_startup = 1
"}}}
" deoplete (neovim only) "{{{---------------------------------------------------
"let g:deoplete#enable_at_startup           = 1
"let g:deoplete#enable_refresh_always       = 1
"let g:deoplete#delimiters                  = ['/', '.', '::', ':', '#', '_']
"
"let g:deoplete#sources#clang#libclang_path = '/usr/lib64/libclang.so'
"let g:deoplete#sources#clang#clang_header  = '/usr/include/clang/'
"let g:deoplete#sources#clang#flags         = [
"                                           \ '-I/home/tzm/dev/',
"                                           \ '-I/home/tzm/dev/tz/',
"                                           \ '-I/usr/local/include/vulkan/',
"                                           \ ]
"let g:deoplete#sources#clang#sort_algo     = 'priority'
"let g:deoplete#sources#clang#std           = 'c99'
"}}}
" neosnippet "{{{---------------------------------------------------------------
imap <C-k>     <Plug>(neosnippet_expand_or_jump)
smap <C-k>     <Plug>(neosnippet_expand_or_jump)
xmap <C-k>     <Plug>(neosnippet_expand_target)
"}}}
" completor "{{{----------------------------------------------------------------
"let g:completor_refresh_always = 0
set cot-=preview
"let g:completor_clang_binary = "/usr/lib/llvm/5/bin/clang"
"inoremap <expr> <Tab> pumvisible() ? "\<C-n>" : "\<C-x>\<C-u>\<C-p>"
"}}}
" table-mode"{{{ ---------------------------------------------------------------
let g:table_mode_corner='|'
"}}}
" syntastic "{{{ ---------------------------------------------------------------
let g:syntastic_always_populate_loc_list = 1
let g:syntastic_auto_loc_list            = 1
let g:syntastic_check_on_open            = 1
let g:syntastic_check_on_wq              = 0
let g:syntastic_error_symbol             = "☓"
let g:syntastic_warning_symbol           = "⚠"
let g:syntastic_enable_balloons          = 1
"
"let g:syntastic_error_symbol             = " "\u2694" " crossed swords
"let g:syntastic_warning_symbol           = " "\u26A0" " warning sign
"
"let g:syntastic_c_checkers               = ["clang_tidy", "gcc"]
"
"let g:syntastic_c_clang_tidy_tail        = "2>/dev/null"
"let g:syntastic_c_clang_tidy_args        = join(["",
"                                           \"-I/home/tzm/dev/t/",
"                                           \"-I/usr/include/",
"                                           \"-I/usr/local/include/",
"                                           \"-march=native",
"                                           \"-std=c11",
"                                           \"-D_POSIX_C_SOURCE 199506L",
"                                           \""])

"let g:syntastic_c_gcc_tail               = g:syntastic_c_clang_tidy_tail
"let g:syntastic_c_gcc_args               = g:syntastic_c_clang_tidy_args
"}}}
" vim-easy-align "{{{ ----------------------------------------------------------
xmap al <Plug>(EasyAlign)
nmap al <Plug>(EasyAlign)
"}}}
"}}}
" TODO (plaintasks) "{{{ -------------------------------------------------------
function! s:todo_fmt()
	setlocal tabstop    =2
	setlocal softtabstop=2
	setlocal shiftwidth =2
	setlocal foldmethod =indent
	setlocal textwidth=0 wrapmargin=0
endfunction
autocmd BufRead,BufNewFile todo,*.tasks,TODO  call s:todo_fmt()
"}}}
" c "{{{ =======================================================================
function! s:load_cscope()
  let db = findfile("cscope.out", ".;")
  if (!empty(db))
    let path = strpart(db, 0, match(db, "/cscope.out$"))
    set nocscopeverbose " suppress 'duplicate connection' error
    exe "cs add " . db . " " . path
    set cscopeverbose
  endif
endfunction

function! s:linux_fmt()
	setlocal fdm=syntax
	setlocal ts=8 sts=8 sw=8 tw=80

	setlocal noexpandtab     " Don't expand tabs to spaces.
	setlocal cindent         " Enable automatic C program indenting.
	setlocal cinoptions+=t0  " Don't outdent function return types.
	setlocal cinoptions+=:0  " No extra indentation for case labels.
	setlocal cinoptions+=g0  " No extra indentation for "public", "protected", "private" labels.
	setlocal cinoptions+=(0  " Line up function args.

	" Setup formatoptions:
	"   c - auto-wrap comments to textwidth.
	"   r - automatically insert comment leader when pressing <Enter>.
	"   o - automatically insert comment leader after 'o' or 'O'.
	"   q - allow formatting of comments with 'gq'.
	"   l - long lines are not broken in insert mode.
	"   n - recognize numbered lists.
	"   t - autowrap using textwidth,
	setlocal formatoptions=croqlnt

	" clang-format
	map <C-I> :py3f /usr/lib64/llvm/5/share/clang/clang-format.py<cr>
	"imap <C-I> <c-o>:py3f /usr/lib64/llvm/5/share/clang/clang-format.py<cr>

	" clean autocomplete window.
	autocmd InsertLeave  * if pumvisible() == 0|pclose|endif
	if has("cscope")
		call s:load_cscope()
		" s - symbol ocurrences
		" g - global definition
		" c - calls
		" d - called
		" for more: http://cscope.sourceforge.net/cscope_maps.vim
		nmap <leader>s :scscope find s <C-R>=expand("<cword>")<cr><cr>
		nmap <leader>g :scscope find g <C-R>=expand("<cword>")<cr><cr>
		nmap <leader>c :scscope find c <C-R>=expand("<cword>")<cr><cr>
		nmap <leader>d :scscope find d <C-R>=expand("<cword>")<cr><cr>
	endif
endfunction

function! s:html_fmt()
"	setlocal fdm=identation
	setlocal ts=2 sts=2 sw=2 tw=80
endfunction

" -----------------------------------------------------------------------------
autocmd BufRead,BufNewFile *.cpp,*.h,*.c,*.inl call s:linux_fmt() "     c-mode
autocmd BufRead,BufNewFile *.tex               set iskeyword+=:   " latex-mode

autocmd BufRead,BufNewFile *.vs,*.fs     set filetype=glsl  " glsl-mode
autocmd BufRead,BufNewFile *.html,*.htm  call s:html_fmt()  " html

"}}}

