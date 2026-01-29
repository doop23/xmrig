#!/bin/bash
# Cross-compile xmrig for Windows from Linux using MinGW-w64
# This script builds a static Windows executable

set -e  # Exit on error

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(dirname "$SCRIPT_DIR")"
BUILD_DIR="${PROJECT_ROOT}/build-windows"

echo "=== XMRig Windows Cross-Compilation Setup ==="
echo "Project root: $PROJECT_ROOT"
echo "Build directory: $BUILD_DIR"
echo ""

# Check if MinGW is installed
if ! command -v x86_64-w64-mingw32-gcc &> /dev/null; then
    echo "ERROR: MinGW-w64 is not installed!"
    echo "Install it with: sudo apt-get install mingw-w64"
    exit 1
fi

echo "MinGW version:"
x86_64-w64-mingw32-gcc --version | head -1
echo ""

# Create build directory
mkdir -p "$BUILD_DIR"
cd "$BUILD_DIR"

echo "=== Configuring CMake for Windows Target ==="
cmake "$PROJECT_ROOT" \
    -DCMAKE_TOOLCHAIN_FILE="${PROJECT_ROOT}/cmake/toolchain-mingw-w64.cmake" \
    -DCMAKE_BUILD_TYPE=Release \
    -DBUILD_STATIC=ON \
    -DWITH_HWLOC=OFF \
    -DWITH_OPENCL=OFF \
    -DWITH_CUDA=OFF \
    -DWITH_HTTPS=ON \
    -DWITH_DEBUG_LOG=OFF \
    "$@"

echo ""
echo "=== Building XMRig for Windows ==="
make -j$(nproc)

if [ -f "xmrig.exe" ]; then
    echo ""
    echo "=== Build Successful ==="
    echo "Output: $BUILD_DIR/xmrig.exe"
    file "$BUILD_DIR/xmrig.exe"
else
    echo ""
    echo "WARNING: xmrig.exe not found at expected location"
    echo "Built files in: $BUILD_DIR"
    find "$BUILD_DIR" -name "*.exe" -type f
fi
