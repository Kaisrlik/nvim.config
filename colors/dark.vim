" Vim color file

" First remove all existing highlighting.
set background=dark
hi clear
if exists("syntax_on")
  syntax reset
endif

let colors_name = "dark"

hi Normal	guifg=White guibg=grey20

hi SpecialKey term=bold ctermfg=239 guifg=Blue
hi NonText term=bold cterm=bold ctermfg=4 gui=bold guifg=Blue
hi Directory term=bold ctermfg=4 guifg=Blue
hi ErrorMsg term=standout cterm=bold ctermfg=7 ctermbg=1 gui=bold guifg=White guibg=Red
hi IncSearch term=reverse cterm=reverse gui=reverse
hi Search term=reverse ctermbg=3 guibg=Gold2
hi MoreMsg term=bold ctermfg=2 gui=bold guifg=SeaGreen
hi ModeMsg term=bold cterm=bold gui=bold
hi LineNr term=underline ctermfg=240 guifg=Red3
hi Question term=standout ctermfg=2 gui=bold guifg=SeaGreen
hi StatusLine term=bold,reverse cterm=bold,reverse gui=bold guifg=White guibg=Black
hi StatusLineNC term=reverse cterm=reverse gui=bold guifg=PeachPuff guibg=Gray45
hi VertSplit term=reverse cterm=reverse gui=bold guifg=White guibg=Gray45
hi Title term=bold ctermfg=3
hi Visual term=reverse cterm=reverse gui=reverse guifg=Grey80 guibg=fg
hi VisualNOS term=bold,underline cterm=bold,underline gui=bold,underline
hi WarningMsg term=standout ctermfg=1 gui=bold guifg=Red
hi WildMenu term=standout ctermfg=0 ctermbg=3 guifg=Black guibg=Yellow
hi Folded term=standout ctermfg=4 ctermbg=7 guifg=Black guibg=#e3c1a5
hi FoldColumn term=standout ctermfg=4 ctermbg=7 guifg=DarkBlue guibg=Gray80
hi DiffAdd term=bold ctermbg=4 guibg=White
hi DiffChange term=bold ctermbg=5 guibg=#edb5cd
hi DiffDelete term=bold cterm=bold ctermfg=4 ctermbg=6 gui=bold guifg=LightBlue guibg=#f6e8d0
hi DiffText term=reverse cterm=bold ctermbg=1 gui=bold guibg=#ff8060

hi CursorLine ctermbg=236 guibg=#75756e cterm=none
hi CursorLineNr ctermbg=236 cterm=bold guibg=#75756e

" Colors for syntax highlighting
" hi Comment term=bold ctermfg=4 guifg=#406090
hi Comment ctermfg=247 guifg=#808080
" hi Constant term=underline ctermfg=1 guifg=#c00058
hi Constant ctermfg=brown guifg=#ffa0a0
hi Special term=bold ctermfg=5 guifg=SlateBlue
hi Identifier term=underline ctermfg=6 guifg=DarkCyan
hi Statement term=bold ctermfg=3 gui=bold guifg=Brown
hi PreProc term=underline ctermfg=5 guifg=Magenta3
hi Type term=underline ctermfg=2 gui=bold guifg=SeaGreen
hi Ignore cterm=bold ctermfg=7 guifg=bg
hi Error cterm=bold ctermfg=7 ctermbg=1
hi SpellBad ctermfg=7 ctermbg=1
hi Todo cterm=bold ctermfg=3 ctermbg=0

" git
hi diffRemoved ctermfg=9
hi diffAdded ctermfg=10
hi diffFile ctermfg=6
hi diffSubname cterm=bold ctermfg=3

" syn case ignore

" Taby a mezery TODO doenst work
highlight Tab1 ctermbg=lightgreen guibg=#e0ffe0
highlight Tab2 ctermbg=lightred   guibg=#ffe0e0
highlight Tab3 ctermbg=lightblue  guibg=#e0e0ff
highlight Tab4 ctermbg=lightcyan  guibg=#ffffe0

syn match Tab1 '\t'
syn match Tab2 "\t\t"
syn match Tab3 "\t\t\t"
syn match Tab4 "\t\t\t\t"
" Show trailing whitepace and spaces before a tab:
syn match ExtraWhitespace /\s\+$\| \+\ze\t/
" po nasapni <01>44= oznacuje
syn match fixPrice         "<01>44=[^<01>]*"
hi def link fixPrice         Label
