cmake_minimum_required(VERSION 2.8)

project(p4)

add_executable(p4 main.cpp)
target_link_libraries(p4 PGUPV)

set_target_properties( p4 PROPERTIES
  RUNTIME_OUTPUT_DIRECTORY_DEBUG   ${CMAKE_SOURCE_DIR}/bin 
  RUNTIME_OUTPUT_DIRECTORY_RELEASE ${CMAKE_SOURCE_DIR}/bin
)

install(TARGETS p4 DESTINATION ${PG_SOURCE_DIR}/bin)
