function res = round2(x, order)
% function res = round2(x, order)
% Zaoukrouhli na dany pocet desetinnych mist (order 1: desitky, 0:
% jednotky, -1 desetiny, -2 setiny apod.)
%
% Pr. round2(pi*100, -2), round2(pi*100, 2)
%
% v1.0, Tomas Boril, borilt@gmail.com

res = round(x / 10^order) * 10^order;
