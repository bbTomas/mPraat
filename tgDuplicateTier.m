function tgNew = tgDuplicateTier(tg, originalInd, newInd)
% function tgNew = tgDuplicateTier(tg, originalInd, newInd)
% Duplikuje vrstvu (tier) textgridu s daným indexem originalInd (1 = první) na pozici nového indexu.
% Pùvodní vrstvy od pozice newInd výše posune o jednu dál.
% Po duplikaci doporuèujeme zavolat funkci tgSetTierName a nové vrstvì
% zmìnit jméno, i když to není nutné, protože dvì vrstvy se mohou jmenovat stejnì.
% v1.0, Tomáš Boøil, borilt@gmail.com

if nargin ~= 3
    error('nesprávný poèet argumentù')
end

% if ~isInt(originalInd)
%     error(['index tier musí být celé èíslo od 1 výše [' num2str(originalInd) ']']);
% end
originalInd = tgI(tg, originalInd);
if ~isInt(newInd)
    error(['index tier musí být celé èíslo od 1 výše [' num2str(newInd) ']']);
end

ntiers = tgGetNumberOfTiers(tg);
% if originalInd < 1 || originalInd>ntiers
%     error(['index tier mimo rozsah, originalInd = ' num2str(originalInd) ', ntiers = ' num2str(ntiers)]);
% end
if newInd < 1 || newInd>ntiers+1
    error(['index tier mimo rozsah <1; ntiers+1>, newInd = ' num2str(newInd) ', ntiers = ' num2str(ntiers)]);
end

tgNew = tg;

tOrig = tg.tier{originalInd};

for I = ntiers + 1: -1: newInd+1
    tgNew.tier{I} = tgNew.tier{I-1};
end

tgNew.tier{newInd} = tOrig;
