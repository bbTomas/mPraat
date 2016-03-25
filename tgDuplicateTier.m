function tgNew = tgDuplicateTier(tg, originalInd, newInd)
% function tgNew = tgDuplicateTier(tg, originalInd, newInd)
% Duplikuje vrstvu (tier) textgridu s danym indexem originalInd (1 = prvni) na pozici noveho indexu.
% Puvodni vrstvy od pozice newInd vyse posune o jednu dal.
% Po duplikaci doporucujeme zavolat funkci tgSetTierName a nove vrstve
% zmenit jmeno, i kdyz to neni nutne, protoze dve vrstvy se mohou jmenovat stejne.
% v1.0, Tomas Boril, borilt@gmail.com

if nargin ~= 3
    error('Wrong number of arguments.')
end

% if ~isInt(originalInd)
%     error(['index tier musi byt cele cislo od 1 vyse [' num2str(originalInd) ']']);
% end
originalInd = tgI(tg, originalInd);
if ~isInt(newInd)
    error(['index tier must be integer >= 1 [' num2str(newInd) ']']);
end

ntiers = tgGetNumberOfTiers(tg);
% if originalInd < 1 || originalInd>ntiers
%     error(['index tier mimo rozsah, originalInd = ' num2str(originalInd) ', ntiers = ' num2str(ntiers)]);
% end
if newInd < 1 || newInd>ntiers+1
    error(['index of tier out of range <1; ntiers+1>, newInd = ' num2str(newInd) ', ntiers = ' num2str(ntiers)]);
end

tgNew = tg;

tOrig = tg.tier{originalInd};

for I = ntiers + 1: -1: newInd+1
    tgNew.tier{I} = tgNew.tier{I-1};
end

tgNew.tier{newInd} = tOrig;
