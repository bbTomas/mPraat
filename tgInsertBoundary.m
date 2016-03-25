function tgNew = tgInsertBoundary(tg, tierInd, time, label)
% function tgNew = tgInsertBoundary(tg, tierInd, time, label)
% Vlozi novou hranici do IntervalTier, cimz vzdy vznikne novy interval,
% kteremu je prirazen label (nepovinny parametr) ci zustane s prazdnym
% labelem.
% Mozne jsou ruzne situace umisteni nove hranice:
% a) Do jiz existujiciho intervalu:
%    Interval se novou hranici rozdeli na dve casti. Leva si zachova
%    label puvodniho intervalu, prave je nastaven nepovinny novy label.
%
% b) Vlevo od existujicich intervalu:
%    Novy interval zacina zadanou hranici a konci v miste zacatku prvniho
%    jiz drive existujiciho intervalu. Noveme intervalu je nastaven
%    nepovinny novy label.
%
% c) Vpravo od existujicich intervalu:
%    Novy interval zacina v miste konce posledniho jiz existujiciho
%    intervalu a konci zadanou novou hranici. Tomuto novem intervalu je
%    nastaven nepovinny novy label. Situace je tak tedy ponekud odlisna od
%    situaci a) a b), kde novy label byl nastavovan vzdy intervalu, ktery
%    lezel napravo od nove hranice. V situaci c) lezi label naopak nalevo
%    od hranice. Ale je to jedina logicka moznost ve smyslu pridavani
%    novych intervalu za konec jiz existujicich.
%
% Situace, kdy by se vkladala hranice mezi existujici intervaly na pozici,
% kde jeste zadny interval neni, neni z hlediska logiky Praatu mozna.
% Neni totiz pripustne, aby existoval jeden interval, pak nic, a pak dalsi interval.
% Nic mezi intervaly Praat dusledne znaci jako interval s prazdnym labelem.
% Nova vrstva IntervalTier vzdy obsahuje prazdny interval
% pres celou dobu trvani. Tento interval je mozne hranicemi delit na
% podintervaly ci rozsirovat na obe strany. Mezery bez intervalu tak
% nemohou vzniknout.
%
% v1.0, Tomas Boril, borilt@gmail.com

if nargin < 3 || nargin > 4
    error('Wrong number of arguments.')
end
if nargin == 3
    label = '';
end

% if ~isInt(tierInd)
%     error(['index tier musi byt cele cislo od 1 vyse [' num2str(tierInd) ']']);
% end
tierInd = tgI(tg, tierInd);

% ntiers = tgGetNumberOfTiers(tg);
% if tierInd < 1 || tierInd>ntiers
%     error(['index tier mimo rozsah, tierInd = ' num2str(tierInd) ', ntiers = ' num2str(ntiers)]);
% end
if ~tgIsIntervalTier(tg, tierInd)
    error(['tier ' num2str(tierInd) ' is not IntervalTier']);
end

tgNew = tg;

index = tgGetIntervalIndexAtTime(tg, tierInd, time);
nint = tgGetNumberOfIntervals(tg, tierInd);

if nint == 0
    error('strange situation, tier does not have any interval.')
end

if isnan(index)
    if time > tg.tier{tierInd}.T2(end)   % pripad c) vpravo od existujicich intervalu
        tgNew.tier{tierInd}.T1(nint+1) = tg.tier{tierInd}.T2(nint);
        tgNew.tier{tierInd}.T2(nint+1) = time;
        tgNew.tier{tierInd}.Label{nint+1} = label;
        tgNew.tmax = max(tg.tmax, time);
    elseif time < tg.tier{tierInd}.T1(1) % pripad b) vlevo od existujicich intervalu
        for I = nint: -1: 1
            tgNew.tier{tierInd}.T1(I+1) = tgNew.tier{tierInd}.T1(I);
            tgNew.tier{tierInd}.T2(I+1) = tgNew.tier{tierInd}.T2(I);
            tgNew.tier{tierInd}.Label{I+1} = tgNew.tier{tierInd}.Label{I};
        end
        tgNew.tier{tierInd}.T1(1) = time;
        tgNew.tier{tierInd}.T2(1) = tgNew.tier{tierInd}.T1(2);
        tgNew.tier{tierInd}.Label{1} = label;
        tgNew.tmin = min(tg.tmin, time);
    elseif time == tg.tier{tierInd}.T2(end) % pokus o nesmyslne vlozeni hranice presne na konec tier
        error(['cannot insert boundary because it already exists at the same position (tierInd ' num2str(tierInd) ', time ' num2str(time) ')'])
    else
        error('strange situation, cannot find any interval and ''time'' is between intervals.')
    end
else % pripad a) do jiz existujiciho intervalu
    for I = 1: nint
        if ~isempty(find(tgNew.tier{tierInd}.T1 == time, 1)) || ~isempty(find(tgNew.tier{tierInd}.T2 == time, 1))
            error(['cannot insert boundary because it already exists at the same position (tierInd ' num2str(tierInd) ', time ' num2str(time) ')'])
        end
    end
    
    for I = nint: -1: index+1
        tgNew.tier{tierInd}.T1(I+1) = tgNew.tier{tierInd}.T1(I);
        tgNew.tier{tierInd}.T2(I+1) = tgNew.tier{tierInd}.T2(I);
        tgNew.tier{tierInd}.Label{I+1} = tgNew.tier{tierInd}.Label{I};
    end
    tgNew.tier{tierInd}.T1(index) = tg.tier{tierInd}.T1(index);
    tgNew.tier{tierInd}.T2(index) = time;
    tgNew.tier{tierInd}.Label{index} = tg.tier{tierInd}.Label{index};
    tgNew.tier{tierInd}.T1(index+1) = time;
    tgNew.tier{tierInd}.T2(index+1) = tg.tier{tierInd}.T2(index);
    tgNew.tier{tierInd}.Label{index+1} = label;
end
