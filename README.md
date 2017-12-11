# STM32Cube + CMake + C++

This is a template for creating projects using CMake with STM32CubeMX generation tool. It allows to use C++, but can be easily modified for pure C. For the toolchain.cmake you need to download [stm32-cmake](https://github.com/ObKo/stm32-cmake) (there's a straightforward tutorial on its usage too).

Above all it is just a code snippet. You have to understand it and modify the way you need. Use it however you want.

## Usage

First generate the Cube project in the directory src/stm32cube and set the project name in CMakeLists.txt there. Cube code generation options don't matter, but if not needed then set toolchain to "Other Toolchains" and don't copy libraries.

Then do the standard cmake project generation & build, providing the definitions ([stm32-cmake](https://github.com/ObKo/stm32-cmake) for more details and options):

* *CMAKE_BUILD_TYPE* --- release/debug build
* *STM32_CHIP* --- the MCU used
* *CMAKE_MODULE_PATH* --- path to the stm32-cmake module
* *CMAKE_TOOLCHAIN_FILE* --- path to the gcc_stm32.cmake toolchain file
* *STM32Cube_DIR* --- directory with used STM32Cube repository

**Example CMake usage:**
~~~bash
> mkdir build/
> cd build/
> cmake
-DCMAKE_BUILD_TYPE=Debug
-DSTM32_CHIP=STM32F407VGT6
-DCMAKE_MODULE_PATH=/opt/stm32-cmake/cmake/
-DCMAKE_TOOLCHAIN_FILE=/opt/stm32-cmake/cmake/gcc_stm32.cmake
-DSTM32Cube_DIR=/opt/STM32Cube_FW_F4_V1.17.0
..
~~~

**For linux you may use the Makefile provided** (but it may be helpful anyway).

## Remote operation

Copy the necessary openocd configuration from default scripts (*/usr/share/openocd/scripts/*) and modify if needed. See example of remote operations in *Makefile*.

## Bridge between STM32Cube and user code

To make the program a little less "hard-coded" you may use the example structure provided in *src/stm32cube* (*stm_config.h, stm_config.cpp, stm_interrupts.cpp*). The main idea is to group everything in one place so it can be easily modified.
