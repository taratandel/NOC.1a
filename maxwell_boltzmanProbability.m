function P = maxwell_boltzmanProbability(M, no_amp, amp_dis, abs_amp)
    
    % how distributed is maxwell boltzman
    a_vectorized = linspace(0.4, 4.57, 9);
    
    p_opt = zeros(M,length(a_vectorized));
    
    no_of_amplitudes = no_amp;
    
    amplitude_distance = amp_dis;
    
    absolute_values_of_amplitudes = abs_amp;
    for m = 1:1:M
        j = 0;
        for a = a_vectorized
            j = j + 1;
    %       offset is b in the graph
            offset = 0;
            for i = 1:1:length(no_of_amplitudes)
                offset = offset + no_of_amplitudes(i)*max_bol_formula(amplitude_distance(i), a);
            end
            offset = 1/offset;

            p_opt(m, j) = max_bol_formula(absolute_values_of_amplitudes(m),a).*offset;
        end
    end
    P = p_opt;
end