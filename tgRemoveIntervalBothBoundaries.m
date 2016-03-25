function tgNew = tgRemoveIntervalBothBoundaries(tg, tierInd, index)
% function tgNew = tgRemoveIntervalBothBoundaries(tg, tierInd, index)
% Odstrani levou i pravou hranici intervalu s danym indexem z vrstvy (tier) tierInd typu IntervalTier.
% Slouci se tim tri intervaly do jednoho (spoji se i labely). Nelze pouzit
% pro prvni a posledni interval, protoze to je konecna hranice vrstvy.
% Napr. mam intervaly 1-2-3, dam odstranit obe hranice 2. intervalu.
% Vysledkem bude jeden interval 123. Pokud mi vadi slouceni labelu (chtel
% jsem "odstranit interval vcetne labelu"), mohu
% label jeste pred odstranovanim hranice nastavit na prazdny retezec.
% Pokud chci jen "odstranit interval bez slucovani", tedy obdrzet 1-nic-3,
% nejedna se o odstranovani hranic. Staci pouze nastavit label 2. intervalu
% na prazdny retezec ''.
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
    error(['index of interval out of range, index = ' num2str(index) ', nint = ' num2str(nint)]);
end

if ~isInt(index)
    error(['index must be integer >= 1 [' num2str(index) ']']);
end

if index == 1
    error(['index cannot be 1 because left boundary is the first boundary of the tier. index = ' num2str(index)]);
end

if index == nint
    error(['index cannot be the last interval because right boundary is the last boundary of the tier. index = ' num2str(index)]);
end

t1 = tg.tier{tierInd}.T1(index-1);
t2 = tg.tier{tierInd}.T2(index+1);
lab = [tg.tier{tierInd}.Label{index-1} tg.tier{tierInd}.Label{index} tg.tier{tierInd}.Label{index+1}];

tgNew = tg;
for I = index: nint-2
    tgNew.tier{tierInd}.T1(I) = tgNew.tier{tierInd}.T1(I+2);
    tgNew.tier{tierInd}.T2(I) = tgNew.tier{tierInd}.T2(I+2);
    tgNew.tier{tierInd}.Label{I} = tgNew.tier{tierInd}.Label{I+2};
end

tgNew.tier{tierInd}.T1(end) = [];
tgNew.tier{tierInd}.T2(end) = [];
tgNew.tier{tierInd}.Label(end) = [];
tgNew.tier{tierInd}.T1(end) = [];
tgNew.tier{tierInd}.T2(end) = [];
tgNew.tier{tierInd}.Label(end) = [];

tgNew.tier{tierInd}.T1(index-1) = t1;
tgNew.tier{tierInd}.T2(index-1) = t2;
tgNew.tier{tierInd}.Label{index-1} = lab;

