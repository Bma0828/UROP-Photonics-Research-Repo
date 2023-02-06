# Thickness and Angle-Wave Test for Global optimization based on generative nerual networks (GLOnet)

## Requirements

We recommend using python3 and a virtual environment

```
virtualenv -p python3 .env
source .env/bin/activate
pip install -r requirements.txt
```

When you're done working on the project, deactivate the virtual environment with `deactivate`.

NOTE: If some of the aforementioned commands failed to work, try include `python -m` before commands, for instance:
```
python -m virtualenv -p python3 .env
python -m source .env/bin/activate
pip install -r requirements.txt
```


A matlab engine for python is needed for EM simulation. Please refer to [MathWorks Pages](https://www.mathworks.com/help/matlab/matlab_external/install-matlab-engine-api-for-python-in-nondefault-locations.html) for installation.

Path of [RETICOLO](https://www.lp2n.institutoptique.fr/equipes-de-recherche-du-lp2n/light-complex-nanostructures) should be added in the `main.py`

## Training the GLOnet

You can change the parameters by editing parameters included in `Initialization` section in `thickness_test.py` and `angle_wave_test.py` files. 

If you want to train the network with default parameters provided by MetaNet, simply run
```
python main.py 
```

or 

```
python main.py --output_dir results --wavelength 900 --angle 60
```

to specify non-default output folder or parameters

If you want to run thickness test for a certain range of thickness values, please modify parameters in `thickness_test.py` and run
```
python thickness_test.py 
```

If you want to run test for a heatmap with certain range of wavelength and deflection angle values, please modify parameters in `angle_wave_test.py` and run
```
python angle_wave_test.py 
```

NOTE: If some of the aforementioned commands failed to work, try python3 instead of python depending on your environment. 

## Results

Results will be stored in separate folders with name `"rw" + wavevalue + "a" + anglevalue + "n" + nvalue + "t" + thick`.

There will be following files inside the result folder:

	-figures/  (figures of generated devices and loss function curve)
	
	-model/    (all weights of the generator)
	
	-outputs/  (500 generated devices in `.mat` format)
	
	-history.mat
	
	-train.log

## Citation
If you use this code for your research, please cite:

[Simulator-based training of generative models for the inverse design of metasurfaces.<br>](https://arxiv.org/abs/1906.07843)
Jiaqi Jiang, Jonathan A. Fan 

[Global Optimization of Dielectric Metasurfaces Using a Physics-Driven Neural Network.<br>](https://pubs.acs.org/doi/abs/10.1021/acs.nanolett.9b01857)
Jiaqi Jiang, Jonathan A. Fan

