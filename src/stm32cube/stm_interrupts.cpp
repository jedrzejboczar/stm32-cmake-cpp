/*
    Callback handlers.
    It is probably the easiest to store all callback functions in one file.
*/

/* Includes (or declare functions with 'extern' if it's prefered) */
// #include "my_header.h"

extern "C" {


/* Example callback:
    void HAL_TIM_PeriodElapsedCallback(TIM_HandleTypeDef *htim) {
        if (htim->Instance == stm::delayTimer.Instance)
            onTimPeriodElapsed();
    }
*/


/*
    Note about Priority in ARM Cortex-M

    High priority means low priority number, low priority means high number.
    In call to NVIC_SetPriority(IRQn, priority) write priority "just as is" (don't shift the value left).

    There are two parts of priority: preemption priority and subpriority,
    available priority bits are divided between these two.
    To do so use function NVIC_SetPriorityGrouping(NVIC_PRIORITYGROUP_X).

    Preemption priority allows for preempting interrupts, which means that
    interrupt with higher preempt priority can interrupt the one with lower.
    Subpriority is used only for choosing which of pending interrupts to process next.

    Default division in HAL_Init is NVIC_PRIORITYGROUP_4, so 4 bits for preemption, 0 bits for subpriority.
    Default SysTick priority in HAL_Init is TICK_INT_PRIORITY from *_hal_conf.h,
    that is set for preemption priority (default value 0x0f - lowest priprity).
*/
}
