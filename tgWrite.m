function tgWrite(tgrid, fileNameTextGrid, fileFormat)
% function tgWrite(tgrid, fileNameTextGrid, fileFormat)
%
% Saves TextGrid to the file. TextGrid may contain both interval and point
% tiers (.tier{1}, .tier{2}, etc.). If tier type is not specified in .type,
% is is assumed to be interval. If specified, .type have to be 'interval' or 'point'.
% If there is no .tmin and .tmax, they are calculated as min and max of
% all tiers. The file is saved in Short text file, UTF-8 format.
% v1.6 Tomas Boril, borilt@gmail.com
%
% tgrid            ... TextGrid object
% fileNameTextGrid ... output file name
% fileFormat       ... [optional] output file format: 'short' (default, short text format)
%                                                  or 'text' (a.k.a. full text format)
% 
% Example
%   tg = tgRead('demo/H.TextGrid');
%   tgPlot(tg);
%   tgWrite(tg, 'demo/ex_output.TextGrid');

if nargin < 2 || nargin > 3
    error('Wrong number of arguments.')
end

if nargin == 2
    fileFormat = 'short'; 
end

if ~strcmp(fileFormat, 'short') && ~strcmp(fileFormat, 'text')
    error('Unsupported format (supported: ''short'' [default], ''text'')')
end

nTiers = length(tgrid.tier);  % number of Tiers

minTimeTotal = NaN;
maxTimeTotal = NaN;
if isfield(tgrid, 'tmin') && isfield(tgrid, 'tmax')
    minTimeTotal = tgrid.tmin;
    maxTimeTotal = tgrid.tmax;
end

for I = 1: nTiers
    if isfield(tgrid.tier{I}, 'type')
        if strcmp(tgrid.tier{I}.type, 'interval') == 1
            typInt = true;
        elseif strcmp(tgrid.tier{I}.type, 'point') == 1
            typInt = false;
        else
            error(['unknown tier type [' tgrid.tier{I}.type ']']);
        end
    else
        typInt = true;
    end
    tgrid.tier{I}.typInt = typInt;
    
    if typInt == true
        nInt = length(tgrid.tier{I}.T1); % number of intervals
        if nInt > 0
            minTimeTotal = min(tgrid.tier{I}.T1(1), minTimeTotal);
            maxTimeTotal = max(tgrid.tier{I}.T2(end), maxTimeTotal);
        end
    else
        nInt = length(tgrid.tier{I}.T); % number of points
        if nInt > 0
            minTimeTotal = min(tgrid.tier{I}.T(1), minTimeTotal);
            maxTimeTotal = max(tgrid.tier{I}.T(end), maxTimeTotal);
        end
    end
end

[fid, message] = fopen(fileNameTextGrid, 'w', 'ieee-be', 'UTF-8');
if fid == -1
    error(['cannot open file [' fileNameTextGrid ']: ' message]);
end

fprintf(fid, 'File type = "ooTextFile"\n');
fprintf(fid, 'Object class = "TextGrid"\n');
fprintf(fid, '\n');
if strcmp(fileFormat, 'short')
    fprintf(fid, '%.15f\n', minTimeTotal); 
    fprintf(fid, '%.15f\n', maxTimeTotal); 
    fprintf(fid, '<exists>\n');
    fprintf(fid, '%d\n', nTiers); 
elseif strcmp(fileFormat, 'text')
    fprintf(fid, 'xmin = %.15f \n', minTimeTotal); 
    fprintf(fid, 'xmax = %.15f \n', maxTimeTotal); 
    fprintf(fid, 'tiers? <exists> \n');
    fprintf(fid, 'size = %d \n', nTiers);
    fprintf(fid, 'item []: \n');
end

for N = 1: nTiers
    if strcmp(fileFormat, 'text')
        fprintf(fid, '    item [%d]:\n', N);
    end
    
    if tgrid.tier{N}.typInt == true
        if strcmp(fileFormat, 'short')
            fprintf(fid, '"IntervalTier"\n');
            fprintf(fid, ['"' tgrid.tier{N}.name '"\n']);
        elseif strcmp(fileFormat, 'text')
            fprintf(fid, '        class = "IntervalTier" \n');
            fprintf(fid, ['        name = "' tgrid.tier{N}.name '" \n']);
        end

        nInt = length(tgrid.tier{N}.T1); % number of intervals
        if nInt > 0
            if strcmp(fileFormat, 'short')
                fprintf(fid, '%.15f\n', tgrid.tier{N}.T1(1)); % start time of tier
                fprintf(fid, '%.15f\n', tgrid.tier{N}.T2(end)); % end time of tier
                fprintf(fid, '%d\n', nInt);  % number of intervals
            elseif strcmp(fileFormat, 'text')
                fprintf(fid, '        xmin = %.15f \n', tgrid.tier{N}.T1(1)); % start time of tier
                fprintf(fid, '        xmax = %.15f \n', tgrid.tier{N}.T2(end)); % end time of tier
                fprintf(fid, '        intervals: size = %d \n', nInt);  % number of intervals
            end

            for I = 1: nInt
                if strcmp(fileFormat, 'short')
                    fprintf(fid, '%.15f\n', tgrid.tier{N}.T1(I));
                    fprintf(fid, '%.15f\n', tgrid.tier{N}.T2(I));
                    fprintf(fid, '"%s"\n', tgrid.tier{N}.Label{I});
                elseif strcmp(fileFormat, 'text')
                    fprintf(fid, '        intervals [%d]:\n', I);  % number of intervals
                    fprintf(fid, '            xmin = %.15f \n', tgrid.tier{N}.T1(I));
                    fprintf(fid, '            xmax = %.15f \n', tgrid.tier{N}.T2(I));
                    fprintf(fid, '            text = "%s" \n', tgrid.tier{N}.Label{I});
                end
            end
        else % one empty interval only
            if strcmp(fileFormat, 'short')
                fprintf(fid, '%.15f\n', minTimeTotal); % start time of tier
                fprintf(fid, '%.15f\n', maxTimeTotal); % end time of tier
                fprintf(fid, '%d\n', 1);  % number of intervals
                fprintf(fid, '%.15f\n', minTimeTotal);
                fprintf(fid, '%.15f\n', maxTimeTotal);
                fprintf(fid, '""\n');
            elseif strcmp(fileFormat, 'text')
                fprintf(fid, '        xmin = %.15f \n', minTimeTotal); % start time of tier
                fprintf(fid, '        xmax = %.15f \n', maxTimeTotal); % end time of tier
                fprintf(fid, '        intervals: size = 1 \n');  % number of intervals
                fprintf(fid, '        intervals [1]:\n');  % number of intervals
                fprintf(fid, '            xmin = %.15f \n', minTimeTotal);
                fprintf(fid, '            xmax = %.15f \n', maxTimeTotal);
                fprintf(fid, '            text = "" \n');
            end
        end
    else % pointTier
        if strcmp(fileFormat, 'short')
            fprintf(fid, '"TextTier"\n');
            fprintf(fid, ['"' tgrid.tier{N}.name '"\n']);
        elseif strcmp(fileFormat, 'text')
            fprintf(fid, '        class = "TextTier" \n');
            fprintf(fid, ['        name = "' tgrid.tier{N}.name '" \n']);
        end

        nInt = length(tgrid.tier{N}.T); % number of points
        if nInt > 0
            if strcmp(fileFormat, 'short')
                fprintf(fid, '%.15f\n', tgrid.tier{N}.T(1)); % start time of tier
                fprintf(fid, '%.15f\n', tgrid.tier{N}.T(end)); % end time of tier
                fprintf(fid, '%d\n', nInt);  % number of points
            elseif strcmp(fileFormat, 'text')
                fprintf(fid, '        xmin = %.15f \n', tgrid.tier{N}.T(1)); % start time of tier
                fprintf(fid, '        xmax = %.15f \n', tgrid.tier{N}.T(end)); % end time of tier
                fprintf(fid, '        points: size = %d \n', nInt);  % number of points
            end

            for I = 1: nInt
                if strcmp(fileFormat, 'short')
                    fprintf(fid, '%.15f\n', tgrid.tier{N}.T(I));
                    fprintf(fid, '"%s"\n', tgrid.tier{N}.Label{I});
                elseif strcmp(fileFormat, 'text')
                    fprintf(fid, '        points [%d]:\n', nInt);
                    fprintf(fid, '            number = %.15f \n', tgrid.tier{N}.T(I));
                    fprintf(fid, '            mark = "%s" \n', tgrid.tier{N}.Label{I});
                end
            end
        else % empty pointtier
            if strcmp(fileFormat, 'short')
                fprintf(fid, '%.15f\n', minTimeTotal); % start time of tier
                fprintf(fid, '%.15f\n', maxTimeTotal); % end time of tier
                fprintf(fid, '0\n');  % number of points
            elseif strcmp(fileFormat, 'text')
                fprintf(fid, '        xmin = %.15f \n', minTimeTotal); % start time of tier
                fprintf(fid, '        xmax = %.15f \n', maxTimeTotal); % end time of tier
                fprintf(fid, '        points: size = 0 \n');  % number of points
            end
        end
    end

end
fclose(fid);

