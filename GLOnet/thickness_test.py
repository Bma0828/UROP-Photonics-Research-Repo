import numpy as np
from test_functions import diff_thick, barplot

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
mat_name = "Indium Tin Oxide"
anglevalue = 60
wavevalue = 400
nvalue = 3.0
thickness = np.array(range(50,1001,50))
matname = 'ITO.mat'

# Call Functions
eff = diff_thick(anglevalue, wavevalue, nvalue, thickness, matname)
barplot(mat_name, wavevalue, anglevalue, thickness, eff)
