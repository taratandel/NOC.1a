% the space of probability: ex: when we have n = 2 the space of probability
% would be equal to 0,1,2
% we don't use this code in our new program for low ns we can use this
function p = Probability_Distribution(number_of_probabilities)
    n = number_of_probabilities;
    probabilities = zeros(n,1);

    for i = n:-1:1
        if i == 0
            break;
        end
        probabilities(i) = (i - 1)/n;
    end
    p = probabilities;
    
end