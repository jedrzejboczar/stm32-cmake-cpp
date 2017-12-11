###############################################################################
### Makefile for building cmake projects for STM32
###############################################################################

### STM32
# STM32_FAMILY is not needed if STM32_CHIP is provided
# default TARGET_TRIPLET = arm-none-eabi is ok
STM32_CHIP = STM32F407VGT6
STM32Cube_DIR = $(HOME)/opt/stm32cubemx/repo/STM32Cube_FW_F4_V1.18.0
STM32_MODULE_PATH = $(HOME)/opt/stm32-cmake/cmake

### CMake
CMAKE_BUILD_TYPE = Debug
CMAKE_INSTALL_PREFIX = /tmp/install
BUILD_DIR = ./build
NJOBS = 3
# "Ninja" for ninja, "Unix Makefiles" for make
CMAKE_GENERATOR = Ninja
# additional flags
CMAKE_FLAGS = -DCMAKE_EXPORT_COMPILE_COMMANDS=1

### Remote device
# copy the needed script from /usr/share/openocd/scripts/ to project directory
# as for now it has to be 'remote/openocd.cfg' as it is hard-coded into gdbinit
OPENOCD_CONFIG = remote/openocd.cfg
# this is the cmake project name
EXECUTABLE_PATH = $(BUILD_DIR)/stm32
# commands to start remote debugging with gdb through openocd
GDB_INIT = remote/gdbinit

###############################################################################
###############################################################################

CMAKE_TOOLCHAIN_FILE = $(STM32_MODULE_PATH)/gcc_stm32.cmake
CMAKE_FLAGS += \
	-DSTM32_CHIP="$(STM32_CHIP)" \
	-DSTM32Cube_DIR="$(STM32Cube_DIR)" \
	-DCMAKE_BUILD_TYPE="$(CMAKE_BUILD_TYPE)" \
	-DCMAKE_INSTALL_PREFIX="$(CMAKE_INSTALL_PREFIX)" \
	-DCMAKE_MODULE_PATH="$(STM32_MODULE_PATH)" \
	-DCMAKE_TOOLCHAIN_FILE="$(CMAKE_TOOLCHAIN_FILE)" \

# all targets are just commands (no specific files produced)
.PHONY: build cmake clean cleanall upload gdb gdbgui rtags rtagsclear

### Main targets
# only 'cmake' has to be called explicitly (if not using GLOB
# it is sufficient to use 'cmake' only once at project generation)
build:
	cmake --build $(BUILD_DIR)

cmake:
	cmake -E make_directory $(BUILD_DIR)
	cd $(BUILD_DIR) && cmake $(CMAKE_FLAGS) -G "$(CMAKE_GENERATOR)" ..

clean:
	cmake --build $(BUILD_DIR) --target clean

cleanall:
	rm -rf $(BUILD_DIR)/*

### Connections
# udev rule needed (or run with sudo)
# paths are quite hard-coded
upload: build
	openocd -f $(OPENOCD_CONFIG) -c "program $(EXECUTABLE_PATH) verify reset exit"

gdb: build
	arm-none-eabi-gdb --command=$(GDB_INIT)  $(EXECUTABLE_PATH)
	killall openocd || true

# for https://github.com/cs01/gdbgui (but has problems with remote operation)
gdbgui: build
	gdbgui --gdb=arm-none-eabi-gdb --gdb_cmd_file=$(GDB_INIT) $(EXECUTABLE_PATH)
	killall openocd || true

killopenocd:
	killall openocd || true

### RTags: feed compile_commands.json to RDM deamon
rtags:
	rc -J $(BUILD_DIR)

rtagsclear:
	rc --clear
