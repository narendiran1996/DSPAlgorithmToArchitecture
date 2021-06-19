#include <iostream>
#include <cmath>

class myComplex
{
public:
    double realP, imagP;
    myComplex()
    {
        this->realP = 0.0f;
        this->imagP = 0.0f;
    }
    myComplex(double real)
    {
        this->realP = real;
        this->imagP = 0.0f;
    }
    myComplex(double real, double imag)
    {
        this->realP = real;
        this->imagP = imag;
    }
    static myComplex myComplexFromEuler(double magnitude, double eulerAngle)
    {
        return myComplex(magnitude * cos(eulerAngle), magnitude * sin(eulerAngle));
    }
    myComplex operator+(myComplex &other)
    {
        return myComplex(this->realP + other.realP, this->imagP + other.imagP);
    }
    myComplex operator+(double num)
    {
        return myComplex(this->realP + num, this->imagP);
    }
    myComplex operator-(myComplex &other)
    {
        return myComplex(this->realP - other.realP, this->imagP - other.imagP);
    }
    myComplex operator-(double num)
    {
        return myComplex(this->realP - num, this->imagP);
    }
    myComplex operator*(myComplex &other)
    {
        return myComplex((this->realP * other.realP) - (this->imagP * other.imagP), (this->imagP * other.realP) + (this->realP * other.imagP));
    }
    myComplex operator*(double num)
    {
        return myComplex(this->realP * num, this->imagP * num);
    }
    bool operator==(myComplex &other)
    {
        return (this->realP == other.realP) && (this->imagP == other.imagP);
    }
};

std::ostream &operator<<(std::ostream &stream, myComplex &compNo)
{
    // if (compNo.imagP == 0)
    //     stream << compNo.realP;
    // else if (compNo.imagP > 0)
    //     stream << compNo.realP << " + " << compNo.imagP << "j";
    // else
    //     stream << compNo.realP << " - " << -1 * compNo.imagP << "j";
    stream << '(' << compNo.realP << " , " << compNo.imagP << ")";
    return stream;
}

void DFT_using_ForLoops(myComplex *xin, myComplex *Xout, int N)
{

    for (int k = 0; k < N; k++)
    {
        myComplex tempX(0, 0);
        for (int n = 0; n < N; n++)
        {
            myComplex expValWithJ = myComplex::myComplexFromEuler(1, -k * (2 * M_PI / N) * n);
            myComplex mulVal = expValWithJ * xin[n];
            tempX = tempX + mulVal;
        }
        Xout[k] = tempX;
    }
}

void DFT2Point(myComplex *xin, myComplex *Xout)
{
    Xout[0] = xin[0] + xin[1];
    Xout[1] = xin[0] - xin[1];
}

void DFTUsingDITRecursive_2powers(myComplex *xin, myComplex *Xout, int N)
{
    if (N == 2)
        return DFT2Point(xin, Xout);

    myComplex xeven[N / 2];
    myComplex xodd[N / 2];
    int j, l;
    j = l = 0;
    for (int i = 0; i < N; i++)
    {
        if (i % 2 == 0)
        {
            xeven[j] = xin[i];
            j++;
        }
        else
        {
            xodd[l] = xin[i];
            l++;
        }
    }

    myComplex Xeven[N / 2];
    myComplex Xodd[N / 2];

    DFTUsingDITRecursive_2powers(xeven, Xeven, N / 2);
    DFTUsingDITRecursive_2powers(xodd, Xodd, N / 2);

    myComplex XoddM[N / 2];
    for (int i = 0; i < N / 2; i++)
    {
        myComplex wnTemp = myComplex::myComplexFromEuler(1, -1 * (2 * M_PI / N) * i);
        XoddM[i] = Xodd[i] * wnTemp;
    }
    j = l = 0;
    for (int i = 0; i < N; i++)
    {
        if (i < N / 2)
        {
            Xout[i] = Xeven[l] + XoddM[l];
            l++;
        }
        else
        {
            Xout[i] = Xeven[j] - XoddM[j];
            j++;
        }
    }
}

int main()
{
    int N = 16;
    myComplex xin[N] = {0.0767, -0.402,   0.0755,  0.3313, -0.2713,  0.246,   0.2854, -0.16 ,  -0.1935, -0.2192, -0.1876, -0.8407, -0.8863, -0.8433,  0.3914, -0.9417};
    myComplex Xout[N];
    DFT_using_ForLoops(xin, Xout, N);
    // DFTUsingDITRecursive_2powers(xin, Xout, N);

    for (int i = 0; i < N; i++)
    {
        std::cout << Xout[i] << '\t';
    }
    std::cout << '\n';

    return 0;
}