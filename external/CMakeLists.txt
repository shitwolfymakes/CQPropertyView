cmake_minimum_required(VERSION 3.23)
string(REPLACE ";" " " EXTERN_DEPS_STR "${DEPENDENCIES}")

# force cmake to run a command to build all dependencies before
# building anything else
add_custom_target(
    build_dependencies ALL
    COMMAND "${CMAKE_SOURCE_DIR}/tools/build_dependencies.sh" "${EXTERN_DEPS_STR}"
    COMMENT "Building dependencies in \"external/\", this may take a while..."
)
