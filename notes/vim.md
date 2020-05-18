npx prettier --stdin --parser typescript %

change path
lcd %:p:h

copy file path
:!echo %:p | pbcopy 

open location list - errors
:lopen

refresh buffers
:checktime

open explorer
:Lex
-

open current file in explorer
:e %:h


relative file path 
@%
!echo @%  | pbcopy

current directory ranger
!ranger %:h

show command history
:History:

closes a window but keeps the buffer
CTRL+w, c:

local vim
.lvimrc

import paths work with js, ts files
setlocal suffixesadd+=.ts,.tsx,.js,.jsx

ale setup:
let g:ale_javascript_eslint_options = "--cache"
let b:ale_fixers = {
            \ 'javascript': ['eslint', 'stylelint'],
            \ 'typescript': ['eslint', 'stylelint'],
            \ 'typescriptreact': ['eslint', 'stylelint'],
            \ 'javascriptreact': ['eslint', 'stylelint'],
            \}

let b:ale_linters = {
            \ 'javascript': ['tsserver', 'stylelint', 'eslint'],
            \ 'typescript': ['tsserver', 'stylelint', 'eslint'],
            \ 'typescriptreact': ['tsserver', 'stylelint', 'eslint'],
            \ 'javascriptreact': ['tsserver', 'stylelint', 'eslint'],
            \}

{
  "eslint.validate": [
      "javascript",
      "javascriptreact",
      { "language": "typescript", "autoFix": true },
      { "language": "typescriptreact", "autoFix": true }
  ],
}
