#include<iostream>
#include<fstream>
#include<map>
#include<set>
using namespace std;

ifstream in("ESCanaliza.txt");
ofstream outSemi1("semi1politics.txt"), outSemi2("semi2politics.txt"),
         outSemi1_2018("semi1_2018politics.txt"), outSemi2_2018("semi2_2018politics.txt");

string tmp, from, to;
double politics, thisCountryPolitics;

set<string> semi1 = {"Malta", "Sweden", "Cyprus", "Lithuania", "Romania", "Azerbaijan", "Norway", "Russia", "Ukraine",
                    "Croatia", "Belgium", "Israel", "Australia", "Ireland", "Macedonia", "Slovenia",
                    "Germany", "Italy", "Netherlands"};
set<string> semi2 = {"Switzerland", "Bulgaria", "Finland", "Iceland", "Greece", "SanMarino", "Moldova", "Serbia",
                    "Albania", "Austria", "Poland", "Portugal", "Denmark", "Czech", "Estonia", "Latvia", "Georgia",
                    "France", "Spain", "UnitedKingdom"};
set<string> semi1_2018 = {"Cyprus", "Israel", "Estonia", "Czech", "Bulgaria", "Lithuania",
                          "Austria", "Greece", "Switzerland", "Armenia", "Finland", "Belgium",
                          "Azerbaijan", "Belarus", "Albania", "Ireland", "Croatia", "Macedonia", "Iceland",
                          "Portugal", "Spain", "UnitedKingdom"};
set<string> semi2_2018 = {"Sweden", "Norway", "Ukraine", "Moldova", "Denmark", "Australia",
                          "Hungary", "Netherlands", "Poland", "Malta", "Romania", "Slovenia",
                          "Russia", "Latvia", "Serbia", "Montenegro", "Georgia", "SanMarino",
                          "France", "Germany", "Italy"};

void generatePoliticsReport(set<string> whichSemi, ofstream& out)
{
    for(auto country: whichSemi)
    {
        in.clear();
        in.seekg(0);
        getline(in, tmp);

        thisCountryPolitics = 0;
        for(int i = 0; i < 2652; i++)
        {
            in >> from >> to >> tmp >> tmp >> tmp >> tmp >> tmp >> tmp >> tmp;
            for(int i = 0; i < tmp.length(); i++)
                if(tmp[i] == ',')
                    tmp[i] = '.';
            tmp = tmp.substr(0, tmp.size()-1);
            politics = stod(tmp);
            //cout << from << to << tmp << endl;
            if(to == country && whichSemi.count(from))
                thisCountryPolitics += politics;
        }

        out << country << "\t" << thisCountryPolitics << endl;
    }
}

int main()
{
    generatePoliticsReport(semi1, outSemi1);
    generatePoliticsReport(semi2, outSemi2);
    generatePoliticsReport(semi1_2018, outSemi1_2018);
    generatePoliticsReport(semi2_2018, outSemi2_2018);

    return 0;
}
