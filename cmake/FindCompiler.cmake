#===============================================================================
# Copyright 2020 Intel Corporation
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
# http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing,
# software distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions
# and limitations under the License.
#
#
# SPDX-License-Identifier: Apache-2.0
#===============================================================================

include_guard()

include(CheckCXXCompilerFlag)
include(FindPackageHandleStandardArgs)

check_cxx_compiler_flag("-fsycl" is_dpcpp)

if(is_dpcpp)
  find_package_handle_standard_args(SYCL DEFAULT_MSG)
endif()

if(SYCL_FOUND AND is_dpcpp)
  # Workaround for internal compiler error during linking if -fsycl is used
  get_filename_component(SYCL_BINARY_DIR ${CMAKE_CXX_COMPILER} DIRECTORY)
  find_library(SYCL_LIBRARY NAMES sycl PATHS "${SYCL_BINARY_DIR}/../lib")

  add_library(ONEMKL::SYCL::SYCL INTERFACE IMPORTED)
  set_target_properties(ONEMKL::SYCL::SYCL PROPERTIES
      INTERFACE_COMPILE_OPTIONS "-fsycl"
      INTERFACE_LINK_LIBRARIES ${SYCL_LIBRARY})
endif()
