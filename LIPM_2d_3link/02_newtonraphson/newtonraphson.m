function [u, C, n, brk] = newtonraphson(P, dt, q0, u0, um, c, m, L, Cq, eps)
    %% Setup
    a = 1;
    N = length(um);
    uc = u0;
    Cc = cost(P, dt, q0, uc, c, m, L, Cq, 'NNR Initial Cost');
    Jc = cost_gradient(P, dt, q0, uc, c, m, L, Cq, eps);
    un = uc;  Cn = Cc;

    count = 1;
    brk = 0;
    while (Cc > eps)
        udn = -Jc/Cc;
        un = uc + a*udn;
        
        % check boundary constraints
        for i = 1:N
            if (un(i) > um(i))
                un(i) = um(i);
            elseif (un(i) < -um(i))
                un(i) = -um(i);
            end
        end

        Cn = cost(P, dt, q0, un, c, m, L, Cq, 'NNR Initial Cost');
        Jn = cost_gradient(P, dt, q0, un, c, m, L, Cq, eps);

        Cdn = abs(Cn - Cc);  % not used currently
        count = count + 1;

        if (sum(udn < eps) == N)
            fprintf("Change in input break. (%i)\n", count)
            brk = 1;
            break;
        end

        if (count == 1000)
            fprintf("ERROR: Iteration break. (%i)\n", count)
            brk = -1;
            break;
        end

        uc = un;  Cc = Cn;  Jc = Jn;
    end

    if (brk == 0)
        fprintf("Zero cost break. (%i)\n", count)
    end

    u = un;
    C = Cn;
    n = count;

    fprintf("u1 = %.3f  u2 = %.3f  u3 = %.3f\n", u)
end

