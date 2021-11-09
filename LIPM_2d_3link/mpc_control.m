function [T, q] = mpc_control(P, T, q0, um, c1, c2, c3, Cq, eps)
    %% MPC Controller
    dt = T(2) - T(1);
    q = NaN(length(T), length(q0));
    q(1,:) = q0;
    for i = 2:length(T)
        
        [u, C, n] = bisection(P, dt, q(i-1,1:6), um, c1, c2, c3, Cq, eps);
        [~, qc] = ode45(@(t,q) statespace1(q, u, c1, c2, c3), 0:dt:P*dt, q(i-1,1:6));
        q(i,:) = [qc(2,:), u', C', n];
        
    end
end