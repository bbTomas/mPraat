close all
clear all
clc

tg = tgRead('demo/H.TextGrid');

tg = tgInsertNewIntervalTier(tg, 1, 'moje');
tg = tgInsertBoundary(tg, 1, 1, 'ahoj');
tg = tgInsertBoundary(tg, 1, 2);
tg = tgInsertBoundary(tg, 1, 3, 'uzivateli');
tg = tgInsertBoundary(tg, 1, 3.5);

pocitadloE = 0;
pocitadloVokaly = 0;
for I = 1: tgGetNumberOfIntervals(tg, 3)
    lab = tgGetLabel(tg, 3, I);
    
    if strcmp(lab, 'a') || strcmp(lab, 'a:')
        pocitadloE = pocitadloE + 1;
    end
    if ~isempty(strfind('i:e:a:o:u:', lab)) % kratke i dlouhe vokaly
        pocitadloVokaly = pocitadloVokaly + 1;
        trvani = tgGetIntervalDuration(tg, 3, I);
        fprintf([num2str(pocitadloVokaly) '. vokal [' lab ']\ttrva\t' num2str(round2(trvani*1000, -1), '%05.1f') ' ms.\n']);
    end
end

tgPlot(tg)
disp(['Nalezeno ' num2str(pocitadloE) ' a-ovych vokalu a ' num2str(pocitadloVokaly) ' vokalu celkove.'])

tg = tgInsertInterval(tg, 1, -0.5, -0.25, 'tady'); % vlozeni mimo vlevo + automaticky prazdny interval jako vypln
tg = tgInsertInterval(tg, 1, -1, -0.5, 'Tak'); % vlozeni mimo vlevo plne navazujici
tg = tgInsertInterval(tg, 1, 0, 0.25, 'to'); % vlozeni do existujiciho intervalu uplne nalevo (vznikne jen jedna nova hranice)
tg = tgInsertInterval(tg, 1, 0.75, 1, 'je:'); % vlozeni do existujiciho intervalu uplne napravo (vznikne jen jedna nova hranice)
tg = tgInsertInterval(tg, 1, 2.25, 2.75, 'vazeny'); % vlozeni do existujiciho intervalu doprostred (vzniknou dve nove hranice)
tg = tgInsertInterval(tg, 1, 3.616, 4, 'tecka'); % vlozeni mimo vpravo plne navazujici
tg = tgInsertInterval(tg, 1, 4.25, 4.5, 'konec'); % vlozeni mimo vpravo + automaticky prazdny interval jako vypln

figure, tgPlot(tg)

tgWrite(tg, 'demo/vystup.TextGrid')


tg = tgRead('demo/H.TextGrid');
figure
[snd, fs] = audioread('demo/H.wav');
t = 0: 1/fs: (length(snd)-1)/fs;
subplot(tgGetNumberOfTiers(tg) + 1, 1, 1)
plot(t, snd, 'k')
axis([t(1) t(end) -1 1])
tgPlot(tg, 2)
subplot(tgGetNumberOfTiers(tg) + 1, 1, 3)
hold on
plot(t, snd, 'k')
axis([t(1) t(end) -1 2])
hold off

tgProblem = tgRead('demo/H_problem.TextGrid');
tgNew = tgRepairContinuity(tgProblem);
tgNew2 = tgRepairContinuity(tgNew);

