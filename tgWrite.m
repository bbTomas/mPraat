function tgWrite(tgrid, fileNameTextGrid, type)
% function tgWrite(tgrid, fileNameTextGrid, type)
%
% Saves TextGrid to the file. TextGrid may contain both interval and point
% tiers (.tier{1}, .tier{2}, etc.). If tier type is not specified in .type,
% is is assumed to be interval. If specified, .type have to be 'interval' or 'point'.
% If there is no .tmin and .tmax, they are calculated as min and max of
% all tiers. The file is saved in Short text file, UTF-8 format.
% v1.5 Tomas Boril, borilt@gmail.com
%
% type can be 'collection' or 'long' for the long format. If no parameter
% is used the short format will be used.
%
% Example
%   tg = tgRead('demo/H.TextGrid');
%   tgPlot(tg);
%   tgWrite(tg, 'demo/ex_output.TextGrid');

if nargin < 3
    type = [];
    shortFormat = true;
else
    shortFormat = false;
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

if strcmp(type, 'collection')
    % load old lines from prefix
    for l = 1:numel(tgrid.prefix)
        fprintf(fid, cell2mat([tgrid.prefix{l}, '\n']));
    end
    spacing = '        ';
    fprintf(fid, [spacing, 'xmin = %.17f\n'], minTimeTotal);
    fprintf(fid, [spacing, 'xmax = %.17f\n'], maxTimeTotal);
    fprintf(fid, [spacing, 'tiers? <exists>\n']);
    fprintf(fid, [spacing, 'size = %d\n'], nTiers);
    fprintf(fid, [spacing, 'item []:\n'], nTiers);
    spacing = [spacing, '    ']; % increase spacing for next step
    
else
    fprintf(fid, 'File type = "ooTextFile"\n');
    fprintf(fid, 'Object class = "TextGrid"\n');
    fprintf(fid, '\n');
    if shortFormat
        fprintf(fid, '%.17f\n', minTimeTotal);
        fprintf(fid, '%.17f\n', maxTimeTotal);
        fprintf(fid, '<exists>\n');
        fprintf(fid, '%d\n', nTiers);
        spacing = '';
    else
        fprintf(fid, 'xmin = %.17f\n', minTimeTotal);
        fprintf(fid, 'xmax = %.17f\n', maxTimeTotal);
        fprintf(fid, 'tiers? <exists> \n');
        fprintf(fid, 'size = %d\n', nTiers);
        spacing = '    ';
    end
end

for N = 1: nTiers
    if tgrid.tier{N}.typInt == true
        if shortFormat
            fprintf(fid, '"IntervalTier"\n');
            fprintf(fid, ['"' tgrid.tier{N}.name '"\n']);
        else
            fprintf(fid, [spacing, 'item [', num2str(N), ']\n']);
            spacing = [spacing, '    ']; % increase spacing
            fprintf(fid, [spacing, 'class = "IntervalTier"\n']);
            fprintf(fid, [spacing, 'name = "' tgrid.tier{N}.name '"\n']);
        end
        nInt = length(tgrid.tier{N}.T1); % number of intervals
        if nInt > 0
            if shortFormat
                fprintf(fid, '%.17f\n', tgrid.tier{N}.T1(1)); % start time of tier
                fprintf(fid, '%.17f\n', tgrid.tier{N}.T2(end)); % end time of tier
                fprintf(fid, '%d\n', nInt);  % number of intervals
            else
                fprintf(fid, [spacing, 'xmin = %.17f\n'], tgrid.tier{N}.T1(1)); % start time of tier
                fprintf(fid, [spacing, 'xmax = %.17f\n'], tgrid.tier{N}.T2(end)); % end time of tier
                fprintf(fid, [spacing, 'intervals: size = %d\n'], nInt);  % number of intervals
            end
            for I = 1: nInt
                if shortFormat
                    fprintf(fid, '%.17f\n', tgrid.tier{N}.T1(I));
                    fprintf(fid, '%.17f\n', tgrid.tier{N}.T2(I));
                    fprintf(fid, '"%s"\n', tgrid.tier{N}.Label{I});
                else
                    fprintf(fid, [spacing, 'intervals [', num2str(I), ']\n']);
                    spacing = [spacing, '    ']; % increase spacing
                    fprintf(fid, [spacing, 'xmin = %.17f\n'], tgrid.tier{N}.T1(I));
                    fprintf(fid, [spacing, 'xmax = %.17f\n'], tgrid.tier{N}.T2(I));
                    fprintf(fid, [spacing, 'text = "%s"\n'], tgrid.tier{N}.Label{I});
                    spacing = spacing(5:end); % decrease spacing for next step
                end
            end
        else % one empty interval only
            % TODO: implement !shortFormat here
            fprintf(fid, '%.17f\n', minTimeTotal); % start time of tier
            fprintf(fid, '%.17f\n', maxTimeTotal); % end time of tier
            fprintf(fid, '%d\n', 1);  % number of intervals
            fprintf(fid, '%.17f\n', minTimeTotal);
            fprintf(fid, '%.17f\n', maxTimeTotal);
            fprintf(fid, '""\n');
        end
    else % pointTier        
        if shortFormat
            fprintf(fid, '"TextTier"\n');
            fprintf(fid, ['"' tgrid.tier{N}.name '"\n']);
        else
            fprintf(fid, [spacing, 'item [', num2str(N), ']\n']);
            spacing = [spacing, '    ']; % increase spacing
            fprintf(fid, [spacing, 'class = "TextTier"\n']);
            fprintf(fid, [spacing, 'name = "' tgrid.tier{N}.name '"\n']);
        end

        nInt = length(tgrid.tier{N}.T); % number of points
        if nInt > 0
            if shortFormat
                fprintf(fid, '%.17f\n', tgrid.tier{N}.T(1)); % start time of tier
                fprintf(fid, '%.17f\n', tgrid.tier{N}.T(end)); % end time of tier
                fprintf(fid, '%d\n', nInt);  % number of points
            else
                fprintf(fid, [spacing, 'xmin = %.17f\n'], tgrid.tier{N}.T(1)); % start time of tier
                fprintf(fid, [spacing, 'xmax = %.17f\n'], tgrid.tier{N}.T(end)); % end time of tier
                fprintf(fid, [spacing, 'points: size = %d\n'], nInt);  % number of intervals
            end
            
            for I = 1: nInt
                if shortFormat
                    fprintf(fid, '%.17f\n', tgrid.tier{N}.T(I));
                    fprintf(fid, '"%s"\n', tgrid.tier{N}.Label{I});
                else
                    fprintf(fid, [spacing, 'points [', num2str(I), ']\n']);
                    spacing = [spacing, '    ']; % increase spacing
                    fprintf(fid, [spacing, 'number = %.17f\n'], tgrid.tier{N}.T(I));
                    fprintf(fid, [spacing, 'mark = "%s"\n'], tgrid.tier{N}.Label{I});
                    spacing = spacing(5:end); % decrease spacing for next step
                end
            end
        else % empty pointtier
            % TODO: implement !shortFormat here
            fprintf(fid, '%.17f\n', minTimeTotal); % start time of tier
            fprintf(fid, '%.17f\n', maxTimeTotal); % end time of tier
            fprintf(fid, '0\n');  % number of points
        end
    end
    spacing = spacing(5:end); % decrease spacing for next Tier
end

fclose(fid);