function dq = statespace(q, c1, c2)
    %% Setup
    mc = 100;  % [kg]
    mb = 10;   % [kg]
    l = 1;     % [m]
    g = 9.81;  % [m/s^2]
    
    % Measured/Retained Values
    q1 = q(1);   % not needed for computations
    q2 = q(2);
    q3 = q(3);
    q4 = q(4);
    u  = q(5);
    
    %% State Space
    dq = [
         (q2);
         (u - c1*q2 + mb*sin(q3)*(l*q4^2 - g*cos(q3)))...
               / (mc + mb*sin(q3)^2);               
         (q4);
         (-u*cos(q3) - mb*l*sin(q3)*cos(q3) - (mc+mb)*g*sin(q3) - c2*l*q4)...
               / (l*(mc+mb*sin(q3)^2));
         (u)
         ];
end

