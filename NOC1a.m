close all
clear all
clc
b = 8;
n = 10000;
rate = 1.15;
dm = shapecomm.webdm(b, n, rate);
dm.pA
M = 2^6;
a1 = {};
Amplitudes = qammod(0:M-1,M,'gray');
sorted_amplitudes = sort(abs(Amplitudes));

[a,b] = histcounts(sorted_amplitudes,unique(sorted_amplitudes));
p = repelem(dm.pA,a)';
SNR = 0;
for i = 1 : length(sorted_amplitudes)
    SNR = SNR + sorted_amplitudes(i).^2 * p(i);
end
% symsum(p(a)*((1/sqrt(2*pi))*exp(-(y-Amplitudes(a)).^2/2)), a, 1, length(Amplitudes))
f_y = @(y) sum(p(a)*((1/sqrt(2*pi))*exp(-(y-Amplitudes(a)).^2/2)));
% f_y = @(y) symsum(p(a).*(1/sqrt(2*pi)).*exp(-(y-Amplitudes(a)).^2/2), a, 1:length(Amplitudes));
fun = @(y) -f_y(y).*log2(f_y(y)+eps);
entY = integral(fun,-10,10);
% entropy_of_noise = 1/2*log2(2*pi*exp(1));
% 
mutual_information = entropy_of_noise - entY;