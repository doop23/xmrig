# MinGW-w64 Toolchain for Cross-Compilation from Linux to Windows
# Usage: cmake -DCMAKE_TOOLCHAIN_FILE=cmake/toolchain-mingw-w64.cmake ..

set(CMAKE_SYSTEM_NAME Windows)
set(CMAKE_SYSTEM_PROCESSOR x86_64)

# Adjust these based on your MinGW installation
# For 64-bit Windows target
set(MINGW_PREFIX /usr/x86_64-w64-mingw32)

# Compiler settings
set(CMAKE_C_COMPILER x86_64-w64-mingw32-gcc)
set(CMAKE_CXX_COMPILER x86_64-w64-mingw32-g++)
set(CMAKE_RC_COMPILER x86_64-w64-mingw32-windres)

# Search paths
set(CMAKE_FIND_ROOT_PATH ${MINGW_PREFIX})
set(CMAKE_FIND_ROOT_PATH_MODE_PROGRAM NEVER)
set(CMAKE_FIND_ROOT_PATH_MODE_LIBRARY ONLY)
set(CMAKE_FIND_ROOT_PATH_MODE_INCLUDE ONLY)

# Compiler flags for static linking
set(CMAKE_C_FLAGS "${CMAKE_C_FLAGS} -static-libgcc" CACHE STRING "C Flags")
set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -static-libgcc -static-libstdc++" CACHE STRING "CXX Flags")

# Prefer static libraries
set(CMAKE_FIND_LIBRARY_SUFFIXES .a .lib)

# pkg-config for MinGW
set(PKG_CONFIG_EXECUTABLE x86_64-w64-mingw32-pkg-config CACHE FILEPATH "pkg-config executable")
