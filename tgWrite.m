function tgWrite(tgrid, fileNameTextGrid)
% function tgWrite(tgrid, fileNameTextGrid)
% uloží textgrid s libovolným poètem tiers (intervalové i bodové)
% pokud v tier není specifikován .type, je automaticky brána jako
% intervalová (kvùli zpìtné kompatibilitì). Jinak je doporuèováno .type
% uvádìt ('interval' nebo 'point').
% Pokud neobsahuje textgrid .tmin a .tmax, jsou urèeny automaticky jako
% nejkrajnìjší hodnoty ze všech tier.
% Ukládá ve formátu Short text file, UTF-8.
% v1.5 Tomáš Boøil, borilt@gmail.com

% tgrid = readTextGrid('H5a_3_BARA.TextGrid');
% fileNameTextGrid = 'vystup.TextGrid';

nTiers = length(tgrid.tier);  % poèet Tiers

minCasTotal = NaN;
maxCasTotal = NaN;
if isfield(tgrid, 'tmin') && isfield(tgrid, 'tmax')
    minCasTotal = tgrid.tmin;
    maxCasTotal = tgrid.tmax;
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
        nInt = length(tgrid.tier{I}.T1); % poèet intervalù
        if nInt > 0
            minCasTotal = min(tgrid.tier{I}.T1(1), minCasTotal);
            maxCasTotal = max(tgrid.tier{I}.T2(end), maxCasTotal);
        end
    else
        nInt = length(tgrid.tier{I}.T); % poèet intervalù
        if nInt > 0
            minCasTotal = min(tgrid.tier{I}.T(1), minCasTotal);
            maxCasTotal = max(tgrid.tier{I}.T(end), maxCasTotal);
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
fprintf(fid, '%.17f\n', minCasTotal); % nejmenší èas ze všech vrstev
fprintf(fid, '%.17f\n', maxCasTotal); % nejvìtší èas ze všech vrstev
fprintf(fid, '<exists>\n');
fprintf(fid, '%d\n', nTiers);  % poèet Tiers

for N = 1: nTiers
    if tgrid.tier{N}.typInt == true
        fprintf(fid, '"IntervalTier"\n');
        fprintf(fid, ['"' tgrid.tier{N}.name '"\n']);

        nInt = length(tgrid.tier{N}.T1); % poèet intervalù
        if nInt > 0
            fprintf(fid, '%.17f\n', tgrid.tier{N}.T1(1)); % poèáteèní èas tier
            fprintf(fid, '%.17f\n', tgrid.tier{N}.T2(end)); % finální èas tier
            fprintf(fid, '%d\n', nInt);  % poèet intervalù textgrid

            for I = 1: nInt
                fprintf(fid, '%.17f\n', tgrid.tier{N}.T1(I));
                fprintf(fid, '%.17f\n', tgrid.tier{N}.T2(I));
                fprintf(fid, '"%s"\n', tgrid.tier{N}.Label{I});
            end
        else % vytvoøení jednoho prázdného intervalu
            fprintf(fid, '%.17f\n', minCasTotal); % poèáteèní èas tier
            fprintf(fid, '%.17f\n', maxCasTotal); % finální èas tier
            fprintf(fid, '%d\n', 1);  % poèet intervalù textgrid
            fprintf(fid, '%.17f\n', minCasTotal);
            fprintf(fid, '%.17f\n', maxCasTotal);
            fprintf(fid, '""\n');
        end
    else % je to pointTier
        fprintf(fid, '"TextTier"\n');
        fprintf(fid, ['"' tgrid.tier{N}.name '"\n']);

        nInt = length(tgrid.tier{N}.T); % poèet intervalù
        if nInt > 0
            fprintf(fid, '%.17f\n', tgrid.tier{N}.T(1)); % poèáteèní èas tier
            fprintf(fid, '%.17f\n', tgrid.tier{N}.T(end)); % finální èas tier
            fprintf(fid, '%d\n', nInt);  % poèet intervalù textgrid

            for I = 1: nInt
                fprintf(fid, '%.17f\n', tgrid.tier{N}.T(I));
                fprintf(fid, '"%s"\n', tgrid.tier{N}.Label{I});
            end
        else % prázdný pointtier
            fprintf(fid, '%.17f\n', minCasTotal); % poèáteèní èas tier
            fprintf(fid, '%.17f\n', maxCasTotal); % finální èas tier
            fprintf(fid, '0\n');  % poèet intervalù textgrid
        end
    end

end
fclose(fid);

