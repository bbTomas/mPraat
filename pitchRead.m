function [p, fid] = pitchRead(fileName, encoding)
% function p = pitchRead(fileName)
%
% Reads Pitch object from Praat. Supported formats: text file, short text file.
%
% fileName ... file name of Pitch object
% encoding ... [optional, default: 'UTF-8'] file encoding, 'auto' for Unicode
%              standard autodetection
%
% Returns: A Pitch object represents periodicity candidates as a function of time.
%   [ref: Praat help, http://www.fon.hum.uva.nl/praat/manual/Pitch.html]
%   p.xmin ... start time (seconds)
%   p.xmax ... end time (seconds)
%   p.nx   ... number of frames
%   p.dx   ... time step = frame duration (seconds)
%   p.x1   ... time associated with the first frame (seconds)
%   p.t    ... vector of time instances associated with all frames
%   p.ceiling        ... a frequency above which a candidate is considered  voiceless (Hz)
%   p.maxnCandidates ... maximum number of candidates in frame
%   p.frame{1} to p.frame{p.nx} ... frames
%      p.frame{1}.intensity   ... intensity of the frame
%      p.frame{1}.nCandidates ... actual number of candidates in this frame
%      p.frame{1}.frequency ... vector of candidates' frequency (in Hz)
%                               (for a voiced candidate), or 0 (for an unvoiced candidate)
%      p.frame{1}.strength  ... vector of degrees of periodicity of candidates (between 0 and 1)
%
% Tomas Boril, borilt@gmail.com + Pol van Rijn
%
% Example
%   p = pitchRead('demo/sound.Pitch');
%   p
%   p.t(4)      % time instance of the 4th frame
%   p.frame{4}  % 4th frame: pitch candidates
%   p.frame{4}.frequency(2)
%   p.frame{4}.strength(2)

p = [];

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
        if ~strcmp(r, 'Object class = "Pitch 1"')
            fclose(fid);
            error('Unknown Pitch format.')
        end
        
        r = fgetl(fid);  % 3.
        if ~strcmp(r, '')
            fclose(fid);
            error('Unknown Pitch format.')
        end
        
        r = fgetl(fid);  % 4.
        if length(r) < 1
            fclose(fid);
            error('Unknown Pitch format.')
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
        ceiling = getNumberInLine(r);
        r = fgetl(fid);  % 10.
        maxnCandidates = getNumberInLine(r);
        
        frame = cell(1, nx);
        
        r = fgetl(fid);  % 11.
        if isempty(strfind(r, 'frame []: '))
            fclose(fid);
            error('Unknown Pitch format.')
        end

        for I = 1: nx
            r = fgetl(fid);
            if isempty(strfind(r, ['    frame [' num2str(I) ']:']))
                fclose(fid);
                error(['Unknown Pitch format, wrong frame id (' num2str(I) ').'])
            end
            r = fgetl(fid);
            frame{I}.intensity = getNumberInLine(r);
            r = fgetl(fid);
            frame{I}.nCandidates = getNumberInLine(r);
            r = fgetl(fid);
            if isempty(strfind(r, '        candidate []: '))
                fclose(fid);
                error('Unknown Pitch format.')
            end
            frame{I}.frequency = nan(1, frame{I}.nCandidates);
            frame{I}.strength = nan(1, frame{I}.nCandidates);
            for Ic = 1: frame{I}.nCandidates
                r = fgetl(fid);
                if isempty(strfind(r, ['            candidate [' num2str(Ic) ']:']))
                    fclose(fid);
                    error(['Unknown Pitch format, wrong candidate nr. (' num2str(Ic) ') in frame id (' num2str(I) ').'])
                end
                r = fgetl(fid);
                frame{I}.frequency(Ic) = getNumberInLine(r);
                r = fgetl(fid);
                frame{I}.strength(Ic) = getNumberInLine(r);
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
        ceiling = str2double(r);
        r = fgetl(fid);  % 10.
        maxnCandidates = str2double(r);
        
        frame = cell(1, nx);
        
        for I = 1: nx
            r = fgetl(fid);
            frame{I}.intensity = str2double(r);
            r = fgetl(fid);
            frame{I}.nCandidates = str2double(r);
            frame{I}.frequency = nan(1, frame{I}.nCandidates);
            frame{I}.strength = nan(1, frame{I}.nCandidates);
            for Ic = 1: frame{I}.nCandidates
                r = fgetl(fid);
                frame{I}.frequency(Ic) = str2double(r);
                r = fgetl(fid);
                frame{I}.strength(Ic) = str2double(r);
            end
        end
        if ~isnumeric(fileName)
            fclose(fid);
        end
    end
    
else   % unknown format
    fclose(fid);
    error('Unknown Pitch format.')
end

p.xmin = xmin;
p.xmax = xmax;
p.nx = nx;
p.dx = dx;
p.x1 = x1;
p.t = (0: (nx-1))*dx + x1;
p.ceiling = ceiling;
p.maxnCandidates = maxnCandidates;
p.frame = frame;
