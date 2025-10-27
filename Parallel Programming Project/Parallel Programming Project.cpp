#include <iostream>
#include<time.h>
#include <chrono>
#include<vector>

#define Bound 10000

int main()
{
    srand(time(NULL));
    using namespace std;
    int Am[Bound];
    int Bm[Bound];
    for (int i = 0; i < Bound; i++)
    {
        Am[i] = rand()%100;
        Bm[i] = rand()%100;
    }
    int Cm[Bound];
    
    //Classis Coding:
    auto start = std::chrono::high_resolution_clock::now();
    for (int i = 0; i < Bound; i++)
    {
        Cm[i] = Am[i] + Bm[i];
    }
    auto end = std::chrono::high_resolution_clock::now();
    chrono::duration<double> result = end - start;
    cout << "First test with array, time: " << result.count() << " seconds\n";

    // NOW vector:
    vector<int> Av, Bv, Cv;
    for (int i = 0; i < Bound; i++)
    {
        Av.push_back(rand() % 100);
        Bv.push_back(rand() % 100);
    }
    auto start = std::chrono::high_resolution_clock::now();
    Cv = Av + Bv;
    
    auto end = std::chrono::high_resolution_clock::now();
    return 0;
}

