% calculating the expected value for a given input and corresponding
% probability
function expected = expected_value(x,p)
    sum = 0;
    for i = 1:1:size(x,2)
        sum = sum + p(i)*(abs(x(i)).^2);
    end
    expected = sum;
end