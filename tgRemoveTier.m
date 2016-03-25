function tgNew = tgRemoveTier(tg, tierInd)
% function tgNew = tgRemoveTier(tg, tierInd)
% Odstraní vrstvu (tier) textgridu s daným indexem (1 = první).
% v1.0, Tomáš Boøil, borilt@gmail.com

if nargin ~= 2
    error('Wrong number of arguments.')
end

% if ~isInt(tierInd)
%     error(['index tier musí být celé èíslo od 1 výše [' num2str(tierInd) ']']);
% end
tierInd = tgI(tg, tierInd);

ntiers = tgGetNumberOfTiers(tg);
% if tierInd < 1 || tierInd>ntiers
%     error(['index tier mimo rozsah, tierInd = ' num2str(tierInd) ', ntiers = ' num2str(ntiers)]);
% end

tgNew = tg;

for I = tierInd: ntiers - 1
    tgNew.tier{I} = tgNew.tier{I+1};
end

tgNew.tier(ntiers) = [];
