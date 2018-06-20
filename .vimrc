" + colors --------------------------------------------------------------------
	set t_Co=256
	set colorcolumn=80
	set background=dark
	colorscheme OceanicNext
	"colorscheme campfire
	set notermguicolors
" + global --------------------------------------------------------------------
	"filetype enable " auto (via plug)
	"syntax enable   " auto (via plug)
	set nowrap
	set noswapfile
	set completeopt   =menuone,noselect
	let mapleader     =','
	let maplocalleader=','
	set statusline    =[%n]\ %<%.99f\ %h%w%m%r%y%=%-16(\ %l,%c-%v\ %)%P
	"set textwidth     =80
	let c_space_errors= 1

	" show invisible characters
	set listchars=tab:·\ ,trail:.,extends:>,precedes:<,nbsp:?
	set list

	" navigate errors
	nmap <leader>ne :lnext<cr>
	nmap <leader>pe :lprev<cr>

	" navigate buffers
	nmap <leader>nb :bn<cr>
	nmap <leader>pb :bp<cr>

	nmap <leader>m :make<cr><cr><cr>
	nmap <leader>s :wa<Bar>exe "mksession!" . v:this_session<cr>:so ~/.vim/sessions/
" + fold ----------------------------------------------------------------------
	"setlocal foldenable
	setlocal foldmethod=indent
	"setlocal foldmethod=expr    " too slow for ~1k+ fules
	setlocal foldexpr=T_cfold(v:lnum)
	"setlocal foldcolumn=1
	nnoremap <leader>z :echom T_cfold(line("."))<cr>
	nnoremap <space> za
" + UI ------------------------------------------------------------------------
	"set cursorline
	set wildmenu
	set lazyredraw
	set showmatch
" + search --------------------------------------------------------------------
	set incsearch
	set hlsearch
	nnoremap <ESC> :nohlsearch<cr>
" + plugins -------------------------------------------------------------------
	call plug#begin('~/.vim/plug/')
	Plug 'junegunn/vim-plug'
	Plug 'Shougo/echodoc.vim'
		set noshowmode
		let g:echodoc_enable_at_startup=1
	Plug 'mpolitzer/plaintasks.vim'
	Plug 'scrooloose/syntastic'
	Plug 'scrooloose/nerdtree'
		nnoremap <leader>t :NERDTreeToggle<cr>
	"Plug 'Shougo/deol.nvim'
	"	nmap  <C-t> :Deol<cr>
	"Plug 'rhysd/vim-clang-format'
	Plug 'Shougo/neosnippet' | Plug 'Shougo/neosnippet-snippets'
	Plug 'maralla/completor.vim'
		"nmap <C-k> <Plug>CompletorCppJumpToPlaceholder
		"imap <C-k> <Plug>CompletorCppJumpToPlaceholder
		"
	Plug 'maralla/completor-neosnippet'
		"imap <C-j> <Plug>(neosnippet_expand_or_jump)
		"smap <C-j> <Plug>(neosnippet_expand_or_jump)

		" <C-k> For completor and snippets
		smap <C-k> <Plug>CompletorCppJumpToPlaceholder<Plug>(neosnippet_expand_or_jump)
		imap <C-k> <Plug>CompletorCppJumpToPlaceholder<Plug>(neosnippet_expand_or_jump)

	"Plug 'maralla/validator.vim'
	"	let g:validator_c_checkers = ['clang-tidy']
	"	let g:validator_auto_open_quickfix = 1
	"	let g:validator_permament_sign = 1
	"	let g:validator_debug = 1
	call plug#end()
" + functions -----------------------------------------------------------------
	" cfold
		function! T_cfold(lnum)
			let this_line_no =              a:lnum
			let next_line_no = nextnonblank(a:lnum+1)

			let this_line = getline(this_line_no)
			let next_line = getline(next_line_no)

			if this_line =~? '\v^\s*$'
				return '-1'
			endif

			" keep going on open curly as first sym on line
			if this_line =~? '^{$'
				return '='
			endif

			" got a '}' without '{' afterwords.
			if this_line =~? '[^}]*}[^{]*$'
				" 'b'	search Backward instead of forward
				" 'n'	do Not move the cursor
				" 'W'	don't Wrap around the end of the file
				" NOTE: synIDattr(...) is to ignore when inside a string
				let in_string = 'synIDattr(synID(line("."), col("."), 0), "name") =~? "string"'
				return (indent(searchpairpos('{', '', '}', 'bnW', in_string)[0]) / &shiftwidth+1)
			endif

			let this_indent  = indent(this_line_no) / &shiftwidth
			let next_indent  = indent(next_line_no) / &shiftwidth

			if this_indent < next_indent
				return '>' . next_indent
			end

			return this_indent
		endfunction
	" C
		function! T_load_cscope()
			let db = findfile("cscope.out", ".;")
			if (!empty(db))
				let path = strpart(db, 0, match(db, "/cscope.out$"))
				setlocal nocscopeverbose " suppress 'duplicate connection' error
				exe "cs add " . db . " " . path
				setlocal cscopeverbose
			endif
		endfunction

		function! T_linux_fmt()
			"setlocal foldmethod=syntax
			setlocal ts=8 sts=8 sw=8 tw=80

			setlocal noexpandtab     " Don't expand tabs to spaces.
			setlocal cindent         " Enable automatic C program indenting.
			setlocal cinoptions+=t0  " Don't outdent function return types.
			setlocal cinoptions+=:0  " No extra indentation for case labels.
			setlocal cinoptions+=g0  " No extra indentation for "public", "protected", "private" labels.
			setlocal cinoptions+=(0  " Line up function args.

			" completor plugin
			noremap gd :call completor#do('definition')<CR>

			" Setup formatoptions:
			"   c - auto-wrap comments to textwidth
			"   r - automatically insert comment leader when pressing <Enter>
			"   o - automatically insert comment leader after 'o' or 'O'
			"   q - allow formatting of comments with 'gq'
			"   l - long lines are not broken in insert mode
			"   n - recognize numbered lists
			"   t - autowrap using textwidth                         (disabled)
			setlocal formatoptions=croqln

			" clang-format
			map <leader>f :py3f /usr/lib64/llvm/5/share/clang/clang-format.py<cr>
			"imap <C-I> <c-o>:py3f /usr/lib64/llvm/5/share/clang/clang-format.py<cr>

			" clean autocomplete window.
			"autocmd InsertLeave  * if pumvisible() == 0|pclose|endif
			if has("cscope")
				call T_load_cscope()
				" s - symbol ocurrences
				" g - global definition
				" c - calls
				" d - called
				" for more: http://cscope.sourceforge.net/cscope_maps.vim
				"nmap <leader>s :scscope find s <C-R>=expand("<cword>")<cr><cr>
				nmap <leader>g :scscope find g <C-R>=expand("<cword>")<cr><cr>
				nmap <leader>c :scscope find c <C-R>=expand("<cword>")<cr><cr>
				"nmap <leader>c :scscope find c <C-R>=expand("<cword>")<cr><cr>
				nmap <leader>d :scscope find d <C-R>=expand("<cword>")<cr><cr>

				"nmap gs :scscope find s <C-R>=expand("<cword>")<cr><cr>
				nmap gc :scscope find c <C-R>=expand("<cword>")<cr><cr>
			endif
		endfunction
		autocmd BufRead,BufNewFile *.cpp,*.h,*.c,*.inl call T_linux_fmt()
	" glsl
		function! T_glsl_fmt()
			setlocal filetype=glsl
		endfunction
		autocmd BufRead,BufNewFile *.vert,*.frag,*.vs,*.fs    call T_glsl_fmt()
	" vimrc
		function! T_vimrc_fmt()
			setlocal foldmethod=expr
		endfunction
		autocmd BufRead,BufNewFile *.vimrc      call T_vimrc_fmt()
	" Makefile
		function! T_make_fmt()
			setlocal foldmethod=expr
		endfunction
		autocmd BufRead,BufNewFile Makefile     call T_make_fmt()
	" todo
		function! T_todo_fmt()
			setlocal tabstop    =2
			setlocal softtabstop=2
			setlocal shiftwidth =2
			setlocal textwidth  =0
			setlocal wrapmargin =0
			setlocal foldmethod =expr
		endfunction
		autocmd BufRead,BufNewFile todo,*.todo  call T_todo_fmt()
