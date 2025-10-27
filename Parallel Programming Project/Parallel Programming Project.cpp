#include <iostream>
#include<time.h>
#include <chrono>

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
    cout << "Elapsed time: " << result.count() << " seconds\n";
    return 0;
}

