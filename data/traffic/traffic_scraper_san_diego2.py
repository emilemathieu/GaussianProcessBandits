#!/usr/bin/env python3

import re
import json
import codecs
import datetime
import requests
from lxml import html
import pandas as pd
from pathlib import Path

rows = []
for hwyid in ['sb5']:#range(48):
    headers = {'User-agent':'Mozilla/5.0 (X11; Linux x86_64; rv:2.0.1) Gecko/20110506 Firefox/4.0.1'}
    R = requests.get('http://www.dot.ca.gov/dist11/d11tmc/sdmap/showmap.php?route='+str(hwyid), headers=headers)
    T = R.content

    U = codecs.decode(T, 'ISO-8859-1')
    H = html.fromstring(U)

    L = H.xpath('//table[@id="speeds"]/tr/td[1]')
    location_list = [l.text_content().strip() for l in L]

    L = H.xpath('//table[@id="speeds"]/tr/td[2]')
    speed_list = [l.text_content().strip() for l in L]

    L = H.xpath('//tr[@class="titlerow"]/td[2]')
    date = L[0].text_content().strip().split('5 South Bound')[1]
    DDmmSS = date.split(' ')[3].split(':')
    #date_formated = pd.to_datetime(date, format="%MMM %D '%YY HH:mm:SS")
    df = pd.DataFrame({'year': [2016],'month': [12],'day': [date.split(' ')[1]], 'hour':[DDmmSS[0]], 'minute':[DDmmSS[1]], 'second':[DDmmSS[2]]})
    date_formated = pd.to_datetime(df)[0]
    
    rows = rows + [{
    'datetime':date_formated, 
    'hwy_id':hwyid,
    'location':l,
    'speed':s.split(' ')[0]} for l,s in zip(location_list, speed_list)]

D = pd.DataFrame(rows)
D = D.drop(0)
D_small = D.copy()
D_small.drop(D_small.columns[[0, 1, 2]], axis=1, inplace=True)
filename_full = "/Users/EmileMathieu/Desktop/MVA/S1/Graphs/Projet/data/traffic/san_diego_full_"+"sb5"+".csv"
filename = "/Users/EmileMathieu/Desktop/MVA/S1/Graphs/Projet/data/traffic/san_diego_"+"sb5"+".csv"
if Path(filename).is_file():
    print('file exists')
    D.to_csv(filename_full, index=True, mode='a', header=False)
    D_small.to_csv(filename, index=True, mode='a', header=False)
else:
    print('does not exists')
    D.to_csv(filename_full, index=True)
    D_small.to_csv(filename, index=True)