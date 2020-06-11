function p = Probability_Distribution(number_of_probabilities)
    n = number_of_probabilities;
    probabilities = zeros(n,1);

    for i = (n + 1):-1:1
        probabilities(i) = (i-1)/n;
    end
    p = probabilities;
    
end