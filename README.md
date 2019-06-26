# DroneDEM
This repository contains two scripts to analyse drone Digital Elevation Models (DEMs) against RTK GPS Ground Control Points. 
The script was prepared to illustrate the results of Casella et al. (under review), that compare the performance of different drone flight altitudes and different cameras. 
The two required inputs are: 
-an Excel file containing Ground Control Points (used in Agisoft Photoscan or similar software to georeference the DEM) and Control Points (indipendent RTK GPS points used as control). The excel file needs to be formatted as in the example.
-a folder containing the DEMs (geotiff format) derived from each drone flight. The file name will serve as label for each figure.

<b>Drone_data_extract.m</b> - This script compares Control Points and DEM elevations, and produces a figure showing the result of the comparison for each DEM in the dataset. The script also writes the results of the DEM analysis as text, comma separated files. This script needs the Matlab 'Mapping Toolbox', 'Image Processing Toolbox' and 'Statistics and Machine Learning Toolbox'

![Results_1](https://github.com/Alerovere/DroneDEM/blob/master/Results/Canon%20S100%2050m.png)

<b>Data_analysis.m</b> - This script takes the results of the previous step and plots them together into a summary figure. Before the final figure is produced, the user needs to insert manually the picture overlap, that is usually available in the processing reports of photogrammetric software. This script needs the Matlab 'Statistics and Machine Learning Toolbox'

![Results_2](https://github.com/Alerovere/DroneDEM/blob/master/Results/sumplots.png)

All the images and files are placed into the "Results" folder.
