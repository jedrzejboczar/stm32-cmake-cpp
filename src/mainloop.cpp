/*
    This is the "second main". Here it is possible to use regular C++.
    It should be called in main.c to take over controll for the rest of program,
    for example:

    / * USER CODE BEGIN 2 * /
    extern void mainloop();
    mainloop();
    / * USER CODE END 2 * /

 */

#include "stm_config.h"


extern "C" void mainloop() {

    while (1) {

    }
}
