function [] = EpsilonConverter(input_name, output_name, n_val, k_val, WL)

% EpsilonConverter("somename.txt", 'outputname.mat', n, k, WL);
if input_name ~= ""
    m = dlmread(input_name);
    WL = m(:,1); e1 = m(:,2); e2 = m(:,3);
    complex_sum = e1 + i * e2;
    sqrt_complex = sqrt(complex_sum);
    k = imag(sqrt_complex); 
    n = real(sqrt_complex);
    
elseif (n_val~=0 && length(n_val)==1) && (k_val==0 && length(k_val)==1)
    n = zeros(length(WL),1) + n_val;
    k = zeros(length(WL),1);
    
elseif (n_val~=0 && length(n_val)==1) && (k_val~=0 && length(k_val)==1)
    k = zeros(length(WL),1) + k_val;
    n = zeros(length(WL),1) + n_val;
end

save(output_name, 'n','k','WL');



end