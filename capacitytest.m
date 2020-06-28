clc, clear all
%% initialization
% the number of QAM constellation
M = 64;
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

% Sorting the inputs based on theier abosulute values

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
%% creating the graph for equiprobable case
pXA = (1/M)*ones(M,1);
i = 0;
for SNRdB = SNRdB_vec
    i = i+1;
    C(i) = QAMCapacity(SNRdB,x, pXA');
end

plot(SNRdB_vec, C, 'Linewidth', 2)
out{1} = sprintf('equiprobable %d QAM', M);

%% unrestricted capacity
i = 0;
for SNRdB = SNRdB_vec
    i = i+1;
    C(i) = shannon(SNRdB);
end
hold on, grid on
plot(SNRdB_vec, C, 'Linewidth', 2)
out{2} = sprintf('unrestricted capacity');
%% maxWell boltzman
% I still don't know if it's better to use this or not
p_optimaz = [0.149, 0.139, 0.079, 0.129, 0.159, 0.159, 0.099, 0.057 0.03]./no_of_amplitudes;


C = zeros(size(SNRdB_vec));

p_maxwell = maxwell_boltzmanProbability(M,no_of_amplitudes,amplitude_distance,sorted_amplitudes);
p_maxwell = sort(p_maxwell, 'descend');
mx_optimal_prob = size(p_maxwell,1);
for j = 1:1:size(p_maxwell,2)
    i = 0;
    t_C = zeros(size(SNRdB_vec));
    for SNRdB = SNRdB_vec
        i = i+1;
        t_C(i) = QAMCapacity(SNRdB,x, p_maxwell(:,j)');
    end
    C = t_C;
  
end
    out{end + 1} = sprintf('MaxWell a step = %d',a_vectorized(j));
    plot(SNRdB_vec, C, 'Linewidth', 2)

%% CCDM
for n=10:10:30
    quant = quantize_prob(p_optimaz, n);
    probs = convert9to64(quant, no_of_amplitudes);
    i = 0;
    for SNRdB = SNRdB_vec
        i = i+1;
        C(i) = QAMCapacity(SNRdB,x, probs);
    end
    plot(SNRdB_vec, C, 'Linewidth', 2)
    out{end + 1} = sprintf('quantization step = %d',n);
end
legend(out)
