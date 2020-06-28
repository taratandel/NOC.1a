function quant = quantize_prob(unquant, n)
% unquant is the input vector of probabilities computed with the
% Maxwell-Boltzmann distribution, n is the n in Tpn
% so we first inizialize the quantized vector as a copy of the
% unquantized one (we will correct it later)
quant_prob = unquant;
% then we define the probabs vector, that is a vector that contains
% all the possible values of the output probability, i.e. {1/n, 2/n,
% ..., 1}
probabs = linspace(0, 1, (n+1)); % all possible probabilities
% in this for loop we substitute each of the (unquantized) values
% in quant_prob with the quantized corresponding one, and we get
% this value as the rounding to values of probabs
for i = 1:size(unquant')
    for j = 1:(n+1)
        if (abs(quant_prob(i)-probabs(j))<= 1/(2*n))
            quant_prob(i) = probabs(j);
        end
    end
end
% the two while loops that follow are used to handle exceptions
% i.e. the cases when the sum of the quantized probabilities
% is not equal to one: if it's less then one we add 1/n to the
% first element of the probability vector until the sum equals
% one; if instead the probabilities sum to more than one we
% subtract 1/n to the first probability (starting from the outer
% ones) that is more than zero, until the sum equals one
while sum(quant_prob) < 1
    quant_prob(1) = quant_prob(1) + 1/n;
end
while sum(quant_prob) > 1
    for i = size(unquant):1
        if quant_prob(i) > 0
            quant_prob(i) = quant_prob(i) - 1/n;
            break
        end
    end
end
% at the end the function returns the quantized version of the
% unquantized vector we got as input
quant = quant_prob;