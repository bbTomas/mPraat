function c = tgCountLabels(tg, tierInd, label)
% function c = tgCountLabels(tg, tierInd, label)
% Vrátí poèet labelù v dané vrstvì (tier), které se rovnají požadovanému øetìzci.
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

c = 0; % poèet

for I = 1: length(tg.tier{tierInd}.Label)
    if strcmp(tg.tier{tierInd}.Label{I}, label) == 1
        c = c + 1;
    end
end