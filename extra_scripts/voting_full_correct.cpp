#include<bits/stdc++.h>
using namespace std;

ifstream in("../data/old/eurovision_voting_full.csv");
ofstream out("../data/eurovision_voting_full.csv");

string line;

int main()
{
    getline(in, line);
    out << "ID;Year;Which contest;Edition;Jury or televoting;From;To;Points;Is duplicate" << endl;
    for(int i = 1; i <= 49832; i++)
    {
        out << i << ";";
        getline(in, line);
        if(line[line.length()-1] == 'x')
            line[line.length()-1] = '1';
        else
            line += '0';
        out << line << endl;
    }

    in.close();
    out.close();
    return 0;
}
