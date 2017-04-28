" nvim "{{{ ====================================================================
set nocompatible
scriptencoding     utf-8
set encoding      =utf-8
let mapleader     =','
let maplocalleader=','
set statusline    =[%n]\ %<%.99f\ %h%w%m%r%y%=%-16(\ %l,%c-%v\ %)%P
set textwidth     =80
set colorcolumn   =81
set bg            =dark
set nowrap     " keep the line going
"
"set completeopt  -=preview " disable preview window
"set noshowmode " don't show --INSERT--

autocmd BufRead,BufNewFile *.vim set foldmethod=marker

" vimdiff update
map <leader>du :diffupdate<cr><cr>

" sane ESC on terminal mode
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
"call plug#begin('~/.vim/plug')
call plug#begin('~/.config/nvim/plug')
"Plug 'Shougo/deoplete.nvim', { 'do': ':UpdateRemotePlugins' } | Plug 'zchee/deoplete-clang'
Plug 'Shougo/echodoc.vim'
Plug 'Shougo/neosnippet' | Plug 'Shougo/neosnippet-snippets'
Plug 'junegunn/vim-easy-align'
Plug 'junegunn/vim-plug'
"Plug 'scrooloose/syntastic'
Plug 'elentok/plaintasks.vim'
Plug 'jceb/vim-orgmode'
Plug 'tpope/vim-speeddating'
Plug 'dhruvasagar/vim-table-mode'
call plug#end()
"}}}
" plug-conf "{{{ ===============================================================
" echodoc "{{{------------------------------------------------------------------
"let g:echodoc_enable_at_startup = 1
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
" table-mode"{{{----------------------------------------------------------------
let g:table_mode_corner='|'
"}}}
" syntastic "{{{----------------------------------------------------------------
let g:syntastic_always_populate_loc_list = 1
let g:syntastic_auto_loc_list            = 1
let g:syntastic_check_on_open            = 1
let g:syntastic_check_on_wq              = 0
let g:syntastic_error_symbol             = "\u2694" " crossed swords
let g:syntastic_warning_symbol           = "\u26A0" " warning sign
let g:syntastic_enable_balloons          = 1

let g:syntastic_c_checkers               = ["clang_tidy", "gcc"]

let g:syntastic_c_clang_tidy_tail        = "2>/dev/null"
let g:syntastic_c_clang_tidy_args        = join(["",
                                           \"-I/usr/include/",
                                           \"-I/usr/local/include/",
                                           \"-I/home/tzm/dev/",
                                           \""])

let g:syntastic_c_gcc_tail               = g:syntastic_c_clang_tidy_tail
let g:syntastic_c_gcc_args               = g:syntastic_c_clang_tidy_args
"}}}
" vim-easy-align "{{{-----------------------------------------------------------
xmap al <Plug>(EasyAlign)
nmap al <Plug>(EasyAlign)
"}}}
"}}}
" TODO (plaintasks) "{{{ =======================================================
function! s:todo_fmt()
	setlocal tabstop    =2
	setlocal softtabstop=2
	setlocal shiftwidth =2
	setlocal foldmethod =indent
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

" -----------------------------------------------------------------------------
autocmd BufRead,BufNewFile *.h,*.c,*.inl call s:linux_fmt() "    c-mode

"}}}

