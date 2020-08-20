# Checking the status of the CTD Reference database (RDB) for Argo DMQC

To perform an adequate Argo Salinity DMQC is necessary to use reference databases with appropriate temporal and spatial coverage. The CTD-RDB is maintained and updated by Coriolis operational services (IFREMER). To guarantee the high quality of the data, the CTD-RDB users (DMQC operators)
are encouraged to perform a local audit for their region of interest and provide feedback in case they encounter errors, suspicious data, large temporal gaps, etc.

This repository hosts some code to perform a first diagnosis of the CTD-RDB in a user-defined region.

## How to use?
Add the repository (and the required toolboxes and functions, see below) to your Matlab path and run the script check_RD_proc.m.
This code will ask you for inputs (see below) in the command window.
Leaving the inputs empty will run the analysis for an example region (Weddell Sea)

## Input
Added by the user in the command window

- Region definition
  - Name: Ex. 'Nordic Seas'
  - List of WMO boxes: Ex. [1600 1601 .. 7802];
  - (optional) Geographical areas that you want to exclude from the analysis
- Grid definition:
  - Longitude and Latitude limits: Ex. [-30 30] and [60 90]
  - Grid step (in degrees): Ex. 2
- Map and plot settings
  - m_map projection string ? Ex. ['m_proj(''Albers'',''lon'',lonlims,''lat'',latlims)'];
  - Positions of the x-axis (longitude) and the y-axis (latitude) ticks as a vector: Ex. [-30:10:30] and [60:10:90]
  - Bathymetry contours (m) to be plotted.
  - Marker Size for the color-coded plots
  - Font Size for plots

## Output
Some of the outputs for the Weddell Sea can be downloaded here: https://filebox.bsh.de/index.php/s/Q6fRvTjmSwuC0UM

  - RD_CTD2019v01_*region name*.mat containing all data selected.
  - SD_RD_CTD2019v01_*region name*.mat and SD_RD_CTD2019v01_*region name*.txt
    containing the output of the diagnostic test
  - Figures (saving the plots is optional)
    - World Map with all WMO boxes. Selected boxes are highlighted.
    - Grid maps: 'Number of profiles per bin', 'Year of the latest profile per bin';
    - Scatter maps: 'Profile positions - year is color-coded',
     'Profile positions - Maximum Recorded Pressure (MRP) is color-coded',
     'Profile positions - MRP<900 is color-coded';
     'Profile positions - Presence of invalid samples color-coded';
    - Histograms: 'Number of profiles per year', 'Number of profiles per month',
      'Number of profiles per MRP intervals [db]';
    - Data for each boxes: One plot per box containing Profile positions (with
      color-coded year), Temperature and Salinity profiles and a TS diagram.

## Requirements (data)
- Full path to the folder containing the reference database OR
- Login and password for downloading it.

## Requirements (toolboxes and functions)

- Ingrid Angel's utility functions
  https://github.com/imab4bsh/imab
- OCEANS
	http://mooring.ucsd.edu/software/matlab/mfiles/toolbox/.download/ocean_download.zip
- m_map
	https://www.eoas.ubc.ca/~rich/map.html
- export_fig to save figures
	https://github.com/altmany/export_fig
	https://www.mathworks.com/matlabcentral/fileexchange/23629-export_fig
- finput
	https://www.mathworks.com/matlabcentral/fileexchange/49727-finput
- Jan Even Nilsen's functions (https://github.com/evenrev1/evenmat): mima.m and wmosquare.m

## Funding

This work is part of the following projects: MOCCA received funding from the European Maritime and Fisheries Fund (EMFF) under grant agreement No.
EASME/EMFF/2015/1.2.1.1/SI2.709624. EA-RISE is funded by the European Union’s Horizon 2020 research and innovation programme under grant agreement No. 824131

<img src="https://www.euro-argo.eu/var/storage/images/_aliases/fullsize/medias-ifremer/medias-euro_argo/eu-project-contribution/mocca/logo_mocca_4-3/1537744-1-eng-GB/Logo_MOCCA_4-3.jpg" width="100" /> <img src="https://www.euro-argo.eu/var/storage/images/_aliases/fullsize/medias-ifremer/medias-euro_argo/logos/euro-argo-rise-logo/1688041-1-eng-GB/Euro-argo-RISE-logo.png" width="100" />

and is developed by the Federal Maritime and Hydrographic Agency (Bundesamt für Seeschifffahrt und Hydrographie, BSH) 

<img src="https://www.bsh.de/SiteGlobals/Frontend/Images/logo.png?__blob=normal&v=9" width="50" />
