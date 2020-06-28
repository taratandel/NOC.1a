function quant = quantize_prob(unquant, n)
% unquant is the input vector of probabilities computed with the
% Maxwell-Boltzmann distribution, n is the n in Tpn
%% Inizialization of the function
% so we first inizialize the quantized vector as a copy of the
% unquantized one (we will correct it later)
quant_prob = unquant;
% then we define the probabs vector, that is a vector that contains
% all the possible values of the output probability, i.e. {1/n, 2/n,
% ..., 1}
%% Quantization operation
probabs = linspace(0, 1, (n+1)); % all possible probabilities
% in this for loop we substitute each of the (unquantized) values
% in quant_prob with the quantized corresponding one, and we get
% this value as the rounding to values of probabs
for i = 1:length(unquant)
    for j = 1:(n+1)
        if (abs(quant_prob(i)-probabs(j))<= 1/(2*n))
            quant_prob(i) = probabs(j);
        end
    end
end
%% Exception management
% It can happen that the quantization operation gives a vector of
% probabilities whose sum is not 1. In this case we add or subtract 1/n to the
% probabilities until the sum is 1. We first compute the number of 1/n to
% be added or subtracted in total and assign this value to the variable
% cnt, if the sum of the probabilities is lower than 1 we add 1/n to the
% first cnt probabilites, if cnt is bigger than the vector we add 1/n to
% all the probabilities and restart the procedure until cnt is lower or
% equal than the sum of the probabilities; if instead the sum of the
% probabilities is bigger than 1, we compute the same variable cnt (number
% of 1/n to be subtracted) and we subtract 1/n from the first cnt
% probabilities, counting in descending order and starting from the
% probability with the highest index among those with probability bigger
% than zero, if cnt is bigger than the total number of nonzero probabilites
% we subtract 1/n to all of the nonzero probabilities and we restart the
% procedure.
while abs(sum(quant_prob) - 1) > 10^-9
    if sum(quant_prob) < 1
        cnt = round((1-sum(quant_prob))*n);
        if cnt > length(quant_prob)
            cnt = length(quant_prob)
        end
        for j=1:cnt
            quant_prob(j) = quant_prob(j) + 1/n;
        end
    end
    if sum(quant_prob) > 1
        stop = 0;
        for i = 1:length(quant_prob)
            if quant_prob(i) > 0
                stop = i;
            end
        end
        cnt = round((sum(quant_prob) - 1)*n);
        if cnt > stop
            cnt = stop;
        end
        for i = (stop + 1 - cnt):stop
            quant_prob(i) = quant_prob(i) - 1/n;
            if quant_prob(i) < 0.7/n
                quant_prob(i) = 0;
            end
        end
     end
end
%% Output
% at the end the function returns the quantized version of the
% unquantized vector we got as input
sss = sum(quant_prob)
quant = quant_prob;