function ptWrite(pt, fileNamePitchtier, fileFormat)
% function ptWrite(pt, fileNamePitchtier, fileFormat)
%
% Saves PitchTier to file (spread sheet file format).
% pt is struct with at least 't' and 'f' fields (one dimensional matrices
% of the same length). If there are no 'tmin' and 'tmax' fields, there are
% set as min and max of 't' field.
% 
% pt                ... PitchTier object
% fileNamePitchtier ... file name to be created
% fileFormat        ... [optional] output file format:
%                       'short' (short text format),
%                       'text' (a.k.a. full text format),
%                       'spreadsheet' (default),
%                       'headerless' (not recommended, it does not contain tmin and tmax info))
%
% v1.1, Tomas Boril, borilt@gmail.com
%
% Example
%   pt = ptRead('demo/H.PitchTier');
%   pt.f = 12*log(pt.f/100) / log(2);  % conversion of Hz to Semitones, reference 0 ST = 100 Hz.
%   ptPlot(pt); xlabel('Time (sec)'); ylabel('Frequency (ST)');
%   ptWrite(pt, 'demo/H_st.PitchTier')

if nargin < 2 || nargin > 3
    error('Wrong number of arguments.')
end

if nargin == 2
    fileFormat = 'spreadsheet'; 
end

if ~strcmp(fileFormat, 'short') && ~strcmp(fileFormat, 'text') && ~strcmp(fileFormat, 'spreadsheet') && ~strcmp(fileFormat, 'headerless')
    error('Unsupported format (supported: ''short'', ''text'', ''spreadsheet'' [default], ''headerless'')')
end


if ~isfield(pt, 't') || ~isfield(pt, 'f')
    error('pt must be a structure with fields ''t'' and ''f'' and optionally ''tmin'' and ''tmax''')
end

if length(pt.t) ~= length(pt.f)
    error('t and f lengths mismatched.')
end
    
N = length(pt.t);

if ~isfield(pt, 'tmin')
    xmin = min(pt.t);
else
    xmin = pt.tmin;
end

if ~isfield(pt, 'tmax')
    xmax = max(pt.t);
else
    xmax = pt.tmax;
end


[fid, message] = fopen(fileNamePitchtier, 'w', 'ieee-be', 'UTF-8');
if fid == -1
    error(['cannot open file [' fileNamePitchTier ']: ' message]);
end

if strcmp(fileFormat, 'spreadsheet')
    fprintf(fid, '"ooTextFile"\n');
    fprintf(fid, '"PitchTier"\n');
elseif strcmp(fileFormat, 'short')  ||  strcmp(fileFormat, 'text')
    fprintf(fid, 'File type = "ooTextFile"\n');
    fprintf(fid, 'Object class = "PitchTier"\n');
    fprintf(fid, '\n');
end

if strcmp(fileFormat, 'spreadsheet')
    fprintf(fid, '%.15f %.15f %d\n', xmin, xmax, N);
elseif strcmp(fileFormat, 'short')
    fprintf(fid, '%.15f\n', xmin);
    fprintf(fid, '%.15f\n', xmax);
    fprintf(fid, '%d\n', N);
elseif strcmp(fileFormat, 'text')
    fprintf(fid, 'xmin = %.15f\n', xmin);
    fprintf(fid, 'xmax = %.15f\n', xmax);
    fprintf(fid, 'points: size = %d\n', N);
end
    
for n = 1: N
    if strcmp(fileFormat, 'spreadsheet')  ||  strcmp(fileFormat, 'headerless')
        fprintf(fid, '%.15f\t%.15f\n', pt.t(n), pt.f(n));
    elseif strcmp(fileFormat, 'short')
        fprintf(fid, '%.15f\n', pt.t(n));
        fprintf(fid, '%.15f\n', pt.f(n));
    elseif strcmp(fileFormat, 'text')
        fprintf(fid, 'points [%d]:\n', n);
        fprintf(fid, '    number = %.15f \n', pt.t(n));
        fprintf(fid, '    value = %.15f \n', pt.f(n));
    end
end

fclose(fid);
