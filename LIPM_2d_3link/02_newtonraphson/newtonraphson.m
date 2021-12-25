function [u, C, n, brk] = newtonraphson(P, dt, q0, u0, um, c, m, L, Cq, eps)
    %% Setup - Initial Guess, Cost, Gradient, and Hessian
    N = length(um);
    uc = u0;
    Cc = cost(P, dt, q0, uc, c, m, L, Cq, 'NNR Initial Cost');
    gc = cost_gradient(P, dt, q0, uc, c, m, L, Cq, 1e-3);
    Hc = cost_hessian(P, dt, q0, uc, c, m, L, Cq, 1e-3);
    un = uc;  Cn = Cc;

    %% Loop for Newton-Raphson Method
    count = 1;
    brk = 0;
    while (Cc > eps)
        % compute the next iteration of the input
        udn = Hc\gc;
        un = uc - udn;
        
        % check boundary constraints
        for i = 1:N
            if (un(i) > um(i))
                un(i) = um(i);
            elseif (un(i) < -um(i))
                un(i) = -um(i);
            end
        end

        % compute new values for cost, gradient, and hessian
        Cn = cost(P, dt, q0, un, c, m, L, Cq, 'NNR Initial Cost');
        gn = cost_gradient(P, dt, q0, un, c, m, L, Cq, 1e-3);
        Hn = cost_hessian(P, dt, q0, un, c, m, L, Cq, 1e-3);

        Cdn = abs(Cn - Cc);
        count = count + 1;

        if (sum(gn < eps) == N)
            % fprintf("First Order Optimality break. (%i)\n", count)
            brk = 1;
            break;
        end

%         if ((udn < eps) == N)
%             fprintf("Change in input break. (%i)\n", count)
%             brk = 2;
%             break;
%         end
% 
%         if ((Cdn < eps) == N)
%             fprintf("Change in cost break. (%i)\n", count)
%             brk = 3;
%             break;
%         end

        if (count == 1000)
            fprintf("ERROR: Iteration break. (%i)\n", count)
            brk = -1;
            break;
        end

        % apply the new values to current for the next iteration
        uc = un;  Cc = Cn;  gc = gn;  Hc = Hn;
    end

    if (brk == 0)
        % fprintf("Zero cost break. (%i)\n", count)
    end

    % fprintf("u1 = %.3f  u2 = %.3f  u3 = %.3f\n", un)

    %% Return Values for Input, Cost, and Iteration Count
    u = un;
    C = Cn;
    n = count;
end

