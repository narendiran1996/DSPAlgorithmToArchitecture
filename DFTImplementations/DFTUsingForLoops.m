clc;
clear;
close all;
x = [2, 3, 4];

X = zeros(size(x));

N = length(x);
for k = 0 : N-1
    for n = 0 : N-1
        expVal = k * (2 * pi / N) * n;
        expValWithJ = exp(-j*expVal);
        X(k+1) = X(k+1) + (x(n+1) * expValWithJ);
    end
end

disp(X);