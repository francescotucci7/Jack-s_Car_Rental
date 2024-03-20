function policy = policyImpr(P,R,gamma,v)
    S = size(P,1);
    A = size(R,2);
   
    policy = zeros(S,1);
    
    for s=1:S
        Q = zeros(A,1);
        for a = 1:A
            Q(a) = R(s,a) + gamma*P(s,:,a)*v;
        end
        policy(s) = find(Q == max(Q),1);
    end

end