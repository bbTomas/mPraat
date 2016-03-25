function res = round2(x, order)
% function res = round2(x, order)
% Zaoukrouhlí na daný poèet desetinných míst (order 1: desítky, 0:
% jednotky, -1 desetiny, -2 setiny apod.)
%
% Pø. round2(pi*100, -2), round2(pi*100, 2)
%
% v1.0, Tomáš Boøil, borilt@gmail.com

res = round(x / 10^order) * 10^order;