cmake_minimum_required(VERSION 3.23)

project(CQPropertyView VERSION 1.0 LANGUAGES CXX)
set(CMAKE_CXX_STANDARD 17)
set(CMAKE_CXX_STANDARD_REQUIRED ON)

# set project-wide compile flags
set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -Wall -Wextra -Wpedantic")
option(BUILD_WERROR "Build with -Werror" ON)
if(BUILD_WERROR)
    if (LINUX)
        set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -Werror")
    endif (LINUX)
endif(BUILD_WERROR)

# ---- Include guards ----
if(PROJECT_SOURCE_DIR STREQUAL PROJECT_BINARY_DIR)
  message(
    FATAL_ERROR
      "In-source builds not allowed. Please make a new directory (called a build directory) and run CMake from there."
  )
endif()

set(CMAKE_INCLUDE_CURRENT_DIR ON)

# Set up AUTOMOC and some sensible defaults for runtime execution
# When using Qt 6.3, you can replace the code block below with
# qt_standard_project_setup()
set(CMAKE_AUTOMOC ON)
include(GNUInstallDirs)
include(CheckCXXCompilerFlag)

find_package(QT NAMES Qt5 Qt6 REQUIRED COMPONENTS Core)
find_package(Qt${QT_VERSION_MAJOR} REQUIRED COMPONENTS Gui Svg Widgets)
find_package(JPEG)
set(DEPENDENCIES CQUtil CConfig CFont CImageLib CMath CFile CFileUtil CStrUtil CRegExp CGlob CUtil COS)

set(QT_LIBRARIES Qt5::Core Qt5::Gui Qt5::Svg Qt5::Widgets)

# Set path to the external dependencies
add_subdirectory(external/)
set(CQPropertyView_EXTERNAL_DIR ${CQPropertyView_SOURCE_DIR}/external)
foreach(DEP IN LISTS DEPENDENCIES)
    include_directories(
        ${CQPropertyView_EXTERNAL_DIR}/${DEP}/include
    )
endforeach()

# add the src subproject
add_subdirectory(src)

# add the test subproject
set(BUILD_TESTS ON)
if (BUILD_TESTS)
   add_subdirectory(test)
endif()
