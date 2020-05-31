% Copyright (c) 2017 shapecomm UG (haftungsbeschränkt) - All Rights Reserved
% Unauthorized copying of this file, via any medium is strictly prohibited
% Proprietary and confidential
% contact@shapecomm.de, 07/21/2017
%
% This is trial software.

classdef webdm < handle
    
    properties
        k
        n
        M
        pA
        type_seq
        host
        num_retries
    end
    
    methods
        function obj = webdm(M, n, k, varargin)
            
            if nargin > 3
                host = varargin{1};
                fprintf('Setting hostname to: %s\n', host);
            else
                host = 'http://dm.shapecomm.de';
            end
            
            obj.n = n;
            obj.M = M;
            [obj.pA, obj.k, obj.type_seq] = shapecomm.get_ccdm_params(struct('M', obj.M, 'n', obj.n, 'k', n * k));
            
            obj.host = host;
            obj.num_retries = 10;
        end
        
        
        function symbols = encode(obj, bits)
            if length(bits) ~= obj.k
                error('Parameter "bits" to sc_web_ccdm.encode() must have size: %d. Given was: %d', obj.k, length(bits));
            end
            
            data = struct('bits', bits, 'type_seq', obj.type_seq);
            options = weboptions('MediaType', 'application/json');
            % be patient and allow time to receover
            for ii=1:obj.num_retries
                try
                    resp = webwrite(sprintf('%s/encode', obj.host), data, options);
                    break;
                catch
                    if ii < obj.num_retries
                        fprintf('Error during encode request, trying again.\n');
                        pause(5);
                    else
                        error('Can not encode. Giving up after %d tries.', obj.num_retries);
                    end
                end
            end
            if isfield(resp, 'error')
                error(resp.error);
                symbols = [];
            else
                symbols = resp.symbols;
            end
        end
        
        
        function bits = decode(obj, symbols)
            if length(symbols) ~= obj.n
                error('Parameter "symbols" to sc_web_ccdm.decode() must have size: %d. Given was: %d', obj.n, length(symbols));
            end
            
            symbol_type = get_type(symbols);
            if ~isequal(symbol_type, obj.type_seq)
                warning(['symbol sequence has type [ ', sprintf('%d ', symbol_type), ...
                    '], which does not match with desired one: [ ', ...
                    sprintf('%d ', obj.type_seq), ']. Returning random sequence.']);
                bits = randi([0 1], [obj.k 1]);
                return;
            end
            
            data = struct('symbols', symbols, 'type_seq', obj.type_seq, 'k', obj.k);
            options = weboptions('MediaType', 'application/json');
            % be patient and allow time to receover
            for ii=1:obj.num_retries
                try
                    resp = webwrite(sprintf('%s/decode', obj.host), data, options);
                    break;
                catch
                    if ii < obj.num_retries
                        fprintf('Error during decode request, trying again.\n');
                        pause(5);
                    else
                        error('Can not decode. giving up after %d tries.', obj.num_retries);
                    end
                end
            end
            
            if isfield(resp, 'error')
                error(resp.error);
                bits = [];
            else
                bits = resp.bits;
            end
        end
        
        %         function test_conn(obj)
        %             options = weboptions('MediaType', 'application/json');
        %             resp = webwrite(sprintf('%s/test', obj.host), data, options);
        %         end
        
    end
end


function type_seq = get_type(symbols)
    symbols_u = unique(symbols);
    type_seq = zeros(length(symbols_u),1);   
    for ii=1:length(symbols_u)
        type_seq(ii) = sum(symbols_u(ii) == symbols);
    end
end