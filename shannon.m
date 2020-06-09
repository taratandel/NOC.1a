

%SNR = 10^(SNRdb/10)

SNR = 0:0.01:20;
SNRdb= 10*log10(SNR);

C = 0.5 * log2(1 + SNR);

figure,
plot(SNRdb, C);
xlabel("SNR[db]");
ylabel("C");



