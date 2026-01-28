#include <iostream>
#include <cmath>
#include <vector>
#include <omp.h>

double f(double x) {
    return x * x + x - 2;
}

double bisection_serial(double a, double b, double tol, int max_iter) {
    double c = 0;

    for (int i = 0; i < max_iter; i++) {
        c = (a + b) / 2.0;

        if (std::abs(f(c)) < tol)
            return c;

        if (f(a) * f(c) < 0)
            b = c;
        else
            a = c;
    }
    return c;
}

//std::vector<double> bisection_parallel_simd(
//    double A, double B,
//    int n_intervals,
//    double tol,
//    int max_iter
//) {
//    std::vector<double> roots(n_intervals);
//    double interval_size = (B - A) / n_intervals;
//
//#pragma omp parallel for
//    for (int i = 0; i < n_intervals; i++) {
//        double a = A + i * interval_size;
//        double b = a + interval_size;
//
//        // بررسی شرط وجود ریشه
//        if (f(a) * f(b) > 0) {
//            roots[i] = NAN;
//            continue;
//        }
//
//        double c;
//        for (int iter = 0; iter < max_iter; iter++) {
//            c = (a + b) / 2.0;
//
//            if (std::abs(f(c)) < tol)
//                break;
//
//            if (f(a) * f(c) < 0)
//                b = c;
//            else
//                a = c;
//        }
//        roots[i] = c;
//    }
//    return roots;
//}

double bisection_parallel_early_stop(
    double A, double B,
    int n_intervals,
    double tol,
    int max_iter
) {
    double interval_size = (B - A) / n_intervals;

    double found_root = NAN;
    bool found = false;

    #pragma omp parallel for shared(found, found_root)
    for (int i = 0; i < n_intervals; i++) {

        // اگر ریشه پیدا شده، این Thread ادامه ندهد
        if (found) continue;

        double a = A + i * interval_size;
        double b = a + interval_size;

        if (f(a) * f(b) > 0)
            continue;

        double c;
        for (int iter = 0; iter < max_iter; iter++) {

            // بررسی توقف زودهنگام
            if (found) break;

            c = (a + b) / 2.0;

            if (std::abs(f(c)) < tol) {
                #pragma omp critical
                {
                    if (!found) {
                        found = true;
                        found_root = c;
                    }
                }
                break;
            }

            if (f(a) * f(c) < 0)
                b = c;
            else
                a = c;
        }
    }
    return found_root;
}


int main() {
    double A = -20000, B = 0;
    double tol = 1e-6;
    int max_iter = 1000000;
    int n_intervals = 16;

    // ===== SERIAL =====
    double t1 = omp_get_wtime();
    double serial_root = bisection_serial(A, B, tol, max_iter);
    double t2 = omp_get_wtime();
    double serial_time = t2 - t1;

    // ===== PARALLEL =====
    double t3 = omp_get_wtime();
    double parallel_root = bisection_parallel_early_stop(
        A, B, n_intervals, tol, max_iter
    );
    double t4 = omp_get_wtime();
    double parallel_time = t4 - t3;

    int threads = omp_get_max_threads();
    double speedup = serial_time / parallel_time;
    double efficiency = speedup / threads;

    // ===== OUTPUT =====
    std::cout << "Serial Root: " << serial_root << std::endl;
    std::cout << "Serial Time: " << serial_time << " s\n\n";

    std::cout << "Parallel Root: " << parallel_root << std::endl;
    std::cout << "Parallel Time: " << parallel_time << " s\n";

    std::cout << "Threads: " << threads << std::endl;
    std::cout << "Speedup: " << speedup << std::endl;
    std::cout << "Efficiency: " << efficiency << std::endl;

    return 0;
}