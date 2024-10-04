#include "tick_sys.h"
#include "tt_tasks.h"
#include "driver/timer.h"

void IRAM_ATTR timer0_isr(void*) {
    // Clear the interrupt
    timer_group_clr_intr_status_in_isr(TIMER_GROUP_0, TIMER_0);

    // Reload the timer
    timer_group_enable_alarm_in_isr(TIMER_GROUP_0, TIMER_0);

    // Task update
    Task_Update();
}

void Config_TIMER_Int(const float timer_divider, const float timer_scale, const float timer_interval_sec) {
    // Initialize the timer
    timer_config_t config = {
        .alarm_en = TIMER_ALARM_EN,
        .counter_en = TIMER_PAUSE,
        // .intr_type = TIMER_INTR_LEVEL,
        .counter_dir = TIMER_COUNT_UP,
        .auto_reload = TIMER_AUTORELOAD_EN,
        .divider = timer_divider
    };
    timer_init(TIMER_GROUP_0, TIMER_0, &config);

    // Set the timer counter value
    timer_set_counter_value(TIMER_GROUP_0, TIMER_0, 0);

    // Set the alarm value
    timer_set_alarm_value(TIMER_GROUP_0, TIMER_0, timer_scale * timer_interval_sec);

    // Enable the interrupt
    timer_enable_intr(TIMER_GROUP_0, TIMER_0);
    timer_isr_register(TIMER_GROUP_0, TIMER_0, timer0_isr, NULL, ESP_INTR_FLAG_IRAM, NULL);

    // Start the timer
    timer_start(TIMER_GROUP_0, TIMER_0);
}