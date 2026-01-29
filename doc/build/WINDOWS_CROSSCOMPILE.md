# Cross-Compile XMRig for Windows on Linux

This guide explains how to build XMRig as a static Windows executable from Linux.

## Prerequisites

### Install MinGW-w64 (on Ubuntu/Debian)

```bash
sudo apt-get update
sudo apt-get install mingw-w64 mingw-w64-tools pkg-config
```

Verify installation:
```bash
x86_64-w64-mingw32-gcc --version
```

### Install Build Tools

```bash
sudo apt-get install cmake make git
```

## Build Static Windows Executable

### Method 1: Using the Provided Build Script (Recommended)

```bash
cd /workspaces/xmrig
bash scripts/build_windows_mingw.sh
```

The compiled `xmrig.exe` will be in the `build-windows/` directory.

### Method 2: Manual Build

```bash
cd /workspaces/xmrig
mkdir -p build-windows
cd build-windows

cmake .. \
    -DCMAKE_TOOLCHAIN_FILE=../cmake/toolchain-mingw-w64.cmake \
    -DCMAKE_BUILD_TYPE=Release \
    -DBUILD_STATIC=ON \
    -DWITH_HWLOC=OFF \
    -DWITH_OPENCL=OFF \
    -DWITH_CUDA=OFF

make -j$(nproc)
```

## Build Options Explained

| Option | Value | Purpose |
|--------|-------|---------|
| `-DCMAKE_TOOLCHAIN_FILE` | `toolchain-mingw-w64.cmake` | Use MinGW cross-compiler |
| `-DCMAKE_BUILD_TYPE` | `Release` | Optimized build |
| `-DBUILD_STATIC` | `ON` | Create static binary (no DLL dependencies) |
| `-DWITH_HWLOC` | `OFF` | Disable hwloc (causes issues with cross-compile) |
| `-DWITH_OPENCL` | `OFF` | Disable OpenCL (requires Windows SDK) |
| `-DWITH_CUDA` | `OFF` | Disable CUDA (incompatible) |
| `-DWITH_HTTPS` | `ON` | Enable HTTPS/TLS support |

## Customization

To customize the build, pass additional CMake flags to the script:

```bash
bash scripts/build_windows_mingw.sh -DWITH_RANDOMX=ON -DWITH_ARGON2=ON
```

## Troubleshooting

### Missing Dependencies

If the build fails due to missing headers (e.g., `openssl/ssl.h`):

1. Install Windows headers for MinGW:
   ```bash
   sudo apt-get install mingw-w64-dev
   ```

2. Install static libraries:
   ```bash
   sudo apt-get install libssl-dev:i386
   ```

### Build Verification

Check if the compiled binary is correctly built for Windows:

```bash
file build-windows/xmrig.exe
# Should output something like:
# PE32+ executable (console) x86-64, for MS Windows
```

### Cross-compilation Issues

- **Static linking problems**: Some libraries may not build statically. Consider using pre-compiled Windows dependencies.
- **Resource files**: The toolchain includes resource compiler support for `.rc` files (Windows resources).

## Alternative: Using Pre-built Dependencies

For more reliable builds, use xmrig-deps:

```bash
git clone https://github.com/xmrig/xmrig-deps xmrig-deps-windows
cd xmrig-deps-windows
bash build.sh mingw64

# Then rebuild xmrig with:
cd /workspaces/xmrig
mkdir -p build-windows
cd build-windows
cmake .. \
    -DCMAKE_TOOLCHAIN_FILE=../cmake/toolchain-mingw-w64.cmake \
    -DXMRIG_DEPS=../xmrig-deps-windows/build \
    -DBUILD_STATIC=ON
make -j$(nproc)
```

## Result

After successful compilation, you'll have `build-windows/xmrig.exe` - a standalone Windows executable with no external dependencies that can be distributed and run on Windows systems.
