function! diffdiff#DiffDiff()
  let diff = @0
  let [head, rest] = split(diff, '||||||| merged common ancestors\n')
  let [ance, merg] = split(rest, '=======\n')

  let file_head = tempname()
  let file_ance = tempname()
  let file_merg = tempname()

  call writefile(split(head, '\n'), file_head)
  call writefile(split(ance, '\n'), file_ance)
  call writefile(split(merg, '\n'), file_merg)

  vnew
  set filetype=diff

  execute 'r !diff -u '.file_ance.' '.file_head.' --label common --label HEAD'
  execute 'r !echo "\n\n\n"'
  execute 'r !diff -u '.file_ance.' '.file_merg.' --label common --label merg'

  set nomodified
endfunction
