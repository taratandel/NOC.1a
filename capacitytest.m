clc, clear all
SNRdB_vec = 0:0.05:20;
M = 64;
C = zeros(size(SNRdB_vec));
pxA_opt = zeros(size(SNRdB_vec));
pXA = (1/M)*ones(M,1);
i = 0;
x = qammod(0:M-1,M,'gray');
x = x / sqrt(1/M*norm(x, 'fro')^2);
pXA = reshape(pXA, 1, M);
for SNRdB = SNRdB_vec
    i = i+1;
%     if i == 204
%         break;
%     end
    C(i) = QAMCapacity(SNRdB,x, pXA);
end


figure,
plot(SNRdB_vec, C, 'Linewidth', 2)
xlabel('SNR [dB]')
ylabel('C [bpcu]')
hold on, grid on
plot(SNRdB_vec, C, 'r-', 'Linewidth', 2)

legend('Optimally shaped 4-PAM','Gaussian input','Plain 4-PAM')