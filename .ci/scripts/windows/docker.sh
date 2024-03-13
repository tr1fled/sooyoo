#!/bin/bash -ex

# SPDX-FileCopyrightText: 2019 yuzu Emulator Project & 2024 suyu Emulator Project
# SPDX-License-Identifier: GPL-2.0-or-later

set -e

#cd /suyu

#wine ccache.exe -sv

mkdir -p build && cd build
wine cmake.exe .. \
    -DCMAKE_BUILD_TYPE=Release \
    -DCMAKE_INSTALL_PREFIX=C:/windows-libs/mingw64/ \
    -DDISPLAY_VERSION="$1" \
    -DENABLE_COMPATIBILITY_LIST_DOWNLOAD=OFF \
    -DENABLE_QT_TRANSLATION=OFF \
#    -DUSE_CCACHE=ON \
    -DENABLE_LIBUSB=NO \
    -DSUYU_TESTS=OFF \
    -GNinja
wine ninja.exe suyu suyu-cmd

#wine ccache.exe -sv

echo "Tests skipped"
# TODO: actually run the tests
#ctest -VV -C Release

echo 'Prepare binaries...'
cd ..
mkdir package

find build/ -name "suyu*.exe" -exec cp {} 'package' \;

for i in package/*.exe; do
  # we need to process pdb here, however, cv2pdb
  # does not work here, so we just simply strip all the debug symbols
  x86_64-w64-mingw32-strip "${i}"
done

python3 .ci/scripts/windows/scan_dll.py package/*.exe "package/"

# copy FFmpeg libraries
EXTERNALS_PATH="$(pwd)/build/externals"
FFMPEG_DLL_PATH="$(find "${EXTERNALS_PATH}" -maxdepth 1 -type d | grep 'ffmpeg-')/bin"
find ${FFMPEG_DLL_PATH} -type f -regex ".*\.dll" -exec cp -nv {} package/ ';'

# copy libraries from suyu.exe path
find "$(pwd)/build/bin/" -type f -regex ".*\.dll" -exec cp -v {} package/ ';'
