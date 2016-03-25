function tgNew = tgCreateNewTextGrid(tStart, tEnd)
% function tgNew = tgCreateNewTextGrid(tStart, tEnd)
% Vytvori novy zcela prazdny textgrid. Parametry tStart a tEnd
% nastavi tmin a tmax, ktere jsou napr. pouzivany, kdyz se prida nova
% vrstva IntervaTier bez udaneho rozsahu.
% Tento prazdny textgrid je samostatne nepouzitelny, je potreba do nej
% pridat alespon jednu vrstvu pomoci tgInsertNewIntervalTier nebo
% tgInsertNewPointTier.
% v1.0, Tomas Boril, borilt@gmail.com

if nargin ~= 2
    error('Wrong number of arguments.')
end

tgNew.tier = {};

if tStart > tEnd
    error(['tStart [' num2str(tStart) '] must be lower than tEnd [' num2str(tEnd) ']']);
end

tgNew.tmin = tStart;
tgNew.tmax = tEnd;
