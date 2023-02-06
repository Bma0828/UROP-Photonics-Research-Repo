import json
import argparse
import numpy as np
import seaborn as sns
import matplotlib.pyplot as plt
import scipy.io
import os

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
    nvalue: int value for the N value of lossless material. e.g. nvalue = 3.4. NOTE: If material is not lossless, LEAVE THIS EMPTY
'''

def get_command(wavevalue, anglevalue, thick, matname, nvalue=None):
    '''
    Return:
        runcommand: string of command that gets run on GLOnet main.py functions
        matcommand: string of command that is used to test the existance of output .mat file
    '''
    
    if (nvalue != None):
        filename = "rw" + str(wavevalue) + "a" + str(anglevalue) + "n" + str(nvalue) + "t" + str(thick)
    else:
        filename = "rw" + str(wavevalue) + "a" + str(anglevalue) + "t" + str(thick)
    runcommand = "python main.py --output_dir " + filename  + " --wavelength " + str(wavevalue) + " --angle "+ str(anglevalue) + " --thickness " + str(thick) + " --matname " + str(matname)
    matcommand = filename + '\outputs\imgs_w' + str(wavevalue) + '_a' + str(anglevalue) + 'deg.mat'
    return runcommand, matcommand

def create_json(wavevalue, anglevalue, thick, nvalue=None):
    '''
    Return:
        This function has no variable return. It create a new folder directory, 
        create and place a json file of parameters required for running GLOnet in the folder.
    '''

    # Get the current directory
    parser = argparse.ArgumentParser()
    cwd = os.getcwd()
    args = parser.parse_args()

    # Make a new directory for storing outputs and change to that directory
    if (nvalue != None):
        filename = "/rw" + str(wavevalue) + "a" + str(anglevalue) + "n" + str(nvalue) + "t" + str(thick)
    else:
        filename = "/rw" + str(wavevalue) + "a" + str(anglevalue) + "t" + str(thick)
    os.makedirs(cwd+filename, exist_ok = True)
    os.chdir(cwd+filename)

    # Create Json file inside that directory
    aDict = {
        "wavelength": wavevalue,
        "angle": anglevalue,
        "noise_dims": 256.0,
        "noise_amplitude": 1,
        "numIter": 1000.0,
        "gkernlen": 19.0,
        "gkernsig": 6.0,
        "lr": 1e-03,
        "beta1": 0.9,
        "beta2": 0.99,
        "batch_size_start": 100,
        "batch_size_end": 100,
        "batch_size_power": 1,
        "binary": 1,
        "binary_penalty_start": 0,
        "binary_penalty_end": 100,
        "binary_penalty_power": 4,
        "binary_step_iter": 400,
        "step_size": 5000000,
        "gamma": 1.0,
        "sigma_start": 0.7,
        "sigma_end": 0.7,
        "plot_iter": 50
    } 
    jsonString = json.dumps(aDict)
    jsonFile = open("Params.json", "w")
    jsonFile.write(jsonString)
    jsonFile.close()
    os.chdir(cwd)


def diff_angles_waves(angle_values, wave_values, thick, matname, n_value=None):
    '''
    Return:
        value_mat = np matrix storing best efficiencies of the best devices generated for each matching wavelength/angle values
    '''
    # Initialize value_mat with corresponding shape
    value_mat = np.zeros([len(wave_values), len(angle_values)])

    # Main loop for all values of wavelength and deflection angles
    for i in range(len(angle_values)):
        for j in range(len(wave_values)):
            # Create json file needed and commands for running GLOnet
            create_json(np.uint32(wave_values[j]).item(), np.uint32(angle_values[i]).item(), thick, n_value)
            runcmd, matcmd = get_command(wave_values[j], angle_values[i], thick, matname, n_value)
            print("Running Wavelength="+str(wave_values[j])+" Angle="+str(angle_values[i])+": "+" Thick="+str(thick))
            
            # Check if the output matrix for the current value of wavelength and angle exist, if yes, skip running GLOnet and use existing output results
            # Save time if exception happens during the middle of the loop after several successful runs
            if not os.path.exists(matcmd):
                os.system(runcmd)

            # Extract the value of efficiency of the best device from all devices generated
            mat = scipy.io.loadmat(matcmd)
            mat = mat.get('effs')

            # Show best efficiency from the best device and store the value in value_mat
            print("Best Efficency is: " + str(max(mat[0])))
            value_mat[j][i] = max(mat[0]) * 100
    return value_mat

def diff_thick(anglevalue, wavevalue, n_value, thickness, matname):
    '''
    Return:
        eff: 1-D np array storing best efficiencies of the best devices generated for all values of the thickness array.
    '''

    # Initialze n as list for easy appends
    n = []

    # Main loop for all thickness values
    for thick in thickness:
        # Create json file needed and commands for running GLOnet
        create_json(np.uint32(wavevalue).item(), np.uint32(anglevalue).item(), thick, n_value)
        runcmd, matcmd = get_command(wavevalue, anglevalue, thick, matname, n_value)
        print("Running Wavelength="+str(wavevalue)+" Angle="+str(anglevalue)+": "+" Thick="+str(thick))
        
        # Check if the output matrix for the current value of wavelength and angle exist, if yes, skip running GLOnet and use existing output results
        # Save time if exception happens during the middle of the loop after several successful runs
        if not os.path.exists(matcmd):
            os.system(runcmd)
        
        # Extract the value of efficiency of the best device from all devices generated
        mat = scipy.io.loadmat(matcmd)
        mat = mat.get('effs')

        # Show best efficiency from the best device and store the value in n
        print("Best Efficency is: " + str(max(mat[0])))
        n.append(max(mat[0]) * 100)
        eff = np.array(n)
    return eff

def heatplot(wave_values, angle_values, value_mat):
    '''
    Args:
        value_mat: np matrix storing best efficiencies of the best devices generated for each matching wavelength/angle values
    Return:
        This function has no return variables. Will generate a heatmap given the input matrix and show the heatmap.
    Example Shape:
               800   x   x   x   x   x
               700   x   x   x   x   x
    Wavelength 600   x   x   x   x   x
               500   x   x   x   x   x
               400   x   x   x   x   x 
                     40  50  60  70  80
                      Deflection Angle
    '''
    ax = sns.heatmap(value_mat,annot=True, fmt=".2f", cmap="RdYlGn", yticklabels=wave_values,xticklabels=angle_values,cbar_kws={'label': 'Deflection Efficiency(%)'})
    ax.set(ylabel="Wavelength(nm)", xlabel="Deflection Angle(deg)")
    plt.show()

def barplot(mat_name, wave_value, angle_value, thickness, eff):
    '''
    Args:
        eff: 1-D np array storing best efficiencies of the best devices generated for all values of the thickness array.
    Return:
        This function has no return variables. Will generate a barplot given the input array and show the barplot.
    Example Shape:
        100                      x
         80            x         x
    Eff  60            x    x    x
         40       x    x    x    x
         20   x   x    x    x    x 
             50  100  150  200  250
                  Thickness
    '''
    plt.plot(thickness, eff)
    plt.ylabel("Deflection Efficiency(%)"), 
    plt.xlabel("Thickness(nm)")
    plt.title(r'$Material: {2}\;\;\;\Lambda={0}nm\;\;\;\angle = {1}\degree$'
        .format(str(wave_value), str(angle_value), mat_name))
    plt.show()


