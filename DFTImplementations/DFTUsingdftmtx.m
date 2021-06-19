clc;
clear;
close all;
x = [2, 3, 4];

X = zeros(size(x));

N = length(x);


F = dftmtx(N);

X = F*x';

disp(X)