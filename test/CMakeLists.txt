cmake_minimum_required(VERSION 3.23)

# Executable
add_executable(CQPropertyViewTest
    CQPropertyViewTest.cpp
    CQPropertyViewTest.h
)

target_link_directories(CQPropertyViewTest PUBLIC
    ${CMAKE_SOURCE_DIR}/lib
)

target_link_libraries(CQPropertyViewTest PUBLIC
    CQPropertyView
    tre
)

set_target_properties(CQPropertyViewTest PROPERTIES
    WIN32_EXECUTABLE ON
    MACOSX_BUNDLE ON
)
