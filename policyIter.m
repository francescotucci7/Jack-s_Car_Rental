S = size(P,1);
A = size(R,2);
gamma = 0.9;
policy = randi(A,[S 1]);
contourf(reshape(policy-8,[4,4]))
value = randn(S,1);
old_policy = policy;
while true
    value = policyEval (P, R, gamma, policy, value);
    policy = policyImpr(P,R,gamma,value);
    if norm(policy-old_policy,Inf) ==0
        break
    end
     old_policy = policy;
end

figure()
contourf(reshape(policy-8,[4,4]))