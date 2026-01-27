clc;
clear;

% -------------------------------------------------
% Read image and generate noisy version
% -------------------------------------------------
x = imread('piclena.jpg');
x = rgb2gray(x);
y = imnoise(x, 'salt & pepper', 0.30);

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
    % Distribute image among workers
    % ---------------------------------------------
    yd = distributed(y);

    % ---------------------------------------------
    % SPMD: apply median filter to local partitions
    % ---------------------------------------------
    spmd
        y1 = getLocalPart(yd);
        y1 = medfilt2(y1, [3 3]);
    end

    % ---------------------------------------------
    % Gather filtered image blocks
    % ---------------------------------------------
    z = [];
    for k = 1:numel(y1)
        z = [z y1{k}];
    end

    times(ncpus) = toc; 
end

% -------------------------------------------------
% Close the parallel pool
% -------------------------------------------------
delete(gcp('nocreate'));

% -------------------------------------------------
% Display results
% -------------------------------------------------
figure;
subplot(1,3,1); imshow(x); title('Original Image');
subplot(1,3,2); imshow(y); title('Noisy Image');
subplot(1,3,3); imshow(z); title('Median Filtered Image');

% ------------------------------------------
% Timing, speedup, efficiency table
% ------------------------------------------
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
