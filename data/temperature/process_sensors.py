#!/usr/bin/env python3

# Peprocess intial data file 'sensors.txt':
# awk -F" " '{ print $1" "$2" "$4" "$5}' sensors_full.txt > sensors.txt
# cat sensors.txt | sort -t ' ' -k 3,3n -k2 > sensors_sorted.txt
# Then launch this python script

import pandas as pd
from datetime import datetime

filename = 'sensors_sorted.txt'
i = 0
rows = []
last_hour = -1

with open(filename) as f:
    for line in f:
        elements = line.split(' ')
        # print(elements)
        date = elements[0]
        sensor_id = elements[2]
        if date < '2004-02-29' or date > '2004-03-30' or sensor_id == '':
            continue

        hour = elements[1].split(':')[0]
        temperature = elements[3].split('\n')[0]

        if hour == last_hour:
            continue
        else:

            last_hour = hour

            date_time = datetime.strptime(date + ' ' + hour, '%Y-%m-%d %H')       
            # date_formated = date_time.strftime('%Y-%m-%d %H-%M-%S')
            date_formated = date_time.timestamp()

            rows = rows + [{
                'sensor_id': sensor_id,
                'datetime':date_formated, 
                'temperature':temperature
            }]

        i = i + 1

D = pd.DataFrame(rows)
filename = "/Users/EmileMathieu/Desktop/MVA/S1/Graphs/Projet/data/temperature/1h_1month.csv"
D.to_csv(filename, index=True, header=False)