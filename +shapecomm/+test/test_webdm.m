% Copyright (c) 2017 shapecomm UG (haftungsbeschränkt) - All Rights Reserved
% Unauthorized copying of this file, via any medium is strictly prohibited
% Proprietary and confidential
% contact@shapecomm.de, 07/18/2017
%
% This is trial software.

fprintf('Running Test for WebDM\n');
dm = shapecomm.webdm(4, 5000, 1.5);

ii = 1;
while 1
    fprintf('Run: %d\n', ii);
    bits_in = randi([0 1], [dm.k 1]);
    symbols = dm.encode(bits_in);
    bits_out = dm.decode(symbols);
    fprintf('Matching Errors: %d\n', sum(bits_in ~= bits_out));
    ii = ii+1;
end

