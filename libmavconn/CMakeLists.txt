cmake_minimum_required(VERSION 3.5)
project(libmavconn)

set(CMAKE_PREFIX_PATH ${CMAKE_PREFIX_PATH} ../../mavlink-gbp-release/build/usr/local/share/mavlink/cmake)

# Default to C11
if(NOT CMAKE_C_STANDARD)
  set(CMAKE_C_STANDARD 11)
endif()

# Default to C++14
if(NOT CMAKE_CXX_STANDARD)
  set(CMAKE_CXX_STANDARD 14)
  set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -std=c++14")
endif()
if(CMAKE_COMPILER_IS_GNUCXX OR CMAKE_CXX_COMPILER_ID MATCHES "Clang")
  # we dont use add_compile_options with pedantic in message packages
  # because the Python C extensions dont comply with it
  set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -Wall -Wextra -Wpedantic")
endif()
set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -Wcomment")

# Allow GNU extensions (-std=gnu++20)
set(CMAKE_C_EXTENSIONS ON)
set(CMAKE_CXX_EXTENSIONS ON)

#find_package(ament_cmake REQUIRED)

# add package modules path, not needed in dependend packages
list(INSERT CMAKE_MODULE_PATH 0 "${CMAKE_CURRENT_SOURCE_DIR}/cmake/Modules")

## System dependencies are found with CMake's conventions
find_package(ASIO REQUIRED)
find_package(mavlink REQUIRED)

include(em_expand)

include_directories(
  include
  ${CMAKE_CURRENT_BINARY_DIR}/generated/include
  ${ASIO_INCLUDE_DIRS}
  ${mavlink_INCLUDE_DIRS}
)

## Declare a cpp library
add_library(mavconn SHARED
  ${CMAKE_CURRENT_BINARY_DIR}/generated/src/mavlink_helpers.cpp
  src/interface.cpp
  src/serial.cpp
  src/tcp.cpp
  src/udp.cpp
)

# Use em_expand macros to generate source files
em_expand(${CMAKE_CURRENT_SOURCE_DIR}/mavlink.context.py.in
  ${CMAKE_CURRENT_BINARY_DIR}/generated/mavlink.context.py
  ${CMAKE_CURRENT_SOURCE_DIR}/include/mavconn/mavlink_dialect.hpp.em
  ${CMAKE_CURRENT_BINARY_DIR}/generated/include/mavconn/mavlink_dialect.hpp)

em_expand(${CMAKE_CURRENT_SOURCE_DIR}/mavlink.context.py.in
  ${CMAKE_CURRENT_BINARY_DIR}/generated/mavlink.context.py
  ${CMAKE_CURRENT_SOURCE_DIR}/src/mavlink_helpers.cpp.em
  ${CMAKE_CURRENT_BINARY_DIR}/generated/src/mavlink_helpers.cpp)

message(STATUS "Copy mavlink_dialect.hpp to source tree")
file(
  COPY ${CMAKE_CURRENT_BINARY_DIR}/generated/include/mavconn/mavlink_dialect.hpp
  DESTINATION ${CMAKE_CURRENT_SOURCE_DIR}/include/mavconn/
)

install(TARGETS mavconn
  ARCHIVE DESTINATION lib
  LIBRARY DESTINATION lib
  RUNTIME DESTINATION bin
)

install(DIRECTORY include/
  DESTINATION include
)

install(DIRECTORY ${CMAKE_CURRENT_BINARY_DIR}/generated/include/mavconn/
  DESTINATION include/mavconn
  FILES_MATCHING PATTERN "*.hpp"
)

install(DIRECTORY cmake
  DESTINATION share/${PROJECT_NAME}
)