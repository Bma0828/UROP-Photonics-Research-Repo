function [Best_thick, Best_eff] = Best_thick_test(name, refractive_i, thickness, Wavelength, angle, Method, startdeviation)
% Initialization
Best_thick = 0;
Best_eff = 0;
thick_eff = [];

% Main Optimiztion Loop
for thick = thickness
    fname = strcat('OptOutTE_T', string(thick), '_WL', string(Wavelength), '.mat');
    existFolder = true;
    dirname = strcat('OptOut',name, '_', Method,'_WL',string(Wavelength), '_THICK', string(thick));

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
        fprintf('Running Thickness = %d\n', thick)
    
        % Defines target output angle
        target_angle = angle;

        % Device parameters
        OptParm.Input.Wavelength = Wavelength;
        OptParm.Input.Polarization = Method;
        OptParm.Optimization.Target = [1];
        OptParm.Geometry.Thickness = thick; % Device layer thickness
        OptParm.Geometry.Device = refractive_i; % Refractive index of device

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
        save(strcat(dirname,'/',fname), 'optout')
        thick_eff(end+1) = max(optout.AbsoluteEfficiency(:,2));
        if Best_eff < max(optout.AbsoluteEfficiency(:,2))
            Best_eff = max(optout.AbsoluteEfficiency(:,2));
            Best_thick = thick;
        end
    else
        load(strcat(dirname, '/',  fname), 'optout')
        thick_eff(end+1) = max(optout.AbsoluteEfficiency(:,2));
        if Best_eff < max(optout.AbsoluteEfficiency(:,2))
            Best_eff = max(optout.AbsoluteEfficiency(:,2));
            Best_thick = thick;
        end
        disp(strcat('Value for thickness = ', string(thick), ' found and saved'))
    end
end
plot(thickness, thick_eff);
save('thick_eff.mat', 'thick_eff');
xlabel('Thickness (nm)');
ylabel('Max Efficiency for 0 Edge Deviation');
title('Thickness vs. Efficiency Plot');
f = gcf;
exportgraphics(f, 'result.png');
end
