cmake_minimum_required(VERSION 3.15)

set(THIS_PROJECT_NAME calc)

project(${THIS_PROJECT_NAME} VERSION 1.0 LANGUAGES CXX)

set(CMAKE_CXX_STANDARD 20)
set(CMAKE_CXX_STANDARD_REQUIRED ON)
set(CMAKE_RUNTIME_OUTPUT_DIRECTORY ${CMAKE_BINARY_DIR}/bin)
set(CMAKE_EXPORT_COMPILE_COMMANDS ON)

add_executable(${THIS_PROJECT_NAME}
    src/main.cpp
)

set(DEBUG_FLAGS
    -Wall -Wextra -Wpedantic
    -Wconversion -Wsign-conversion
    -Wold-style-cast -Werror -g
    -fsanitize=address,undefined
)

target_compile_options(${THIS_PROJECT_NAME} PRIVATE
    $<$<CONFIG:Debug>:${DEBUG_FLAGS}>
    $<$<CONFIG:Release>:-O2>
)

target_link_options(${THIS_PROJECT_NAME} PRIVATE
    $<$<CONFIG:Debug>:-fsanitize=address,undefined>
)

# Fetch litmath
include(FetchContent)
FetchContent_Declare(
    litmath
    GIT_REPOSITORY https://github.com/kenka1/litmath.git
    GIT_TAG v1.0.0
)
FetchContent_MakeAvailable(litmath)
target_link_libraries(${THIS_PROJECT_NAME} PRIVATE litmath)

# Setup clang-format
if(USE_CLANG_FORMAT)
    find_program(CLANG_FORMAT_PATH NAMES clang-format-21 REQUIRED)
    message(STATUS "Found clang-format: ${CLANG_FORMAT_PATH}")

    file(GLOB_RECURSE CLANG_FORMAT_SRC CONFIGURE_DEPENDS
        src/*.h
        src/*.cpp
        src/*.hpp
    )

    add_custom_target(clang-format-fix
        COMMAND
            ${CLANG_FORMAT_PATH} -style=file -i ${CLANG_FORMAT_SRC}
        WORKING_DIRECTORY
            ${CMAKE_SOURCE_DIR}
        COMMENT
            "Formatting ${THIS_PROJECT_NAME} with ${CLANG_FORMAT_PATH} ..."
    )

    add_custom_target(clang-format
        COMMAND
            run-clang-format.py --clang-format-executable=${CLANG_FORMAT_PATH} --style=file ${CLANG_FORMAT_SRC}
        WORKING_DIRECTORY
            ${CMAKE_SOURCE_DIR}
        COMMENT
            "Checking format ${THIS_PROJECT_NAME} with ${CLANG_FORMAT_PATH} ..."
    )
    add_dependencies(${THIS_PROJECT_NAME} clang-format)
endif()

# Setup clang-tidy
if(USE_CLANG_TIDY)
    find_program(CLANG_TIDY_PATH NAMES clang-tidy-21 REQUIRED)
    message(STATUS "Found clang-tidy: ${CLANG_TIDY_PATH}")
    set(CLANG_TIDY_COMMAND ${CLANG_TIDY_PATH} "-config-file=${CMAKE_SOURCE_DIR}/.clang-tidy")
    set_target_properties(${THIS_PROJECT_NAME} PROPERTIES CXX_CLANG_TIDY "${CLANG_TIDY_COMMAND}")
endif()

# Setup install
include(GNUInstallDirs)
install(TARGETS ${THIS_PROJECT_NAME}
    RUNTIME DESTINATION ${CMAKE_INSTALL_BINDIR}
)
