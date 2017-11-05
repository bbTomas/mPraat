function res = round2(x, order)
% function res = round2(x, order)
%
% Rounds to the specified order.
%
% x ... number to be rounded
% order ... [optional, default: 0] 1 = units, 10 = tens, -1 = tenths, etc.
% 
% v1.1, Tomas Boril, borilt@gmail.com
%
% Example
%   round2(pi*100, -2)
%   round2(pi*100, 2)

if nargin < 2
    order = 0;
end

res = round(x / 10^order) * 10^order;
