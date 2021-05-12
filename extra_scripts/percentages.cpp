#include<iostream>
#include<iomanip>
#include<map>
#include<set>
#include<fstream>
using namespace std;


ifstream in("eurovision.txt");
ofstream out("from_to_percentages.txt");

int year, points, lastYear;
int timesCountryInFinal, countriesVotingInFinals;
int allPointsGivenLeft, allPointsGivenRight, allPointsGottenRight, allPointsGivenLeftGottenRight;
int pointsGottenRight, allPointsGotten, allPointsGottenWhenRinFinals;
bool didCountryParticipateInFinal;
double percentageFrom, percentageTo, meanPercentYearsParticipanting, rightPercentYearsParticipating;
string tmp, whichContest, from, to;

set<string> allTheCountries;
map<int,set<string>> whichCountriesParticipate;
map<string,int> whichToWhomHowMany;
// map<string,double> meanPercentageOfPoints;

int main()
{
    getline(in, tmp);
    for(int i = 0; i < 49832; i++)
    {
        in >> year >> whichContest >> tmp >> tmp >> from >> to >> points;
        if(from == to)
            in >> tmp;
        whichCountriesParticipate[year].insert(from);
        allTheCountries.insert(from);
    }

    // Check if we have countries for years
    for(int i = 1975; i <= 2019; i++)
    {
        cout << i << ": ";
        for(auto country: whichCountriesParticipate[i])
            cout << country << " ";
        cout << endl;
    }

    // Calculate mean country score for every year
    /*
    for(auto country: allTheCountries)
    {
        in.clear();
        in.seekg(0);
        getline(in, tmp);
        lastYear = 1975;

        timesCountryInFinal = 0;
        countriesVotingInFinals = 0;

        for(int i = 0; i < 49832; i++)
        {
            in >> year >> whichContest >> tmp >> tmp >> from >> to >> points;
            if(from == to)
                in >> tmp;
            if(year != lastYear)
                didCountryParticipateInFinal = false;

            if(to == country && whichContest == "f" && !didCountryParticipateInFinal && year >= 2000)
            {
                timesCountryInFinal++;
                didCountryParticipateInFinal = true;
                countriesVotingInFinals += whichCountriesParticipate[year].size();
            }

            lastYear = year;
        }
        meanPercentageOfPoints[country] = (double)timesCountryInFinal/countriesVotingInFinals*100;
    }
    */

    out << "From;To;All points given by L;All points gotten by R;All points given from L to R;% of given points from L to R out of all given;% of given points to R from L out of all gotten;% of all votes for R\n";
    for(auto countryFrom: allTheCountries)
    {
        for(auto countryTo: allTheCountries)
        {
            if(countryTo == countryFrom)
                continue;

            in.clear();
            in.seekg(0);
            getline(in, tmp);
            lastYear = 1974;

            allPointsGivenLeft = 0;
            allPointsGivenLeftGottenRight = 0;
            allPointsGottenRight = 0;

            timesCountryInFinal = 0;
            countriesVotingInFinals = 0;

            allPointsGottenWhenRinFinals = 0;

            for(int i = 0; i < 49832; i++)
            {
                in >> year >> whichContest >> tmp >> tmp >> from >> to >> points;
                if(from == to)
                    in >> tmp;

                if(year != lastYear)
                    didCountryParticipateInFinal = false;
                if(year < 2000) // can be commented
                    continue;
                if(!whichCountriesParticipate[year].count(countryFrom) || !whichCountriesParticipate[year].count(countryTo))
                    continue;
                if(from == to)
                    continue;
                if(whichContest != "f") // ?? Can be done sth here
                    continue;

                if(!didCountryParticipateInFinal)
                {
                    timesCountryInFinal++;
                    didCountryParticipateInFinal = true;
                    countriesVotingInFinals += whichCountriesParticipate[year].size();
                }

                if(from == countryFrom)
                {
                    allPointsGivenLeft += points;
                    if(to == countryTo)
                    {
                        allPointsGivenLeftGottenRight += points;
                    }
                }
                if(to == countryTo)
                {
                    allPointsGottenRight += points;
                }

                allPointsGottenWhenRinFinals += points;
            }

            out << countryFrom << ";" << countryTo << ";" << allPointsGivenLeft << ";" << allPointsGottenRight << ";" << allPointsGivenLeftGottenRight << ";";

            percentageFrom = (double)allPointsGivenLeftGottenRight / allPointsGivenLeft * 100;
            percentageTo = (double)allPointsGivenLeftGottenRight / allPointsGottenRight * 100;
            meanPercentYearsParticipanting = (double)timesCountryInFinal / countriesVotingInFinals * 100;
            rightPercentYearsParticipating = (double)allPointsGottenRight / allPointsGottenWhenRinFinals * 100;

            out << setprecision(4) << percentageFrom << "%;" << percentageTo << "%;";
            out << setprecision(4) << rightPercentYearsParticipating <<"%\n";
        }
    }

    in.close();
    out.close();

    return 0;
}
