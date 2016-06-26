function! diffdiff#DiffDiff()
  let diff = @0
  let [head, rest] = split(diff, '||||||| merged common ancestors\n')
  let [ance, merg] = split(rest, '=======\n', 1)

  if head=~'<<<<<<< \S*\n'
    let [_, head]  = split(head, '<<<<<<< \S*\n', 1)
  endif

  if merg=~'>>>>>>> \S*\n'
    let [merg, _]  = split(merg, '>>>>>>> \S*\n', 1)
  endif

  let file_head = tempname()
  let file_ance = tempname()
  let file_merg = tempname()

  call writefile(split(head, '\n'), file_head)
  call writefile(split(ance, '\n'), file_ance)
  call writefile(split(merg, '\n'), file_merg)

  vnew
  set filetype=diff

  silent :execute 'r !diff -u '.file_ance.' '.file_head.' --label common --label HEAD'
  silent :execute 'r !echo "\n\n\n"'
  silent :execute 'r !diff -u '.file_ance.' '.file_merg.' --label common --label merg'

  set nomodified
  nnoremap <silent> <buffer> q :bw<cr>
endfunction
