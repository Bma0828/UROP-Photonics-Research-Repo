% The thickness test needs to clear workspaces, please make sure to store
% your data prior to running the code or parameters may be lost.
close all
clear all
addpath('Functions')

% Tunable parameters, full list of parameters and descriptions could be 
% found in 'Functions/Initialize.m'
name = 'n2.1k0';
refractive_i = 2.1;
Method = 'TM';

% Target wavelength and deflection angle, must remain constant in this test
Wavelength = 400;
Target_angle = 40;

% list of thickness values for this test
thickness = [100, 200, 300, 400, 500, 600, 700, 800, 900, 1000];

% edge deviation ranges in nanometers
startdeviation = [-5 0 5]; 

% Call functions to run the test
[Best_thick, Best_eff] = Best_thick_test(name, refractive_i, thickness, Wavelength, Target_angle, Method, startdeviation);

% Display results
disp('--------------RESULT-------------------')
fprintf('Best Thickness is %d', Best_thick)
fprintf('Best Efficiency is %d', Best_eff)
