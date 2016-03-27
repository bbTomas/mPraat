%% mPraat demonstration

%% mPraat and rPraat homepage
% rPraat and mPraat homepage:
% <http://fu.ff.cuni.cz/praat/>
%
% Toolbox mPraat at github:
% <https://github.com/bbTomas/mPraat>


%% Installation and help
% Download mPraat v1.0.0: mPraat-master.zip
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
tgNew = tgInsertNewIntervalTier(tgNew, 1, 'word');
tgNew = tgInsertInterval(tgNew, 1, 2, 3.5, 'hello');
tgNew = tgInsertInterval(tgNew, 1, 4, 4.8, 'world');
tgNew = tgInsertNewPointTier(tgNew, 2, 'click');
tgNew = tgInsertPoint(tgNew, 2, 2, 'click');
tgNew = tgInsertPoint(tgNew, 2, 4, 'click');
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
% Transform Hz to semitones (ST) and cut the pitchtier along the TextGrid.

pt = ptRead('demo/H.PitchTier');
pt.f = 12*log(pt.f/100) / log(2);  % conversion of Hz to Semitones, reference 0 ST = 100 Hz.

subplot(2,1,1)
ptPlot(pt); xlabel('Time (sec)'); ylabel('Frequency (ST)');

subplot(2,1,2)
tg = tgRead('demo/H.TextGrid');
labelsOfInterest = tg.tier{tgI(tg, 'word')}.Label(1:6) .'

conditionCut = (pt.t >= 0  &  pt.t <= tgGetIntervalEndTime(tg, 'word', 6));
ptCut = pt;
ptCut.t = pt.t(conditionCut);
ptCut.f = pt.f(conditionCut);
ptCut.tmax = ptCut.t(end);
ptPlot(ptCut); xlabel('Time (sec)'); ylabel('Frequency (ST)');

ptWrite(ptCut, 'demo/H_cut.PitchTier')

