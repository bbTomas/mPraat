function tgNew = tgRemoveIntervalRightBoundary(tg, tierInd, index)
% function tgNew = tgRemoveIntervalRightBoundary(tg, tierInd, index)
% Odstrani pravou hranici intervalu s danym indexem z vrstvy (tier) tierInd typu IntervalTier.
% Slouci se tim dva intervaly do jednoho (spoji se i labely). Nelze pouzit
% pro posledni interval, protoze to je konecna hranice vrstvy.
% Napr. mam intervaly 1-2-3, dam odstranit pravou hranici 2. intervalu.
% Vysledkem budou dva intervaly 1-23. Pokud mi vadi slouceni labelu, mohu
% label jeste pred odstranovanim hranice nastavit na prazdny retezec.
% v1.0, Tomas Boril, borilt@gmail.com

if nargin ~= 3
    error('Wrong number of arguments.')
end

% if ~isInt(tierInd)
%     error(['index tier musi byt cele cislo od 1 vyse [' num2str(tierInd) ']']);
% end
tierInd = tgI(tg, tierInd);

% ntiers = tgGetNumberOfTiers(tg);
% if tierInd < 1 || tierInd>ntiers
%     error(['index tier mimo rozsah, tierInd = ' num2str(tierInd) ', ntiers = ' num2str(ntiers)]);
% end
if ~tgIsIntervalTier(tg, tierInd)
    error(['tier ' num2str(tierInd) ' is not IntervalTier']);
end

nint = tgGetNumberOfIntervals(tg, tierInd);
if index < 1 || index>nint
    error(['index out of range, index = ' num2str(index) ', nint = ' num2str(nint)]);
end

if ~isInt(index)
    error(['index must be integer >= 1 [' num2str(index) ']']);
end

if index == nint
    error(['index cannot be the last interval because it is the last boundary of the tier. index = ' num2str(index)]);
end

t1 = tg.tier{tierInd}.T1(index);
t2 = tg.tier{tierInd}.T2(index+1);
lab = [tg.tier{tierInd}.Label{index} tg.tier{tierInd}.Label{index+1}];

tgNew = tg;
for I = index: nint - 1
    tgNew.tier{tierInd}.T1(I) = tgNew.tier{tierInd}.T1(I+1);
    tgNew.tier{tierInd}.T2(I) = tgNew.tier{tierInd}.T2(I+1);
    tgNew.tier{tierInd}.Label{I} = tgNew.tier{tierInd}.Label{I+1};
end

tgNew.tier{tierInd}.T1(end) = [];
tgNew.tier{tierInd}.T2(end) = [];
tgNew.tier{tierInd}.Label(end) = [];

tgNew.tier{tierInd}.T1(index) = t1;
tgNew.tier{tierInd}.T2(index) = t2;
tgNew.tier{tierInd}.Label{index} = lab;

