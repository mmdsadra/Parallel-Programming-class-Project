clear; clc;

%f = @(x) x.^3 - x - 2;
f = @(x) sin(x);

a = 0; 
b = 2*pi;
c = 1e-6;
N = 10;

%true_root = 1.52137970680457;
true_root = 3.1415926535;

% ---------- Serial ----------
tic;
[root_s, iter_s] = bisection_serial(f, a, b, c);
time_s = toc;
prec_s = abs(root_s - true_root);

% ---------- Parallel ----------
parpool('Processes');

tic;
[root_p, iter_p] = simd_root_parallel(f, a, b, c, N);
time_p = toc;
prec_p = abs(root_p - true_root);

delete(gcp);

% ---------- Performance ----------
speedup = time_s / time_p;
efficiency = speedup / N;

% ---------- Table ----------
fprintf('\n-------------------------------------------------------------\n');
fprintf('| Method   | Time (s) | Precision      | Speedup | Efficiency |\n');
fprintf('-------------------------------------------------------------\n');
fprintf('| Serial   | %8.5f | %12.6e |  1.00   |  1.00      |\n', time_s, prec_s);
fprintf('| Parallel | %8.5f | %12.6e | %6.2f | %8.4f |\n', time_p, prec_p, speedup, efficiency);
fprintf('-------------------------------------------------------------\n');