### PROJECT ###################################################################
cmake_minimum_required(VERSION 3.1)
enable_language(ASM)  # needed for startup_*.s files
project(stm32)

set(CMAKE_EXPORT_COMPILE_COMMANDS ON)  # optional, creates compile_commands.json


### COMPILATION OPTIONS #######################################################
## Linker
# use newlib-nano - minimal implementation of libc that removes unneeded features
set(LINKER_SPECS "--specs=nano.specs --specs=nosys.specs")
set(CMAKE_EXE_LINKER_FLAGS "${CMAKE_EXE_LINKER_FLAGS} ${LINKER_SPECS}")
set(CMAKE_MODULE_LINKER_FLAGS "${CMAKE_MODULE_LINKER_FLAGS} ${LINKER_SPECS}")
set(CMAKE_SHARED_LINKER_FLAGS "${CMAKE_SHARED_LINKER_FLAGS} ${LINKER_SPECS}")

## Compiler
# disable c++ exceptions and runtime type info (they're too expensive for embedded)
set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -fno-exceptions -fno-rtti")


### TARGET ####################################################################
add_executable(${CMAKE_PROJECT_NAME} "")  # add sources with target_sources()
stm32_set_target_properties(${CMAKE_PROJECT_NAME})
stm32_add_hex_bin_targets(${CMAKE_PROJECT_NAME})
stm32_print_size_of_targets(${CMAKE_PROJECT_NAME})


### EXTERNAL SOURCES ##########################################################
# Hardware abstraction libraries - CMSIS and STM32HAL
find_package(CMSIS REQUIRED)
find_package(STM32HAL COMPONENTS
    gpio REQUIRED
)
target_include_directories(${CMAKE_PROJECT_NAME} PUBLIC ${CMSIS_INCLUDE_DIRS} PUBLIC ${STM32HAL_INCLUDE_DIR})
target_sources(${CMAKE_PROJECT_NAME} PUBLIC ${CMSIS_SOURCES} PUBLIC ${STM32HAL_SOURCES})


### INTERNAL SOURCES ##########################################################
# STM32Cube generated code
add_subdirectory(src/stm32cube)

# # Project sources
# add_subdirectory(src/your/subdirectory)


### Libraries #################################################################

# ## ARM math library
# # linking with prebuilt original library from https://github.com/ARM-software/CMSIS/tree/master/CMSIS/Lib/GCC
# # prebuild version needs hardware float abi so... (you could compile from source too, but it takes some time - about 300 source files)
# string(REPLACE "-mfloat-abi=softfp" "-mfloat-abi=hard" CMAKE_C_FLAGS "${CMAKE_C_FLAGS}")
# string(REPLACE "-mfloat-abi=softfp" "-mfloat-abi=hard" CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS}")
# string(REPLACE "-mfloat-abi=softfp" "-mfloat-abi=hard" CMAKE_ASM_FLAGS "${CMAKE_ASM_FLAGS}")
# string(REPLACE "-mfloat-abi=softfp" "-mfloat-abi=hard" CMAKE_EXE_LINKER_FLAGS "${CMAKE_EXE_LINKER_FLAGS}")
# string(REPLACE "-mfloat-abi=softfp" "-mfloat-abi=hard" CMAKE_MODULE_LINKER_FLAGS "${CMAKE_MODULE_LINKER_FLAGS}")
# string(REPLACE "-mfloat-abi=softfp" "-mfloat-abi=hard" CMAKE_SHARED_LINKER_FLAGS "${CMAKE_SHARED_LINKER_FLAGS}")
# target_link_libraries(${CMAKE_PROJECT_NAME} "${CMAKE_CURRENT_SOURCE_DIR}/path/to/prebuilt/libarm_cortexM4lf_math.a")
