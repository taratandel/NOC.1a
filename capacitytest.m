clc, clear all
%% initialization
% the number of QAM constellation 
M = 64;

% vector of desired SNRs
SNRdB_vec = 0:1:20;

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

%% creating the graph for equiprobable case
pXA = (1/M)*ones(M,1);
C = zeros(size(SNRdB_vec));
i = 0;
for SNRdB = SNRdB_vec
        i = i+1;
        C(i) = QAMCapacity(SNRdB,x, pXA');
end

plot(SNRdB_vec, C, 'Linewidth', 2)

%% unrestricted capacity
i = 0;
for SNRdB = SNRdB_vec
    i = i+1;
    C(i) = shannon(SNRdB);
end
hold on, grid on
plot(SNRdB_vec, C, 'Linewidth', 7)
legend('equiprobable 64 QAM', 'unrestricted capacity')
%% maxWell boltzman
p_maxwell = maxwell_boltzmanProbability(M,no_of_amplitudes,amplitude_distance,absolute_values_of_amplitudes);
for j = 1:1:size(p_maxwell,2)
    i = 0;
    for SNRdB = SNRdB_vec
        i = i+1;
        C(i) = QAMCapacity(SNRdB,x, p_maxwell(:,j)');
    end
    plot(SNRdB_vec, C, 'Linewidth', 2)
end

%% second approach

% n = size(no_of_amplitudes,2);
% p_second = zeros(M,1);
% for i = 4:1:n
%     p_second_distribution = Probability_Distribution(i);
%     p_second_multichoose = nmultichoosek(p_second_distribution,i);
%     prob_space = find(sum(p_second_multichoose,2)==1);
%     ps = zeros(n);
%     t = 0;
%     C = zeros(size(SNRdB_vec,2));
%     j = 0;
%     for index = prob_space'
%         t = t + 1;
%         ps(t,:) = [sort(p_second_multichoose(index,:), 'descend'),zeros(1, n-i)];
%         p_second = repelem(ps(t,:)/no_of_amplitudes(t),no_of_amplitudes)';
%         for SNRdB = SNRdB_vec
%             j = j+1;
%             C(j) = QAMCapacity(SNRdB,x, p_second');
%         end
%     end
%     c_plot = min(C);
%       plot(SNRdB_vec, c_plot, 'Linewidth', 2)
% 
%     hold on, grid on
%     str = 'optimaly shaped';
%     out{i} = sprintf('%s_%d',str,i);
%     legend(out)
% end


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


