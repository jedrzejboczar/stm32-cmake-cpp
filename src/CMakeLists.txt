# STM32Cube generated code
add_subdirectory(stm32cube)

# Main loop (to be added in main.c)
target_sources(${CMAKE_PROJECT_NAME} PUBLIC ${CMAKE_CURRENT_SOURCE_DIR}/mainloop.cpp)

# Project sources
# add_subdirectory(yoursubdir1)
# add_subdirectory(yoursubdir2)
