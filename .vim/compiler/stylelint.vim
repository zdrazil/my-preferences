if executable('stylelint')
    let s:args_after = {
    \ 'css':  '-f json',
    \ 'html': '-f json',
    \ 'less': '-f json -s less',
    \ 'scss': '-f json -s scss' }
    setlocal errorformat='%t:%f:%l:%c:%m'
    setlocal makeprg=stylelint\ -f\ json
endif
