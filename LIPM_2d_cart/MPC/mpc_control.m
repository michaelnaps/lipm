function dq = mpc_control(q, p, um, c1, c2)
    %% MPC Controller
    dt = p(1);
    P = p(2);
    up = (-um:1:um)';  % inputs to consider
    
    % cost function: linear quadratic regulator (based on error)
    %          cart vel.     ang. pos.      ang. vel.     prev. input
    C = @(qc) (0-qc(2))^2 + (pi-qc(3))^2 + (0-qc(4))^2;
    
    % loop for iteration checks
    c = Inf;
    for i = 1:length(up)
        
        % solve for states at next state inputs (unrefined)
        dqc = statespace([q(1:4); up(i)], c1, c2);
        qc = [
              q(1) + P*dt*dqc(1);
              q(2) + P*dt*dqc(2);
              q(3) + P*dt*dqc(3);
              q(4) + P*dt*dqc(4);
             ];
        
        % check cost at end of prediction horizon
        Cp = C(qc);
        if (Cp < c)
            u = up(i);
            c = Cp;
        end
        
    end
    
    % Return state variables with new inputs
    dq = [statespace([q(1:4); u], c1, c2); c];
end