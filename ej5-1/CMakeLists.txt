cmake_minimum_required(VERSION 2.8)

project(ej5-1)

add_executable(ej5-1 main.cpp)
target_link_libraries(ej5-1 PGUPV)

set_target_properties( ej5-1 PROPERTIES
  RUNTIME_OUTPUT_DIRECTORY_DEBUG   ${CMAKE_SOURCE_DIR}/bin 
  RUNTIME_OUTPUT_DIRECTORY_RELEASE ${CMAKE_SOURCE_DIR}/bin
)

install(TARGETS ej5-1 DESTINATION ${PG_SOURCE_DIR}/bin)
