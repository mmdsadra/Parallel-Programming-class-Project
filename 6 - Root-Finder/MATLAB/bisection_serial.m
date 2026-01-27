function [root, iter] = bisection_serial(f, a, b, c)
% Bisection method (Serial)
% EXACT implementation of the given pseudo-code

iter = 0;

while abs(b - a) >= c
    iter = iter + 1;

    % 1) m <- 1/2 (a + b)
    m = 0.5 * (a + b);

    % 2) if f(a) * f(m) < 0
    if f(a) * f(m) < 0
        b = m;
    else
        a = m;
    end
end

root = 0.5 * (a + b);
end