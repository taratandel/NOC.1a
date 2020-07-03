clc, clear all
%% initialization
% the number of QAM constellation
M = 64;
% maxwell-boltzmann space feature
a_vectorized = linspace(0.4, 2.57, 9);
% vector of desired SNRs
SNRdB_vec = 1:.1:20;

% number of capacities that we are evaluating
C = zeros(size(SNRdB_vec));

% creating the QAM constellations
x = qammod(0:M-1,M,'gray');
absolute_values_of_amplitudes = abs(x);
sorted_amplitudes = sort(absolute_values_of_amplitudes);
[no_of_amplitudes,amplitude_distance] = hist(sorted_amplitudes,unique(sorted_amplitudes));

% Sorting the inputs based on theier avslute values

[~,idx] = sort(abs(x));

x = x(idx);

% normalizing the amplitudes

x = x / sqrt(1/M*norm(x, 'fro')^2);

% creating the figure
figure,
xlabel('SNR [dB]')
ylabel('C [bpcu]')
% legends goes here
out = {};

%% unrestricted capacity
i = 0;
for SNRdB = SNRdB_vec
    i = i+1;
    C(i) = shannon(SNRdB);
end
hold on, grid on
plot(SNRdB_vec, C, 'Linewidth', 2)
out{1} = sprintf('unrestricted capacity');

%% creating the graph for equiprobable case
pXA = (1/M)*ones(M,1);
i = 0;
for SNRdB = SNRdB_vec
    i = i+1;
    C(i) = QAMCapacity(SNRdB,x, pXA');
end

plot(SNRdB_vec, C, 'Linewidth', 2)
out{2} = sprintf('equiprobable %d QAM', M);


%% maxWell boltzman
% getting the maxwell-boltzman probability distribution
p_maxwell = maxwell_boltzmanProbability(M,no_of_amplitudes,amplitude_distance,sorted_amplitudes);
p_maxwell = sort(p_maxwell, 'descend');
% matrix to keep the best maxwell-boltzman probability 
p_optimized = zeros(M,length(SNRdB_vec));

for j = 1:1:size(p_maxwell,2)
    i = 0;
    t_C = zeros(size(SNRdB_vec));
    for SNRdB = SNRdB_vec
        i = i+1;
        
        t_C(i) = QAMCapacity(SNRdB,x, p_maxwell(:,j)');
        if t_C(i)>C(i)
            C(i) = t_C(i);
            p_optimized(:,i) = p_maxwell(:,j)';
        end
    end
end
plot(SNRdB_vec, C, 'Linewidth', 2)
out{end + 1} = sprintf('MaxWell best');

%% CCDM

for n=30:50:130
        i = 0;
    for SNRdB = SNRdB_vec
        i = i+1;
        quant = quantize_prob(p_optimized(:,i), n);
        
        C(i) = QAMCapacity(SNRdB,x, quant');
    end
    plot(SNRdB_vec, C, 'Linewidth', 2)
    out{end + 1} = sprintf('quantization step = %d',n);
end
legend(out)
