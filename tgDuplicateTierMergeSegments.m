function tgNew = tgDuplicateTierMergeSegments(tg, originalInd, newInd, newTierName, pattern, sep)
% function tgNew = tgDuplicateTierMergeSegments(tg, originalInd, newInd, newTierName, pattern, sep)
%
%  Duplicate tier originalInd and merge segments (according to the pattern) to the new tier with specified index newInd
%  (existing tiers are shifted).
%  Typical use: create new syllable tier from phone tier. It merges phones into syllables according to separators in pattern.
% 
%  Note 1: there can be segments with empty labels in the original tier (pause), do not specify them in the pattern
% 
%  Note 2: if there is an segment with empty label in the original tier in the place of separator in the pattern,
%          the empty segment is duplicated into the new tier, i.e. at the position of the separator, there may or may not be
%          an empty segment, if there is, it is duplicated. And they are not specified in the pattern.
% 
%  Note 3: if the segment with empty label is not at the position corresponding to separator, it leads to error
%          - the part specified in the pattern between separators cannot be split by empty segments
% 
%  Note 4: beware of labels that appear empty but they are not (space, new line character etc.) - these segments are handled
%          as classical non-empty labels. See example - one label is ' ', therefore it must be specified in the pattern.
%
% 
% tg          ... TextGrid object
% originalInd ... tier index or 'name'
% newInd      ... new tier index (1 = the first, Inf = the last)
% newTierName ... name of the new tier
% pattern     ... merge segments pattern for the new tier (e.g., 'he-llo-world')
% sep         ... [optional] separator in pattern (default: '-')
%
% v1.0, Tomas Boril, borilt@gmail.com
%
%   tg = tgRead('demo/H.TextGrid');
%   tg = tgRemoveTier(tg, 5); tg = tgRemoveTier(tg, 4); tg = tgRemoveTier(tg, 3); tg = tgRemoveTier(tg, 1); % get phone tier only
% 
%   % Get actual labels - concatenated (collapsed into one string)
%   % Use horzcat instead of strcat because strcat removes leading white-space chars which is undesirable.
%   collapsed = horzcat(tg.tier{tgI(tg, 'phone')}.Label{:})
% 
%   % Edit the collapsed string with labels - insert separators to mark boundaries of syllables.
% 
%   %  * There can be segments with empty labels in the original tier (pauses), do not specify them in the pattern.
%   %  * Beware of labels that appear empty but they are not (space, new line character etc.) - these segments are handled as classical non-empty labels. See example - one label is " ", therefore it must be specified in the pattern.
% 
%   pattern = 'ja:-ci-P\ek-nu-t_so-?u-J\e-la:S- -nej-dP\i:f-naj-deZ-h\ut_S-ku-?a-?a-ta-ma-na:'
%   tg2 = tgDuplicateTierMergeSegments(tg, 'phone', 1, 'syll', pattern, '-');
%   tgPlot(tg2);




if nargin < 5 ||  nargin > 6
    error('Wrong number of arguments.')
end

originalInd = tgI(tg, originalInd);

if ~tgIsIntervalTier(tg, originalInd)
    error('originalInd must be interval tier')
end

ntiers = tgGetNumberOfTiers(tg);

if nargin == 5
    sep = '-';
end

if isinf(newInd)
    if newInd > 0
        newInd = ntiers+1;
    else
        error('newInd must be integer >= 1 or +Inf')
    end
end


if ~isInt(newInd)
    error(['newInd must be integer >= 1 or +Inf [' num2str(newInd) ']']);
end

if newInd < 1 || newInd>ntiers+1
    error(['newInd out of range [1; ntiers+1], newInd = ' num2str(newInd) ', ntiers = ' num2str(ntiers)]);
end

for I = 1: ntiers
    if strcmp(tg.tier{I}.name, newTierName)
        warning(['TextGrid has a duplicate tier name [', newTierName, ']. You should not use the name for indexing to avoid ambiguity.']);
    end
end

tgNew = tg;

tOrig = tg.tier{originalInd};



%-%% process tOrig
collapsed = horzcat(tOrig.Label{:});
patternCollapsed =  strrep(pattern, sep, '');
if strcmp(collapsed, patternCollapsed) ~= true
    newline = sprintf('\n');
    error(['pattern does not match actual labels in the tier', newline, 'pattern:       [', patternCollapsed, ']', newline, ...
                'actual labels: [', collapsed, ']'])
end

parts = strsplit(pattern, sep, 'CollapseDelimiters', false);  % cell-array of string characters

t1 = [];
t2 = [];
label = {}; indLabel = 1;
indPart = 1;
labTemp = '';

t1Last = NaN;

% pozor, nìjak se též vypoøádat s prázdnými labely - ideálnì je zachovat a brát je též jako oddìlovaè, tedy v rámci jedné "part" nemùže být uvnitø prázdný label

for I = 1: length(tOrig.Label)
    if isempty(labTemp)
        t1Last = tOrig.T1(I);
    end

    if isempty(tOrig.Label{I})  % empty label
        if ~isempty(labTemp)
            error(['unmatched labels [', labTemp, '] with the part [', parts{indPart}, '], prematurely terminated by new segment with empty label'])
        end

        t1 = [t1, tOrig.T1(I)];
        t2 = [t2, tOrig.T2(I)];
        label{1, indLabel} = tOrig.Label{I}; indLabel = indLabel + 1;
    else  % non-empty label
        labTemp = [labTemp, tOrig.Label{I}];
        if indPart > length(parts)
            error('more labels than parts')
        end
        if length(labTemp) > length(parts{indPart})
            error(['unmatched label [', labTemp, '], the part should be [', parts{indPart}, ']'])
        end

        if strcmp(labTemp, parts{indPart}) == true  % match
            t1 = [t1, t1Last];
            t2 = [t2, tOrig.T2(I)];
            label{1, indLabel} = labTemp; indLabel = indLabel + 1;
            labTemp = '';
            indPart = indPart + 1;
        else  % not yet
            % nothing to do
        end
    end
end

if indPart <= length(parts)
    error('labels prematurely ended, not all parts found')
end

tOrig.T1 = t1;
tOrig.T2 = t2;
tOrig.Label = label;

%-%%





for I = ntiers + 1: -1: newInd+1
    tgNew.tier{I} = tgNew.tier{I-1};
end

tgNew.tier{newInd} = tOrig;
tgNew.tier{newInd}.name = newTierName;
