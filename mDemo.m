%% mPraat demonstration

%% mPraat and rPraat homepage
% rPraat and mPraat homepage:
% <https://fu.ff.cuni.cz/praat/>
% 
% Toolbox mPraat at github:
% <https://github.com/bbTomas/mPraat>

%% How to cite this toolbox?
% We have invested a lot of time and effort in creating mPraat toolbox / rPraat package, please cite it when using it for data analysis.
%
% *Boøil, T., & Skarnitzl, R. (2016). Tools rPraat and mPraat. In P. Sojka, A. Horák, I. Kopeèek, & K. Pala (Eds.), Text, Speech, and Dialogue (pp. 367–374). Springer International Publishing.*
%
% Download Tools rPraat and mPraat manuscript .pdf:
% <https://fu.ff.cuni.cz/praat/boril_skarnitzl_2016_Tools_rPraat_and_mPraat_[manuscript].pdf>
%
% The final publication is available at Springer via
% <https://dx.doi.org/10.1007/978-3-319-45510-5_42>
%
% Download BibTeX reference mpraatrpraat2016.bib:
% <https://fu.ff.cuni.cz/praat/mpraatrpraat2016.bib>




%% Installation and help
% Download mPraat: mPraat-master.zip
% <https://github.com/bbTomas/mPraat/archive/master.zip>
%
% To install mPraat, just unzip all files to any directory of your choice
% and Set Path (in Matlab) to this directory.
%
% For help and examples, use command
%
%   help functionName
%
% - or -
%
%   doc functionName


%% Read and plot TextGrid, PitchTier and Sound

tg = tgRead('demo/H.TextGrid');
figure, tgPlot(tg)

pt = ptRead('demo/H.PitchTier');
figure, ptPlot(pt);

[snd, fs] = audioread('demo/H.wav');
t = 0: 1/fs: (length(snd)-1)/fs;

figure, tgPlot(tg, 3);   % plot TextGrid with 2 empty subplots
nTiers = tgGetNumberOfTiers(tg);

subplot(nTiers+2, 1, 1); % plot Sound
plot(t, snd); axis tight

subplot(nTiers+2, 1, 2); % plot PitchTier
ptPlot(pt);


%% TextGrid

tg = tgRead('demo/H.TextGrid');

tiers = tgGetNumberOfTiers(tg)
tiers = length(tg.tier)
duration = tgGetTotalDuration(tg)

tier1name = tgGetTierName(tg, 1)

%% Tier accessed both by index and name (TextGrid)
tgIsPointTier(tg, 1)
tgIsPointTier(tg, 'phoneme')

tgIsIntervalTier(tg, 1)
tgIsIntervalTier(tg, 'phoneme')

type = tg.tier{1}.type
type = tg.tier{tgI(tg, 'phoneme')}.type


%% Point tier (TextGrid)
numPoints = tgGetNumberOfPoints(tg, 1)
numPoints = tgGetNumberOfPoints(tg, 'phoneme')
time4 = tgGetPointTime(tg, 'phoneme', 4)
label4 = tgGetLabel(tg, 'phoneme', 4)


%% Point tier 'low-level access' (TextGrid)
numPoints = length(tg.tier{1}.T)   % or: numPoints = length(tg.tier{tgI(tg, 'phoneme')}.T)
time4 = tg.tier{1}.T(4)
label4 = tg.tier{1}.Label{4}

t = tg.tier{1}.T(5:8)


%% Interval tier  (TextGrid)
tierIndex = tgI(tg, 'word')
tgIsPointTier(tg, 'word')
tgIsIntervalTier(tg, 'word')
type = tg.tier{4}.type   % or: type = tg.tier{tgI(tg, 'word')}.type

tierDuration = tgGetTotalDuration(tg, 'word')
tStart = tgGetStartTime(tg, 'word')
tEnd = tgGetEndTime(tg, 'word')

numIntervals = tgGetNumberOfIntervals(tg, 'word')
t1 = tgGetIntervalStartTime(tg, 'word', 4)
t2 = tgGetIntervalStartTime(tg, 'word', 4)
dur = tgGetIntervalDuration(tg, 'word', 4)
label = tgGetLabel(tg, 'word', 4)


%% Interval tier 'low-level access' (TextGrid)
numIntervals = length(tg.tier{4}.T1)
t1 = tg.tier{4}.T1(4)
t2 = tg.tier{4}.T2(4)
label = tg.tier{4}.Label{4}

lab = tg.tier{4}.Label(5:8)

%% Vectorized operations

labelsOfInterest = {'i', 'i:', 'e', 'e:', 'a', 'a:', 'o', 'o:', 'u', 'u:'};
tierInd = tgI(tg, 'phone');
condition = ismember( tg.tier{tierInd}.Label, labelsOfInterest );

count = sum(condition)
dur = tg.tier{tierInd}.T2(condition) - tg.tier{tierInd}.T1(condition);
meanDur = mean( dur )

figure, hist(dur)


%% Cut TextGrid
tg = tgRead('demo/H.TextGrid');
figure
tgPlot(tgCut(tg, 2, 2.2)); % preserve times
figure
tgPlot(tgCut0(tg, 2, 2.2)); % time from 0


%% Find labels in TextGrid: find label 'n' in phoneme tier (Point tier)
tg = tgRead('demo/H_plain.TextGrid');
i = tgFindLabels(tg, 'phoneme', 'n')   % get result indices
length(i)  % 4 results
i{1}       % index of the first result
tg.tier{tgI(tg, 'phoneme')}.Label{i{1}}   % label of the 1st result
tg.tier{tgI(tg, 'phoneme')}.Label(cell2mat(i))  % all found label: cell-array of char strings

%% Find labels in TextGrid: find fragments with successive labels '?' 'a' in phone tear (Interval tier)
i = tgFindLabels(tg, 'phone', {'?', 'a'})
length(i)   % 2 results found
i{1}        % indices of the first result
length(i{1}) % length of the first result
i{1}(2)     % index of the 2nd label of the first result
tg.tier{tgI(tg, 'phone')}.Label{i{1}(2)}  % 2nd label of the first result
i{2}        % indices of the second result
tg.tier{tgI(tg, 'phone')}.Label(i{1})  % label of the 1st result: cell-array of char strings
tg.tier{tgI(tg, 'phone')}.Label(i{2})  % 2nd result
tg.tier{tgI(tg, 'phone')}.Label(cell2mat(i))  % all results together: cell-array of char strings

%% Find labels in TextGrid: find fragments with successive labels '?' 'a' in phone tier and return initial and final time of these fragments
t = tgFindLabels(tg, 'phone', {'?', 'a'}, true)  % 2 results and their initial (T1) and final (T2) time
t.T2(1) - t.T1(1)    % duration of the first fragment
t.T2(2) - t.T1(2)    % duration of the second fragment
t.T2 - t.T1          % durations of all fragments

%% Find labels in TextGrid: find fragments with successive labels 'ti' 'reknu' 'co' in word tier (Interval tier)
i = tgFindLabels(tg, 'word', {'ti', 'reknu', 'co'})
length(i)   % 1 result found
i{1}          % indices of segments in the first (and only) result
length(i{1})  % length of the first (and only) result (number of segments)
i{1}(2)       % index of the second segment in the first result
tg.tier{tgI(tg, 'word')}.Label{i{1}(2)} % second label in the fragment
tg.tier{tgI(tg, 'word')}.Label(i{1})    % all labels in the fragment: cell-array of char strings

%% Find labels in TextGrid: get initial and final time of the fragment and extract this interval from the PitchTier
t = tgFindLabels(tg, 'word', {'ti', 'reknu', 'co'}, true)
pt = ptRead('demo/H.PitchTier');
tStart = t.T1(1)
tEnd = t.T2(1)
figure, ptPlot(ptCut(pt, tStart, tEnd))



%% Create syllable tier from phone tier

tg = tgRead('demo/H.TextGrid');
tg = tgRemoveTier(tg, 5); tg = tgRemoveTier(tg, 4); tg = tgRemoveTier(tg, 3); tg = tgRemoveTier(tg, 1); % get phone tier only

% Get actual labels - concatenated (collapsed into one string)
% Use horzcat instead of strcat because strcat removes leading white-space chars which is undesirable.
collapsed = horzcat(tg.tier{tgI(tg, 'phone')}.Label{:})

% Edit the collapsed string with labels - insert separators to mark boundaries of syllables.

% * There can be segments with empty labels in the original tier (pauses), do not specify them in the pattern.
% * Beware of labels that appear empty but they are not (space, new line character etc.) - these segments are handled as classical non-empty labels. See example - one label is ' ', therefore it must be specified in the pattern.

pattern = 'ja:-ci-P\ek-nu-t_so-?u-J\e-la:S- -nej-dP\i:f-naj-deZ-h\ut_S-ku-?a-?a-ta-ma-na:'
tg2 = tgDuplicateTierMergeSegments(tg, 'phone', 1, 'syll', pattern, '-');
figure, tgPlot(tg2);




%% Overview of some TextGrid operations
% For all functions, see help for description and example of use.

tg = tgRead('demo/H.TextGrid');
figure, tgPlot(tg)

tg = tgRemoveTier(tg, 'syllable');
tg = tgRemoveTier(tg, 'phrase');
tg = tgRemoveTier(tg, 'phone');

ind = tgGetPointIndexNearestTime(tg, 'phoneme', 1.5);
tg = tgSetLabel(tg, 'phoneme', ind, '!Q!');
tg = tgInsertPoint(tg, 'phoneme', 1.6, 'NEW');
tg.tier{tgI(tg, 'phoneme')}.T(30: 40) = [];      % remove points
tg.tier{tgI(tg, 'phoneme')}.Label(30: 40) = [];

tg = tgDuplicateTier(tg, 'word', 2);
tg = tgSetTierName(tg, 2, 'WORD2');
tg = tgRemoveIntervalBothBoundaries(tg, 'WORD2', 6);
tg = tgSetLabel(tg, 'WORD2', 5, '');
tg = tgInsertInterval(tg, 'WORD2', 0.9, 1.7, 'NEW LAB');
ind = tgGetIntervalIndexAtTime(tg, 'WORD2', 2.3);
tg = tgRemoveIntervalBothBoundaries(tg, 'WORD2', ind);
figure, tgPlot(tg)

tgNew = tgCreateNewTextGrid(0, 5);
tgNew = tgInsertNewIntervalTier(tgNew, 1, 'word');   % the first tier
tgNew = tgInsertInterval(tgNew, 1, 2, 3.5, 'hello');
tgNew = tgInsertInterval(tgNew, 1, 4, 4.8, 'world');
tgNew = tgInsertNewIntervalTier(tgNew, Inf, 'wordLast');  % the last tier (at this moment)
tgNew = tgInsertInterval(tgNew, 'wordLast', 2, 3, 'ABC');
tgNew = tgInsertNewPointTier(tgNew, 2, 'click');
tgNew = tgInsertPoint(tgNew, 2, 2, 'click');
tgNew = tgInsertPoint(tgNew, 2, 4, 'click');
tgNew = tgInsertNewPointTier(tgNew, Inf, 'pointTierLast');
tgNew = tgInsertPoint(tgNew, 'pointTierLast', 3, 'point');
figure, tgPlot(tgNew)
tgWrite(tgNew, 'demo/ex_output.TextGrid');

%% Repair continuity problem of TextGrid
% Repairs problem of continuity of T2 and T1 in interval tiers. This
% problem is very rare and it should not appear. However, e.g., 
% automatic segmentation tool Prague Labeller produces random numeric
% round-up errors featuring, e.g., T2 of preceding interval is slightly
% higher than the T1 of the current interval. Because of that, the boundary
% cannot be manually moved in Praat edit window.

tgProblem = tgRead('demo/H_problem.TextGrid');
tgNew = tgRepairContinuity(tgProblem);
tgWrite(tgNew, 'demo/H_problem_OK.TextGrid');

tgNew2 = tgRepairContinuity(tgNew); % no problem in repaired TextGrid



%% PitchTier
% Transform Hz to semitones (ST), cut the original pitchtier along the TextGrid, make interpolated contour.

pt = ptRead('demo/H.PitchTier');
pt = ptHz2ST(pt, 100);  % conversion of Hz to Semitones, reference 0 ST = 100 Hz.

figure
subplot(3,1,1)
ptPlot(pt); xlabel('Time (sec)'); ylabel('Frequency (ST)');

subplot(3,1,2)
tg = tgRead('demo/H.TextGrid');
labelsOfInterest = tg.tier{tgI(tg, 'word')}.Label(2:6) .'

pt2 = ptCut0(pt, tgGetIntervalStartTime(tg, 'word', 2), tgGetIntervalEndTime(tg, 'word', 6));
ptPlot(pt2); xlabel('Time (sec)'); ylabel('Frequency (ST)');

subplot(3,1,3)
pt2interp = ptInterpolate(pt2, pt2.t(1): 0.001: pt2.t(end));
ptPlot(pt2interp); xlabel('Time (sec)'); ylabel('Frequency (ST)');

ptWrite(pt2interp, 'demo/H_cut_interp.PitchTier')

%% Legendre polynomials modelling

% Orthogonal basis
figure
ptLegendreDemo()

% Cut the PitchTier
pt = ptRead('demo/H.PitchTier');
pt = ptHz2ST(pt, 100);
pt = ptCut(pt, 3);  % cut PitchTier from t = 3 sec and preserve time

% Model it using Legendre polynomials
c = ptLegendre(pt)

% Reconstruct the contour from these 4 coefficients
leg = ptLegendreSynth(c);
ptLeg = pt;
ptLeg.t = linspace(ptLeg.tmin, ptLeg.tmax, length(leg));
ptLeg.f = leg;

figure
plot(pt.t, pt.f, 'ko'); xlabel('Time (sec)'); ylabel('F0 (ST re 100 Hz)');
hold on
plot(ptLeg.t, ptLeg.f, 'b')
hold off
axis tight

%% Pitch object
% In addition to PitchTier, a Pitch object represents periodicity candidates as a function of time.
p = pitchRead('demo/sound.Pitch');
p
p.t(4)      % time instance of the 4th frame
p.frame{4}  % 4th frame: pitch candidates
p.frame{4}.frequency(2)
p.frame{4}.strength(2)

%% Formant object
% A Formant object represents formant frequencies and bandwidths as a function of time.
f = formantRead('demo/maminka.Formant');
f
f.t(4)      % time instance of the 4th frame
f.frame{4}  % 4th frame: formants
f.frame{4}.frequency(2)
f.frame{4}.bandwidth(2)

%% IntensityTier
% Intensity tier files have very similar structure to PitchTiers. Using this toolbox, you can also interpolate, cut or model Intensity tiers with Legendre polynomials.
it = itRead('demo/maminka.IntensityTier');
it = itCut(it, 0.2, 0.4);  % cut IntensityTier and preserve time
c = itLegendre(it)
leg = itLegendreSynth(c);
itLeg = it;
itLeg.t = linspace(itLeg.tmin, itLeg.tmax, length(leg));
itLeg.i = leg;
figure, plot(it.t, it.i, 'ko')
xlabel('Time (sec)'); ylabel('Intensity (dB)')
hold on; plot(itLeg.t, itLeg.i, 'b')

%% Read Collections of objects
% With col.read() function, it is convenient to read a lot of objects stored in one Praat .Collection file
coll = colRead('demo/coll_text.Collection');
length(coll)  % number of objects in collection
coll{1}.type  % 1st object type
coll{1}.name  % 1st object name
it = coll{1}; % 1st object
figure, itPlot(it)

coll{2}.type  % 2nd object type
coll{2}.name  % 2nd object name
tg = coll{2}; % 2nd object
figure, tgPlot(tg)
length(tg.tier)  % number of tiers in TextGrid
tg.tier{tgI(tg, 'word')}.Label

coll{3}.type  % 3rd object type
coll{3}.name  % 3rd object name
pitch = coll{3}; % 3rd object
pitch.nx         % number of frames
pitch.t(4)       % time instance of the 4th frame
pitch.frame{4}   % th frame: pitch candidates
pitch.frame{4}.frequency(2)
pitch.frame{4}.strength(2)

coll{4}.type  % 4th object type
coll{4}.name  % 4th object name
pt = coll{4}; % 4th object
figure, ptPlot(pt)


%% Process all files in folder
%   inputFolder = 'experiment1/data';
%   listFiles = dir([inputFolder '/*.TextGrid']);  % Beware of case-sensitive file system!
%   
%   for (I = 1: length(listFiles))
%       file = listFiles(I).name;
%       if listFiles(I).isdir
%           continue
%       end
%       fileName = file(1:end-9);
%       fileTextGrid = [inputFolder, '/', fileName, '.TextGrid'];
%       filePitchTier = [inputFolder, '/', fileName, '.PitchTier'];
%       fileIntensityTier = [inputFolder, '/', fileName, '.IntensityTier'];
%       fileSound = [inputFolder, '/', fileName, '.wav'];
%       %
%       tg = tgRead(fileTextGrid);
%       pt = ptRead(filePitchTier);
%       % your code %
%   end


