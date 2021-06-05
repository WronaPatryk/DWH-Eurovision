#include<bits/stdc++.h>
using namespace std;

string s;
ifstream in("points_given_without_contests_together.csv");
ofstream out("points_given_without_contests_together_id.csv");

int main()
{
    getline(in, s);
    out << "\"ID\";" << s << endl;

    for(int i = 2; i <= 35350; i++)
    {
        getline(in, s);
        out << i-1 << ";" << s << endl;
    }

    in.close();
    out.close();
    return 0;
}
