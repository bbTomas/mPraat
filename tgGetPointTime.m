function t = tgGetPointTime(tg, tierInd, index)
% function t = tgGetPointTime(tg, tierInd, index)
% Vr�t� �as bodu s dan�m indexem ve vybran� vrstv� (tier) typu PointTier.
% v1.0, Tom� Bo�il, borilt@gmail.com

if nargin ~= 3
    error('Wrong number of arguments.')
end

% if ~isInt(tierInd)
%     error(['index tier mus� b�t cel� ��slo od 1 v��e [' num2str(tierInd) ']']);
% end
tierInd = tgI(tg, tierInd);

% ntiers = tgGetNumberOfTiers(tg);
% if tierInd < 1 || tierInd>ntiers
%     error(['index tier mimo rozsah, tierInd = ' num2str(tierInd) ', ntiers = ' num2str(ntiers)]);
% end
if ~tgIsPointTier(tg, tierInd)
    error(['tier ' num2str(tierInd) ' is not PointTier']);
end

if ~isInt(index)
    error(['index must by integer >= 1 [' num2str(index) ']']);
end

npoints = tgGetNumberOfPoints(tg, tierInd);
if index < 1 || index>npoints
    error(['indexout of range, index = ' num2str(index) ', npoints = ' num2str(npoints)]);
end


t = tg.tier{tierInd}.T(index);