function text = getTextInQuotes(str)
    text = regexp(str, '".+?"', 'match'); % find quoted text
    text = strrep(text, '"', ''); % remove quotes
    text = text{1}; % remove cell around string
end
