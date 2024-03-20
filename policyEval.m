function v = policyEval (P, R, gamma, policy, v)
    trash = 1e-6;
    S= size(P,1);
    Ppi = zeros(S,S);
    Rpi = zeros(S,1);
    for s=1:S
       Ppi(s,:) = P(s,:,policy(s));
       Rpi(s) = R(s,policy(s));
    end
    
    while true
        v_old = v;
        v = Rpi + gamma*Ppi*v_old;
        if norm(v_old-v,Inf) < trash
            break
        end
    end


end