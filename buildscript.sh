pacman -Syu git make mingw-w64-x86_64-SDL2 mingw-w64-x86_64-cmake mingw-w64-x86_64-python-pip mingw-w64-x86_64-qt5 mingw-w64-x86_64-toolchain autoconf libtool automake-wrapper --noconfirm
echo 'PATH=/mingw64/bin:$PATH' >> ~/.bashrc
echo 'PATH=$(readlink -e /c/VulkanSDK/*/Bin/):$PATH' >> ~/.bashrc
cd sooyoo
mkdir build
cmake -G "MSYS Makefiles" -DSUYU_USE_BUNDLED_VCPKG=ON -DSUYU_TESTS=OFF ..
make -j$(nproc)
