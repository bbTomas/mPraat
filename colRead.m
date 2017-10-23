function collection = colRead(fileName, encoding)
% function textgrid = tgRead(fileName)
%
% Loads TextGrid from Praat in Text or Short text format (UTF-8),
% it handles both Interval and Point tiers.
% Labels can may contain quotation marks and new lines.
% v1.5, Tomas Boril, borilt@gmail.com
%
% Example
%   tg = tgRead('demo/H.TextGrid');
%   tgPlot(tg);

collection = [];
if nargin < 2
    encoding = tgDetectEncoding(fileName);
end
if strcmp(encoding, 'UTF-8') == 0 && strcmp(encoding, 'UTF-16BE') == 0 && strcmp(encoding, 'UTF-16LE') == 0
    error(['Unknown encoding: ', encoding]);
end
[fid, message] = fopen(fileName, 'r', 'n', encoding);
if fid == -1
    error(['cannot open file [' fileName ']: ' message]);
end

for I = 1: 3
    r = fgetl(fid); % ignore
    if I == 2
        if contains(r, '"Collection"') == 0
            error('This is not a Collection file!!')
        end
    end
end

size = getNumberInLine(fgetl(fid)); % Read the size, remove eventual spaces
fgetl(fid); % ignore "item []: "
for s = 1:size
    fgetl(fid); % discard item [1]:
    r = fgetl(fid);
    if contains(r, 'TextGrid')
        class = 'TextGrid';
    elseif contains(r, 'PitchTier')
        class = 'PitchTier';
    elseif contains(r, 'Pitch 1')
        class = 'Pitch';
    elseif contains(r, 'Sound')
        error(['Sound files are currently not supported, because of their inefficient loading and saving duration, rather use WAVE files'])
    else
        error(['Class not recognized! Line: ', r]);
    end
    name = getTextInQuotes(fgetl(fid));
    switch class
        case 'TextGrid'
            [object, fid] = tgRead(fid);
        case 'PitchTier'
            [object, fid] = ptRead(fid);
        case 'Pitch'
            [object, fid] = pitchRead(fid);
    end % end switch case
    object.type = class;
    collection = [collection, {object}];
end % end for loop
fclose(fid);
