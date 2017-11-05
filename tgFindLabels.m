function res = tgFindLabels(tg, tierInd, labels, returnTime)
% function res = tgFindLabels(tg, tierInd, labels, returnTime)
%
% Find label or consecutive sequence of labels and returns their indices.
%
% If returnTime == false (or not specified), returns cell-array with vectors of all occurrences,
% each cell-array member is one occurence and contains vector of label indices.
% If returnTime == true, returns structure with vectors containing T1 (begin) and T2 (end) time
% for each found group of sequence of labels.
%
% tg         ... TextGrid object
% tierInd    ... tier index or 'name'
% labels     ... label or cell-array of labels (consecutive sequence of labels) to be found
% returnTime ... [optional, default == false] If true, return begin and end time for each found group of sequence of labels.
%                                             If false, return indices of labels.
% 
% v1.0, Tomas Boril, borilt@gmail.com
%
% Example
%   tg = tgRead('demo/H_plain.TextGrid');
%   i = tgFindLabels(tg, 'phoneme', 'n')
%   length(i)
%   i{1}
%   tg.tier{tgI(tg, 'phoneme')}.Label{i{1}}
%   tg.tier{tgI(tg, 'phoneme')}.Label(cell2mat(i))
%
%   i = tgFindLabels(tg, 'phone', {'?', 'a'})
%   length(i)
%   i{1}
%   length(i{1})
%   i{1}(2)
%   tg.tier{tgI(tg, 'phone')}.Label{i{1}(2)}
%   i{2}
%   tg.tier{tgI(tg, 'phone')}.Label(i{1})
%   tg.tier{tgI(tg, 'phone')}.Label(i{2})
%   tg.tier{tgI(tg, 'phone')}.Label(cell2mat(i))
%
%   t = tgFindLabels(tg, 'phone', {'?', 'a'}, true)
%   t.T2(1) - t.T1(1)    % duration of the first result
%   t.T2(2) - t.T1(2)    % duration of the second result
%   t.T2 - t.T1          % durations of all results
%
%   i = tgFindLabels(tg, 'word', {'ti', 'reknu', 'co'})
%   length(i)
%   i{1}
%   length(i{1})
%   i{1}(2)
%   tg.tier{tgI(tg, 'word')}.Label{i{1}(2)}
%   tg.tier{tgI(tg, 'word')}.Label(i{1})
%
%   t = tgFindLabels(tg, 'word', {'ti', 'reknu', 'co'}, true)
%   pt = ptRead('demo/H.PitchTier');
%   tStart = t.T1(1)
%   tEnd = t.T2(1)
%   ptPlot(ptCut(pt, tStart, tEnd))

if nargin < 3  || nargin > 4
    error('Wrong number of arguments.')
end

if nargin ~= 4
    returnTime = false;
end

tierInd = tgI(tg, tierInd);

if length(returnTime) ~= 1 || (returnTime ~= true && returnTime ~= false)
    error('returnTime must be a logical value.')
end


if iscell(labels)
    nlabs = length(labels);
elseif ischar(labels)
    nlabs = 1;
else
    error('labels must be a char string or cell-array of char strings.');
end
    

if nlabs < 1
    res = NaN;
    return
elseif nlabs == 1
    indLab = find(strcmp(tg.tier{tierInd}.Label, labels));
    if returnTime == false
        res = num2cell(indLab);
        return
    else
        if tgIsIntervalTier(tg, tierInd)  % IntervalTier
            res.T1 = tg.tier{tierInd}.T1(indLab);
            res.T2 = tg.tier{tierInd}.T2(indLab);
            return
        else                              % PointTier
            res.T1 = tg.tier{tierInd}.T(indLab);
            res.T2 = tg.tier{tierInd}.T(indLab);
            return
        end
    end
else
    indStart = find(strcmp(tg.tier{tierInd}.Label, labels{1}));
    indStart = indStart(indStart <= length(tg.tier{tierInd}.Label) - nlabs + 1);  % pokud zbývá do konce ménì labelù, než hledáme, nemá smysl hledat

    indLab = {};
    
    for I = indStart(:).'
        ok = true;
        for J = 2: nlabs
            if strcmp(tg.tier{tierInd}.Label{I+J-1}, labels{J}) ~= true
                ok = false;
                break
            end
        end
        if ok
            indLab = [indLab, I:(I+nlabs-1)];
        end
    end

    if returnTime == false
        res = indLab;
        return
    else
        if tgIsIntervalTier(tg, tierInd)  % IntervalTier
            t1 = zeros(1, length(indLab));
            t2 = zeros(1, length(indLab));
            for I = 1: length(indLab)
                t1(I) = tg.tier{tierInd}.T1(indLab{I}(1));
                t2(I) = tg.tier{tierInd}.T2(indLab{I}( length(indLab{I}) ));
            end
        else       % PointTier
            t1 = zeros(1, length(indLab));
            t2 = zeros(1, length(indLab));
            for I = 1: length(indLab)
                t1(I) = tg.tier{tierInd}.T(indLab{I}(1));
                t2(I) = tg.tier{tierInd}.T(indLab{I}( length(indLab{I}) ));
            end
        end
        res.T1 = t1;
        res.T2 = t2;
        return
    end

end


