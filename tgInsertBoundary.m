function tgNew = tgInsertBoundary(tg, tierInd, time, label)
% function tgNew = tgInsertBoundary(tg, tierInd, time, label)
% Vloží novou hranici do IntervalTier, èímž vždy vznikne nový interval,
% kterému je pøiøazen label (nepovinný parametr) èi zùstane s prázdným
% labelem.
% Možné jsou rùzné situace umístìní nové hranice:
% a) Do již existujícího intervalu:
%    Interval se novou hranicí rozdìlí na dvì èásti. Levá si zachová
%    label pùvodního intervalu, pravé je nastaven nepovinný nový label.
%
% b) Vlevo od existujících intervalù:
%    Nový interval zaèíná zadanou hranicí a konèí v místì zaèátku prvního
%    již døíve existujícího intervalu. Novéme intervalu je nastaven
%    nepovinný nový label.
%
% c) Vpravo od existujících intervalù:
%    Nový interval zaèíná v místì konce posledního již existujícího
%    intervalu a konèí zadanou novou hranicí. Tomuto novém intervalu je
%    nastaven nepovinný nový label. Situace je tak tedy ponìkud odlišná od
%    situací a) a b), kde nový label byl nastavován vždy intervalu, který
%    ležel napravo od nové hranice. V situaci c) leží label naopak nalevo
%    od hranice. Ale je to jediná logická možnost ve smyslu pøidávání
%    nových intervalù za konec již existujících.
%
% Situace, kdy by se vkládala hranice mezi existující intervaly na pozici,
% kde ještì žádný interval není, není z hlediska logiky Praatu možná.
% Není totiž pøípustné, aby existoval jeden interval, pak nic, a pak další interval.
% Nic mezi intervaly Praat dùslednì znaèí jako interval s prázdným labelem.
% Nová vrstva IntervalTier vždy obsahuje prázdný interval
% pøes celou dobu trvání. Tento interval je možné hranicemi dìlit na
% podintervaly èi rozšiøovat na obì strany. Mezery bez intervalù tak
% nemohou vzniknout.
%
% v1.0, Tomáš Boøil, borilt@gmail.com

if nargin < 3 || nargin > 4
    error('Wrong number of arguments.')
end
if nargin == 3
    label = '';
end

% if ~isInt(tierInd)
%     error(['index tier musí být celé èíslo od 1 výše [' num2str(tierInd) ']']);
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
    if time > tg.tier{tierInd}.T2(end)   % pøípad c) vpravo od existujících intervalù
        tgNew.tier{tierInd}.T1(nint+1) = tg.tier{tierInd}.T2(nint);
        tgNew.tier{tierInd}.T2(nint+1) = time;
        tgNew.tier{tierInd}.Label{nint+1} = label;
        tgNew.tmax = max(tg.tmax, time);
    elseif time < tg.tier{tierInd}.T1(1) % pøípad b) vlevo od existujících intervalù
        for I = nint: -1: 1
            tgNew.tier{tierInd}.T1(I+1) = tgNew.tier{tierInd}.T1(I);
            tgNew.tier{tierInd}.T2(I+1) = tgNew.tier{tierInd}.T2(I);
            tgNew.tier{tierInd}.Label{I+1} = tgNew.tier{tierInd}.Label{I};
        end
        tgNew.tier{tierInd}.T1(1) = time;
        tgNew.tier{tierInd}.T2(1) = tgNew.tier{tierInd}.T1(2);
        tgNew.tier{tierInd}.Label{1} = label;
        tgNew.tmin = min(tg.tmin, time);
    elseif time == tg.tier{tierInd}.T2(end) % pokus o nesmyslné vložení hranice pøesnì na konec tier
        error(['cannot insert boundary because it already exists at the same position (tierInd ' num2str(tierInd) ', time ' num2str(time) ')'])
    else
        error('strange situation, cannot find any interval and ''time'' is between intervals.')
    end
else % pøípad a) do již existujícího intervalu
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
