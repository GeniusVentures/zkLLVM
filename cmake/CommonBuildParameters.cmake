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
set(_BOOST_ROOT "${THIRDPARTY_BUILD_DIR}/boost/build")
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

set(CMAKE_C_STANDARD "17" CACHE STRING "CMAKE C standard")

if(APPLE OR WIN32 OR UNIX)
    # For desktop platforms (macOS, Windows, Linux)
    set(_ZKLLVM_EXTRA_PARAM
        -DZKLLVM_BUILD_TRANSPILER_LIB:BOOL=OFF
        -DZKLLVM_BUILD_EXAMPLES:BOOL=OFF
        -DZKLLVM_BUILD_STD_LIB:BOOL=ON
        -DZKLLVM_BUILD_EXECUTABLES:BOOL=OFF
        -DLLVM_INCLUDE_UTILS:BOOL=OFF
        -DLLVM_INCLUDE_TESTS:BOOL=OFF
    )
endif()
if(ANDROID OR IOS)
    # For mobile platforms (Android, iOS)
    set(_ZKLLVM_EXTRA_PARAM
        -DZKLLVM_BUILD_TRANSPILER_LIB:BOOL=OFF
        -DZKLLVM_BUILD_EXAMPLES:BOOL=OFF
        -DZKLLVM_BUILD_STD_LIB:BOOL=OFF
        -DZKLLVM_BUILD_EXECUTABLES:BOOL=OFF
        -DLLVM_INCLUDE_UTILS:BOOL=OFF
        -DLLVM_INCLUDE_TESTS:BOOL=OFF
        -DCLANG_INCLUDE_DOCS:BOOL=OFF
    )
endif()

if(CMAKE_SYSTEM_NAME STREQUAL "Linux")
    set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -D_GNU_SOURCE")
    set(CMAKE_C_FLAGS "${CMAKE_C_FLAGS} -D_GNU_SOURCE")
    set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -fvisibility=hidden")
    set(CMAKE_C_FLAGS "${CMAKE_C_FLAGS} -fvisibility=hidden")
endif()
if(WIN32)
	set(CMAKE_CXX_FLAGS_RELEASE "${CMAKE_CXX_FLAGS_RELEASE} /MT")
	set(CMAKE_CXX_FLAGS_DEBUG "${CMAKE_CXX_FLAGS_DEBUG} /MTd")
	set(CMAKE_C_FLAGS_RELEASE "${CMAKE_C_FLAGS_RELEASE} /MT")
	set(CMAKE_C_FLAGS_DEBUG "${CMAKE_C_FLAGS_DEBUG} /MTd")
	if (CMAKE_BUILD_TYPE EQUAL Debug)
		set(CMAKE_C_FLAGS "${CMAKE_C_FLAGS} /MTd")
		set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} /MTd")
	endif (CMAKE_BUILD_TYPE EQUAL Debug)

	if (CMAKE_BUILD_TYPE EQUAL Release)
		set(CMAKE_C_FLAGS "${CMAKE_C_FLAGS} /MT")
		set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} /MT")
	endif (CMAKE_BUILD_TYPE EQUAL Release)
endif()

set(_CMAKE_COMMON_CACHE_ARGS
    -DBUILD_SHARED_LIBS:BOOL=OFF
    -DBUILD_TESTING:BOOL=OFF
    -DCMAKE_BUILD_TYPE:STRING=${CMAKE_BUILD_TYPE}
    -DCMAKE_C_FLAGS_DEBUG:STRING=${CMAKE_C_FLAGS_DEBUG}
    -DCMAKE_C_FLAGS_RELEASE:STRING=${CMAKE_C_FLAGS_RELEASE}
    -DCMAKE_C_FLAGS:STRING=${CMAKE_C_FLAGS}
    -DCMAKE_C_STANDARD:STRING=${CMAKE_C_STANDARD}
    -DCMAKE_CXX_FLAGS_DEBUG:STRING=${CMAKE_CXX_FLAGS_DEBUG}
    -DCMAKE_CXX_FLAGS_RELEASE:STRING=${CMAKE_CXX_FLAGS_RELEASE}
    -DCMAKE_CXX_FLAGS:STRING=${CMAKE_CXX_FLAGS}
    -DCMAKE_CXX_STANDARD:STRING=${CMAKE_CXX_STANDARD}
    -DCMAKE_FIND_PACKAGE_PREFER_CONFIG:BOOL=ON
    -DCMAKE_POLICY_DEFAULT_CMP0057:STRING=NEW
    -DCMAKE_POLICY_DEFAULT_CMP0074:STRING=NEW
    -DCMAKE_POLICY_DEFAULT_CMP0144:STRING=NEW
    -DCMAKE_POSITION_INDEPENDENT_CODE:BOOL=ON
    -DCMAKE_VS_GLOBALS:STRING=${CMAKE_VS_GLOBALS}
    -DCMAKE_MSVC_RUNTIME_LIBRARY:STRING=${MSVC_RUNTIME_LIBRARY_OPTION}
    -DCMAKE_TOOLCHAIN_FILE:STRING=${CMAKE_TOOLCHAIN_FILE}
)

if(APPLE)
set(_CMAKE_COMMON_CACHE_ARGS ${_CMAKE_COMMON_CACHE_ARGS}
    -DNAMED_LANGUAGE_SUPPORT:BOOL=${NAMED_LANGUAGE_SUPPORT}
    -DENABLE_BITCODE:BOOL=${ENABLE_BITCODE}
    -DENABLE_ARC:BOOL=${ENABLE_ARC}
    -DENABLE_VISIBILITY:BOOL=${ENABLE_VISIBILITY}
    -DENABLE_STRICT_TRY_COMPILE:BOOL=${ENABLE_STRICT_TRY_COMPILE}
    -DPLATFORM:STRING=${PLATFORM}
    -DDEPLOYMENT_TARGET:STRING=${DEPLOYMENT_TARGET}
)
endif()
if(ANDROID)
set(_CMAKE_COMMON_CACHE_ARGS ${_CMAKE_COMMON_CACHE_ARGS}
    -DCMAKE_ANDROID_NDK:PATH=${CMAKE_ANDROID_NDK}
    -DANDROID_ABI:STRING=${ANDROID_ABI}
    -DANDROID_NATIVE_API_LEVEL:STRING=${ANDROID_NATIVE_API_LEVEL}
    -DANDROID_PLATFORM_LEVEL:STRING=${ANDROID_PLATFORM_LEVEL}
    -DANDROID_PLATFORM:STRING=${ANDROID_PLATFORM}
    -DANDROID_STL:STRING=c++_static
    -DANDROID_TOOLCHAIN:STRING=${ANDROID_TOOLCHAIN}
    -DANDROID_USE_LEGACY_TOOLCHAIN_FILE:BOOL=${ANDROID_USE_LEGACY_TOOLCHAIN_FILE}
    -DCMAKE_FIND_ROOT_PATH_MODE_INCLUDE:STRING=BOTH
    -DCMAKE_FIND_ROOT_PATH_MODE_PACKAGE:STRING=BOTH
    -DCMAKE_FIND_ROOT_PATH_MODE_LIBRARY:STRING=BOTH
    -DOPENSSL_USE_STATIC_LIBS:BOOL=TRUE
)
set(_BOOST_CACHE_ARGS ${_BOOST_CACHE_ARGS}
    -Dboost_atomic_DIR:PATH=${boost_atomic_DIR}
    -Dboost_chrono_DIR:PATH=${boost_chrono_DIR}
    -Dboost_container_DIR:PATH=${boost_container_DIR}
    -Dboost_log_DIR:PATH=${boost_log_DIR}
    -Dboost_log_setup_DIR:PATH=${boost_log_setup_DIR}
    -Dboost_thread_DIR:PATH=${boost_thread_DIR}
    -Dboost_unit_test_framework_DIR:PATH=${boost_unit_test_framework_DIR}
    -DBoost_COMPILER:STRING=clang
)
endif()

include(ExternalProject)
ExternalProject_Add(zkLLVM
    PREFIX zkLLVM
    SOURCE_DIR "${CMAKE_CURRENT_SOURCE_DIR}/../../../zkLLVM/"
    CMAKE_GENERATOR ${CMAKE_GENERATOR}
    CONFIGURE_COMMAND
    ${CMAKE_COMMAND} <SOURCE_DIR>
    -DCMAKE_INSTALL_PREFIX:PATH=<INSTALL_DIR>
    -DCLANG_BUILD_TOOLS:BOOL=OFF
    -DLLVM_BUILD_TOOLS:BOOL=OFF
    -DLLVM_ENABLE_CURSES:BOOL=OFF
    -DLLVM_ENABLE_LIBEDIT:BOOL=OFF
    -DLLVM_ENABLE_PLUGINS:BOOL=OFF
    -DLLVM_ENABLE_TERMINFO:BOOL=OFF
    -DLLVM_ENABLE_ZSTD:BOOL=OFF
    -DLLVM_EXPORT_SYMBOLS_FOR_PLUGINS=OFF
    -DLLVM_INCLUDE_EXAMPLES:BOOL=OFF
    -DZKLLVM_BUILD_EXECUTABLES:BOOL=OFF
    -DZKLLVM_BUILD_RSLANG:BOOL=OFF
    -DZKLLVM_DEV_ENVIRONMENT:BOOL=ON
    -DZKLLVM_STDLIB_DIR:PATH=lib
    -DZKLLVM_VERSION:STRING=v0.1.18-22-gf095fb0
    ${_CMAKE_COMMON_CACHE_ARGS}
    ${_BOOST_CACHE_ARGS}
    ${_ZKLLVM_EXTRA_PARAM}
    -DCMAKE_BUILD_TYPE=${CMAKE_BUILD_TYPE}
    BUILD_COMMAND ${CMAKE_COMMAND} --build <BINARY_DIR> --config $<CONFIG>
    INSTALL_COMMAND ${CMAKE_COMMAND} --install . --config $<CONFIG>
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



