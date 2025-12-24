clear; 
clc;

% -------------------------------------------------
% Define integrand and parallel configuration
% -------------------------------------------------
F = @(x) 4./(1 + x.^2);     
maxWorkers = 2;            

times = zeros(1, maxWorkers);   

% -------------------------------------------------
% Start process-based parallel pool 
% -------------------------------------------------
parpool('Processes', maxWorkers); % Processes = local

for ncpus = 1:maxWorkers

    fprintf('\nRunning with %d worker(s)\n', ncpus);
    tic;

    % ---------------------------------------------
    % SPMD: split interval and compute local integrals
    % ---------------------------------------------
    spmd (ncpus)
        a = (spmdIndex - 1) / spmdSize; % spmdIndex = labindex , spmdSize = numlabs  
        b = spmdIndex / spmdSize;         
        fprintf('Subinterval: [%-4g, %-4g]\n', a, b);

        myIntegral = integral(F, a, b);    % integral = quadl
        fprintf('Subinterval: [%-4g, %-4g] Integral: %4g\n', ...
                a, b, myIntegral);

        % -----------------------------------------
        % Global reduction to obtain pi approximation
        % -----------------------------------------
        piApprox = spmdPlus(myIntegral); % spmdPlus = gplus
        fprintf('PI = %4g\n', piApprox);
    end

    times(ncpus) = toc;                 
end

% -------------------------------------------------
% Close the parallel pool
% -------------------------------------------------
delete(gcp('nocreate'));

% -------------------------------------------------
% Timing, speedup, efficiency table
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
