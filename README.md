# Graphs in ML Project: Gaussian Process Optimization in the Bandit Setting

## Report
The report is the file ```Rapport/report.pdf```. It has been written in Latex and sources are in the folder ```Rapport```.

## Data
Temperature data are in the file ```data/temperature/1h_1month.csv```.

Trafic data are in the file ```data/traffic/san_diego_sb5_filtered_6-11am.csv```.

Trafic data has been gathered by scheduling as a cronjob the python script ```data/traffic/traffic_scraper_san_diego2.py```.

## Code
All project is written in Matlab/Octave (it has not been tested with Octave, even if it should be compatible).

To run experiments on synthetic data, run the script ```main_synthetic.m```

For experiments on temperature data, run the script ```main_temperature.m```

Finally, for experiments on trafic data, run the script ```main_trafic.m```
