function [root, iter] = simd_root_parallel(f, a, b, tol, N)
% SIMD-Root (Parallel implementation)

iter = 0;

while (b - a) >= tol
    iter = iter + 1;

    S = (b - a) / (N + 1);
    x = a + (0:N+1)*S;

    y = zeros(size(x));
    parfor i = 1:length(x)
        y(i) = f(x(i));
    end

    idx = find(y(1:end-1).*y(2:end) < 0, 1);

    if ~isempty(idx)
        a = a + (idx-1)*S;
        b = a + S;
    end
end

root = (a + b)/2;
end