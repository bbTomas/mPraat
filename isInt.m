function b = isInt(a)
% function b = isInt(a)
% Vrátí 1/0, zda je èíslo a celé
% v1.0, Tomáš Boøil, borilt@gmail.com

b = (fix(a) == a);