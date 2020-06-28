function output = convert9to64(prob9, n_of_amp)
% we want to convert a vector of size 9 to a vector of size 64
% the input vector contains the probabilities of the points in
% a 64 qam constellations, the n-th element is the total
% probability of all the points that share the n-th amplitude
% (the amplitudes are sorted in ascending order) so that the
% sum of the input vector has to be 1
% the output vector is a size 64 vector, that also has the
% sum of its elements equal to one and contains the
% probabilities of all 64 points of the QAM constellation
% the second input n_of_amp is also a size 9 vector, that
% specifies how many points there are in the constellation
% for each amplitude, its elements sum to 64
prob64 = zeros(1,64); %we first initialize the 64 sized vector
cnt = 1; %this is a temporary variable to count the element of prob64 to be rewritten in the for loop
prob9 = prob9./n_of_amp; %we divide each probability for the number of points that have that probability
for i = 1:size(n_of_amp')
    for j = 1:n_of_amp(i)
        prob64(cnt) = prob9(i);
        cnt = cnt+1;
    end
end
output = prob64;