" =============================================================================
" 
"   Program:   CMake - Cross-Platform Makefile Generator
"   Module:    $RCSfile$
"   Language:  C++
"   Date:      $Date$
"   Version:   $Revision$
" 
"   Copyright (c) 2002 Kitware, Inc., Insight Consortium.  All rights reserved.
"   See Copyright.txt or http://www.cmake.org/HTML/Copyright.html for details.
" 
"      This software is distributed WITHOUT ANY WARRANTY"  without even 
"      the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR 
"      PURPOSE.  See the above copyright notices for more information.
" 
" =============================================================================

" Vim indent file
" Language:     CMake (ft=cmake)
" Author:       Andy Cedilnik <andy.cedilnik@kitware.com>
" Maintainer:   Andy Cedilnik <andy.cedilnik@kitware.com>
" Last Change:  $Date$
" Version:      $Revision$
" 
" Licence:      This program is free software; you can redistribute it
"               and/or modify it under the terms of the CMake
"               License. See http://www.cmake.org/HTML/Copyright.html

if exists("b:did_indent")
  finish
endif
let b:did_indent = 1

setlocal indentexpr=CMakeGetIndent(v:lnum)

" Only define the function once.
if exists("*CMakeGetIndent")
  finish
endif

fun! CMakeGetIndent(lnum)
  let this_line = getline(a:lnum)

  " Find a non-blank line above the current line.
  let lnum = a:lnum
  let lnum = prevnonblank(lnum - 1)
  let previous_line = getline(lnum)

  " Hit the start of the file, use zero indent.
  if lnum == 0
    return 0
  endif

  let ind = indent(lnum)

  let or = '\|'
  " Regular expressions used by line indentation function.
  let cmake_regex_comment = '#.*'
  let cmake_regex_identifier = '[A-Za-z][A-Za-z0-9_]*'
  let cmake_regex_quoted = '"\([^"\\]\|\\.\)*"'
  let cmake_regex_arguments = '\(' . cmake_regex_quoted .
                    \       or . '\$(' . cmake_regex_identifier . ')' .
                    \       or . '[^()\\#"]' . or . '\\.' . '\)*'

  let cmake_indent_comment_line = '^\s*' . cmake_regex_comment
  let cmake_indent_blank_regex = '^\s*$')
  let cmake_indent_open_regex = '^\s*' . cmake_regex_identifier .
                    \           '\s*(' . cmake_regex_arguments .
                    \           '\(' . cmake_regex_comment . '\)\?$'

  let cmake_indent_close_regex = '^' . cmake_regex_arguments .
                    \            ')\s*' .
                    \            '\(' . cmake_regex_comment . '\)\?$'

  let cmake_indent_begin_regex = '^\s*\(IF\|MACRO\|FOREACH\|ELSE\)\s*('
  let cmake_indent_end_regex = '^\s*\(ENDIF\|ENDFOREACH\|ENDMACRO\|ELSE\)\s*('

  " Add
  if previous_line =~? cmake_indent_comment_line " Handle comments
    let ind = ind
  else
    if previous_line =~? cmake_indent_begin_regex
      let ind = ind + &sw
    endif
    if previous_line =~? cmake_indent_open_regex
      let ind = ind + &sw
    endif
  endif

  " Subtract
  if this_line =~? cmake_indent_end_regex
    let ind = ind - &sw
  endif
  if previous_line =~? cmake_indent_close_regex
    let ind = ind - &sw
  endif

  return ind
endfun
