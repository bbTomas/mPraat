function tgNew = tgRemoveIntervalLeftBoundary(tg, tierInd, index)
% function tgNew = tgRemoveIntervalLeftBoundary(tg, tierInd, index)
% Odstraní levou hranici intervalu s daným indexem z vrstvy (tier) tierInd typu IntervalTier.
% Slouèí se tím dva intervaly do jednoho (spojí se i labely). Nelze použít
% pro první interval, protože to je poèáteèní hranice vrstvy.
% Napø. mám intervaly 1-2-3, dám odstranit levou hranici 2. intervalu.
% Výsledkem budou dva intervaly 12-3. Pokud mi vadí slouèení labelù, mohu
% label ještì pøed odstraòováním hranice nastavit na prázdný øetìzec.
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
    error(['index nesmí být 1, protože to je poèáteèní hranice vrstvy. index = ' num2str(index)]);
end

t1 = tg.tier{tierInd}.T1(index-1);
t2 = tg.tier{tierInd}.T2(index);
lab = [tg.tier{tierInd}.Label{index-1} tg.tier{tierInd}.Label{index}];

tgNew = tg;
for I = index: nint - 1
    tgNew.tier{tierInd}.T1(I) = tgNew.tier{tierInd}.T1(I+1);
    tgNew.tier{tierInd}.T2(I) = tgNew.tier{tierInd}.T2(I+1);
    tgNew.tier{tierInd}.Label{I} = tgNew.tier{tierInd}.Label{I+1};
end

tgNew.tier{tierInd}.T1(end) = [];
tgNew.tier{tierInd}.T2(end) = [];
tgNew.tier{tierInd}.Label(end) = [];

tgNew.tier{tierInd}.T1(index-1) = t1;
tgNew.tier{tierInd}.T2(index-1) = t2;
tgNew.tier{tierInd}.Label{index-1} = lab;

