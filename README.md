# libtdlpack

**libtdlpack** is a subset of Fortran subroutines from the MOS-2000 (MOS2K) software system used for reading and writing TDLPACK files.

>[!IMPORTANT]
>**_The primary use for this library will be to serve the [tdlpackio](https://github.com/NOAA-MDL/tdlpackio) Python package.  A handful of subroutines have been further modified to interface with C using the `ISO_C_BINDING` instrinsic module._**

## Introduction

The MOS2K system serves multiple functions, most notably providing subroutines for encoding and decoding the TDLPACK data format into Fortran variable-length unformatted files and direct-access files. In MOS2K terminology, these are referred to as "sequential" and "random access" files, respectively.

MOS2K is a collection of libraries and executable programs designed for [Model Output Statistics (MOS)](https://vlab.noaa.gov/web/mdl/mos) and, more recently, serves as the primary software for running the [National Blend of Models (NBM)](https://vlab.noaa.gov/web/mdl/nbm). The [NWS Meteorological Development Laboratory (MDL)](https://vlab.noaa.gov/web/mdl), formerly TDL, develops both the MOS2K software and the MOS and NBM guidance products. The complete MOS2K documentation is available in [TDL Office Note 00-1](https://www.weather.gov/media/mdl/TDL_OfficeNote00-1.pdf) and [TDL Office Note 00-2](https://www.weather.gov/media/mdl/OfficeNote2000-02.pdf).

## Development

libtdlpack will primarily focus on serving that purpose and supporting its core users—mainly meteorologists, physical scientists, and software developers working within NOAA’s National Weather Service (NWS), the National Centers for Environmental Prediction (NCEP), and other NOAA and U.S. Government organizations.

## Disclaimer

This repository is a scientific product and is not official communication of the National Oceanic and Atmospheric Administration, or the United States Department of Commerce. All NOAA GitHub project code is provided on an 'as is' basis and the user assumes responsibility for its use. Any claims against the Department of Commerce or Department of Commerce bureaus stemming from the use of this GitHub project will be governed by all applicable Federal law. Any reference to specific commercial products, processes, or services by service mark, trademark, manufacturer, or otherwise, does not constitute or imply their endorsement, recommendation or favoring by the Department of Commerce. The Department of Commerce seal and logo, or the seal and logo of a DOC bureau, shall not be used in any manner to imply endorsement of any commercial product or activity by DOC or the United States Government.
