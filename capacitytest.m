clc, clear all
%% initialization
% the number of QAM constellation 
M = 64;

% vector of desired SNRs
SNRdB_vec = 0:.1:20;

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
% figure,
% xlabel('SNR [dB]')
% ylabel('C [bpcu]')
% 
% %% creating the graph for equiprobable case
% pXA = (1/M)*ones(M,1);
% C = zeros(size(SNRdB_vec));
% i = 0;
% for SNRdB = SNRdB_vec
%         i = i+1;
%         C(i) = QAMCapacity(SNRdB,x, pXA');
% end
% 
% plot(SNRdB_vec, C, 'Linewidth', 2)
% 
% %% unrestricted capacity
% i = 0;
% for SNRdB = SNRdB_vec
%     i = i+1;
%     C(i) = shannon(SNRdB);
% end
% hold on, grid on
% plot(SNRdB_vec, C, 'Linewidth', 7)
% legend('equiprobable 64 QAM', 'unrestricted capacity')
% %% maxWell boltzman
% p_maxwell = maxwell_boltzmanProbability(M,no_of_amplitudes,amplitude_distance,sorted_amplitudes);
% for j = 1:1:size(p_maxwell,2)
%     i = 0;
%     for SNRdB = SNRdB_vec
%         i = i+1;
%         C(i) = QAMCapacity(SNRdB,x, p_maxwell(:,j)');
%     end
%     plot(SNRdB_vec, C, 'Linewidth', 2)
% end

%% CCDM
n = 64;
% choosing probabilities according to the number of different amplitudes
s = size(no_of_amplitudes,2);
% probability distri bution for each different set
p_second = zeros(n);
for i = s:10:n
%     creating the probabilities space
%     for example if n is equal to 2 the space is {0,0.5,1}
    p_second_distribution = Probability_Distribution(i);
%     creating all the prossible permutation with number of given
%     amplitudes, the repeatition is allowed.
    p_second_multichoose = nmultichoosek(p_second_distribution,s);
%     between all the possible permutations we choose the indexes of the
%     ones that the sum's equal to 1
    prob_space = find(sum(p_second_multichoose,2)==1);
    ps = zeros(s);
    t = 0;
    C = zeros(size(SNRdB_vec,2));
    j = 0;
    for index = prob_space'
        t = t + 1;
        ps(t,:) = sort(p_second_multichoose(index,:), 'descend');
        p_second(t,:) = repelem(ps(t,:)/no_of_amplitudes(t),no_of_amplitudes)';
%         for SNRdB = SNRdB_vec
%             j = j+1;
%             C(j) = QAMCapacity(SNRdB,x, p_second');
%         end
    end
%     c_plot = min(C);
%       plot(SNRdB_vec, c_plot, 'Linewidth', 2)
% 
%     hold on, grid on
%     str = 'optimaly shaped';
%     out{i} = sprintf('%s_%d',str,i);
%     legend(out)
end


%% first approach

%  compare the Cs and just keep the biggest one
% C = zeros(size(SNRdB_vec,2),size(a_vectorized,2));
% j = 0;
% for SNRdB = SNRdB_vec
%     j = j+1;
%     for i = 1:1:size(p_first,2)
%         C(j,i) = QAMCapacity(SNRdB,x, p_first(:,i)');
%     end
%     
% end
% 
% for i = 1: 1: 5
%     c = C(:,i);
%     plot(SNRdB_vec, c, 'Linewidth', 2)
% 
%     hold on, grid on
%     str = 'optimaly shaped';
%     out{i} = sprintf('%s_%d',str,i);
%     legend(out)
% end



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


