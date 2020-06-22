clc, clear all
%% initialization
% the number of QAM constellation 
M = 64;

% vector of desired SNRs
SNRdB_vec = 0:.1:20;

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
plot(SNRdB_vec, C, 'Linewidth', 7)
out{2} = sprintf('unrestricted capacity');
%% maxWell boltzman
kjhgf = [0.149, 0.139, 0.079, 0.129, 0.159, 0.159, 0.099, 0.057 0.03]./no_of_amplitudes;
C = zeros(size(SNRdB_vec));
p_maxwell = repelem(kjhgf, no_of_amplitudes);
i = 0;
for SNRdB = SNRdB_vec
    i = i+1;
    C(i) = QAMCapacity(SNRdB,x, p_maxwell);
end
% p_maxwell = maxwell_boltzmanProbability(M,no_of_amplitudes,amplitude_distance,sorted_amplitudes);
% mx_optimal_prob = size(p_maxwell,1);
% for j = 1:1:size(p_maxwell,2)
%     i = 0;
%     t_C = zeros(size(SNRdB_vec));
%     for SNRdB = SNRdB_vec
%         i = i+1;
%         t_C(i) = QAMCapacity(SNRdB,x, p_maxwell(:,j)');
%     end
%     if C < t_C 
%         C = t_C;
%         mx_optimal =  p_maxwell(:,j);
%     end
% %     legend('Req_Check_%d',j)
% %     out{j + 2} = sprintf('MaxWell a = %d',j);
% end
    plot(SNRdB_vec, C, 'Linewidth', 2)
    out{end} = sprintf('MaxWell_boltzMan optimized');


%% CCDM
n = 30;
% choosing probabilities according to the number of different amplitudes
s = size(no_of_amplitudes,2);
% probability distri bution for each different set
p_second = zeros(n);
for i = s+1:10:n
%     creating the probabilities space
%     for example if n is equal to 2 the space is {0,0.5,1}
    p_second_distribution = Probability_Distribution(i);
%     creating all the prossible permutation with number of given
%     amplitudes, the repeatition is allowed.
    p_second_multichoose = nmultichoosek(int8(p_second_distribution),s);
%     between all the possible permutations we choose the indexes of the
%     ones that the sum's equal to 1
    prob_space = find(sum(p_second_multichoose,2)==1);
    p_final = zeros(size(prob_space,1), M);
    t = 0;
    C = zeros(size(SNRdB_vec,2));
    j = 0;
    for index = prob_space'
        t = t + 1;
        p_final(t,:) = repelem(sort(p_second_multichoose(index,:), 'descend')./no_of_amplitudes,no_of_amplitudes);
       
    end
    divergence = KLDiv(p_final,p_maxwell(:,9)');
    [~,I] = min(divergence);
    for SNRdB = SNRdB_vec
            j = j+1;
            C(j) = QAMCapacity(SNRdB,x, p_final(I,:));
    end
    plot(SNRdB_vec, C, 'Linewidth', 2)
    out{end + 1} = sprintf('CCDM n = %d',i);

end
for q=size(out,2):1:1
    newarr{q} = out{size(out,2) - q + 1};
    out = newarr;
end
legend(out)

