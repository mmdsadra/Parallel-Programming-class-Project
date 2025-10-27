#include <iostream>
#include<time.h>
#include <chrono>
#include<vector>
#include <fstream>

#define Bound 10000

int main()
{
 
    srand(time(NULL));
    using namespace std;
    ofstream file("Data without Ox flag.txt");

    int Am[Bound];
    int Bm[Bound];
    file << "First test with array, time(in seconds) :\n";
    for (int i = 0; i < 40; i++)
    {


        for (int i = 0; i < Bound; i++)
        {
            Am[i] = rand() % 100;
            Bm[i] = rand() % 100;
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
        file << result.count() << "\n";
    }
    // NOW vector:
    vector<int> Av, Bv, Cv(Bound);
    file << "second test with Vector, No flag, time(in second): \n";
    for (int i = 0; i < 40; i++)
    {


        for (int i = 0; i < Bound; i++)
        {
            Av.push_back(rand() % 100);
            Bv.push_back(rand() % 100);
        }
        auto start2 = chrono::high_resolution_clock::now();
        for (int i = 0; i < Bound; i++)
        {
            Cv[i] = Av[i] + Bv[i];
        }
        auto end2 = chrono::high_resolution_clock::now();
        chrono::duration<double> result2 = end2 - start2;
        file << result2.count() << "\n";
    }
    return 0;
}

