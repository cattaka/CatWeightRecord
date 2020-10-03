#! /usr/bin/python3

import time
import sys
import statistics as stt

EMULATE_HX711=False
RECORD_LIMIT_SEC=5.0
THRESHOLD_COUNT=30
THRESHOLD_VARIANCE=0.05
THRESHOLD_DIFF_MEAN=0.5
DELAY_FOR_SAVE=5

referenceUnit = -19209.1867659067

if not EMULATE_HX711:
    import RPi.GPIO as GPIO
    from hx711py.hx711 import HX711
else:
    from emulated_hx711 import HX711

def cleanAndExit():
    print("Cleaning...")

    if not EMULATE_HX711:
        GPIO.cleanup()
        
    print("Bye!")
    sys.exit()

hx = HX711(5, 6)

hx.set_reading_format("MSB", "MSB")

hx.set_reference_unit(referenceUnit)

hx.reset()

hx.tare()

print("Tare done! Add weight now...")

records = []

hx.power_down()
hx.power_up()
last_fixed = False
last_fixed_mean = None
delay_for_save = -1

while True:
    try:
        value = hx.get_weight(1)

        ct = time.monotonic()
        records.append([ct, value])
        records = list(filter(lambda r: r[0] > ct - RECORD_LIMIT_SEC, records))
        
        if len(records) < THRESHOLD_COUNT:
            print("Read initial values: %d" % (len(records)))
            continue

        variance = stt.variance(map(lambda r: r[1], records))
        mean = stt.mean(map(lambda r: r[1], records))

        value_to_save = 0
        if variance < THRESHOLD_VARIANCE:
            if not last_fixed:
                delay_for_save = DELAY_FOR_SAVE
            last_fixed = True
        else:
            if last_fixed:
                last_fixed_mean = stt.mean(map(lambda r: r[1], records[:-DELAY_FOR_SAVE]))
            delay_for_save = -1
            last_fixed = False
        if delay_for_save > 0 and last_fixed_mean is not None:
            delay_for_save -= 1
            if delay_for_save == 0:
                value_to_save = mean - last_fixed_mean
                

        print("%.5f, %d, %.5f, %.5f, %.5f" % (value, len(records), variance, mean, value_to_save))

#        time.sleep(0.1)

    except (KeyboardInterrupt, SystemExit):
        cleanAndExit()
