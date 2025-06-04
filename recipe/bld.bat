cmake %CMAKE_ARGS% --trace-expand -S . -B build ^
  -DCMAKE_INSTALL_PREFIX=%PREFIX% ^
  -DBUILD_SHARED_LIBS=ON ^
  -DINSTALL_LIBRARY=ON ^
  -DBUILD_PYTHON_MODULE=ON ^
  -DBUILD_TESTING=ON

REM cmake always creates a Debug build
REM cmake --build build --config Release
cd build
dir
msbuild mkdssp.sln /property:Configuration=Release
cd ..
cmake --install build

REM copy mkdssp.pyd file to correct location
copy build\bin\Release\mkdssp.pyd %SP_DIR%\mkdssp.pyd

REM remove extra files in bin
del \S \Q %PREFIX%\bin\msvcp*.dll
del \S \Q %PREFIX%\bin\vcruntime*.dll
del \S \Q %PREFIX%\bin\concrt140.dll

set LIBCIFPP_DATA_DIR=%PREFIX%\share\libcifpp
ctest --output-on-failure --test-dir build -C Release
dir

%PYTHON% -c "import sys; print(sys.path)"
