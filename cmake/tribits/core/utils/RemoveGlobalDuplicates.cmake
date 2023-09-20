# @HEADER
# ************************************************************************
#
#            TriBITS: Tribal Build, Integrate, and Test System
#                    Copyright 2013 Sandia Corporation
#
# Under the terms of Contract DE-AC04-94AL85000 with Sandia Corporation,
# the U.S. Government retains certain rights in this software.
#
# Redistribution and use in source and binary forms, with or without
# modification, are permitted provided that the following conditions are
# met:
#
# 1. Redistributions of source code must retain the above copyright
# notice, this list of conditions and the following disclaimer.
#
# 2. Redistributions in binary form must reproduce the above copyright
# notice, this list of conditions and the following disclaimer in the
# documentation and/or other materials provided with the distribution.
#
# 3. Neither the name of the Corporation nor the names of the
# contributors may be used to endorse or promote products derived from
# this software without specific prior written permission.
#
# THIS SOFTWARE IS PROVIDED BY SANDIA CORPORATION "AS IS" AND ANY
# EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
# IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR
# PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL SANDIA CORPORATION OR THE
# CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL,
# EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO,
# PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR
# PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF
# LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING
# NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
# SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
#
# ************************************************************************
# @HEADER

include(AssertDefined)
include(GlobalSet)


# @FUNCTION: remove_global_duplicates()
#
# Remove duplicate elements from a global list variable (removes boiler-plate
# code and errors).
#
# Usage::
#
#   remove_global_duplicates(<globalVarName>)
#
# This function is necessary in order to preserve the "global" nature of the
# variable.  If one just calls ``list(REMOVE_DUPLICATES ...)`` it will
# actually create a local variable of the same name and shadow the global
# variable!  That is a fun bug to track down!  The variable
# ``<globalVarName>`` must be defined before this function is called.  If
# ``<globalVarName>`` is actually not a global cache variable before this
# function is called it will be after it completes.
#
function(remove_global_duplicates VARNAME)
  assert_defined(${VARNAME})
  if (${VARNAME})
    set(TMP ${${VARNAME}})
    list(REMOVE_DUPLICATES TMP)
    global_set(${VARNAME} ${TMP})
  endif()
endfunction()
