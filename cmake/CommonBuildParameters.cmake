# BOOST VERSION TO USE
set(BOOST_MAJOR_VERSION "1" CACHE STRING "Boost Major Version")
set(BOOST_MINOR_VERSION "85" CACHE STRING "Boost Minor Version")
set(BOOST_PATCH_VERSION "0" CACHE STRING "Boost Patch Version")

# convenience settings
set(BOOST_VERSION "${BOOST_MAJOR_VERSION}.${BOOST_MINOR_VERSION}.${BOOST_PATCH_VERSION}")
set(BOOST_VERSION_3U "${BOOST_MAJOR_VERSION}_${BOOST_MINOR_VERSION}_${BOOST_PATCH_VERSION}")
set(BOOST_VERSION_2U "${BOOST_MAJOR_VERSION}_${BOOST_MINOR_VERSION}")

# Boost should be loaded before libp2p v0.1.2
# Set config of Boost project
set(_BOOST_ROOT "${THIRDPARTY_BUILD_DIR}/boost/build/${CMAKE_SYSTEM_NAME}${ABI_SUBFOLDER_NAME}")
set(Boost_LIB_DIR "${_BOOST_ROOT}/lib")
set(Boost_INCLUDE_DIR "${_BOOST_ROOT}/include/boost-${BOOST_VERSION_2U}")
set(Boost_DIR "${Boost_LIB_DIR}/cmake/Boost-${BOOST_VERSION}")
set(boost_headers_DIR "${Boost_LIB_DIR}/cmake/boost_headers-${BOOST_VERSION}")
set(boost_random_DIR "${Boost_LIB_DIR}/cmake/boost_random-${BOOST_VERSION}")
set(boost_system_DIR "${Boost_LIB_DIR}/cmake/boost_system-${BOOST_VERSION}")
set(boost_filesystem_DIR "${Boost_LIB_DIR}/cmake/boost_filesystem-${BOOST_VERSION}")
set(boost_program_options_DIR "${Boost_LIB_DIR}/cmake/boost_program_options-${BOOST_VERSION}")
set(boost_date_time_DIR "${Boost_LIB_DIR}/cmake/boost_date_time-${BOOST_VERSION}")
set(boost_regex_DIR "${Boost_LIB_DIR}/cmake/boost_regex-${BOOST_VERSION}")
set(boost_atomic_DIR "${Boost_LIB_DIR}/cmake/boost_atomic-${BOOST_VERSION}")
set(boost_chrono_DIR "${Boost_LIB_DIR}/cmake/boost_chrono-${BOOST_VERSION}")
set(boost_log_DIR "${Boost_LIB_DIR}/cmake/boost_log-${BOOST_VERSION}")
set(boost_log_setup_DIR "${Boost_LIB_DIR}/cmake/boost_log_setup-${BOOST_VERSION}")
set(boost_thread_DIR "${Boost_LIB_DIR}/cmake/boost_thread-${BOOST_VERSION}")
set(Boost_USE_MULTITHREADED ON)
set(Boost_USE_STATIC_LIBS ON)
set(Boost_NO_SYSTEM_PATHS ON)
option(Boost_USE_STATIC_RUNTIME "Use static runtimes" ON)

set(_BOOST_CACHE_ARGS
    -DBOOST_ROOT:PATH=${_BOOST_ROOT}
    -DBoost_DIR:PATH=${Boost_DIR}
    -DBoost_INCLUDE_DIR:PATH=${Boost_INCLUDE_DIR}
    -Dboost_headers_DIR:PATH=${boost_headers_DIR}
    -Dboost_date_time_DIR:PATH=${boost_date_time_DIR}
    -Dboost_filesystem_DIR:PATH=${boost_filesystem_DIR}
    -Dboost_program_options_DIR:PATH=${boost_program_options_DIR}
    -Dboost_random_DIR:PATH=${boost_random_DIR}
    -Dboost_regex_DIR:PATH=${boost_regex_DIR}
    -Dboost_system_DIR:PATH=${boost_system_DIR}
    -DBoost_NO_SYSTEM_PATHS:BOOL=ON
    -DBoost_USE_MULTITHREADED:BOOL=ON
    -DBoost_USE_STATIC_LIBS:BOOL=ON
    -DBoost_USE_STATIC_RUNTIME:BOOL=ON
)

set(_ZKLLVM_EXTRA_PARAM
    -DZKLLVM_BUILD_TRANSPILER_LIB:BOOL=OFF
    -DZKLLVM_BUILD_EXAMPLES:BOOL=OFF
    -DZKLLVM_BUILD_STD_LIB:BOOL=ON
    -DZKLLVM_BUILD_EXECUTABLES:BOOL=OFF
    -DLLVM_INCLUDE_UTILS:BOOL=OFF
    -DLLVM_INCLUDE_TESTS:BOOL=OFF
)
include(ExternalProject)
ExternalProject_Add(zkLLVM
    PREFIX zkLLVM
    SOURCE_DIR "${CMAKE_CURRENT_SOURCE_DIR}/../../../zkLLVM/"
    CMAKE_GENERATOR ${CMAKE_GENERATOR}
    CONFIGURE_COMMAND
    ${CMAKE_COMMAND} <SOURCE_DIR>
    -DCMAKE_INSTALL_PREFIX:PATH=<INSTALL_DIR>
    -DZKLLVM_STDLIB_DIR:PATH=lib
    -DZKLLVM_DEV_ENVIRONMENT:BOOL=true
    -DZKLLVM_VERSION:STRING=v0.1.18-22-gf095fb0
    -DLLVM_ENABLE_ZSTD:BOOL=FALSE
    -DLLVM_INCLUDE_EXAMPLES:BOOL=OFF
    -DZKLLVM_BUILD_RSLANG:BOOL=FALSE
    -DBUILD_SHARED_LIBS:BOOL=OFF
    ${_CMAKE_COMMON_CACHE_ARGS}
    ${_BOOST_CACHE_ARGS}
    ${_ZKLLVM_EXTRA_PARAM}
    -DCMAKE_BUILD_TYPE=Release
    BUILD_COMMAND ${CMAKE_COMMAND} --build <BINARY_DIR> --config Release
    INSTALL_COMMAND ${CMAKE_COMMAND} --install .
)

if(EXT_ZKSTDLIB)
    ExternalProject_Add(stdlib
        PREFIX stdlib
        SOURCE_DIR "${CMAKE_CURRENT_SOURCE_DIR}/../../../zkLLVM/libs/stdlib"
        CMAKE_CACHE_ARGS
        -DCMAKE_INSTALL_PREFIX:PATH=<INSTALL_DIR>
        -DCMAKE_INSTALL_INCLUDEDIR:PATH=<INSTALL_DIR>
        -DZKLLVM_STDLIB_DIR:PATH=lib
        -DPATH_TO_CIRCUIT_FUNCTION:PATH=${THIRDPARTY_DIR}/build/circuit_functions.cmake
        -D_THIRDPARTY_BUILD_DIR:PATH=${CMAKE_CURRENT_BINARY_DIR}
        -DZKLLVM_SRC_DIR:PATH=${THIRDPARTY_DIR}/zkLLVM
        ${_CMAKE_COMMON_CACHE_ARGS}
        ${_BOOST_CACHE_ARGS}
        DEPENDS zkLLVM
    )
endif()



