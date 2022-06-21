#
# libmavconn
# Copyright 2021 Vladimir Ermakov, All rights reserved.
#
# That module ported from catkin project.
# Here original copyright notice:
#
# Software License Agreement (BSD License)
#
# Copyright (c) 2012, Willow Garage, Inc.
# All rights reserved.
#
# Redistribution and use in source and binary forms, with or without
# modification, are permitted provided that the following conditions are met:
#
#    * Redistributions of source code must retain the above copyright
#      notice, this list of conditions and the following disclaimer.
#
#    * Redistributions in binary form must reproduce the above copyright
#      notice, this list of conditions and the following disclaimer in the
#      documentation and/or other materials provided with the distribution.
#
#    * Neither the name of the copyright holder nor the names of its
#      contributors may be used to endorse or promote products derived from
#      this software without specific prior written permission.
#
# THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS"
# AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
# IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE
# ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE
# LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR
# CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF
# SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS
# INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN
# CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE)
# ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE
# POSSIBILITY OF SUCH DAMAGE.
#

# TODO: Maybe in DIFFERENT FILE?
# TODO: Maybe in DIFFERENT FILE?
# TODO: Maybe in DIFFERENT FILE?
# TODO: Maybe in DIFFERENT FILE?
function(assert VAR)
  if(NOT ${VAR})
    message(FATAL_ERROR "\nAssertion failed: ${VAR} (value is '${${VAR}}')\n")
  endif()
  debug_message(3 "assert(${VAR}) passed (${VAR} = ${${VAR}})")
endfunction()

function(assert_unset VAR)
  if(${VAR})
    message(FATAL_ERROR "\nAssertion failed: '${VAR}' is set but should not be (value is '${${VAR}}')\n")
  endif()
  debug_message(3 "assert_unset(${VAR}) passed")
endfunction()

function(assert_file_exists FILENAME MESSAGE)
  if(NOT FILENAME)
    message(FATAL_ERROR "\nAssertion failed:  check for file existence, but filename (${FILENAME}) unset. Message: ${MESSAGE}\n")
  endif()
  if(NOT EXISTS ${FILENAME})
    message(FATAL_ERROR "\nAssertion failed:  file '${FILENAME}' does not exist.  Message: ${MESSAGE}\n")
  endif()
endfunction()

function(stamp path)
  get_filename_component(filename "${path}" NAME)
  configure_file(${path}
          ${CMAKE_CURRENT_BINARY_DIR}/catkin_generated/stamps/${PROJECT_NAME}/${filename}.stamp
          COPYONLY)
endfunction()
# TODO: Maybe in DIFFERENT FILE?
# TODO: Maybe in DIFFERENT FILE?
# TODO: Maybe in DIFFERENT FILE?
# TODO: Maybe in DIFFERENT FILE?


find_package(Python3 COMPONENTS Interpreter)

function(em_expand context_in context_out em_file_in file_out)
  assert_file_exists("${context_in}" "input file for context missing")
  assert_file_exists("${em_file_in}" "template file missing")
  message(DEBUG "configure_file(${context_in}, ${context_out})")
  configure_file(${context_in} ${context_out} @ONLY)
  assert_file_exists("${context_out}" "context file was not generated correctly")

  stamp(${em_file_in})

  # create directory if necessary
  get_filename_component(_folder_out ${file_out} PATH)
  if(NOT IS_DIRECTORY ${_folder_out})
    file(MAKE_DIRECTORY ${_folder_out})
  endif()

  message(DEBUG "Evaluate template '${em_file_in}' to '${file_out}' (with context from '${context_out}')")
  execute_process(COMMAND
    ${Python3_EXECUTABLE}
    -m em
    --raw-errors
    -F ${context_out}
    -o ${file_out}
    ${em_file_in}
    RESULT_VARIABLE _res)

  if(NOT _res EQUAL 0)
    message(FATAL_ERROR "em.py return error code ${_res}")
  endif()
endfunction()

