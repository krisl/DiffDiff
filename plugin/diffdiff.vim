if exists('g:loaded_diffdiff') || &cp
  finish
endif

let g:loaded_diffdiff = '0.1' "version

command! DiffDiff call diffdiff#DiffDiff()
command! -range DiffRange <line1>,<line2>call  diffdiff#DiffDiff()
