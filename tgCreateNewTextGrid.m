function tgNew = tgCreateNewTextGrid(tStart, tEnd)
% function tgNew = tgCreateNewTextGrid(tStart, tEnd)
% Vytvoøí nový zcela prázdný textgrid. Parametry tStart a tEnd
% nastaví tmin a tmax, které jsou napø. používány, když se pøidá nová
% vrstva IntervaTier bez udaného rozsahu.
% Tento prázdný textgrid je samostatnì nepoužitelný, je potøeba do nìj
% pøidat alespoò jednu vrstvu pomocí tgInsertNewIntervalTier nebo
% tgInsertNewPointTier.
% v1.0, Tomáš Boøil, borilt@gmail.com

if nargin ~= 2
    error('Wrong number of arguments.')
end

tgNew.tier = {};

if tStart > tEnd
    error(['tStart [' num2str(tStart) '] must be lower than tEnd [' num2str(tEnd) ']']);
end

tgNew.tmin = tStart;
tgNew.tmax = tEnd;
