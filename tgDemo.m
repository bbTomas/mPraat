close all
clear all
clc

tg = tgRead('demo/H.TextGrid');

tg = tgInsertNewIntervalTier(tg, 1, 'moje');
tg = tgInsertBoundary(tg, 1, 1, 'ahoj');
tg = tgInsertBoundary(tg, 1, 2);
tg = tgInsertBoundary(tg, 1, 3, 'uživateli');
tg = tgInsertBoundary(tg, 1, 3.5);

pocitadloE = 0;
pocitadloVokaly = 0;
for I = 1: tgGetNumberOfIntervals(tg, 3)
    lab = tgGetLabel(tg, 3, I);
    
    if strcmp(lab, 'a') || strcmp(lab, 'a:')
        pocitadloE = pocitadloE + 1;
    end
    if ~isempty(strfind('i:e:a:o:u:', lab)) % krátké i dlouhé vokály
        pocitadloVokaly = pocitadloVokaly + 1;
        trvani = tgGetIntervalDuration(tg, 3, I);
        fprintf([num2str(pocitadloVokaly) '. vokál [' lab ']\ttrvá\t' num2str(round2(trvani*1000, -1), '%05.1f') ' ms.\n']);
    end
end

tgPlot(tg)
disp(['Nalezeno ' num2str(pocitadloE) ' a-ových vokálù a ' num2str(pocitadloVokaly) ' vokálù celkovì.'])

tg = tgInsertInterval(tg, 1, -0.5, -0.25, 'tady'); % vložení mimo vlevo + automatický prázdný interval jako výplò
tg = tgInsertInterval(tg, 1, -1, -0.5, 'Tak'); % vložení mimo vlevo plnì navazující
tg = tgInsertInterval(tg, 1, 0, 0.25, 'to'); % vložení do existujícího intervalu úplnì nalevo (vznikne jen jedna nová hranice)
tg = tgInsertInterval(tg, 1, 0.75, 1, 'je:'); % vložení do existujícího intervalu úplnì napravo (vznikne jen jedna nová hranice)
tg = tgInsertInterval(tg, 1, 2.25, 2.75, 'vážený'); % vložení do existujícího intervalu doprostøed (vzniknou dvì nové hranice)
tg = tgInsertInterval(tg, 1, 3.616, 4, 'teèka'); % vložení mimo vpravo plnì navazující
tg = tgInsertInterval(tg, 1, 4.25, 4.5, 'konec'); % vložení mimo vpravo + automatický prázdný interval jako výplò

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

