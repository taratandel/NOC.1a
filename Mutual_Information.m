function  I = Mutual_Information(probabilities_of_input,amplitudes)
p = probabilities_of_input;
Amplitudes = amplitudes;
f_y = @(y) sum(p.*((1/sqrt(2*pi))*exp(-(y-Amplitudes).^2/2)));
fun = @(y) -f_y(y).*log2(f_y(y)+eps);
entY = quad2d(fun,-20,20, -20,20);
entropy_of_noise = 1/2*log2(2*pi*exp(1));
 
I = entY - entropy_of_noise;