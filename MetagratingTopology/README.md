# Thickness Test and Angle-Wave Test for Metagrating-Topology-Optimization

## Requirements
Matlab 2015b or newer. Older versions may be sufficient but have not been tested.

RETICOLO - rigourous coupled wave analysis (RCWA) solver. Can be downloaded from [RETICOLO](https://www.lp2n.institutoptique.fr/equipes-de-recherche-du-lp2n/light-complex-nanostructures). Copy the folder `reticolo_allege` into the working directory. Copy the provided version of retu.m into the `reticolo_allege` directory as the default retu.m file from newer downloads was causing instabilities.

## Quick Start
Run `RunOpt.m` with default parameters. The example optimization should begin immediately if all files have been installed corrected.

In `RunOpt.m`, define all optimization parameters as necessary. Descriptions of all parameters can be found in `Functions/Initialize.m` along with their default values.

A schematic of metagrating parameter defintions can be found at [MetaNet](http://metanet.stanford.edu/search/dielectric-metagratings/info/).

## Material Features
There are two inputs for characterizing the property of the material:

For constant n-value materials:
    
    const_ri: should be set to 1 to mark constant value.
    
    refractive_i: int or float value for the refractive index of the material, this value could be set as complex number if the material is non lossless. 
    i.e. 2.00623473609108+1i*0.0162199352172530.

For materials that n and k values changes with wavelength:

    const_ri : should be set to 0 to mark non-constant value of refractive index.

    refractive_i: matrix of n and k of the material, number of column of the matrix should match the number of wavelength input, with each column entry matching each wavelength value. 
    i.e. for P_si: 
        Wavelength = [210.31, 211.9, 213.49]
                          n       k
        refractive_i = [1.3116, 2.8035]
                       [1.3277, 2.8291]
                       [1.3442, 2.8550]
                       
## Features
Tunable parameters in `Run_thick_test.m` and `Run_wave_test.m` include:

    name: String value for the name of the output folder. This parameter does not affect any results in tests.

    

    Method: Polarization method for running tests, possible inputs include: 'TE', 'TM', 'BOTH'.

    Wavelength: Value (`Run_thick_test.m`) or list of values (`Run_wave_test.m`) for target wavelength in nanometers.

    Target_angle: Value (`Run_thick_test.m`) or list of values (`Run_wave_test.m`) for target deflection angle in degrees.

    startdeviation: list of values for the range of starting edge deviations for the fabricated model in nanometers. For definition of edge deviation, see 
    [Supporting Information](https://pubs.acs.org/doi/suppl/10.1021/acs.nanolett.7b01082/suppl_file/nl7b01082_si_001.pdf)

## Running Tests
After initialzation of all parameters, run `Run_thick_test.m` and `Run_wave_test.m` to get a barplot and a heatmap results alongside with all results of Metagrating Topology Optimization in separate folders.

## Citation
Please cite this code as:

[MetaNet: A new paradigm for data sharing in photonics research<br>](https://arxiv.org/abs/2002.03050)
Jiaqi Jiang, Robert Lupoiu, Evan W. Wang, David Sell, Jean Paul Hugonin, Philippe Lalanne, Jonathan A. Fan
