function expected = expected_value(x,p)
    sum = 0;
    for i = 1:1:64
        sum = sum + p(i)*(abs(x(i)).^2);
    end
    expected = sum;
end