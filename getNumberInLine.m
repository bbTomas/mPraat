function number = getNumberInLine(str, shortFormat)
% Author: Pol van Rijn

if nargin < 2
    shortFormat = false;
end

if shortFormat == 0
    numberIndex = strfind(str, ' = ') + 3; % 3 because numel(' = ') == 3
    number = str2double(str(numberIndex:end));
else
    number = str2double(str);
end

end
