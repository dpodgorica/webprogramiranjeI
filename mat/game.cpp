#include <iostream>
#include <vector>
#include <random>
#include <utility>
using namespace std;

const int velicina = 5;
pair<int,int> K1, K2;
vector<vector<string>> matrica;

mt19937 gen(random_device{}()); // global generator

bool provjeradvabroja(int a, int b)
{
    if(a>=0 && a<velicina && b>=0 && b<velicina)
        return true;
    return false;
}

void generisi(pair<int,int> &p)
{
    uniform_int_distribution<> distr(0, velicina - 1);
    p.first = distr(gen);
    p.second = distr(gen);
}

void inicijaliziraj()
{
    matrica = vector<vector<string>>(velicina, vector<string>(velicina, "~"));
    generisi(K1);
    while(true)
    {
        generisi(K2);
        if(K2.first != K1.first || K2.second != K1.second)
            break;
    }

    matrica[K1.first][K1.second] = "K1";
    matrica[K2.first][K2.second] = "K2";
}

string ispisklijenta(const string &ime)
{
    string ispis="\n";
    for(int i=0; i<matrica.size(); i++)
    {
        for(int j=0; j<matrica.size(); j++)
        {
            if(matrica[i][j]!=ime)
                ispis.append("~ ");
            else
                ispis.append("X ");
        }
        ispis.append("\n");
    }
    return ispis;
}

bool provjera(const string &ime, int pomak)
{
    pair<int,int> &t = (ime=="K1") ? K1 : K2;

    switch(pomak)
    {
    default:
        return false;
    case 1: // GORE
        if (t.first == 0) return false;
        matrica[t.first][t.second] = "~";
        t.first--;
        matrica[t.first][t.second] = ime;
        return true;

    case 2: // DOLJE
        if (t.first == velicina-1) return false;
        matrica[t.first][t.second] = "~";
        t.first++;
        matrica[t.first][t.second] = ime;
        return true;

    case 3: // LIJEVO
        if (t.second == 0) return false;
        matrica[t.first][t.second] = "~";
        t.second--;
        matrica[t.first][t.second] = ime;
        return true;

    case 4: // DESNO
        if (t.second == velicina-1) return false;
        matrica[t.first][t.second] = "~";
        t.second++;
        matrica[t.first][t.second] = ime;
        return true;

    case 0: // OSTANI
        return true;
    }
}

bool kolizija()
{
    if(K1.first==K2.first && K1.second==K2.second)
        return true;
    return false;
}

bool pogodak(const string &ime, int prva, int druga)
{
    pair<int,int> &pucac = (ime=="K1") ? K1 : K2;
    pair<int,int> &gonjenik = (ime=="K1") ? K2 : K1;
    if(gonjenik.first==prva && gonjenik.second==druga)
        return true;
    return false;
}

string posaljipoziciju(const string &ime)
{
    pair<int,int> &t = (ime=="K1") ? K1 : K2;
    string poz;
    poz = string("\nVasa pozicija je ") + "(" + to_string(t.first) + ", " + to_string(t.second) + ")";
    return poz;
}

string ispispozicija()
{
    string ispis="";
    for(int i=0; i<matrica.size(); i++)
    {
        for(int j=0; j<matrica.size(); j++)
        {
            ispis+=to_string(i)+to_string(j)+" ";
        }
        ispis.append("\n");
    }
    return ispis;
}
