function tgWrite(tgrid, fileNameTextGrid)
% function tgWrite(tgrid, fileNameTextGrid)
% ulozi textgrid s libovolnym poctem tiers (intervalove i bodove)
% pokud v tier neni specifikovan .type, je automaticky brana jako
% intervalova (kvuli zpetne kompatibilite). Jinak je doporucovano .type
% uvadet ('interval' nebo 'point').
% Pokud neobsahuje textgrid .tmin a .tmax, jsou urceny automaticky jako
% nejkrajnejsi hodnoty ze vsech tier.
% Uklada ve formatu Short text file, UTF-8.
% v1.5 Tomas Boril, borilt@gmail.com

% tgrid = readTextGrid('H5a_3_BARA.TextGrid');
% fileNameTextGrid = 'vystup.TextGrid';

nTiers = length(tgrid.tier);  % pocet Tiers

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
        nInt = length(tgrid.tier{I}.T1); % pocet intervalu
        if nInt > 0
            minCasTotal = min(tgrid.tier{I}.T1(1), minCasTotal);
            maxCasTotal = max(tgrid.tier{I}.T2(end), maxCasTotal);
        end
    else
        nInt = length(tgrid.tier{I}.T); % pocet intervalu
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
fprintf(fid, '%.17f\n', minCasTotal); % nejmensi cas ze vsech vrstev
fprintf(fid, '%.17f\n', maxCasTotal); % nejvetsi cas ze vsech vrstev
fprintf(fid, '<exists>\n');
fprintf(fid, '%d\n', nTiers);  % pocet Tiers

for N = 1: nTiers
    if tgrid.tier{N}.typInt == true
        fprintf(fid, '"IntervalTier"\n');
        fprintf(fid, ['"' tgrid.tier{N}.name '"\n']);

        nInt = length(tgrid.tier{N}.T1); % pocet intervalu
        if nInt > 0
            fprintf(fid, '%.17f\n', tgrid.tier{N}.T1(1)); % pocatecni cas tier
            fprintf(fid, '%.17f\n', tgrid.tier{N}.T2(end)); % finalni cas tier
            fprintf(fid, '%d\n', nInt);  % pocet intervalu textgrid

            for I = 1: nInt
                fprintf(fid, '%.17f\n', tgrid.tier{N}.T1(I));
                fprintf(fid, '%.17f\n', tgrid.tier{N}.T2(I));
                fprintf(fid, '"%s"\n', tgrid.tier{N}.Label{I});
            end
        else % vytvoreni jednoho prazdneho intervalu
            fprintf(fid, '%.17f\n', minCasTotal); % pocatecni cas tier
            fprintf(fid, '%.17f\n', maxCasTotal); % finalni cas tier
            fprintf(fid, '%d\n', 1);  % pocet intervalu textgrid
            fprintf(fid, '%.17f\n', minCasTotal);
            fprintf(fid, '%.17f\n', maxCasTotal);
            fprintf(fid, '""\n');
        end
    else % je to pointTier
        fprintf(fid, '"TextTier"\n');
        fprintf(fid, ['"' tgrid.tier{N}.name '"\n']);

        nInt = length(tgrid.tier{N}.T); % pocet intervalu
        if nInt > 0
            fprintf(fid, '%.17f\n', tgrid.tier{N}.T(1)); % pocatecni cas tier
            fprintf(fid, '%.17f\n', tgrid.tier{N}.T(end)); % finalni cas tier
            fprintf(fid, '%d\n', nInt);  % pocet intervalu textgrid

            for I = 1: nInt
                fprintf(fid, '%.17f\n', tgrid.tier{N}.T(I));
                fprintf(fid, '"%s"\n', tgrid.tier{N}.Label{I});
            end
        else % prazdny pointtier
            fprintf(fid, '%.17f\n', minCasTotal); % pocatecni cas tier
            fprintf(fid, '%.17f\n', maxCasTotal); % finalni cas tier
            fprintf(fid, '0\n');  % pocet intervalu textgrid
        end
    end

end
fclose(fid);

