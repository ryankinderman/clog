function! s:throw(msg)
  let v:errmsg = 'clog: '.a:msg
  throw v:errmsg
endfunction

function! s:clog_command()
  return 'REAL=true '.$HOME.'/bin/clog'
endfunction

function! s:run_command(cmd, ...)
  let tempname = tempname()
  let error = tempname.'.error'
  let extension = a:0 ? '.'.a:1 : ''
  let temp = tempname.extension
  silent! execute 'write !'.a:cmd.' > '.temp.' 2> '.error
  if v:shell_error
    call s:throw(join(readfile(error),"\n"))
  endif
  return temp
endfunction

function! ClogPull()
  let outfile = s:run_command(s:clog_command().' pull', 'clogpull')
  execute 'edit '.outfile
endfunction

function! ClogList()
  let outfile = s:run_command(s:clog_command().' pull')
  let outfile = s:run_command('cat '.outfile.' | '.
    \ 'sed -n ''/^--begin post$/,/^--begin body$/ { /^$/ \! p }'' | '.
    \ 'awk ''{ '.
    \   'if($0 ~ /^--begin body/) '.
    \     'print a["date"] "|" a["id"] "|" a["title"] "|" a["link"];'.
    \   'else if($0 ~ /^Post: /) {a["id"] = $0; sub(/^Post: /, "", a["id"])}'.
    \   'else if($0 ~ /^Title: /) {a["title"] = $0; sub(/^Title: /, "", a["title"])}'.
    \   'else if($0 ~ /^Date: /) {a["date"] = $0; sub(/^Date: /, "", a["date"])}'.
    \   'else if($0 ~ /^Link: /) {a["link"] = $0; sub(/^Link: /, "", a["link"])}'.
    \ '}''')
  execute 'edit '.outfile
endfunction
