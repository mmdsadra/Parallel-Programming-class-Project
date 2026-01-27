clear;
clc;
% -------------------------------------------------
% Parallel Monte Carlo experiment configuration
% -------------------------------------------------
maxWorkers = 4;                 % Maximum number of workers
totalSamples = 20000000;        % Total Monte Carlo samples
times = zeros(1, maxWorkers);
% -------------------------------------------------
% Run experiment for increasing number of workers
% -------------------------------------------------
for ncpus = 1:maxWorkers
    
    % ---------------------------------------------
    % Start parallel pool with ncpus workers
    % ---------------------------------------------
    parpool('Processes', ncpus);
    tic;
    
    % ---------------------------------------------
    % SPMD: distribute workload among workers
    % ---------------------------------------------
    spmd
        time = piMC(totalSamples / ncpus);
    end
    % ---------------------------------------------
    % Report execution time (master worker)
    % ---------------------------------------------
    times(ncpus) = toc; 
    fprintf('ncpus = %d, time = %.4f s\n', ncpus, times(ncpus));
    % ---------------------------------------------
    % Shut down parallel pool
    % ---------------------------------------------
    delete(gcp('nocreate'));
    fprintf('\n');
end
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