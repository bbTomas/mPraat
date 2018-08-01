function text = getTextInQuotes(str)
% Author: Pol van Rijn
% ".+?" -> ".*?"  by Tomas Boril

    text = regexp(str, '".*?"', 'match'); % find quoted text
    text = strrep(text, '"', ''); % remove quotes
    text = text{1}; % remove cell around string
end
