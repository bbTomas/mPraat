function number = getNumberInLine(str, shortFormat)
if nargin < 2
    shortFormat = false;
end

if shortFormat == 0
numberIndex = strfind(str, ' = ') + 3; % 3 because numel(' = ') == 3
number = str2num(str(numberIndex:end));
else
    number = str2num(str);
end
end