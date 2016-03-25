function b = isInt(a)
% function b = isInt(a)
% Vrati 1/0, zda je cislo a cele
% v1.0, Tomas Boril, borilt@gmail.com

b = (fix(a) == a);
