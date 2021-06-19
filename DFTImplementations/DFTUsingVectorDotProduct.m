clc;
clear;
close all;
x = [1,3,4,5];
X = zeros(size(x));
N = length(x);

kVector = 0 : 1 : N-1;
nVector = 0 : 1 : N-1;
nVector = nVector';

Mat = kVector.*nVector;
ExpMat = exp(-j*Mat*2*pi/N);

X = x * ExpMat;

disp(X);

