cmake_minimum_required(VERSION 2.8)

project(p6)

add_executable(p6 main.cpp)
target_link_libraries(p6 PGUPV)

include(../PGUPV/pgupv.cmake)

set_target_properties( p6 PROPERTIES
  RUNTIME_OUTPUT_DIRECTORY_DEBUG   ${CMAKE_SOURCE_DIR}/bin 
  RUNTIME_OUTPUT_DIRECTORY_RELEASE ${CMAKE_SOURCE_DIR}/bin
)

install(TARGETS p6 DESTINATION ${PG_SOURCE_DIR}/bin)
