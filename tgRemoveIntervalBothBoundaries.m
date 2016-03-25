function tgNew = tgRemoveIntervalBothBoundaries(tg, tierInd, index)
% function tgNew = tgRemoveIntervalBothBoundaries(tg, tierInd, index)
% Odstraní levou i pravou hranici intervalu s daným indexem z vrstvy (tier) tierInd typu IntervalTier.
% Slouèí se tím tøi intervaly do jednoho (spojí se i labely). Nelze použít
% pro první a poslední interval, protože to je koneèná hranice vrstvy.
% Napø. mám intervaly 1-2-3, dám odstranit obì hranice 2. intervalu.
% Výsledkem bude jeden interval 123. Pokud mi vadí slouèení labelù (chtìl
% jsem "odstranit interval vèetnì labelu"), mohu
% label ještì pøed odstraòováním hranice nastavit na prázdný øetìzec.
% Pokud chci jen "odstranit interval bez sluèování", tedy obdržet 1-nic-3,
% nejedná se o odstraòování hranic. Staèí pouze nastavit label 2. intervalu
% na prázdný øetìzec ''.
% v1.0, Tomáš Boøil, borilt@gmail.com

if nargin ~= 3
    error('nesprávný poèet argumentù')
end

% if ~isInt(tierInd)
%     error(['index tier musí být celé èíslo od 1 výše [' num2str(tierInd) ']']);
% end
tierInd = tgI(tg, tierInd);

% ntiers = tgGetNumberOfTiers(tg);
% if tierInd < 1 || tierInd>ntiers
%     error(['index tier mimo rozsah, tierInd = ' num2str(tierInd) ', ntiers = ' num2str(ntiers)]);
% end
if ~tgIsIntervalTier(tg, tierInd)
    error(['tier ' num2str(tierInd) ' není IntervalTier']);
end

nint = tgGetNumberOfIntervals(tg, tierInd);
if index < 1 || index>nint
    error(['index bodu mimo rozsah, index = ' num2str(index) ', nint = ' num2str(nint)]);
end

if ~isInt(index)
    error(['index musí být celé èíslo od 1 výše [' num2str(index) ']']);
end

if index == 1
    error(['index nesmí být 1, protože levá hranice je poèáteèní hranice vrstvy. index = ' num2str(index)]);
end

if index == nint
    error(['index nesmí být posledního intervalu, protože pravá hranice je koneèná hranice vrstvy. index = ' num2str(index)]);
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

