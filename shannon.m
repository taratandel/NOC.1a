function C = shannon (SNR)
     snr = 10^(SNR/10);
     C = log2(1 + snr);
end
