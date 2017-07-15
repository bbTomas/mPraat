function p = pitchRead(fileName)
% function p = pitchRead(fileName)
%
% Reads Pitch object from Praat. Supported formats: text file, short text file.
% 
% fileName ... file name of Pitch object
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
%   p.frame{1} to p.frame{p.nx} frames
%      p.frame{1}.intensity   ... intensity of the frame
%      p.frame{1}.nCandidates ... actual number of candidates in this frame
%      p.frame{1}.frequency ... vector of candidates' frequency (in Hz)
%                               (for a voiced candidate), or 0 (for an unvoiced candidate)
%      p.frame{1}.strength  ... vector of degrees of periodicity of candidates (between 0 and 1)
%
% v1.0, Tomas Boril, borilt@gmail.com
%
% Example
%   p = pitchRead('demo/sound.Pitch');
%   p
%   p.t(4)      % time instance of the 4th frame
%   p.frame{4}  % 4th frame: pitch candidates
%   p.frame{4}.frequency(2)
%   p.frame{4}.strength(2)

p = [];

[fid, message] = fopen(fileName, 'r', 'n', 'UTF-8');
if fid == -1
    error(['cannot open file [' fileName ']: ' message]);
end

r = fgetl(fid);  % 1.
if strcmp(r, 'File type = "ooTextFile"')  % TextFile or shortTextFile
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
    
    if strcmp(r(1), 'x')   % TextFile
        xmin = str2double(r(8:end));
        r = fgetl(fid);  % 5.
        xmax = str2double(r(8:end));
        r = fgetl(fid);  % 6.
        nx = str2double(r(6:end));   % number of frames
        r = fgetl(fid);  % 7.
        dx = str2double(r(6:end));
        r = fgetl(fid);  % 8.
        x1 = str2double(r(6:end));
        r = fgetl(fid);  % 9.
        ceiling = str2double(r(11:end));
        r = fgetl(fid);  % 10.
        maxnCandidates = str2double(r(18:end));
        
        frame = cell(1, nx);
        
        r = fgetl(fid);  % 11.
        if ~strcmp(r, 'frame []: ')
            fclose(fid);
            error('Unknown Pitch format.')
        end

        for I = 1: nx
            r = fgetl(fid);
            if ~strcmp(r, ['    frame [' num2str(I) ']:'])
                fclose(fid);
                error(['Unknown Pitch format, wrong frame id (' num2str(I) ').'])
            end
            r = fgetl(fid);
            frame{I}.intensity = str2double(r(21:end));
            r = fgetl(fid);
            frame{I}.nCandidates = str2double(r(23:end));
            r = fgetl(fid);
            if ~strcmp(r, '        candidate []: ')
                fclose(fid);
                error('Unknown Pitch format.')
            end
            frame{I}.frequency = nan(1, frame{I}.nCandidates);
            frame{I}.strength = nan(1, frame{I}.nCandidates);
            for Ic = 1: frame{I}.nCandidates
                r = fgetl(fid);
                if ~strcmp(r, ['            candidate [' num2str(Ic) ']:'])
                    fclose(fid);
                    error(['Unknown Pitch format, wrong candidate nr. (' num2str(Ic) ') in frame id (' num2str(I) ').'])
                end
                r = fgetl(fid);
                frame{I}.frequency(Ic) = str2double(r(29:end));
                r = fgetl(fid);
                frame{I}.strength(Ic) = str2double(r(28:end));
            end
        end
        fclose(fid);
        
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
        fclose(fid);
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
