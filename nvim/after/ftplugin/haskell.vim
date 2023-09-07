lua <<END

local wk = require("which-key")
local keys = {
  h = "hoogle",
  b = "ghci load",
  c = "ghci clear",
  d = "ghci doc",
  i = "ghci info",
  j = "ghci instances",
  k = "ghci kind",
  l = "ghci reload",
  m = "ghci main",
  t = "ghci type",
  T = "doctest",
  r = "repl",
}

wk.register(keys, { mode = "n", prefix = "<localleader>", silent = true })
wk.register(keys, { mode = "v", prefix = "<localleader>", silent = true })

END


" disable autopairs
inoremap <buffer> ' '
inoremap <buffer> ` `

" <cword> includes .
setlocal iskeyword+=.

nnoremap <buffer><silent><nowait> <localleader>h   :Hoogle <C-r>=expand('<cword>')<CR><CR>
nnoremap <buffer><silent><nowait> <localleader>b   :Repl :load! *<C-r>=expand('%:p')<CR><CR>
nnoremap <buffer><silent><nowait> <localleader>c   :Repl :!clear<CR>
nnoremap <buffer><silent><nowait> <localleader>l   :Repl :reload<CR>

nnoremap <buffer><silent><nowait> <localleader>m   :Repl :main<CR>
nnoremap <buffer><silent><nowait> <localleader>T   :Repl :doctest <C-r>=expand('%:p')<CR><CR>

nnoremap <buffer><silent><nowait> <localleader>d   :Repl :doc <C-r>=expand('<cword>')<CR><CR>
nnoremap <buffer><silent><nowait> <localleader>i   :Repl :info <C-r>=expand('<cword>')<CR><CR>

nnoremap <buffer><silent><nowait> <localleader>j   :Repl :instances <C-r>=expand('<cword>')<CR><CR>
vnoremap <buffer><silent><nowait> <localleader>j y :Repl :instances <C-r>=@"<CR><CR>

nnoremap <buffer><silent><nowait> <localleader>k   :Repl :kind <C-r>=expand('<cword>')<CR><CR>
vnoremap <buffer><silent><nowait> <localleader>k y :Repl :kind! <C-r>=@"<CR><CR>

nnoremap <buffer><silent><nowait> <localleader>t   :Repl :type +d <C-r>=expand('<cword>')<CR><CR>
vnoremap <buffer><silent><nowait> <localleader>t   <Cmd>call GHC_type_at()<CR>

inoremap <buffer><silent><C-x><C-j>  <Left><C-o>:HaskComplete import <C-r>=expand('<cword>')<CR><CR><Right>
inoremap <buffer><silent><C-j>       <Left><C-o>:HaskComplete <C-r>=expand('<cword>')<CR><CR><Right>

command -nargs=1 -complete=tag HaskComplete Repl :complete repl 1-15 "<args>"

function! GHC_type_at()
  let file = expand('%:p')
  let [startln, startcol] = getpos('v')[1:2]
  let [endln, endcol] = getcursorcharpos()[1:2]
  if startln > endln
    let [startln, endln] = [endln, startln]
  endif
  if startcol > endcol
    let [startcol, endcol] = [endcol, startcol]
  endif
  :execute 'Repl :type-at ' . join([file, startln, startcol, endln, endcol], ' ')
endfunction

setlocal tags+=.hackage.tags

" cabal install fast-tags
command HaskTags silent !find . ~/.hackage -name '*.cabal' -print0 | xargs -0 fast-tags --cabal --qualified -o .hackage.tags

" cabal install ghc-tags
augroup Haskell
  autocmd!
  au BufWritePost *.hs  silent !ghc-tags -c &
augroup END

let g:tagbar_width = max([40, winwidth(0) / 4])
let g:tagbar_type_haskell = {
    \ 'ctagsbin'    : 'hasktags',
    \ 'ctagsargs'   : '-x -c -o-',
    \ 'kinds'       : [
        \  'm:modules:0:1',
        \  'd:data:0:1',
        \  'd_gadt:data gadt:0:1',
        \  'nt:newtype:0:1',
        \  'c:classes:0:1',
        \  'i:instances:0:1',
        \  'cons:constructors:0:1',
        \  'c_gadt:constructor gadt:0:1',
        \  'c_a:constructor accessors:1:1',
        \  't:type names:0:1',
        \  'pt:pattern types:0:1',
        \  'pi:pattern implementations:0:1',
        \  'ft:function types:0:1',
        \  'fi:function implementations:0:1',
        \  'o:others:0:1'
    \ ],
    \ 'sro'          : '.',
    \ 'kind2scope'   : {
        \ 'm'        : 'module',
        \ 'd'        : 'data',
        \ 'd_gadt'   : 'd_gadt',
        \ 'c_gadt'   : 'c_gadt',
        \ 'nt'       : 'newtype',
        \ 'cons'     : 'cons',
        \ 'c_a'      : 'accessor',
        \ 'c'        : 'class',
        \ 'i'        : 'instance'
    \ },
    \ 'scope2kind'   : {
        \ 'module'   : 'm',
        \ 'data'     : 'd',
        \ 'newtype'  : 'nt',
        \ 'cons'     : 'c_a',
        \ 'd_gadt'   : 'c_gadt',
        \ 'class'    : 'ft',
        \ 'instance' : 'ft'
    \ }
\ }
