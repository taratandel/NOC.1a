close all
clear all
clc
T = 8;
maxRate=17/10;
minRate=1/10;
rateVector=zeros(10*(maxRate-minRate)+1,2);
rateInterval=1/10;
pxA_opt = zeros(10*(maxRate-minRate)+1);
C = zeros(10*(maxRate-minRate)+1);
i = 0;
SNR = zeros(10*(maxRate-minRate)+1);
for n=100:100:1000
    for R=minRate:rateInterval:maxRate
        i = i + 1;
        dm = shapecomm.webdm(T, n, R);
        M = 2^6;
        Amplitudes = qammod(0:M-1,M,'gray');
        sorted_amplitudes = sort(abs(Amplitudes));

        [a,b] = histcounts(sorted_amplitudes,unique(sorted_amplitudes));
        p = repelem(dm.pA,a)';
        SNR = 0;
        for i = 1 : length(sorted_amplitudes)
            SNR = SNR + sorted_amplitudes(i).^2 * p(i);
        end
        
        C(i) = Mutual_Information(p, Amplitudes);
        
    end
end
