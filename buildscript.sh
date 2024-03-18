pacman -Syu git make mingw-w64-x86_64-SDL2 mingw-w64-x86_64-cmake mingw-w64-x86_64-python-pip mingw-w64-x86_64-qt5 mingw-w64-x86_64-toolchain autoconf libtool automake-wrapper mingw-w64-x86_64-github-cli zip --noconfirm
git submodule update --init --recursive
echo 'PATH=/mingw64/bin:$PATH' >> ~/.bashrc
echo 'PATH=$(readlink -e /c/VulkanSDK/*/Bin/):$PATH' >> ~/.bashrc
cd sooyoo
#mkdir build && cd build
#cmake -G "MSYS Makefiles" -DSUYU_USE_BUNDLED_VCPKG=ON -DSUYU_TESTS=OFF ..
cd externals
make -j$(nproc) 
zip -r ../suyu-externals.zip .
gh release upload debug ../suyu-externals.zip
