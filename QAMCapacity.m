function c = QAMCapacity( SNR, x, p )
% CAPACITY_AWGN computes the capacity of the Gaussian channel with power 
% constraint, where the signal-to-noise ratio is SNR (in dB) and the input 
% is distributed over x (the constellation) with probability density function
% p, i.e., the probability to observe x(i) is p(i).
%
% By construction, x and p are vectors that should have the same length.
%
% The code works in dimension 1 and 2. 
%
% The channel model is:
% The model is Y = a X + N, where N ~ CN(0, Pn)
% You set SNR = Ps / Pn, where
% Pn is the variance of the additive noise, and
% Ps = a^2 E[ |X|^2 ].
%  
% The term E[ |X|^2 ] will depend on the probabilities of the constellation symbols, while the constant a does not.
%  
% Once SNR and Pn are fixed,
% Ps = SNR * Pn
% and
% a = sqrt(Ps / E[ |X|^2 ])
%  
% The constant a is the scaling factor of the constellation.
%  
% where E[X^2]<1 and N ~ N(0,1). Here snr is in linear scale. The capacity 
% is equal to I(X;Y) where I is the mutual information. The mutual
% information computation gives (H is the entropy function):
% I(X;Y) = H(Y) - H(Y|X)
%        = H(Y) - H(sqrt(snr)X+N|X)
%        = H(Y) - H(N)
% For a one dimensional Gaussian N(mu, sigma^2), the entropy is equal to
% 1/2*log2(2*pi*e*sigma^2). To compute H(Y), we compute the pdf of Y as 
% follow:
% f(y) = sum(a in x) Pr(x=a) Pr(y|x=a).
%
% Arguments (input):
% SNR - Signal-to-noise ratio [dB]
% x   - Input support, in other word the constellation [vector] 
% p   - Input distribution [vector]
%
% Arguments (output):
% c - Capacity of the Gaussian channel
%
% Examples:
% For the uniformly distributed BPSK constellation, the capacity at 10 dB is 
% c = capacity_awgn(10, [-1, 1], [0.5 0.5])
% 
% For the uniformly distributed M-QAM at 5 dB:
% x = (-sqrt(M)+1) : 2 : (sqrt(M)-1)    
% x = ones(sqrt(M), 1) * t              
% x = x - 1i*x'                         
% x = x / sqrt(1/M*norm(x, 'fro')^2)  -> Normalise the constellation power  
% x = reshape(X, 1, M)                  
% c = capacity_awgn(5, x, 1/M*ones(1,M))
%
% Author      : Hugo MERIC
% Homepage    : http://hugo.meric.perso.sfr.fr/index.html
% Release     : 1.0
% Release date: 2015-04-16
% --------------------------
% ----- Initialization -----
% --------------------------
if( length(x) ~= length(p) )
    disp('x and p should have the same length!') ;
    c = NaN;
elseif( abs(sum(p)-1)>10^(-6) )
    disp('p is not a pdf!') ;
    c = NaN;

elseif(abs(x).^2*p' > 1)
    disp('The channel input does not verify E[X^2]<1!') ;
    c = NaN;

else
snr = 10^(SNR/10) ;
expected = expected_value(x,p);
correcting_factor = sqrt(snr/expected);

% --------------------
% ----- Capacity -----
% --------------------
R = norm(max(correcting_factor*x)) + 5                                  ;
h = @(x) sqrt(R^2-x.^2);
g = @(x) -sqrt(R^2-x.^2);
% variance is 1/2 
% entropy of the noise 
%because x is normalaized y will vary between SNR + max{x} which is 21 here
c = -log2(pi*exp(1)) - quad2d(integral(snr, x, p), -20, 20, -20, 20) ;
end
% ---------------------
% ----- Functions -----
% ---------------------
    function z = pdf_channel_output(y1, y2, snr, x, p)
        z = 0 ;
        for k=1:length(x)
            z = z + p(k) .* 1/pi.*exp( -(y1-correcting_factor*real(x(k))).^2 -(y2-correcting_factor*imag(x(k))).^2 ) ;
        end
    end
    function z = integral(snr, x, p)
        z = @(y1,y2) pdf_channel_output(y1, y2, snr, x, p) .* log2(pdf_channel_output(y1, y2, snr, x, p)) ;
    end
end
