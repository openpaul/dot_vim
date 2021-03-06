
if !exists( "b:syntastic_cpp_cflags" )
    let b:syntastic_cpp_cflags = ''
endif

" Taken from clang_complete
function! s:parseConfig()
  let l:local_conf = findfile('.clang_complete', getcwd() . ',.;')
  if l:local_conf == '' || !filereadable(l:local_conf)
    return
  endif

  let l:opts = readfile(l:local_conf)
  for l:opt in l:opts
    " Better handling of absolute path
    " I don't know if those pattern will work on windows
    " platform
    if matchstr(l:opt, '\C-I\s*/') != ''
      let l:opt = substitute(l:opt, '\C-I\s*\(/\%(\w\|\\\s\)*\)',
            \ '-I' . '\1', 'g')
    else
      let l:opt = substitute(l:opt, '\C-I\s*\(\%(\w\|\\\s\)*\)',
            \ '-I' . l:local_conf[:-16] . '\1', 'g')
    endif
    let b:syntastic_cpp_cflags .= ' ' . l:opt
  endfor
endfunction

call s:parseConfig()

" let g:clang_user_options = "-xc++"
" let g:clang_user_options = "-xc++ -I/usr/lib/clang/3.0/include"

nnoremap <Leader>q :call g:ClangUpdateQuickFix()<CR>

