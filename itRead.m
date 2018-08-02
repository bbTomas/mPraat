function [it, fid] = itRead(fileName, encoding)
% function it = itRead(fileName)
%
% Reads IntensityTier from Praat. Supported formats: text file, short text file.
%
% fileName ... file name of IntensityTier
% encoding ... [optional, default: 'UTF-8'] file encoding, 'auto' for Unicode
%              standard autodetection
%
% Tomas Boril, borilt@gmail.com
%
% Example
%   it = itRead('demo/maminka.IntensityTier');
%   itPlot(it);


it = [];

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

if strcmp(r, 'File type = "ooTextFile"')  % TextFile or shortTextFile
    if ~isnumeric(fileName)
        r = fgetl(fid);  % 2.
        if ~strcmp(r, 'Object class = "IntensityTier"')
            fclose(fid);
            error('Unknown IntensityTier format.')
        end
        
        r = fgetl(fid);  % 3.
        if ~strcmp(r, '')
            fclose(fid);
            error('Unknown IntensityTier format.')
        end
        
        r = fgetl(fid);  % 4.
        if length(r) < 1
            fclose(fid);
            error('Unknown IntensityTier format.')
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
        i = NaN*ones(1, N);
        
        for I = 1: N
            r = fgetl(fid);  % 7 + (I-1)*3
            r = fgetl(fid);  % 8 + (I-1)*3
%             t(I) = str2double(r(14:end));
            t(I) = getNumberInLine(r);
            r = fgetl(fid);  % 9 + (I-1)*3
            i(I) = getNumberInLine(r);
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
        i = NaN*ones(1, N);
        
        for I = 1: N
            r = fgetl(fid);  % 7 + (I-1)*2
            t(I) = str2double(r);
            r = fgetl(fid);  % 8 + (I-1)*2
            i(I) = str2double(r);
        end
        if ~isnumeric(fileName)
            fclose(fid);
        end
    end
    
else
    error('Unknown IntensityTier format.')
end

it.t = t;
it.i = i;
it.tmin = xmin;
it.tmax = xmax;
