function itWrite(it, fileNameIntensityTier, fileFormat)
% function ptWrite(it, fileNameIntensityTier, fileFormat)
%
% Saves IntensityTier to file.
% it is struct with at least 't' and 'i' fields (one dimensional matrices
% of the same length). If there are no 'tmin' and 'tmax' fields, there are
% set as min and max of 't' field.
% 
% it                    ... IntensityTier object
% fileNameIntensityTier ... file name to be created
% fileFormat            ... [optional] output file format:
%                           'short' (short text format) (default), 
%                           'text' (a.k.a. full text format),
%
% v1.1, Tomas Boril, borilt@gmail.com
%
% Example
%   it = itRead('demo/maminka.IntensityTier');
%   itPlot(it); xlabel('Time (sec)'); ylabel('Intensity (dB)');
%   itWrite(it, 'demo/intensity.PitchTier')

if nargin < 2 || nargin > 3
    error('Wrong number of arguments.')
end

if nargin == 2
    fileFormat = 'short'; 
end

if ~strcmp(fileFormat, 'short') && ~strcmp(fileFormat, 'text')
    error('Unsupported format (supported: ''short'' [default], ''text'')')
end


if ~isfield(it, 't') || ~isfield(it, 'i')
    error('it must be a structure with fields ''t'' and ''i'' and optionally ''tmin'' and ''tmax''')
end

if length(it.t) ~= length(it.i)
    error('t and i lengths mismatched.')
end
    
N = length(it.t);

if ~isfield(it, 'tmin')
    xmin = min(it.t);
else
    xmin = it.tmin;
end

if ~isfield(it, 'tmax')
    xmax = max(it.t);
else
    xmax = it.tmax;
end


[fid, message] = fopen(fileNameIntensityTier, 'w', 'ieee-be', 'UTF-8');
if fid == -1
    error(['cannot open file [' fileNameIntensityTier ']: ' message]);
end

if strcmp(fileFormat, 'short')  ||  strcmp(fileFormat, 'text')
    fprintf(fid, 'File type = "ooTextFile"\n');
    fprintf(fid, 'Object class = "IntensityTier"\n');
    fprintf(fid, '\n');
end

if strcmp(fileFormat, 'short')
    fprintf(fid, '%.15f\n', xmin);
    fprintf(fid, '%.15f\n', xmax);
    fprintf(fid, '%d\n', N);
elseif strcmp(fileFormat, 'text')
    fprintf(fid, 'xmin = %.15f\n', xmin);
    fprintf(fid, 'xmax = %.15f\n', xmax);
    fprintf(fid, 'points: size = %d\n', N);
end
    
for n = 1: N
    if strcmp(fileFormat, 'short')
        fprintf(fid, '%.15f\n', it.t(n));
        fprintf(fid, '%.15f\n', it.i(n));
    elseif strcmp(fileFormat, 'text')
        fprintf(fid, 'points [%d]:\n', n);
        fprintf(fid, '    number = %.15f \n', it.t(n));
        fprintf(fid, '    value = %.15f \n', it.i(n));
    end
end

fclose(fid);
