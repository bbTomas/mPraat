close all
clear all
clc


disp('PitchTier')
disp('ptRead')
pt = ptRead('demo/H.PitchTier');
expect_equal({length(unique(pt.t)), pt.tmax}, {209, 3.617125});
pt = ptRead('demo/H.PitchTier', 'auto');
expect_equal({length(unique(pt.t)), pt.tmax}, {209, 3.617125});
wid='MATLAB:iofun:UnsupportedEncoding';
pt = ptRead('demo/H_UTF16.PitchTier', 'UTF-16');
expect_equal({length(unique(pt.t)), pt.tmax}, {209, 3.617125});
pt = ptRead('demo/H_UTF16.PitchTier', 'auto');
expect_equal({length(unique(pt.t)), pt.tmax}, {209, 3.617125});
pt = ptRead('demo/H_headerlessSpreadSheet.PitchTier');
expect_equal({length(unique(pt.t)), pt.tmax}, {209, 3.4935625});
pt = ptRead('demo/H_shortTextFile.PitchTier');
expect_equal({length(unique(pt.t)), pt.tmax}, {209, 3.617125});
pt = ptRead('demo/H_spreadSheet.PitchTier');
expect_equal({length(unique(pt.t)), pt.tmax}, {209, 3.617125});

disp('ptWrite')
pt = ptRead('demo/Hround.PitchTier');
f = tempname;
ptWrite(pt, f, 'short');
pt2 = ptRead(f);
delete(f);
expect_equal(isequal(pt, pt2), true);

pt = ptRead('demo/Hround.PitchTier');
f = tempname;
ptWrite(pt, f, 'text');
pt2 = ptRead(f);
delete(f);
expect_equal(isequal(pt, pt2), true);

pt = ptRead('demo/Hround.PitchTier');
f = tempname;
ptWrite(pt, f, 'spreadsheet');
pt2 = ptRead(f);
delete(f);
expect_equal(isequal(pt, pt2), true);

pt = ptRead('demo/Hround.PitchTier');
f = tempname;
ptWrite(pt, f);
pt2 = ptRead(f);
delete(f);
expect_equal(isequal(pt, pt2), true);

disp('ptHz2ST')
pt = ptRead('demo/H.PitchTier');
pt2 = ptHz2ST(pt);
pt3 = ptHz2ST(pt, 200);
expect_equal({length(pt2.f), length(pt3.f), pt.f(1), pt.f(45), pt.f(209), pt2.f(1), pt2.f(45), pt2.f(209), ...
    pt3.f(1), pt3.f(45), pt3.f(209), var(pt2.f), var(pt3.f)}, ...
    {209, 209, 210.0627306, 196.4245331, 161.7025771, 12.8498427, 11.6877016, 8.3201121, 0.8498427, -0.3122984, -3.6798879, 11.2833270, 11.2833270});


disp('ptInterpolate')
pt = ptRead('demo/H.PitchTier');
t = [-1, 0, 0.1, pt.t(3), pt.t(length(pt.t)), pt.t(length(pt.t))+1];
pt2 = ptInterpolate(pt, t);
expect_equal({pt2.tmin, pt2.tmax, length(pt2.t), length(pt2.f), pt2.t, pt2.f}, ...
    {pt.tmin, pt.tmax, length(t), length(t), t, [210.0627306, 210.0627306, 213.8849744, 219.4930673, 161.7025771, 161.7025771]});


disp('ptLegendre')
expect_error('ptLegendre(ptRead(''demo/H.PitchTier''), -1)');
expect_error('ptLegendre(ptRead(''demo/H.PitchTier''), 0, 0)');
expect_error('ptLegendre(ptRead(''demo/H.PitchTier''), -1, 1)');
expect_error('ptLegendreSynth(1, NaN)');
expect_error('ptLegendreSynth(1, [])');
pt = ptRead('demo/H.PitchTier');
expect_equal(sum(isnan(ptLegendre(pt, 0))), 4);
expect_equal(isnan(ptLegendre(pt, 0, 1)), true);
expect_equal(ptLegendre(struct('tmin', 0, 'tmax', 0.4, 't', [0, 0.1, 0.2, 0.3, 0.4], 'f', [1, 2, 3, 6, -1])), [2.7472472, 0.8711174, -2.2633733, -2.4655033]);
expect_equal(ptLegendre(struct('tmin', 0, 'tmax', 0.4, 't', [0, 0.1, 0.2, 0.3, 0.4], 'f', [1, 2, 3, 6, -1]), 1000, 1), 2.7472472472472);
expect_equal(ptLegendre(struct('tmin', 0, 'tmax', 0.4, 't', [0, 0.1, 0.2, 0.3, 0.4], 'f', [1, 2, 3, 6, -1]), 2), [0, -3,  0, -7]);
expect_equal(length(ptLegendreSynth(5, 0)), 0);
expect_equal(ptLegendreSynth(5, 1), 5);
expect_equal(ptLegendreSynth(5, 3), [5, 5, 5]);
expect_equal(ptLegendreSynth([1, 2, 3], 1), 2);
expect_equal(ptLegendreSynth([1, 2, 3], 2), [2, 6]);
expect_equal(ptLegendreSynth([1, 2, 3], 5), [2, -0.375, -0.5, 1.625, 6]);

disp('ptCut')
expect_error('ptCut(ptRead(''demo/H.PitchTier''), [])');
expect_error('ptCut(ptRead(''demo/H.PitchTier''), NaN)');
pt = ptRead('demo/H.PitchTier');
pt = ptCut(pt, 3);
expect_equal({pt.tmin, pt.tmax, length(pt.t), length(pt.f), pt.t(1), pt.t(10), pt.t(37), pt.f(1), pt.f(10), pt.f(37)}, ...
        {3, 3.617125, 37, 37, 3.083563, 3.223562, 3.493562, 199.417691, 194.807345, 161.702577});
pt = ptRead('demo/H.PitchTier');
pt = ptCut(pt, 2, 3);
expect_equal({pt.tmin, pt.tmax, length(pt.t), length(pt.f), pt.t(1), pt.t(10), pt.t(81), pt.f(1), pt.f(10), pt.f(81)}, ...
        {2, 3, 81, 81, 2.003563, 2.093562, 2.993562, 198.818598, 258.404655, 196.152600});
pt = ptRead('demo/H.PitchTier');
pt = ptCut(pt, -inf, 1);
expect_equal({pt.tmin, pt.tmax, length(pt.t), length(pt.f), pt.t(1), pt.t(10), pt.t(71), pt.f(1), pt.f(10), pt.f(71)}, ...
        {0, 1, 71, 71, 0.0935625, 0.1835625, 0.9935625, 210.0627306, 189.5803367, 150.0365144});
pt = ptRead('demo/H.PitchTier');
pt = ptCut(pt, -1, 1);
expect_equal({pt.tmin, pt.tmax, length(pt.t), length(pt.f), pt.t(1), pt.t(10), pt.t(71), pt.f(1), pt.f(10), pt.f(71)}, ...
        {-1, 1, 71, 71, 0.0935625, 0.1835625, 0.9935625, 210.0627306, 189.5803367, 150.0365144});
expect_error('ptCut(ptRead(''demo/H.PitchTier''), 3, 2)');

disp('ptCut0')
expect_error('ptCut0(ptRead(''demo/H.PitchTier''), [])');
expect_error('ptCut0(ptRead(''demo/H.PitchTier''), NaN)');
pt = ptRead('demo/H.PitchTier');
pt = ptCut0(pt, 3);
expect_equal({pt.tmin, pt.tmax, length(pt.t), length(pt.f), pt.t(1), pt.t(10), pt.t(37), pt.f(1), pt.f(10), pt.f(37)}, ...
        {0, 0.617125, 37, 37, 0.083563, 0.223562, 0.493562, 199.417691, 194.807345, 161.702577});
pt = ptRead('demo/H.PitchTier');
pt = ptCut0(pt, 2, 3);
expect_equal({pt.tmin, pt.tmax, length(pt.t), length(pt.f), pt.t(1), pt.t(10), pt.t(81), pt.f(1), pt.f(10), pt.f(81)}, ...
        {0, 1, 81, 81, 0.003563, 0.093562, 0.993562, 198.818598, 258.404655, 196.152600});
pt = ptRead('demo/H.PitchTier');
pt = ptCut0(pt, -inf, 1);
expect_equal({pt.tmin, pt.tmax, length(pt.t), length(pt.f), pt.t(1), pt.t(10), pt.t(71), pt.f(1), pt.f(10), pt.f(71)}, ...
        {0, 1, 71, 71, 0.0935625, 0.1835625, 0.9935625, 210.0627306, 189.5803367, 150.0365144});
pt = ptRead('demo/H.PitchTier');
pt = ptCut0(pt, -1, 1);
expect_equal({pt.tmin, pt.tmax, length(pt.t), length(pt.f), pt.t(1), pt.t(10), pt.t(71), pt.f(1), pt.f(10), pt.f(71)}, ...
        {0, 2, 71, 71, 1.0935625, 1.1835625, 1.9935625, 210.0627306, 189.5803367, 150.0365144});
expect_error('ptCut0(ptRead(''demo/H.PitchTier''), 3, 2)');



disp('IntensityTier')

disp('itRead')
it = itRead('demo/maminka.IntensityTier');
expect_equal({length(unique(it.t)), it.tmin, it.tmax, length(it.t), it.t(1), it.t(16), it.t(29), it.t(40), it.i(1), it.i(16), it.i(29), it.i(40)}, ...
    {40, 0, 0.5460770975056689, 40, 0.0501814058956916, 0.22160997732426302, 0.3701814058956916, 0.4958956916099773, 59.5715903919772, 71.63843325188716, 64.17176220056767, 64.98963270408825});
it = itRead('demo/maminka_short.IntensityTier');
expect_equal({length(unique(it.t)), it.tmin, it.tmax, length(it.t), it.t(1), it.t(16), it.t(29), it.t(40), it.i(1), it.i(16), it.i(29), it.i(40)}, ...
    {40, 0, 0.5460770975056689, 40, 0.0501814058956916, 0.22160997732426302, 0.3701814058956916, 0.4958956916099773, 59.5715903919772, 71.63843325188716, 64.17176220056767, 64.98963270408825});

disp('itWrite')
it = itRead('demo/maminka.IntensityTier');
f = tempname;
itWrite(it, f, 'short');
it2 = itRead(f);
delete(f);
expect_equal({numel(fieldnames(it)), it.t, it.i, it.tmin, it.tmax}, ...
    {numel(fieldnames(it2)), it2.t, it2.i, it2.tmin, it2.tmax});

it = itRead('demo/maminka.IntensityTier');
f = tempname;
itWrite(it, f);
it2 = itRead(f);
delete(f);
expect_equal({numel(fieldnames(it)), it.t, it.i, it.tmin, it.tmax}, ...
    {numel(fieldnames(it2)), it2.t, it2.i, it2.tmin, it2.tmax});

it = itRead('demo/maminka.IntensityTier');
f = tempname;
itWrite(it, f, 'text');
it2 = itRead(f);
delete(f);
expect_equal({numel(fieldnames(it)), it.t, it.i, it.tmin, it.tmax}, ...
    {numel(fieldnames(it2)), it2.t, it2.i, it2.tmin, it2.tmax});

disp('it.interpolate')
it = itRead('demo/maminka.IntensityTier');
t = [-1, 0, 0.1, it.t(3), it.t(end), it.t(end)+1];
it2 = itInterpolate(it, t);
expect_equal({it2.tmin, it2.tmax, length(it2.t), length(it2.i), it2.t, it2.i}, ...
    {it.tmin, it.tmax, length(t), length(t), t, [59.57159039, 59.57159039, 69.76859026, 66.73070258, 64.98963270, 64.98963270]});

disp('itLegendre')
itSample = itRead('demo/maminka.IntensityTier');
expect_error('itLegendre(itRead(''demo/maminka.IntensityTier''), -1)');
expect_error('itLegendre(itRead(''demo/maminka.IntensityTier''), 0, 0)');
expect_error('itLegendre(itRead(''demo/maminka.IntensityTier''), -1, 1)');
expect_error('itLegendreSynth(1, NaN)');
expect_error('itLegendreSynth(1, [])');
expect_equal(sum(isnan(itLegendre(itSample, 0))), 4);
expect_equal(isnan(itLegendre(itSample, 0, 1)), true);
expect_equal(itLegendre(struct('tmin', 0, 'tmax', 0.4, 't', [0, 0.1, 0.2, 0.3, 0.4], 'i', [1, 2, 3, 6, -1])), [2.7472472, 0.8711174, -2.2633733, -2.4655033]);
expect_equal(itLegendre(struct('tmin', 0, 'tmax', 0.4, 't', [0, 0.1, 0.2, 0.3, 0.4], 'i', [1, 2, 3, 6, -1]), 1000, 1), 2.7472472472472);
expect_equal(itLegendre(struct('tmin', 0, 'tmax', 0.4, 't', [0, 0.1, 0.2, 0.3, 0.4], 'i', [1, 2, 3, 6, -1]), 2), [0, -3,  0, -7]);
expect_equal(length(ptLegendreSynth(5, 0)), 0);
expect_equal(itLegendreSynth(5, 1), 5);
expect_equal(itLegendreSynth(5, 3), [5, 5, 5]);
expect_equal(itLegendreSynth([1, 2, 3], 1), 2);
expect_equal(itLegendreSynth([1, 2, 3], 2), [2, 6]);
expect_equal(itLegendreSynth([1, 2, 3], 5), [2, -0.375, -0.5, 1.625, 6]);

disp('itCut')
expect_error('itCut(itRead(''demo/maminka.IntensityTier''), [])');
expect_error('itCut(itRead(''demo/maminka.IntensityTier''), NaN)');
itSample = itRead('demo/maminka.IntensityTier');
it = itCut(itSample, 0.3);
expect_equal({it.tmin, it.tmax, length(it.t), length(it.i), it.t(1), it.t(10), it.t(18), it.i(1), it.i(10), it.i(18)}, ...
    {0.3, 0.5460771, 18, 18, 0.3016100, 0.4044671, 0.4958957, 70.8841436, 58.2129565, 64.9896327});
it = itCut(itSample, 0.2, 0.3);
expect_equal({it.tmin, it.tmax, length(it.t), length(it.i), it.t(1), it.t(4), it.t(8), it.i(1), it.i(4), it.i(8)}, ...
    {0.2, 0.3, 8, 8, 0.2101814, 0.2444671, 0.2901814, 71.6253944, 71.1700598, 69.5956455});
it = itCut(itSample, -Inf, 1);
expect_equal({it.tmin, it.tmax, length(it.t), length(it.i), it.t(1), it.t(35), it.t(40), it.i(1), it.i(35), it.i(40)}, ...
    {0, 1, 40, 40, 0.05018141, 0.43875283, 0.49589569, 59.57159039, 64.97294548, 64.98963270});
it = itCut(itSample, -1, 1);
expect_equal({it.tmin, it.tmax, length(it.t), length(it.i), it.t(1), it.t(35), it.t(40), it.i(1), it.i(35), it.i(40)}, ...
    {-1, 1, 40, 40, 0.05018141, 0.43875283, 0.49589569, 59.57159039, 64.97294548, 64.98963270});
expect_error('itCut(itRead(''demo/maminka.IntensityTier''), 0.3, 0.2)');

disp('itCut0')
expect_error('itCut0(itRead(''demo/maminka.IntensityTier''), [])');
expect_error('itCut0(itRead(''demo/maminka.IntensityTier''), NaN)');
itSample = itRead('demo/maminka.IntensityTier');
it = itCut0(itSample, 0.3);
expect_equal({it.tmin, it.tmax, length(it.t), length(it.i), it.t(1), it.t(10), it.t(18), it.i(1), it.i(10), it.i(18)}, ...
    {0, 0.2460771, 18, 18, 0.001609977, 0.104467120, 0.195895692, 70.8841436, 58.2129565, 64.9896327});
it = itCut0(itSample, 0.2, 0.3);
expect_equal({it.tmin, it.tmax, length(it.t), length(it.i), it.t(1), it.t(4), it.t(8), it.i(1), it.i(4), it.i(8)}, ...
    {0, 0.1, 8, 8, 0.01018141, 0.04446712, 0.09018141, 71.62539439, 71.17005977, 69.59564547});
it = itCut0(itSample, -Inf, 1);
expect_equal({it.tmin, it.tmax, length(it.t), length(it.i), it.t(1), it.t(35), it.t(40), it.i(1), it.i(35), it.i(40)}, ...
    {0, 1, 40, 40, 0.05018141, 0.43875283, 0.49589569, 59.57159039, 64.97294548, 64.98963270});
it = itCut0(itSample, -1, 1);
expect_equal({it.tmin, it.tmax, length(it.t), length(it.i), it.t(1), it.t(35), it.t(40), it.i(1), it.i(35), it.i(40)}, ...
    {0, 2, 40, 40, 1.050181, 1.438753, 1.495896, 59.57159039, 64.97294548, 64.98963270});
expect_error('itCut0(itRead(''demo/maminka.IntensityTier''), 0.3, 0.2)');



disp('TextGrid')

disp('tgRead')
tg = tgRead('demo/H.TextGrid');
expect_equal({length(tg.tier), length(unique(tg.tier{tgI(tg, 'word')}.T2)), tg.tier{1}.Label{7}, tg.tier{2}.type, tg.tier{tgI(tg, 'word')}.Label{4}, tg.tier{tgI(tg, 'word')}.Label{6}}, ...
        {5, 13, 'k', 'interval', [char(345), 'eknu'], ['ud', char(283), 'l', char(225), char(353)]});
tg = tgRead('demo/H_short.TextGrid');
expect_equal({length(tg.tier), length(unique(tg.tier{tgI(tg, 'word')}.T2)), tg.tier{1}.Label{7}, tg.tier{2}.type, tg.tier{tgI(tg, 'word')}.Label{4}, tg.tier{tgI(tg, 'word')}.Label{6}}, ...
        {5, 13, 'k', 'interval', [char(345), 'eknu'], ['ud', char(283), 'l', char(225), char(353)]});
tg = tgRead('demo/utf8.TextGrid');
expect_equal(tg.tier{tgI(tg, 'phone')}.Label{2}, char(660));
tg = tgRead('demo/H_UTF16.TextGrid', 'UTF-16');
expect_equal({length(tg.tier), length(unique(tg.tier{tgI(tg, 'word')}.T2)), tg.tier{1}.Label{7}, tg.tier{2}.type, tg.tier{tgI(tg, 'word')}.Label{4}, tg.tier{tgI(tg, 'word')}.Label{6}}, ...
        {5, 13, 'k', 'interval', [char(345), 'eknu'], ['ud', char(283), 'l', char(225), char(353)]});
tg = tgRead('demo/H_short_UTF16.TextGrid', 'UTF-16');
expect_equal({length(tg.tier), length(unique(tg.tier{tgI(tg, 'word')}.T2)), tg.tier{1}.Label{7}, tg.tier{2}.type, tg.tier{tgI(tg, 'word')}.Label{4}, tg.tier{tgI(tg, 'word')}.Label{6}}, ...
        {5, 13, 'k', 'interval', [char(345), 'eknu'], ['ud', char(283), 'l', char(225), char(353)]});
tg = tgRead('demo/2pr.TextGrid');
expect_equal({tg.tier{tgI(tg, 'ORT')}.Label{4}, tg.tier{tgI(tg, 'ORT')}.Label{5}, tg.tier{tgI(tg, 'ORT')}.Label{6}}, ...
    {['wracal', char(10), 'pokus'], ['siebie""', char(10), 'ah""', char(10), 'a'], ['siebie""', char(10), 'a""h""', char(10), 'a']});
tg = tgRead('demo/sppas.TextGrid');
expect_equal({tg.tier{tgI(tg, 'ORT')}.Label{4}, tg.tier{tgI(tg, 'ORT')}.Label{5}, tg.tier{tgI(tg, 'ORT')}.Label{6}}, ...
    {['wracal', char(10), 'pokus'], ['siebe""', char(10), 'ah""', char(10), 'a'], ['siebie""', char(10), 'a""h""', char(10), 'a']});


disp('tgWrite')
tg = tgRead('demo/2pr.TextGrid');
f = tempname;
tgWrite(tg, f, 'text');
tg2 = tgRead(f);
delete(f);
expect_equal(isequal(tg, tg2), true);

tg = tgCreateNewTextGrid(0, 3);
tg = tgInsertNewIntervalTier(tg, 1, 'word');
tg = tgInsertInterval(tg, 1, 0.8, 1.5, ['s', char(hex2dec('0105')), char(hex2dec('0123'))]);
f = tempname;
tgWrite(tg, f, 'text');
tg2 = tgRead(f);
delete(f);
expect_equal(isequal(tg, tg2), true);

tg = tgCreateNewTextGrid(0, 3);
tg = tgInsertNewIntervalTier(tg, 1, 'word');
tg = tgInsertInterval(tg, 1, 0.8, 1.5, 'tom');
f = tempname;
tgWrite(tg, f, 'text');
tg2 = tgRead(f);
delete(f);
expect_equal(isequal(tg, tg2), true);

tg = tgRead('demo/2pr.TextGrid');
f = tempname;
tgWrite(tg, f);
tg2 = tgRead(f);
delete(f);
expect_equal(isequal(tg, tg2), true);

tg = tgRead('demo/2pr.TextGrid');
f = tempname;
tgWrite(tg, f, 'short');
tg2 = tgRead(f);
delete(f);
expect_equal(isequal(tg, tg2), true);



tg = tgCreateNewTextGrid(0, 3);
tg = tgInsertNewIntervalTier(tg, 1, 'word');
tg = tgInsertInterval(tg, 1, 0.8, 1.5, ['s' char(261) char(291)]);
f = tempname;
tgWrite(tg, f);
tg2 = tgRead(f);
delete(f);
expect_equal(strcmp(tg2.tier{1}.Label(2), ['s' char(261) char(291)]), true);


disp('tgRepairContinuity')
tg = tgRead('demo/H_problem.TextGrid');
tg = tgRepairContinuity(tg, false);
expect_equal(tg.tier{2}.T2(16) > tg.tier{2}.T1(17), false);
expect_error('tgRepairContinuity(ptRead(''demo/H.PitchTier''))');


disp('tgCheckTierInd')
tg = tgRead('demo/H.TextGrid');
expect_equal(tgI(tg, 4), 4);
expect_equal(tgI(tg, 'syllable'), 3);
expect_error('tgI(tgRead(''demo/H.TextGrid''), ''WORD'')');
expect_error('tgI(tgRead(''demo/H.TextGrid''), 6)');


disp('tgInsertNewIntervalTier, tg.insertBoundary, tg.insertInterval, tg.insertNewPointTier')
tg = tgRead('demo/H.TextGrid');
tg2 = tgInsertNewIntervalTier(tg, 1, 'INTERVALS');
tg2 = tgInsertBoundary(tg2, 'INTERVALS', 0.8);
tg2 = tgInsertBoundary(tg2, 'INTERVALS', 0.1, 'Interval A');
tg2 = tgInsertInterval(tg2, 'INTERVALS', 1.2, 2.5, 'Interval B');
tg2 = tgInsertInterval(tg2, 'INTERVALS', 2.5, 2.7, 'Interval C');
tg2 = tgInsertInterval(tg2, 'INTERVALS', 2.7, 3.616, 'Interval D');
expect_equal({length(tg2.tier), tg2.tier{tgI(tg2, 'INTERVALS')}.T1, tg2.tier{tgI(tg2, 'INTERVALS')}.T2, tg2.tier{tgI(tg2, 'INTERVALS')}.Label}, ...
    {6, [0.0, 0.1, 0.8, 1.2, 2.5, 2.7], [0.1, 0.8, 1.2, 2.5, 2.7, 3.616], {'', 'Interval A', '', 'Interval B', 'Interval C', 'Interval D'}});
tg = tgInsertNewPointTier(tgRead('demo/H.TextGrid'), 2, 'aha');
expect_equal({tg.tier{2}.name, tg.tier{3}.name}, {'aha', 'phone'});
expect_error('tgInsertNewIntervalTier(tgRead(''demo/H.TextGrid''), 7, ''aha'')');
expect_error('tgInsertNewPointTier(tgRead(''demo/H.TextGrid''), 7, ''aha'')');


disp('tgDuplicateTier')
tg2 = tgDuplicateTier(tgRead('demo/H.TextGrid'), 'word', 1, 'NEW');
expect_equal({sum(strcmp(tg2.tier{tgI(tg2, 'NEW')}.Label, tg2.tier{tgI(tg2, 'word')}.Label)), ...
    sum(tg2.tier{tgI(tg2, 'NEW')}.T1 == tg2.tier{tgI(tg2, 'word')}.T1), ...
    sum(tg2.tier{tgI(tg2, 'NEW')}.T2 == tg2.tier{tgI(tg2, 'word')}.T2), ...
    tg2.tier{1}.name, tg2.tier{2}.name, length(tg2.tier)}, ...
    {13, 13, 13, 'NEW', 'phoneme', 6});
tg2 = tgDuplicateTier(tgRead('demo/H.TextGrid'), 'phoneme', 3, 'NEW');
expect_equal({sum(strcmp(tg2.tier{tgI(tg2, 'NEW')}.Label, tg2.tier{tgI(tg2, 'phoneme')}.Label)), ...
    sum(tg2.tier{tgI(tg2, 'NEW')}.T == tg2.tier{tgI(tg2, 'phoneme')}.T), ...
    tg2.tier{1}.name, tg2.tier{2}.name, length(tg2.tier), tg2.tier{3}.name, tg2.tier{4}.name}, ...
    {43, 43, 'phoneme', 'phone', 6, 'NEW', 'syllable'});
expect_error('tgDuplicateTier(tgRead(''demo/H.TextGrid''), ''aha'', 3, ''NEW'')');


disp('tgRemoveIntervalBothBoundaries')
tg = tgRead('demo/H.TextGrid');
tg2 = tgRemoveIntervalBothBoundaries(tg, 'word', 3);
expect_equal(tg2.tier{tgI(tg2, 'word')}.Label{2}, ['j', char(225), 'ti', char(345), 'eknu']);

disp('tgRemoveIntervalRightBoundary')
tg2 = tgRemoveIntervalRightBoundary(tg, 'word', 3);
expect_equal(tg2.tier{tgI(tg2, 'word')}.Label{3}, ['ti', char(345), 'eknu']);

disp('tgRemoveIntervalLeftBoundary')
tg2 = tgRemoveIntervalLeftBoundary(tg, 'word', 3);
expect_equal(tg2.tier{tgI(tg2, 'word')}.Label{2}, ['j', char(225), 'ti']);


disp('tg.insertPoint')
tg2 = tgInsertPoint(tgRead('demo/H.TextGrid'), 'phoneme', 1.4, 'NEW POINT');
expect_equal({length(tg2.tier{tgI(tg2, 'phoneme')}.T), length(tg2.tier{tgI(tg2, 'phoneme')}.Label), tg2.tier{tgI(tg2, 'phoneme')}.T(18), tg2.tier{tgI(tg2, 'phoneme')}.Label{18}}, ...
    {44, 44, 1.4, 'NEW POINT'});


disp('tgRemovePoint')
tg2 = tgRemovePoint(tgRead('demo/H.TextGrid'), 'phoneme', 2);
expect_equal({length(tg2.tier{tgI(tg2, 'phoneme')}.T), length(tg2.tier{tgI(tg2, 'phoneme')}.Label), tg2.tier{tgI(tg2, 'phoneme')}.T(18), tg2.tier{tgI(tg2, 'phoneme')}.Label{18}, ...
      tg2.tier{tgI(tg2, 'phoneme')}.T(1), tg2.tier{tgI(tg2, 'phoneme')}.Label{2}, ...
      tg2.tier{tgI(tg2, 'phoneme')}.T(1), tg2.tier{tgI(tg2, 'phoneme')}.Label{2}}, ...
    {42, 42, 1.92282441350142, 'e', 0.120889365898715, 'c', 0.120889365898715, 'c'});
expect_error('tgRemovePoint(tgRead(''demo/H.TextGrid''), ''phoneme'', 44)');


disp('tgGetPointIndexNearestTime')
expect_equal(tgGetPointIndexNearestTime(tgRead('demo/H.TextGrid'), 'phoneme', 0.5), 7);

disp('tgGetPointIndexLowerThanTime')
expect_equal(tgGetPointIndexLowerThanTime(tgRead('demo/H.TextGrid'), 'phoneme', 0.5), 6);

disp('tgGetPointIndexHigherThanTime')
expect_equal(tgGetPointIndexHigherThanTime(tgRead('demo/H.TextGrid'), 'phoneme', 0.5), 7);

disp('tgGetIntervalIndexAtTime')
tg = tgRead('demo/H.TextGrid');
expect_equal(tgGetIntervalIndexAtTime(tg, 'word', 0.5), 4);
expect_equal(tgGetIntervalIndexAtTime(tg, 'word', tg.tier{tgI(tg, 'word')}.T1(5)), 5);


disp('tgRemoveTier')
tg2 = tgRemoveTier(tgRead('demo/H.TextGrid'), 'word');
expect_equal({tg2.tier{1}.name, tg2.tier{2}.name, tg2.tier{3}.name, tg2.tier{4}.name}, ...
    {'phoneme', 'phone', 'syllable', 'phrase'});
expect_error('tgRemoveTier(tg2, ''wor'')');


disp('tgGetPointTime')
tg = tgRead('demo/H.TextGrid');
expect_equal(tgGetPointTime(tg, 'phoneme', 4), 0.3235253313);
expect_error('tgGetPointTime(tg, ''phoneme'', 44)');

disp('tgGetIntervalDuration')
expect_equal(tgGetIntervalDuration(tg, 'phone', 5), 0.0572624682);
expect_error('tgGetIntervalDuration(tg, ''phone'', 50)');

disp('tgGetIntervalEndTime')
expect_equal(tgGetIntervalEndTime(tg, 'phone', 5), 0.3521565654);
expect_error('tgGetIntervalEndTime(tg, ''phone'', 50)');

disp('tgGetIntervalStartTime')
expect_equal(tgGetIntervalStartTime(tg, 'phone', 5), 0.2948940972);
expect_error('tgGetIntervalStartTime(tg, ''phone'', 50)');


disp('tgGetLabel, tg.setLabel')
tg2 = tgSetLabel(tg, 'word', 3, 'New Label');
expect_equal(tgGetLabel(tg2, 'word', 3), 'New Label');
expect_equal(tgGetLabel(tg, 'phoneme', 4), 'i');
expect_error('tgSetLabel(tg, ''Word'', 3, ''New Label'')');
expect_error('tgSetLabel(tg, ''word'', 14, ''New Label'')');
expect_error('tgGetLabel(tg, ''word'', 14)');



disp('tgGetNumberOfIntervals')
tg = tgRead('demo/H.TextGrid');
expect_equal(tgGetNumberOfIntervals(tg, 'phone'), 49);
expect_error('tgGetNumberOfIntervals(tg, 52)');
expect_error('tgGetNumberOfIntervals(tg, ''PHONE'')');
expect_error('tgGetNumberOfIntervals(tg, ''phoneme'')');

disp('tgGetNumberOfPoints')
expect_equal(tgGetNumberOfPoints(tg, 'phoneme'), 43);
expect_error('tgGetNumberOfPoints(tg, ''word'')');

disp('tgGetNumberOfTiers')
expect_equal(tgGetNumberOfTiers(tg), 5);

disp('tgGetTotalDuration, tgGetEndTime, tgGetStartTime')
expect_equal(tgGetTotalDuration(tg), 3.616);
expect_equal(tgGetTotalDuration(tg, 'phone'), 3.608);
expect_equal(tgGetTotalDuration(tg, 'phoneme'), 3.3337929937);
expect_equal(tgGetEndTime(tg), 3.616);
expect_equal(tgGetEndTime(tg, 'phone'), 3.616);
expect_equal(tgGetEndTime(tg, 'phoneme'), 3.4546823596);
expect_equal(tgGetEndTime(tg, 'phrase'), 3.608);
expect_equal(tgGetStartTime(tg), 0);
expect_equal(tgGetStartTime(tg, 'phone'), 0.008);
expect_equal(tgGetStartTime(tg, 'phoneme'), 0.1208893659);

disp('tgCountLabels')
expect_equal(tgCountLabels(tg, 'phone', 'a'), 5);
expect_equal(tgCountLabels(tg, 'phone', 'a:'), 3);
expect_equal(tgCountLabels(tg, 'phone', ':'), 0);
expect_equal(tgCountLabels(tg, 'phoneme', 'a'), 6);


disp('tgSetTierName, tgGetTierName')
tg2 = tgSetTierName(tg, 'word', 'WORDTIER');
expect_equal(tgGetTierName(tg2, 4), 'WORDTIER');
expect_equal({tg2.tier{1}.name, tg2.tier{2}.name, tg2.tier{3}.name, tg2.tier{4}.name, tg2.tier{5}.name}, ...
    {'phoneme', 'phone', 'syllable', 'WORDTIER', 'phrase'});
expect_error('tgSetTierName(tg, 6, ''WORDTIER'')');
expect_error('tgGetTierName(tg, 6)');

disp('tgIsPointTier, tgIsIntervalTier')
expect_equal(tgIsPointTier(tg, 1), true);
expect_equal(tgIsPointTier(tg, 'word'), false);
expect_equal(tgIsIntervalTier(tg, 1), false);
expect_equal(tgIsIntervalTier(tg, 'word'), true);

disp('tgCreateNewTextGrid')
tg = tgCreateNewTextGrid(0, 5);
expect_equal({length(tg.tier), tg.tmin, tg.tmax}, {0, 0, 5});


disp('tgFindLabels')
tg = tgRead('demo/H.TextGrid');
expect_error('tgFindLabels(tgRead(''demo/H.TextGrid''), ''word'', ''nic'', ''aha'')');
expect_error('tgFindLabels(tgRead(''demo/H.TextGrid''), ''word'')');
expect_error('tgFindLabels(tgRead(''demo/H.TextGrid''), ''word'', ''co'', 2)');
expect_error('tgFindLabels(tgRead(''demo/H.TextGrid''), ''word'', 4)');
q = tgFindLabels(tg, 'word', '');
expect_equal({class(q), length(q), q{1}, q{2}}, {'cell', 2, 1, 13});
q = tgFindLabels(tg, 'phoneme', '');
expect_equal({class(q), length(q)}, {'cell', 0});
q = tgFindLabels(tg, 'word', 'nic');
expect_equal({class(q), length(q)}, {'cell', 0});
q = tgFindLabels(tg, 'word', [char(345), 'eknu']);
expect_equal({class(q), length(q), q{1}}, {'cell', 1, 4});
q = tgFindLabels(tg, 'phone', 'a');
expect_equal({class(q), length(q), q{1}, q{2}, q{3}, q{4}, q{5}}, {'cell', 5, 29, 40, 42, 44, 46});
q = tgFindLabels(tg, 'phoneme', 'n');
expect_equal({class(q), length(q), q{1}, q{2}, q{3}, q{4}}, {'cell', 4, 8, 18, 25, 42});
q = tgFindLabels(tg, 'word', {'ti', [char(345), 'eknu'], 'co'});
expect_equal({class(q), length(q), q{1}(1), q{1}(2), q{1}(3)}, {'cell', 1, 3, 4, 5});
q = tgFindLabels(tg, 'phone', {'?', 'a'});
expect_equal({class(q), length(q), q{1}(1), q{1}(2), q{2}(1), q{2}(2)}, {'cell', 2, 39, 40, 41, 42});
q = tgFindLabels(tg, 'phoneme', {'n', 'e'});
expect_equal({class(q), length(q), q{1}(1), q{1}(2)}, {'cell', 1, 18, 19});
q = tgFindLabels(tg, 'phoneme', {'n', 'a'});
expect_equal({class(q), length(q), q{1}(1), q{1}(2), q{2}(1), q{2}(2)}, {'cell', 2, 25, 26, 42, 43});
q = tgFindLabels(tg, 'word', 'xx', true);
expect_equal({length(q.T1), length(q.T2)}, {0, 0});
q = tgFindLabels(tg, 'word', '', true);
expect_equal({class(q), length(q.T1), length(q.T2), q.T1(1), q.T2(1), q.T1(2), q.T2(2)}, ...
    {'struct', 2, 2, 0.008, 0.0965724658757064, 3.495928125, 3.616});
q = tgFindLabels(tg, 'phoneme', '', true);
expect_equal({class(q), length(q.T1), length(q.T2)}, {'struct', 0, 0});
q = tgFindLabels(tg, 'word', 'nic', true);
expect_equal({class(q), length(q.T1), length(q.T2)}, {'struct', 0, 0});
q = tgFindLabels(tg, 'word', [char(345), 'eknu'], true);
expect_equal({class(q), length(q.T1), length(q.T2), q.T1(1), q.T2(1)}, {'struct', 1, 1, 0.352156565444145, 0.632200305451128});
q = tgFindLabels(tg, 'phone', 'a', true);
expect_equal({class(q), length(q.T1), length(q.T2), q.T1(1), q.T2(1), q.T1(2), q.T2(2), q.T1(3), q.T2(3), q.T1(4), q.T2(4), q.T1(5), q.T2(5)}, ...
    {'struct', 5, 5, 2.24830876409774, 2.30352886461156, 2.96666963493613, 3.02360108418367, 3.07030520488411, 3.10631502016129, 3.18439423076923, 3.2390296474359, 3.3053099702381, 3.35952210541475});
q = tgFindLabels(tg, 'phoneme', 'n', true);
expect_equal({class(q), length(q.T1), length(q.T2), q.T1(1), q.T2(1), q.T1(2), q.T2(2), q.T1(3), q.T2(3), q.T1(4), q.T2(4)}, ...
    {'struct', 4, 4, 0.562717206724197, 0.562717206724197, 1.88902324993668, 1.88902324993668, 2.22032423657473, 2.22032423657473, 3.38647934980882, 3.38647934980882});
q = tgFindLabels(tg, 'word', {'ti', [char(345), 'eknu'], 'co'}, true);
expect_equal({class(q), length(q.T1), length(q.T2), q.T1(1), q.T2(1)}, ...
    {'struct', 1, 1, 0.215988182773109, 0.760009490030675});
q = tgFindLabels(tg, 'phone', {'?', 'a'}, true);
expect_equal({class(q), length(q.T1), length(q.T2), q.T1(1), q.T2(1), q.T1(2), q.T2(2)}, ...
    {'struct', 2, 2, 2.91140769675926, 3.02360108418367, 3.02360108418367, 3.10631502016129});
q = tgFindLabels(tg, 'phoneme', {'n', 'e'}, true);
expect_equal({class(q), length(q.T1), length(q.T2), q.T1(1), q.T2(1)}, ...
    {'struct', 1, 1, 1.88902324993668, 1.92282441350142});
q = tgFindLabels(tg, 'phoneme', {'n', 'a'}, true);
expect_equal({class(q), length(q.T1), length(q.T2), q.T1(1), q.T2(1), q.T1(2), q.T2(2)}, ...
    {'struct', 2, 2, 2.22032423657473, 2.27591881435465, 3.38647934980882, 3.45468235960145});


disp('tgDuplicateTierMergeSegments')
expect_equal(strsplit('-a--a-', '-', 'CollapseDelimiters', false), {'', 'a', '', 'a', ''});

expect_error('tgDuplicateTierMergeSegments(tgRead(''demo/H3.TextGrid''), ''phone'', 1, ''syll'', ''ja:-ci-P\ek-nu-t_so-?u-J\e-la:S- -nej-dP\i:f-naj-deZ-h\ut_S-ku-?a-?a-ta-ma-na:'', ''-'')');
expect_error('tgDuplicateTierMergeSegments(tgRead(''demo/H.TextGrid''), ''phone'', 1, ''syll'', ''ja:-ci-P\ek-nu-tso-?u-J\e-la:S- -nej-dP\i:f-naj-deZ-h\ut_S-ku-?a-?a-ta-ma-na:'', ''-'')');
expect_error('tgDuplicateTierMergeSegments(tgRead(''demo/H.TextGrid''), ''phone'', 1, ''syll'', ''ja:-ci-P\ek-nu-t_soa-?u-J\e-la:S- -nej-dP\i:f-naj-deZ-h\ut_S-ku-?a-?a-ta-ma-na:'', ''-'')');
expect_error('tgDuplicateTierMergeSegments(tgRead(''demo/H.TextGrid''), ''phone'', 1, ''syll'', ''ja:-ci-P\ek-nu-t_so-?u-J\e-la:S--nej-dP\i:f-naj-deZ-h\ut_S-ku-?a-?a-ta-ma-na:'', ''-'')');
expect_error('tgDuplicateTierMergeSegments(tgRead(''demo/H.TextGrid''), ''phone'', 1, ''syll'', ''ja:-ci-P\ek-nu-t_so-?u-J\e-la:S- -nej-dP\i:f-naj-deZ-h\ut_S-ku-?a-?a-ta-ma-na:-at'', ''-'')');
expect_error('tgDuplicateTierMergeSegments(tgRead(''demo/H.TextGrid''), ''phone'', 1, ''syll'', ''ja:-nu-ci-P\ek-nu-t_so-?u-J\e-la:S- -nej-dP\i:f-naj-deZ-h\ut_S-ku-?a-?a-ta-ma-na:'', ''-'')');
expect_error('tgDuplicateTierMergeSegments(tgRead(''demo/H.TextGrid''), ''phone'', 1, ''syll'', ''a:-ci-P\ek-nu-t_so-?u-J\e-la:S- -nej-dP\i:f-naj-deZ-h\ut_S-ku-?a-?a-ta-ma-na:'', ''-'')');
% tgDuplicateTierMergeSegments(tgRead('demo/H3.TextGrid'),'phone', 1, 'syll', 'ja:-ci-P\ek-nu-t_so-?u-J\e-la:S- -nej-dP\i:f-naj-deZ-h\ut_S-ku-?a-?a-ta-ma-na:', '-')
% tgDuplicateTierMergeSegments(tgRead('demo/H.TextGrid'), 'phone', 1, 'syll', 'ja:-ci-P\ek-nu-tso-?u-J\e-la:S- -nej-dP\i:f-naj-deZ-h\ut_S-ku-?a-?a-ta-ma-na:', '-')
% tgDuplicateTierMergeSegments(tgRead('demo/H.TextGrid'), 'phone', 1, 'syll', 'ja:-ci-P\ek-nu-t_soa-?u-J\e-la:S- -nej-dP\i:f-naj-deZ-h\ut_S-ku-?a-?a-ta-ma-na:', '-')
% tgDuplicateTierMergeSegments(tgRead('demo/H.TextGrid'), 'phone', 1, 'syll', 'ja:-ci-P\ek-nu-t_so-?u-J\e-la:S--nej-dP\i:f-naj-deZ-h\ut_S-ku-?a-?a-ta-ma-na:', '-')
% tgDuplicateTierMergeSegments(tgRead('demo/H.TextGrid'), 'phone', 1, 'syll', 'ja:-ci-P\ek-nu-t_so-?u-J\e-la:S- -nej-dP\i:f-naj-deZ-h\ut_S-ku-?a-?a-ta-ma-na:-at', '-')
% tgDuplicateTierMergeSegments(tgRead('demo/H.TextGrid'), 'phone', 1, 'syll', 'ja:-nu-ci-P\ek-nu-t_so-?u-J\e-la:S- -nej-dP\i:f-naj-deZ-h\ut_S-ku-?a-?a-ta-ma-na:', '-')
% tgDuplicateTierMergeSegments(tgRead('demo/H.TextGrid'), 'phone', 1, 'syll', 'a:-ci-P\ek-nu-t_so-?u-J\e-la:S- -nej-dP\i:f-naj-deZ-h\ut_S-ku-?a-?a-ta-ma-na:', '-')

expect_error('tgDuplicateTierMergeSegments(tgRead(''demo/H.TextGrid''), ''phone'', 1, ''syll'', ''ja:-ci-P\ek-nu-t_so-?u-J\e-la:S- -nej-dP\i:f--naj-deZ-h\ut_S-ku-?a-?a-ta-ma-na:'', ''-'')');
% tg2 = tgDuplicateTierMergeSegments(tgRead('demo/H.TextGrid'), 'phone', 1, 'syll', 'ja:-ci-P\ek-nu-t_so-?u-J\e-la:S- -nej-dP\i:f--naj-deZ-h\ut_S-ku-?a-?a-ta-ma-na:', '-')
% tg2 = tgDuplicateTierMergeSegments(tgRead('demo/H.TextGrid'), 'phone', 1, 'syll', 'ja:----ci-P\ek----nu-t_so-?u-J\e-la:S- -nej-dP\i:f-naj-deZ-h\ut_S-ku-?a-?a-ta-ma-na:', '-')

expect_error('tgDuplicateTierMergeSegments(tgRead(''demo/H.TextGrid''), ''phone'', 1, ''syll'', ''ja:-ci-P\ek-nu-t_so-?u-J\e-la:S- -nej-dP\i:f-naj-deZ-h\ut_S-ku-?a-?a-ta-ma-na:'', '''')');
expect_error('tgDuplicateTierMergeSegments(tgRead(''demo/H.TextGrid''), ''phone'', 1, ''syll'', ''ja:-ci-P\ek-nu-t_so-?u-J\e-la:S- -nej-dP\i:f-naj-deZ-h\ut_S-ku-?a-?a-ta-ma-na:'', '' '')');
expect_error('tgDuplicateTierMergeSegments(tgRead(''demo/H.TextGrid''), ''phoneme'', 1, ''syll'', ''ja:ciP\eknut_souJ\ela:SnejdP\i:fnajdeZhut_Skuaatamana'', ''-'')');  % should not duplicate point tier
% tgDuplicateTierMergeSegments(tgRead('demo/H.TextGrid'), 'phone', 1, 'syll', 'ja:-ci-P\ek-nu-t_so-?u-J\e-la:S- -nej-dP\i:f-naj-deZ-h\ut_S-ku-?a-?a-ta-ma-na:', '')
% tgDuplicateTierMergeSegments(tgRead('demo/H.TextGrid'), 'phone', 1, 'syll', 'ja:-ci-P\ek-nu-t_so-?u-J\e-la:S- -nej-dP\i:f-naj-deZ-h\ut_S-ku-?a-?a-ta-ma-na:', ' ')
% tgDuplicateTierMergeSegments(tgRead('demo/H.TextGrid'), 'phoneme', 1, 'syll', 'ja:ciP\eknut_souJ\ela:SnejdP\i:fnajdeZhut_Skuaatamana', '-')  % should not duplicate point tier


tg = tgRead('demo/H.TextGrid');
pattern = 'ja:-ci-P\ek-nu-t_so-?u-J\e-la:S- -nej-dP\i:f-naj-deZ-h\ut_S-ku-?a-?a-ta-ma-na:';
tg2 = tgDuplicateTierMergeSegments(tg, 'phone', 1, 'syll', pattern, '-');
expect_equal({length(tg2.tier), tg2.tier{1}.name, length(tg2.tier{tgI(tg2, 'syll')}.Label) - length(tg2.tier{tgI(tg2, 'syllable')}.Label), ...
      sum(strcmp(tg2.tier{1}.Label, tg2.tier{4}.Label)), ... % one difference: pause ' ' != ''
      isequal(tg2.tier{tgI(tg2, 'syll')}.T1(2:22), tg2.tier{tgI(tg2, 'syllable')}.T1(2:22)), ...
      tg2.tier{tgI(tg2, 'syll')}.T1(1), ...
      isequal(tg2.tier{tgI(tg2, 'syll')}.T2, tg2.tier{tgI(tg2, 'syllable')}.T2), ...
      tg2.tier{tgI(tg2, 'syll')}.type}, ...
    {6, 'syll', 0, 21, true, 0.008, true, 'interval'});


disp('tgCut')
expect_error('tgCut(tgRead(''demo/maminka.TextGrid''), 3, 2)');

tg = tgRead('demo/cut.TextGrid');
tg1 = tgRead('demo/0.5-4p.TextGrid');
tg2 = tgCut(tg, 0.5, 4);
expect_equal(isequal(tg1, tg2), true);

tg1 = tgRead('demo/1.25-3.75p.TextGrid');
tg2 = tgCut(tg, 1.25, 3.75);
expect_equal(isequal(tg1, tg2), true);

tg1 = tgRead('demo/1.5-3.5p.TextGrid');
tg2 = tgCut(tg, 1.5, 3.5);
expect_equal(isequal(tg1, tg2), true);

tg1 = tgRead('demo/1-4p.TextGrid');
tg2 = tgCut(tg, 1, 4);
expect_equal(isequal(tg1, tg2), true);

tg1 = tgRead('demo/-1-6p.TextGrid');
tg2 = tgCut(tg, -1, 6);
expect_equal(isequal(tg1, tg2), true);

tg1 = tgRead('demo/0-3p.TextGrid');
tg2 = tgCut(tg, -Inf, 3);
expect_equal(isequal(tg1, tg2), true);

tg1 = tgRead('demo/3-5p.TextGrid');
tg2 = tgCut(tg, 3);
expect_equal(isequal(tg1, tg2), true);

tg2 = tgCut(tg, -Inf, -1);
expect_equal([tgGetStartTime(tg2), tgGetEndTime(tg2)], [-1, -1]);

tg2 = tgCut(tg, 6);
expect_equal([tgGetStartTime(tg2), tgGetEndTime(tg2)], [6, 6]);


disp('tgCut0')
expect_error('tgCut0(tgRead(''demo/maminka.TextGrid''), 3, 2)');

tg = tgRead('demo/cut.TextGrid');
tg1 = tgRead('demo/0.5-4.TextGrid');
tg2 = tgCut0(tg, 0.5, 4);
expect_equal(isequal(tg1, tg2), true);

tg1 = tgRead('demo/1.25-3.75.TextGrid');
tg2 = tgCut0(tg, 1.25, 3.75);
expect_equal(isequal(tg1, tg2), true);

tg1 = tgRead('demo/1.5-3.5.TextGrid');
tg2 = tgCut0(tg, 1.5, 3.5);
expect_equal(isequal(tg1, tg2), true);

tg1 = tgRead('demo/1-4.TextGrid');
tg2 = tgCut0(tg, 1, 4);
expect_equal(isequal(tg1, tg2), true);

tg1 = tgRead('demo/-1-6.TextGrid');
tg2 = tgCut0(tg, -1, 6);
expect_equal(isequal(tg1, tg2), true);

tg1 = tgRead('demo/0-3.TextGrid');
tg2 = tgCut0(tg, -Inf, 3);
expect_equal(isequal(tg1, tg2), true);

tg1 = tgRead('demo/3-5.TextGrid');
tg2 = tgCut0(tg, 3);
expect_equal(isequal(tg1, tg2), true);

tg2 = tgCut0(tg, -Inf, -1);
expect_equal([tgGetStartTime(tg2), tgGetEndTime(tg2)], [0, 0]);

tg2 = tgCut0(tg, 6);
expect_equal([tgGetStartTime(tg2), tgGetEndTime(tg2)], [0, 0]);



disp('Pitch')

disp('pitchRead')
p = pitchRead('demo/sound.Pitch');
expect_equal(...
    {p.xmin, p.xmax, p.nx, p.dx, p.x1, length(p.t), p.t(1), p.t(2), p.t(508), p.ceiling, p.maxnCandidates, length(p.frame), p.frame{4}.intensity, ...
      p.frame{4}.nCandidates, length(p.frame{4}.frequency), length(p.frame{4}.strength), p.frame{4}.frequency(1), p.frame{4}.frequency(2), ...
      p.frame{4}.frequency(3), p.frame{4}.frequency(4), p.frame{4}.strength(1), p.frame{4}.strength(2), p.frame{4}.strength(3), ...
      p.frame{4}.strength(4), p.frame{508}.intensity, p.frame{508}.nCandidates, length(p.frame{508}.frequency), length(p.frame{508}.strength), ...
      p.frame{508}.frequency(1), p.frame{508}.strength(1)}, ...
      {0, 5.112, 508, 0.01, 0.021000000000000015, 508, 0.021000000000000015, 0.031000000000000015, 5.091000000000000015, 600, 15, 508, 6.35938550499208e-005, ...
      4, 4, 4, 0, 6252.408223974137, 3392.821528656231, 1197.0707582170926, 0, 0.3169408893924507, 0.2917449063347636, 0.2758620333629818, 0, 1, 1, 1, 0, 0});
 
p = pitchRead('demo/sound.Pitch');
p2 = pitchRead('demo/sound_short.Pitch');
p3 = pitchRead('demo/sound_UTF16.Pitch', 'UTF-16');
expect_equal({isequal(p, p2), isequal(p, p3)}, {true, true});


disp('Formant')

disp('formantRead')
f = formantRead('demo/maminka.Formant');
expect_equal(...
    {f.xmin, f.xmax, f.nx, f.dx, f.x1, length(f.t), f.t(1), f.t(2), f.t(80), f.maxnFormants, length(f.frame), f.frame{4}.intensity, ...
          f.frame{4}.nFormants, length(f.frame{4}.frequency), length(f.frame{4}.bandwidth), f.frame{4}.frequency(1), f.frame{4}.frequency(2), ...
          f.frame{4}.frequency(3), f.frame{4}.frequency(4), f.frame{4}.frequency(5), f.frame{4}.bandwidth(1), f.frame{4}.bandwidth(2), f.frame{4}.bandwidth(3), ...
          f.frame{4}.bandwidth(4), f.frame{4}.bandwidth(5), f.frame{80}.intensity, f.frame{80}.nFormants, length(f.frame{80}.frequency), length(f.frame{80}.bandwidth), ...
          f.frame{80}.frequency(1), f.frame{80}.frequency(2), f.frame{80}.frequency(3), f.frame{80}.frequency(4), ...
          f.frame{80}.bandwidth(1), f.frame{80}.bandwidth(2), f.frame{80}.bandwidth(3), f.frame{80}.bandwidth(4)}, ...
          {0, 0.5460770975056689, 80, 0.00625, 0.026163548752834397, 80, 0.026163548752834397, 0.032413548752834397, 0.5199135487528345, 5, 80, 1.033142541089274e-005, ...
          5, 5, 5, 192.48696491636466, 1479.2446721696026, 2883.3496059581475, 3969.3756273121708, 5231.531927706885, 234.84667765707806, 295.1069753187278, ...
          160.23124588560367, 452.2355186981254, 1242.9009292690093, 0.0017737676385123245, 4, 4, 4, 601.9084470780567, 1790.5091315894167, ...
          2896.3679369463307, 4329.2993398040635, 147.158951399607, 272.26394394370794, 723.7529213211043, 361.80775918364697});
         
f = formantRead('demo/maminka.Formant');
f2 = formantRead('demo/maminka_short.Formant');
f3 = formantRead('demo/maminka_UTF16.Formant', 'UTF-16');
expect_equal({isequal(f, f2), isequal(f, f3)}, {true, true});



disp('Collection')

disp('colRead')
c1 = colRead('demo/coll_short.Collection');
it = itRead('demo/1.IntensityTier');
pitch = pitchRead('demo/sound.Pitch');
pt = ptRead('demo/H.PitchTier');
tg = tgRead('demo/HC101bA.TextGrid');
formant = formantRead('demo/maminka.Formant');

expect_equal({length(c1), c1{1}.type, c1{1}.name, c1{2}.type, c1{2}.name, c1{3}.type, c1{3}.name, c1{4}.type, c1{4}.name, c1{5}.type, c1{5}.name}, ...
    {5, 'IntensityTier', '1', 'TextGrid', 'HC101bA', 'Pitch 1', 'sound_short', 'PitchTier', 'H_shortTextFile', 'Formant 2', 'maminka'});
expect_equal([isequal(c1{1}.t, it.t), isequal(c1{1}.i, it.i), isequal(c1{1}.tmin, it.tmin), isequal(c1{1}.tmax, it.tmax), ...
          isequal(length(c1{2}.tier), length(tg.tier)), isequal(c1{2}.tier{1}, tg.tier{1}), isequal(c1{2}.tier{2}, tg.tier{2}), isequal(c1{2}.tier{3}, tg.tier{3}), isequal(c1{2}.tier{4}, tg.tier{4}), ...
          isequal(c1{3}.xmin, pitch.xmin), isequal(c1{3}.xmax, pitch.xmax), isequal(c1{3}.nx, pitch.nx), isequal(c1{3}.dx, pitch.dx), ...
                   isequal(c1{3}.x1, pitch.x1), isequal(c1{3}.t, pitch.t), isequal(c1{3}.ceiling, pitch.ceiling), isequal(c1{3}.maxnCandidates, pitch.maxnCandidates), isequal(c1{3}.frame, pitch.frame), ...
          isequal(c1{4}.t, pt.t), isequal(c1{4}.f, pt.f), isequal(c1{4}.tmin, pt.tmin), isequal(c1{4}.tmax, pt.tmax), ...
          isequal(c1{5}.x1, formant.x1), isequal(c1{5}.t, formant.t), isequal(c1{5}.maxnFormants, formant.maxnFormants), isequal(c1{5}.frame, formant.frame)], ...
          [true, true, true, true, true, true, true, true, true, true, true, true, true, true, true, true, true, true, true, true, true, true, true, true, true, true]);
c1 = colRead('demo/coll_short.Collection');
c2 = colRead('demo/coll_text.Collection');
c3 = colRead('demo/coll_text_UTF16.Collection', 'UTF-16');
expect_equal(isequal(c1, c2), true);
expect_equal(isequal(c2, c3), true);



disp('isSomething')

disp('isInt works')
expect_equal(isInt(2), true);
expect_equal(isInt(int16(2)), true);
expect_equal(isInt(-2), true);
expect_equal(isInt(int16(-2)), true);
expect_equal(isInt(2.1), false);
expect_equal(isInt(-2.1), false);
expect_equal(isInt(1:5), false);
expect_equal(isInt([]), false);


disp('round2')

disp('round2 works')
expect_equal(round2(23.5), 24);
expect_equal(round2(23.4), 23);
expect_equal(round2(24.5), 25);
expect_equal(round2(-23.5), -24);
expect_equal(round2(-23.4), -23);
expect_equal(round2(-24.5), -25);
expect_equal(round2(123.456, -1), 123.5);
expect_equal(round2(123.456, -2), 123.46);
expect_equal(round2(123.456, 1), 120);
expect_equal(round2(123.456, 2), 100);
expect_equal(round2(123.456, 3), 0);
expect_equal(round2(-123.456, -1), -123.5);
expect_equal(round2(-123.456, -2), -123.46);
expect_equal(round2(-123.456, 1), -120);
expect_equal(round2(-123.456, 2), -100);
expect_equal(round2(-123.456, 3), 0);
expect_equal(round2(NaN), NaN);
expect_equal(round2([0.3, 2, pi]), [0, 2, 3]);


disp('ifft')

disp('ifft works')
expect_equal(real(ifft(3)), 3);
expect_equal(imag(ifft(3)), 0);
expect_equal(ifft(fft(1:5)), 1:5);


disp('ok.')
disp('-----------')