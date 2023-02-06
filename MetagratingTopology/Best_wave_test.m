function [Best_wave, Best_angle, Best_eff] = Best_wave_test(name, refractive_i, thickness, Wavelength, Target_angle, Method, startdeviation, const_ri)
% Initialization
Best_wave = 0;
Best_angle = 0;
Best_eff = 0;
heatmapMat = zeros(length(Target_angle), length(Wavelength));
count = 1;

% Main Optimization Loop
for wave = Wavelength
    for angle = Target_angle
        % Create name for storing folder
        fname = strcat('OptOutTE_ANGLE', string(angle), '_WL', string(wave), '.mat');
        existFolder = true;
        dirname = strcat('OptOut',name, '_', Method,'_WL',string(wave), '_Angle', string(angle));
        
        % Check if folder already exist to avoid redundant actions
        if not(isfolder(dirname))
            mkdir (dirname);
            addpath(dirname);
            existFolder = false;
        end
        
        if existFolder == false
        % Initialize optimization parameters 
        % Default values and descriptions found in 'Functions/Initialize.m'
        OptParm = Initialize();
        disp('---------------------------------------------------------')
        fprintf('Running Wavelength = %d\n', wave)
        fprintf('Running Angle = %d\n', angle)
        
        % Defines target output angle
        target_angle = angle;

        % Device parameters
        OptParm.Input.Wavelength = wave;
        OptParm.Input.Polarization = Method;
        OptParm.Optimization.Target = [1];
        OptParm.Geometry.Thickness = thickness; % Device layer thickness

        % Refractive Index of device, if ri changes with wavelength and
        % input as a matrix of (n, k), use const_ri = 1 as input while
        % input refractive_i as a matrix
        if const_ri == 1
            OptParm.Geometry.Device = refractive_i; % Refractive index of device
        elseif const_ri == 0
            OptParm.Geometry.Device = refractive_i(count,1)+ 1i*refractive_i(count,2);
            count = count + 1;
        end

        % Compute necessary period corresponding to target angle
        period = [OptParm.Input.Wavelength*OptParm.Optimization.Target/(sind(target_angle)-sind(OptParm.Input.Theta)),0.5*OptParm.Input.Wavelength];
        OptParm.Geometry.Period = period;

        % Define # of Fourier orders
        OptParm.Simulation.Fourier = [12 12];

        % Run robust optimization
        OptParm.Optimization.Robustness.StartDeviation = startdeviation; % Starting edge deviation values
        OptParm.Optimization.Robustness.EndDeviation = OptParm.Optimization.Robustness.StartDeviation; % Ending edge deviation values
        OptParm.Optimization.Robustness.Weights = [.5 1 .5];

        % Plot efficiency history
        OptParm.Display.PlotEfficiency = 1;

        % Run optimizations
        optout = OptimizeDevice(OptParm, dirname);
        
        % m(x==i, y==j) = i + j;
        heatmapMat(Target_angle==angle, Wavelength==wave) = max(optout.AbsoluteEfficiency(:,2));
        save(strcat(dirname,'/',fname), 'optout')
        disp(strcat('Value for wavelength = ', string(wave), ' angle = ', string(angle), 'created and saved'))
        if Best_eff < max(optout.AbsoluteEfficiency(:,2))
            Best_eff = max(optout.AbsoluteEfficiency(:,2));
            Best_angle = angle;
            Best_wave = wave;
        end
        else
            load(strcat(dirname, '/',  fname), 'optout')
            heatmapMat(Target_angle==angle, Wavelength==wave) = max(optout.AbsoluteEfficiency(:,2));
            disp(strcat('Value for wavelength = ', string(wave), ' angle = ', string(angle), 'found and saved'))
        end
    end
end
disp(heatmapMat)
save('heatmapMat.mat', 'heatmapMat');
h = heatmap(heatmapMat);
h.XData = Wavelength;
h.YData = Target_angle;
h.Title = strcat('Heatmap - ', name, ' thickness = ', string(thickness), 'nm');
h.XLabel = 'Wavelength (nm)';
h.YLabel = 'Target Angle (degree)';
exportgraphics(h, 'heatmap.png');
view(h);

end
