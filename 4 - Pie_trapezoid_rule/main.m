clear;
clc;

% Trapezoidal rule integrand
fx = @(x) 4 ./ (1 + x.^2);

n = 100;              
maxWorkers = 4;       
times = zeros(1, maxWorkers);

% -------------------------------------------------
% Start process-based parallel pool ONCE
% -------------------------------------------------
parpool('Processes', maxWorkers); % Processes = local

for ncpus = 1:maxWorkers

    fprintf('\nRunning with %d worker(s)\n', ncpus);
    tic;

    % ---------------------------------------------
    % SPMD: define subintervals
    % ---------------------------------------------
    spmd (ncpus)
        a = (spmdIndex - 1) / spmdSize; % spmdIndex = labindex , spmdSize = numlabs
        b = spmdIndex / spmdSize;
        fprintf('Worker %d: A = %f, B = %f\n', spmdIndex, a, b);
    end

    % ---------------------------------------------
    % SPMD: compute partial trapezoidal integrals
    % ---------------------------------------------
    spmd (ncpus)
        x = linspace(a, b, n);
        quad_part = (b - a) / (n - 1) * ...
            (0.5 * fx(x(1)) + sum(fx(x(2:n-1))) + 0.5 * fx(x(n)));
        fprintf('Worker %d: Partial approx = %f\n', spmdIndex, quad_part);
    end

    % ---------------------------------------------
    % Combine results
    % ---------------------------------------------
    quad = sum([quad_part{:}]);
    times(ncpus) = toc;

    fprintf('Approximation of pi = %f\n', quad);
    fprintf('Elapsed time = %.4f s\n', times(ncpus));

end

% -------------------------------------------------
% Close the parallel pool 
% -------------------------------------------------
delete(gcp('nocreate'));

% -------------------------------------------------
% Speedup and efficiency table
% -------------------------------------------------
fprintf('\n------------------------------------------\n');
fprintf(' ncpus | time (s) | speedup | efficiency\n');
fprintf('------------------------------------------\n');

for i = 1:maxWorkers
    speedup    = times(1) / times(i);
    efficiency = speedup / i;
    fprintf('  %2d   |  %6.4f |  %6.3f |   %6.3f\n', ...
            i, times(i), speedup, efficiency);
end

fprintf('------------------------------------------\n');