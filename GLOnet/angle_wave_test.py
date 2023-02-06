import numpy as np
from test_functions import diff_angles_waves, heatplot

'''
Common Args:
    wavevalue: int value of wavelength
    wave_values: np array of all values of wavelength

    anglevalue: int value of deflection angle
    angle_values: np array of all values of deflection angle
    
    thickness: np array of all values of thickness
    thick: int value of best thickness

    matname: string of created file name in .mat format for material name. e.g. matname = "ITO.mat" 
    NOTE: For none lossless material, the file must be manually stored in /solvers directory before running the code.

    nvalue: int value for the N value of lossless material. e.g. nvalue = 3.4. 
    NOTE: If material is not lossless, LEAVE THIS EMPTY
'''

# Initialization
angle_values = np.array([40, 50, 60, 70, 80])
wave_values = np.array([800, 700, 600, 500, 400])
n_value = None
thick = 450
mat_file_name = 'ITO.mat'

# Call Functions
value_mat = diff_angles_waves(angle_values, wave_values, thick, mat_file_name, n_value)
heatplot(wave_values, angle_values, value_mat)