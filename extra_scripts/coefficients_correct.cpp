#include<bits/stdc++.h>
using namespace std;

ifstream in("../data/old/coefficients.csv");
ofstream out("../data/coefficients.csv");

string line;
int howManySeps;

int main()
{
    getline(in, line);
    out << "From;To;Points given by voting;Points given to voted;Points given from voting to voted" << endl;
    for(int i = 0; i < 2652; i++)
    {
        getline(in, line);
        howManySeps = 0;
        for(int j = 0; j < 1000000; j++)
        {
            if(line[j] == ';')
                howManySeps++;
            if(howManySeps == 5)
                break;
            out << line[j];
        }
        out << endl;
    }

    in.close();
    out.close();
    return 0;
}
