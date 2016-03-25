function I = tgI(tg, tierIndexOrName)
% function n = tgGetTierName(tg, tierInd)
% Vrátí jméno vrstvy (tier).
% v1.0, Tomáš Boøil, borilt@gmail.com

if nargin ~= 2
    error('nesprávný poèet argumentù')
end


ntiers = length(tg.tier);

if isnumeric(tierIndexOrName) && isequal(size(tierIndexOrName), [1,1])   % je to èíselný index
    if tierIndexOrName >= 1 && tierIndexOrName <= ntiers
        if ~isInt(tierIndexOrName)
            error(['tier index have to be an integer value'])
        end
        
        I = tierIndexOrName;
        return
    else
        error(['tier index out of range, tierInd = ' num2str(tierIndexOrName) ', ntiers = ' num2str(ntiers)])
    end
end


if ischar(tierIndexOrName) && size(tierIndexOrName, 1) == 1
    for J = 1: ntiers
        if strcmp(tg.tier{J}.name, tierIndexOrName) == 1
            I = J;
            return
        end
    end
    
    error(['Tier name not found: [' tierIndexOrName  ']'])
else
    error('Incorrect tierIndexOrName format, it has to be either tier index or tier name.')
end

