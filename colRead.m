function collection = colRead(fileName, encoding)
% function collection = colRead(fileName, encoding)
%
% Loads Collection from Praat in Text or Short text format.
% Collection may contain combination of TextGrids, PitchTiers, Pitch and Formant objects, and IntensityTiers.
%
% fileName ... Input file name
% encoding ... File encoding (default: 'UTF-8'), 'auto' for auto-detect of Unicode encoding
%
% Author: Pol van Rijn + Tomas Boril, borilt@gmail.com
%
% Example
%   coll = colRead('demo/coll_text.Collection');
%   length(coll)  % number of objects in collection
%   coll{1}.type  % 1st object type
%   coll{1}.name  % 1st object name
%   it = coll{1}; % 1st object
%   itPlot(it)
%
%   coll{2}.type  % 2nd object type
%   coll{2}.name  % 2nd object name
%   tg = coll{2}; % 2nd object
%   tgPlot(tg)
%   length(tg.tier)  % number of tiers in TextGrid
%   tg.tier{tgI(tg, 'word')}.Label
%
%   coll{3}.type  % 3rd object type
%   coll{3}.name  % 3rd object name
%   pitch = coll{3}; % 3rd object
%   pitch.nx         % number of frames
%   pitch.t(4)       % time instance of the 4th frame
%   pitch.frame{4}   % 4th frame: pitch candidates
%   pitch.frame{4}.frequency(2)
%   pitch.frame{4}.strength(2)
%
%   coll{4}.type  % 4th object type
%   coll{4}.name  % 4th object name
%   pt = coll{4}; % 4th object
%   ptPlot(pt)
%
%   coll{5}.type  % 5th object type
%   coll{5}.name  % 5th object name
%   formant = coll{5}; % 5th object
%   formant.nx         % number of frames
%   formant.t(4)       % time instance of the 4th frame
%   formant.frame{4}   % 4th frame: formants
%   formant.frame{4}.frequency(2)
%   formant.frame{4}.bandwidth(2)
%
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
    elseif ~isempty(strfind(r, 'IntensityTier'))
        class = 'IntensityTier';
    elseif ~isempty(strfind(r, 'Pitch 1'))
        class = 'Pitch 1';
    elseif ~isempty(strfind(r, 'Formant 2'))
        class = 'Formant 2';
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
        case 'IntensityTier'
            [object, fid] = itRead(fid);
        case 'Pitch 1'
            [object, fid] = pitchRead(fid);
        case 'Formant 2'
            [object, fid] = formantRead(fid);
    end % end switch case
    object.type = class;
    object.name = name;
    collection{s} = object;
end % end for loop
fclose(fid);
