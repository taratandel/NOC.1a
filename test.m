function M = test(x,a) 
    M = sqrt(2/pi)*(x.^2*exp((-1*(x.^2))/(2*(a^2))))/a.^3;
end

