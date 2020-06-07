clc, clear all
% the number of QAM constellation 
M = 64;

% vector of desired SNRs
SNRdB_vec = 0:1:20;

% I don't know what is this exaclty :))
a_vectorized = linspace(0.25, 0.5068859522788, 5);

% offset for maxWell_boltzMan
b = zeros(length(a_vectorized),1);

% % creating the QAM constellations
x = qammod(0:M-1,M,'gray');
absolute_values_of_amplitudes = abs(x);
sorted_amplitudes = sort(absolute_values_of_amplitudes);
[no_of_amplitudes,amplitude_distance] = hist(sorted_amplitudes,unique(sorted_amplitudes));

% normalizing the amplitudes
x = x / sqrt(1/M*norm(x, 'fro')^2);


p = zeros(M,length(a_vectorized));
for m = 1:1:M
    j = 0;
    for a = a_vectorized
        j = j + 1;
        offset = 0;
        for i = 1:1:length(no_of_amplitudes)
            offset = offset + no_of_amplitudes(i)*test(amplitude_distance(i), a);
        end
        b = (1-offset)/M;
        p(m, j) = test(absolute_values_of_amplitudes(m),a) + b;
    end
end
C = zeros(size(SNRdB_vec,2),size(a_vectorized,2));
j = 0;
for SNRdB = SNRdB_vec
    j = j+1;
    for i = 1:1:size(p,2)
        C(j,i) = QAMCapacity(SNRdB,x, p(:,i)');
    end
    
end
figure,
xlabel('SNR [dB]')
ylabel('C [bpcu]')
legends = zeros(size(a_vectorized));
for i = 1: 1: 5
    c = C(:,i);
    plot(SNRdB_vec, c, 'Linewidth', 2)

    hold on, grid on
    str = 'optimaly shaped';
    out{i} = sprintf('%s_%d',str,i);
    legend(out)
end

% for i = 1:1:M
%     for a = a_vectorized
%          + b;
%     end
% end
% M = 64;
% C = zeros(size(SNRdB_vec));
% pxA_opt = zeros(size(SNRdB_vec));
% pXA = (1/M)*ones(M,1);
% i = 0;

% pXA = reshape(pXA, 1, M);
% 
% for R=minRate:rateInterval:maxRate
%     j = j + 1;
%     dm = shapecomm.webdm(T, n, R);
% 
%     
%     pXA = repelem(dm.pA,a)';
%     for SNRdB = SNRdB_vec
%         i = i+1;
%         C(i) = QAMCapacity(SNRdB,x, pXA);
%     end
% end


