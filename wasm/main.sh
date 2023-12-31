#!/usr/bin/bash
project_dir=$(pwd)
export project_dir
echo "make build dir"

echo "checking tools"
mkdir -p .tools
cd .tools

echo "Cheking cmake..."
exists=$(which cmake)
if [ -z "$exists" ]; then
    sudo apt install cmake
    cmake --version
fi

echo "Checking emsdk..."
exists=$(which emcmake)
if [ -z "$exists" ] && [ ! -d emsdk-main ]; then
    curl -L "https://github.com/emscripten-core/emsdk/archive/refs/heads/main.zip" -o emsdk.zip
    unzip -q emsdk.zip
    cd emsdk-main
    ./emsdk install latest
    cd -
fi
if [ -z "$exists" ]; then
    cd emsdk-main
    ./emsdk activate latest
    source ./emsdk_env.sh
    cd -
fi
emcc --version

# echo "Checking wasm-opt..."
# exists=$(which wasm-opt)
# binaryen_version="binaryen-version_114"
# if [ -z "$exists" ] && [ ! -d $binaryen_version ]; then
#     curl -L "https://github.com/WebAssembly/binaryen/releases/download/version_114/$binaryen_version-x86_64-linux.tar.gz" -o binaryen.tar.gz
#     tar xf binaryen.tar.gz
# fi
# if [ -z "$exists" ]; then
#     export PATH="$PATH:$project_dir/.tools/$binaryen_version/bin"
# fi
# wasm-opt --version

echo "Checking wasm-strip..."
exists=$(which wasm-strip)
wabt_version="1.0.33"
wabt_dir="wabt-$wabt_version"
if [ -z "$exists" ] && [ ! -d $wabt_dir ]; then
    curl -L "https://github.com/WebAssembly/wabt/releases/download/$wabt_version/$wabt_dir-ubuntu.tar.gz" -o wabt.tar.gz
    tar xf wabt.tar.gz
fi
if [ -z "$exists" ]; then
    export PATH="$PATH:$project_dir/.tools/$wabt_dir/bin"
fi
wasm-strip --version

cd $project_dir

echo "cleaning build dir..."
rm -rf build
mkdir build
cd build

echo "download libsimple master branch"
curl -L "https://github.com/wangfenjin/simple/archive/refs/heads/master.zip" -o libsimple.zip
unzip -q libsimple.zip

cd simple-master
patch -p1 < "$project_dir"/patches/throw.patch
patch -p1 < "$project_dir"/patches/libsimple.CMakeList.patch

echo "begin make libsimple static library"
mkdir build_static
cd build_static
emcmake cmake -DCODE_COVERAGE=OFF -DSIMPLE_WITH_JIEBA=OFF -DCMAKE_EXPORT_COMPILE_COMMANDS=ON -DBUILD_SQLITE3=OFF -DBUILD_TEST_EXAMPLE=OFF -DBUILD_STATIC=ON -DCMAKE_CXX_FLAGS="-fno-exceptions" ../
cmake --build . -v


sqlite_version="3430100"
sqlite_src_dir="sqlite-src-$sqlite_version"
echo "download sqlite version:$sqlite_version"
cd "$project_dir/build"
curl "https://sqlite.org/2023/$sqlite_src_dir.zip" -o sqlite.zip
unzip -q sqlite.zip
cd $sqlite_src_dir/

echo "begin build sqlite with libsimple"
./configure --enable-all
patch -p1 < "$project_dir/patches/sqlite.GNUmakefile.patch"
cd ext/wasm
cp $project_dir/patches/sqlite3_wasm_extra_init.{c,h} ./
# choose o2 for execute speed instead of file size
make dist dist.build=o2
# wasm-opt -O4 jswasm/sqlite3.wasm -o jswasm/sqlite3.opt.wasm
# mv jswasm/sqlite3.{,orginal.}wasm
# mv jswasm/sqlite3.{opt.,}wasm
ln -s $project_dir/build/$sqlite_src_dir/ext/wasm/sqlite-wasm-$sqlite_version.zip $project_dir/

echo "all build done.you can use in in sqlite-wasm-$sqlite_version.zip"
