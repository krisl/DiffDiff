if exists('g:loaded_diffdiff') || &cp
  finish
endif

let g:loaded_diffdiff = '0.1' "version

command! DiffDiff call diffdiff#DiffDiff()
