function c = tgGetNumberOfIntervals(tg, tierInd)
% function c = tgGetNumberOfIntervals(tg, tierInd)
% Vrátí poèet intervalù v dané vrstvì (tier) typu IntervalTier.
% v1.0, Tomáš Boøil, borilt@gmail.com

if nargin ~= 2
    error('nesprávný poèet argumentù')
end

% if ~isInt(tierInd)
%     error(['index tier musí být celé èíslo od 1 výše [' num2str(tierInd) ']']);
% end
tierInd = tgI(tg, tierInd);
% ntiers = tgGetNumberOfTiers(tg);

% if tierInd < 1 || tierInd > ntiers
%     error(['index tier mimo rozsah, tierInd = ' num2str(tierInd) ', ntiers = ' num2str(ntiers)]);
% end

if ~tgIsIntervalTier(tg, tierInd)
    error(['tier ' num2str(tierInd) ' není IntervalTier']);
end

c = length(tg.tier{tierInd}.T1);