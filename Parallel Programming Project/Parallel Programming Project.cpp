#include <iostream>
#include<time.h>
#include <chrono>
#include<vector>
#include <fstream>
#include <immintrin.h>

#define Bound 100

int Am[Bound];
int Bm[Bound];
int Cm[Bound];

alignas(32) int Av[Bound];
alignas(32) int Bv[Bound];
alignas(32) int Cv[Bound];

int main()
{
 
    srand(time(NULL));
    using namespace std;
    ofstream file("Data without flag 10^2.txt");


    file << "First test with array, time(in nanoseconds) :\n";
    for (int i = 0; i < 40; i++)
    {


        for (int i = 0; i < Bound; i++)
        {
            Am[i] = rand() % 100;
            Bm[i] = rand() % 100;
        }


        //Classis Coding:
        auto start = std::chrono::high_resolution_clock::now();
        for (int i = 0; i < Bound; i++)
        {
            Cm[i] = Am[i] + Bm[i];
        }
        auto end = std::chrono::high_resolution_clock::now();
        chrono::duration<double> result = end - start;
        file << result.count()*Bound*Bound/10 << "\n";
    }
    // NOW vector:


    file << "second test with Vector, time(in nanosecond): \n";
    for (int test = 0; test < 40; ++test) {

        for (int i = 0; i < Bound; ++i) {
            Av[i] = rand() % 100;
            Bv[i] = rand() % 100;
        }

        // SIMD Vector Addition using AVX2
        auto start = std::chrono::high_resolution_clock::now();
        int i = 0;
        for (; i + 8 <= Bound; i += 8) {

            __m256i va = _mm256_load_si256((__m256i*) & Av[i]);
            __m256i vb = _mm256_load_si256((__m256i*) & Bv[i]);

            __m256i vc = _mm256_add_epi32(va, vb);

            _mm256_store_si256((__m256i*) & Cv[i], vc);
        }
        // Handle remaining
        for (; i < Bound; ++i) {
            Cv[i] = Av[i] + Bv[i];
        }
        auto end = std::chrono::high_resolution_clock::now();
        std::chrono::duration<double> elapsed = end - start;
        file << elapsed.count() * Bound * Bound / 10 << "\n";
        
    }    
    return 0;
}

