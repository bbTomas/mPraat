function [pt, fid] = ptRead(fileName, encoding)
% function pt = ptRead(fileName)
%
% Reads PitchTier from Praat. Supported formats: text file, short text file,
% spread sheet, headerless spread sheet (headerless not recommended,
% it does not contain tmin and tmax info).
%
% fileName ... file name of PitchTier
% encoding ... [optional, default: 'UTF-8'] file encoding, 'auto' for Unicode
%              standard autodetection
%
% Tomas Boril, borilt@gmail.com + Pol van Rijn
%
% Example
%   pt = ptRead('demo/H.PitchTier');
%   ptPlot(pt);


pt = [];

if ~isnumeric(fileName)
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
    
    r = fgetl(fid);  % 1.
else
    % encoding is never used
    fid = fileName;
    r = 'File type = "ooTextFile"';
end

if strcmp(r, '"ooTextFile"')    % spreadSheet
    if ~isnumeric(fileName)
        r = fgetl(fid);  % 2.
        if ~strcmp(r, '"PitchTier"')
            fclose(fid);
            error('Unknown PitchTier format.')
        end
        
        r = fgetl(fid);  % 3.
        fromToN = strsplit(r);
        if length(fromToN) ~= 3
            fclose(fid);
            error('Unknown PitchTier format.')
        end
    end
    xmin = str2double(fromToN{1});
    xmax = str2double(fromToN{2});
    N = str2double(fromToN{3});
    t = NaN*ones(1, N);
    f = NaN*ones(1, N);
    
    for I = 1: N
        r = fgetl(fid);
        tf = strsplit(r);
        if length(tf) ~= 2
            fclose(fid);
            error('Unknown PitchTier format.')
        end
        t(I) = str2double(tf{1});
        f(I) = str2double(tf{2});
    end
    
    if ~isnumeric(fileName)
        fclose(fid);
    end
    
elseif strcmp(r, 'File type = "ooTextFile"')  % TextFile or shortTextFile
    if ~isnumeric(fileName)
        r = fgetl(fid);  % 2.
        if ~strcmp(r, 'Object class = "PitchTier"')
            fclose(fid);
            error('Unknown PitchTier format.')
        end
        
        r = fgetl(fid);  % 3.
        if ~strcmp(r, '')
            fclose(fid);
            error('Unknown PitchTier format.')
        end
        
        r = fgetl(fid);  % 4.
        if length(r) < 1
            fclose(fid);
            error('Unknown PitchTier format.')
        end
    else
        % if a collection
        r = fgetl(fid);  % 4
    end
    if ~isempty(strfind(r, 'xmin'))   % TextFile
        xmin = getNumberInLine(r);
        r = fgetl(fid);  % 5.
        xmax = getNumberInLine(r);
        r = fgetl(fid);  % 6.
        N = getNumberInLine(r);
        
        t = NaN*ones(1, N);
        f = NaN*ones(1, N);
        
        for I = 1: N
            r = fgetl(fid);  % 7 + (I-1)*3
            r = fgetl(fid);  % 8 + (I-1)*3
%             t(I) = str2double(r(14:end));
            t(I) = getNumberInLine(r);
            r = fgetl(fid);  % 9 + (I-1)*3
            f(I) = getNumberInLine(r);
%             f(I) = str2double(r(13:end));
        end
        if ~isnumeric(fileName)
            fclose(fid);
        end
    else     % shortTextFile
        xmin = str2double(r);
        r = fgetl(fid);  % 5.
        xmax = str2double(r);
        r = fgetl(fid);  % 6.
        N = str2double(r);
        
        t = NaN*ones(1, N);
        f = NaN*ones(1, N);
        
        for I = 1: N
            r = fgetl(fid);  % 7 + (I-1)*2
            t(I) = str2double(r);
            r = fgetl(fid);  % 8 + (I-1)*2
            f(I) = str2double(r);
        end
        if ~isnumeric(fileName)
            fclose(fid);
        end
    end
    
else   % headerless SpreadSheet
    if ~isnumeric(fileName)
        fclose(fid);
    end
    tab = load(fileName, '-ascii');
    t = tab(:,1).';
    f = tab(:,2).';
    N = length(t);
    
    xmin = min(t);
    xmax = max(t);
end

pt.t = t;
pt.f = f;
pt.tmin = xmin;
pt.tmax = xmax;
