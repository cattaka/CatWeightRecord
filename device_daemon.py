#! /usr/bin/python3

import time
import sys
import statistics as stt
import picamera
import io
import requests

EMULATE_HX711=False
RECORD_LIMIT_SEC=5.0
THRESHOLD_COUNT=30
THRESHOLD_VARIANCE=0.05
THRESHOLD_DIFF_VALUE=0.5
DELAY_FOR_SAVE=5

API_URL='http://localhost:3000/cat_weight_scale/weight_events'

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

def post_image(value: float):
    buffer = io.BytesIO()
    with picamera.PiCamera(resolution=(320,240)) as camera:
        camera.capture(buffer, format='jpeg', quality=50)
        buffer.seek(0)
    response = requests.post(API_URL,
        data = {"weight_event[label]": '', "weight_event[value]": '{:0.3f}'.format(value)},
        files = {"weight_event[image_file]": ("image.jpg", buffer.read(), "image/jpeg")}
    )
    print(response.status_code)

hx = HX711(5, 6)
hx.set_reading_format("MSB", "MSB")
hx.set_reference_unit(referenceUnit)
hx.reset()
hx.tare()
hx.power_down()
hx.power_up()

print("Tare done! Add weight now...")

records = []
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

        value_to_save = None
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

        if value_to_save is not None and abs(value_to_save) >= THRESHOLD_DIFF_VALUE:
            post_image(value_to_save)
            print("%.5f, %d, %.5f, %.5f, %.5f" % (value, len(records), variance, mean, value_to_save))

    except (KeyboardInterrupt, SystemExit):
        cleanAndExit()
