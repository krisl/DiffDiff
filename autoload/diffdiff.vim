function! diffdiff#DiffDiff()
  let diff = @0
  let [head, rest] = split(diff, '||||||| \v(\w|\s|\.|\!|\;)*\n')
  let [ance, merg] = split(rest, '=======\n', 1)

  if head=~'<<<<<<< \v(\w|\s|\.)*\n'
    let [_, head]  = split(head, '<<<<<<< \v(\w|\s|\.|\!|\;)*\n', 1)
  endif

  if merg=~'>>>>>>> \v(\w|\s|\.)*\n'
    let [merg, _]  = split(merg, '>>>>>>> \v(\w|\s|\.|\!|\;)*\n', 1)
  endif

  let file_head = tempname()
  let file_ance = tempname()
  let file_merg = tempname()

  call writefile(split(head, '\n'), file_head)
  call writefile(split(ance, '\n'), file_ance)
  call writefile(split(merg, '\n'), file_merg)

  if exists('t:_DiffDiffbufnr') && bufwinnr(t:_DiffDiffbufnr) > 0
    exe bufwinnr(t:_DiffDiffbufnr)."wincmd W"
    exe 'normal ggdG'
  else
    vnew
    set filetype=diff
    let t:_DiffDiffbufnr = bufnr('%')
  endif

  silent :execute 'r !diff -u '.file_ance.' '.file_head.' --label common --label HEAD'
  silent :execute 'r !echo "\n\n\n"'
  silent :execute 'r !diff -u '.file_ance.' '.file_merg.' --label common --label merg'

  set nomodified
  nnoremap <silent> <buffer> q :bw<cr>
endfunction
