function [ Effs ] = Eval_Eff_1D_parallel( imgs, wavelengths, angles, thickness, matname)

N = length(wavelengths);
Effs = zeros(1, N);
imgs = squeeze(imgs);
tic
parfor n = 1:N
    disp(n)
	wavelength = wavelengths(n);
	angle = angles(n);
	img = imgs(n, :);
	Effs(n) = Eval_Eff_1D(img, wavelength, angle, thickness, matname);
end
toc
end