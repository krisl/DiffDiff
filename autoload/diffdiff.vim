function! diffdiff#DiffDiff() range
  let diff = getline(a:firstline, a:lastline)
  let head_mark = match(diff, '<<<<<<<')
  let ance_mark = match(diff, '|||||||', head_mark+1)
  let merg_mark = match(diff, '=======', ance_mark+1)
  let endd_mark = match(diff, '>>>>>>>', merg_mark+1)
  if endd_mark == -1
    let endd_mark = 0 "exclude end marker
  endif

  let file_head = tempname()
  let file_ance = tempname()
  let file_merg = tempname()

  call writefile(diff[head_mark+1:ance_mark-1], file_head)
  call writefile(diff[ance_mark+1:merg_mark-1], file_ance)
  call writefile(diff[merg_mark+1:endd_mark-1], file_merg)

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
