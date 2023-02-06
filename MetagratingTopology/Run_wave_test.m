% The thickness test needs to clear workspaces, please make sure to store
% your data prior to running the code or parameters may be lost.
close all
clear all
addpath('Functions')

% Tunable parameters, full list of parameters and descriptions could be 
% found in 'Functions/Initialize.m'
name = 'n2.1k0';
Method = 'TE';

% Parameters for refractive index. For n and k value changes with
% wavelength, use const_ri = 0 and input refractive_ri as a  matrix of n
% and k values. i.e.[n_value1, k_value1 ; n_value_2, k_value2, ...]
refractive_i = 2.1;
const_ri = 1;

% list of wavelength and deflection angle values for this test
Target_angle = [80, 70, 60, 50, 40];
Wavelength = [400, 500, 600, 700, 800];

% Thickness value for generated device, must remain constant in this test
thickness = 400;

% edge deviation ranges in nanometers
startdeviation = [-5 0 5]; 

% Call functions to run the test 
[Best_wave, Best_angle, Best_eff] = Best_wave_test(name, refractive_i, thickness, Wavelength, Target_angle, Method, startdeviation, const_ri);

% Display results
disp('--------------RESULT-------------------')
fprintf('Best Wavelength is %d', Best_wave)
fprintf('Best Target Angle is %d', Best_angle)
fprintf('Best Efficiency is %d', Best_eff)