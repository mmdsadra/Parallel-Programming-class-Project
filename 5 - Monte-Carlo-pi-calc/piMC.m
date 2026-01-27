function time = piMC(N)
% -------------------------------------------------
% Monte Carlo approximation of pi (SPMD version)
% -------------------------------------------------

tic;

n = 0;   % Local counter for points inside the unit circle

% -------------------------------------------------
% Monte Carlo sampling
% -------------------------------------------------
for j = 1:N
    x = rand;
    y = rand;

    % Check if point lies inside unit circle
    if (x^2 + y^2) <= 1
        n = n + 1;
    end
end

% -------------------------------------------------
% Global reduction: sum points inside circle
% -------------------------------------------------
mypi = 4 * spmdPlus(n) / (spmdSize * N);

% -------------------------------------------------
% Print result from master worker only
% -------------------------------------------------
if spmdIndex == 1
    fprintf('pi is about %.8f\n', mypi);
end

time = toc;
end
