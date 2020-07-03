% for mula of maxwell-boltzman distribution 
function M = max_bol_formula(x,a) 
    M = sqrt(2/pi)*(x.^2*exp((-1*(x.^2))/(2*(a^2))))/a.^3;
end

