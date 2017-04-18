function tgNew = tgDuplicateTier(tg, originalInd, newInd, newTierName)
% function tgNew = tgDuplicateTier(tg, originalInd, newInd, newTierName)
%
% Duplicates tier originalInd to new tier with specified index newInd
% (existing tiers are shifted).
% It is highly recommended to set a name to the new tier (this can also be done
% later by tg.setTierName). Otherwise, both original and new tiers have the
% same name which is permitted but not recommended. In such a case, we
% cannot use the comfort of using tier name instead of its index in other
% functions.
% 
% tg ... TextGrid object
% originalInd ... tier index or 'name'
% newInd ... [optional] new tier index (1 = the first, Inf = the last [default])
% newTierName ... [optional but recommended] name of the new tier
%
% v1.0, Tomas Boril, borilt@gmail.com
%
%   tg = tgRead('demo/H.TextGrid');
%   tg2 = tgDuplicateTier(tg, 'word', 1, 'NEW');
%   tg2 = tgDuplicateTier(tg2, 'word', Inf, 'NEW');
%   tgPlot(tg2);



if nargin < 2 ||  nargin > 4
    error('Wrong number of arguments.')
end

ntiers = tgGetNumberOfTiers(tg);

if nargin == 2
    newInd = Inf;
end

if isinf(newInd)
    if newInd > 0
        newInd = ntiers+1;
    else
        error('newInd must be integer >= 1 or +Inf')
    end
end

originalInd = tgI(tg, originalInd);
if nargin == 2 || nargin == 3
    newTierName = tg.tier{originalInd}.name;
end


if ~isInt(newInd)
    error(['newInd must be integer >= 1 or +Inf [' num2str(newInd) ']']);
end

if newInd < 1 || newInd>ntiers+1
    error(['newInd out of range [1; ntiers+1], newInd = ' num2str(newInd) ', ntiers = ' num2str(ntiers)]);
end

for I = 1: ntiers
    if strcmp(tg.tier{I}.name, newTierName)
        warning(['TextGrid has a duplicate tier name [', newTierName, ']. You should not use the name for indexing to avoid ambiguity.']);
    end
end

tgNew = tg;

tOrig = tg.tier{originalInd};

for I = ntiers + 1: -1: newInd+1
    tgNew.tier{I} = tgNew.tier{I-1};
end

tgNew.tier{newInd} = tOrig;
tgNew.tier{newInd}.name = newTierName;
