cmake_minimum_required(VERSION 3.23)

add_library(CQPropertyView SHARED
    ../include/CQPropertyView.h
    ../include/CQPropertyViewAlignType.h
    ../include/CQPropertyViewAngleType.h
    ../include/CQPropertyViewColorType.h
    ../include/CQPropertyViewDelegate.h
    ../include/CQPropertyViewEditor.h
    ../include/CQPropertyViewFilter.h
    ../include/CQPropertyViewFontType.h
    ../include/CQPropertyViewIntegerType.h
    ../include/CQPropertyViewItem.h
    ../include/CQPropertyViewLineDashType.h
    ../include/CQPropertyViewModel.h
    ../include/CQPropertyViewPaletteType.h
    ../include/CQPropertyViewPointFType.h
    ../include/CQPropertyViewRealType.h
    ../include/CQPropertyViewRectFType.h
    ../include/CQPropertyViewSizeFType.h
    ../include/CQPropertyViewTree.h
    ../include/CQPropertyViewType.h

    CQPropertyView.cpp
    CQPropertyViewAlignType.cpp
    CQPropertyViewColorType.cpp
    CQPropertyViewDelegate.cpp
    CQPropertyViewEditor.cpp
    CQPropertyViewFilter.cpp
    CQPropertyViewFontType.cpp
    CQPropertyViewIntegerType.cpp
    CQPropertyViewItem.cpp
    CQPropertyViewModel.cpp
    CQPropertyViewPointFType.cpp
    CQPropertyViewRealType.cpp
    CQPropertyViewRectFType.cpp
    CQPropertyViewSizeFType.cpp
    CQPropertyViewTree.cpp
    CQPropertyViewType.cpp
)

target_include_directories(CQPropertyView PUBLIC
    ${CMAKE_SOURCE_DIR}/include)

# Specify the dependencies!
add_dependencies(CQPropertyView build_dependencies)

# link the directories and libraries
foreach(DEP IN LISTS DEPENDENCIES)
    target_link_directories(CQPropertyView PUBLIC
        ${CQPropertyView_EXTERNAL_DIR}/${DEP}/lib
    )
    target_link_libraries(CQPropertyView PUBLIC
        ${DEP}
    )
endforeach()
target_link_libraries(CQPropertyView PUBLIC
    ${QT_LIBRARIES}
    png
    JPEG::JPEG
)
