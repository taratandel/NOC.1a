function [pA, k, ni] = get_ccdm_params(obj)
% Copyright (c) 2017 shapecomm UG (haftungsbeschränkt) - All Rights Reserved
% Unauthorized copying of this file, via any medium is strictly prohibited
% Proprietary and confidential
% contact@shapecomm.de, 07/18/2017
%
% This is trial software.
%
% [pA, k, ni] = get_ccdm_params(obj)
%
% Obtain CCDM-DM parameter for given DM input length k and output
% length n. Hence, obj must have the fields:
%           - obj.k
%           - obj.n
%           - obj.M
% The distribution on the output symbols is chosen from the Maxwell Boltzmann
% family (minimizes average energy).

max_M = 32;
max_n = 21600;

if isfield(obj, 'k') && isfield(obj, 'n') && isfield(obj, 'M')
    if obj.M > max_M
        error('the maximum supported output alphabet cardinality is %d', max_M);
    end
    if obj.n > max_n
        error('the maximum supported output length is %d', max_n);
    end        
    
    % Sanity Check: determine maximum possible input symbols by close to
    % uniform distribution.
    %  - calculate the closest distribution to uniform 
    [ni_uniform, ~] = idquant(ones(1,obj.M)/obj.M, obj.n);
    kmax = floor(n_choose_ks_recursive_log2(obj.n, ni_uniform));
    if obj.k > kmax
        error('For this blocklength and modulation, the rate is to high')
    end
   
    obj.p_target = exp(-((1:2:2*obj.M-1)/obj.M).^2);
    obj.p_target = obj.p_target/sum(obj.p_target);
    %try
        [nu,~,exitflag] = fzero(@(nuVal) find_rate(nuVal, obj.p_target, obj.n) - obj.k/obj.n, [1e-6 1e3]);
        addidionalbit = 0;
        while(find_rate(nu, obj.p_target, obj.n) - obj.k/obj.n) < 0
            addidionalbit = addidionalbit+1;
            nu = fzero(@(nu_var) find_rate(nu_var, obj.p_target, obj.n) - (obj.k+addidionalbit)/obj.n, [1e-6 1e3]);
        end
        
    %catch
    if exitflag ~=1
        error('No distribution scaling can be found to support the desired rate.');
    end
    obj.p_target = obj.p_target.^nu/sum(obj.p_target.^nu);
    [ni, pA] = idquant(obj.p_target, obj.n); 
    k = obj.k;
    % Determine rateloss
    entropyrate = H(pA);
    rateloss = entropyrate - obj.k/obj.n;
    if rateloss > 0.1
        warning('Your current selection will lead to a rateloss greater than 0.1 bit/symbol. Please increase the DM output length to avoid that loss.');
    end
else    
    error('Passed object must possess at least fields .k, .n and .M');
end

end

function rate = find_rate(nu, p_target, n)

[ni, ~] = idquant(p_target.^nu/sum(p_target.^nu), n);

kcalc = floor(n_choose_ks_recursive_log2(n, ni));

rate = kcalc / n;

end

function entropy = H(pX)
%H calculate entropy of discrete random variable in bits
%   ENTROPY = H(PX) returns the entropy of the discrete PMF PX in bits
if numel(pX)==1
    pX = [pX 1-pX];
end

entropy = -pX .* log2(pX);
entropy(~isfinite(entropy)) = 0;
entropy = sum(entropy);

end


function [n_i,p_quant] = idquant(p,n)
m = length(p);
n_i = zeros(m,1);
t = log(1./p);
p_quant = t;


for k=1:n
    [~,index] = min(p_quant);
    cj = n_i(index)+1;
    n_i(index) = cj;
    p_quant(index) = (cj+1)*log(cj+1)-cj*log(cj)+t(index);
end
p_quant = n_i/n;
end

function [ out ] = n_choose_k_iter_log( n,k )
if k > n || k < 0
    error('k must be smaller than n and bigger and non-negative')
end
k = min(k,n-k);
i = 1:k;
out = sum(log2((n-(k-i))./(i)));

end

function [ out ] = n_choose_ks_recursive_log2( n,k )

out = 0;
k = sort(k);

for i = 1:length(k)-1
    out = out + n_choose_k_iter_log(n,k(i));
    n = n - k(i);
end

end

