function collection = colRead(fileName, encoding)
% function collection = colRead(fileName, encoding)
%
% Loads Collection from Praat in Text or Short text format.
% Collection may contain combination of TextGrids, PitchTiers and Pitch objects.
%
% Author: Pol van Rijn + Tomas Boril, borilt@gmail.com
%
% Example
%   coll = colRead('demo/textgrid+pitchtier.Collection');
%   length(coll)
%   coll{1}
%   coll{2}
%   coll{2}.tier{2}
%   coll{2}.tier{2}.Label{4}
%   tgPlot(coll{2}, 2)
%   subplot(tgGetNumberOfTiers(coll{2})+1, 1, 1);
%   ptPlot(coll{1});

if nargin < 2
    encoding = 'UTF-8';
end
if strcmp(encoding, 'auto')
    encoding = tgDetectEncoding(fileName);
end
    
[fid, message] = fopen(fileName, 'r', 'n', encoding);
if fid == -1
    error(['cannot open file [' fileName ']: ' message]);
end

for I = 1: 3
    r = fgetl(fid);
    if I == 2
        if isempty(strfind(r, '"Collection"'))
            error('This is not a Collection file!')
        end
    end
end

r = fgetl(fid);
if ~isempty(strfind(r, 'size = '))
    shortFormat = false;
else
    shortFormat = true;
end
nobjects = getNumberInLine(r, shortFormat); % Read the size, remove eventual spaces
collection = cell(1, nobjects);
if ~shortFormat
    fgetl(fid); % ignore "item []: "
end
for s = 1:nobjects
    if ~shortFormat
        fgetl(fid); % discard item [1]:
    end
    r = fgetl(fid);
    if ~isempty(strfind(r, 'TextGrid'))
        class = 'TextGrid';
    elseif ~isempty(strfind(r, 'PitchTier'))
        class = 'PitchTier';
    elseif ~isempty(strfind(r, 'Pitch 1'))
        class = 'Pitch 1';
    elseif ~isempty(strfind(r, 'Sound'))
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
        case 'Pitch 1'
            [object, fid] = pitchRead(fid);
    end % end switch case
    object.type = class;
    object.name = name;
    collection{s} = object;
end % end for loop
fclose(fid);
