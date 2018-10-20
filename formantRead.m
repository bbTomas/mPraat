function [f, fid] = formantRead(fileName, encoding)
% function f = formantRead(fileName, encoding)
%
% Reads Formant object from Praat. Supported formats: text file, short text file.
%
% fileName ... file name of Formant object
% encoding ... [optional, default: 'UTF-8'] file encoding, 'auto' for Unicode
%              standard autodetection
%
% Returns: A Formant object represents formants as a function of time.
%   [ref: Praat help, http://www.fon.hum.uva.nl/praat/manual/Formant.html]
%   p.xmin ... start time (seconds)
%   p.xmax ... end time (seconds)
%   p.nx   ... number of frames
%   p.dx   ... time step = frame duration (seconds)
%   p.x1   ... time associated with the first frame (seconds)
%   p.t    ... vector of time instances associated with all frames
%   p.maxnFormants ... maximum number of formants in frame
%   p.frame{1} to p.frame{p.nx} ... frames
%      p.frame{1}.intensity   ... intensity of the frame
%      p.frame{1}.nCandidates ... actual number of formants in this frame
%      p.frame{1}.frequency ... vector of formant frequencies (in Hz)
%      p.frame{1}.bandwidth ... vector of formant bandwidths (in Hz)
%
% Tomas Boril, borilt@gmail.com + Pol van Rijn
%
% Example
%   f = formantRead('demo/maminka.Formant');
%   f
%   f.t(4)      % time instance of the 4th frame
%   f.frame{4}  % 4th frame: formants
%   f.frame{4}.frequency(2)
%   f.frame{4}.bandwidth(2)

f = [];

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
        if ~strcmp(r, 'Object class = "Formant 2"')
            fclose(fid);
            error('Unknown Formant format.')
        end
        
        r = fgetl(fid);  % 3.
        if ~strcmp(r, '')
            fclose(fid);
            error('Unknown Formant format.')
        end
        
        r = fgetl(fid);  % 4.
        if length(r) < 1
            fclose(fid);
            error('Unknown Formant format.')
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
        nx = getNumberInLine(r);   % number of frames
        r = fgetl(fid);  % 7.
        dx = getNumberInLine(r);
        r = fgetl(fid);  % 8.
        x1 = getNumberInLine(r);
        r = fgetl(fid);  % 9.
        maxnFormants = getNumberInLine(r);
        
        frame = cell(1, nx);
        
        r = fgetl(fid);  % 11.
        if isempty(strfind(r, 'frames []: '))
            fclose(fid);
            error('Unknown Formant format.')
        end

        for I = 1: nx
            r = fgetl(fid);
            if isempty(strfind(r, ['    frames [' num2str(I) ']:']))
                fclose(fid);
                error(['Unknown Formant format, wrong frame id (' num2str(I) ').'])
            end
            r = fgetl(fid);
            frame{I}.intensity = getNumberInLine(r);
            r = fgetl(fid);
            frame{I}.nFormants = getNumberInLine(r);
            r = fgetl(fid);
            if isempty(strfind(r, '        formant []: '))
                fclose(fid);
                error('Unknown Formant format.')
            end
            frame{I}.frequency = nan(1, frame{I}.nFormants);
            frame{I}.bandwidth = nan(1, frame{I}.nFormants);
            for If = 1: frame{I}.nFormants
                r = fgetl(fid);
                if isempty(strfind(r, ['            formant [' num2str(If) ']:']))
                    fclose(fid);
                    error(['Unknown Formant format, wrong candidate nr. (' num2str(If) ') in frame id (' num2str(I) ').'])
                end
                r = fgetl(fid);
                frame{I}.frequency(If) = getNumberInLine(r);
                r = fgetl(fid);
                frame{I}.bandwidth(If) = getNumberInLine(r);
            end
        end
        if ~isnumeric(fileName)
            fclose(fid);
        end
        
    else     % shortTextFile
        xmin = str2double(r);
        r = fgetl(fid);  % 5.
        xmax = str2double(r);
        r = fgetl(fid);  % 6.
        nx = str2double(r);   % number of frames
        r = fgetl(fid);  % 7.
        dx = str2double(r);
        r = fgetl(fid);  % 8.
        x1 = str2double(r);
        r = fgetl(fid);  % 9.
        maxnFormants = str2double(r);
        
        frame = cell(1, nx);
        
        for I = 1: nx
            r = fgetl(fid);
            frame{I}.intensity = str2double(r);
            r = fgetl(fid);
            frame{I}.nFormants = str2double(r);
            frame{I}.frequency = nan(1, frame{I}.nFormants);
            frame{I}.bandwidth = nan(1, frame{I}.nFormants);
            for If = 1: frame{I}.nFormants
                r = fgetl(fid);
                frame{I}.frequency(If) = str2double(r);
                r = fgetl(fid);
                frame{I}.bandwidth(If) = str2double(r);
            end
        end
        if ~isnumeric(fileName)
            fclose(fid);
        end
    end
    
else   % unknown format
    fclose(fid);
    error('Unknown Formant format.')
end

f.xmin = xmin;
f.xmax = xmax;
f.nx = nx;
f.dx = dx;
f.x1 = x1;
f.t = (0: (nx-1))*dx + x1;
f.maxnFormants = maxnFormants;
f.frame = frame;
