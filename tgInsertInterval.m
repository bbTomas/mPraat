function tgNew = tgInsertInterval(tg, tierInd, tStart, tEnd, label)
% function tgNew = tgInsertInterval(tg, tierInd, tStart, tEnd, label)
% Vlozi novy interval do prazdneho mista v IntervalTier, tedy
% a) Do jiz existujiciho intervalu (musi mit prazdny label):
%    Nejcastejsi pripad, protoze samotna nova vrstva IntervalTier je cela
%    jeden prazdny interval od zacatku do konce.
% b) Mimo existujici intervaly nalevo ci napravo, vznikla mezera bude
%    zaplnena prazdnym intervalem.
% Intervalu tStart az tEnd je prirazen label (nepovinny parametr) ci zustane
% s prazdnym labelem.
%
% Tato funkce je ve vetsine pripadu totez, jako 1. tgInsertBoundary(tEnd)
% a 2. tgInsertBoundary(tStart, novy label). Ale navic je provadena kontrola,
% a) zda tStart a tEnd nalezeji do stejneho puvodniho prazdneho intervalu,
% b) nebo jsou oba mimo existujici intervaly nalevo ci napravo.
%
% Pruniky noveho intervalu s vice jiz existujicimi i prazdnymi intervaly
% nedavaji smysl a jsou zakazany.
%
% Je treba si uvedomit, ze ve skutecnosti tato funkce casto
% vytvari vice intervalu. Napr. mame zcela novou IntervalTier s jednim prazdnym
% intervalem 0 az 5 sec. Vlozime interval 1 az 2 sec s labelem 'rekl'.
% Vysledkem jsou tri intervaly: 0-1 '', 1-2 'rekl', 2-5 ''.
% Pak znovu vlozime touto funkci interval 7 az 8 sec s labelem 'ji',
% vysledkem bude pet intervalu: 0-1 '', 1-2 'rekl', 2-5 '', 5-7 '' (vklada se
% jako vypln, protoze jsme mimo rozsah puvodni vrstvy), 7-8 'ji'.
% Pokud vsak nyni vlozime interval presne 2 az 3 'to', prida se ve
% skutecnosti jen jeden interval, kde se vytvori prava hranice intervalu a
% leva se jen napoji na jiz existujici, vysledkem bude sest intervalu:
% 0-1 '', 1-2 'rekl', 2-3 'to', 3-5 '', 5-7 '', 7-8 'ji'.
% Muze take nastat situace, kdy nevytvori zadny novy interval, napr. kdyz
% do predchoziho vlozime interval 3 az 5 'asi'. Tim se pouze puvodne prazdnemu
% intervalu 3-5 nastavi label na 'asi', vysledkem bude opet jen sest intervalu:
% 0-1 '', 1-2 'rekl', 2-3 'to', 3-5 'asi', 5-7 '', 7-8 'ji'.
%
% Tato funkce v Praatu neni, zde je navic a je vhodna pro situace,
% kdy chceme napr. do prazdne IntervalTier pridat nekolik oddelenych intervalu
% (napr. intervaly detekovane recove aktivity).
% Naopak neni zcela vhodna pro pridavani na sebe primo napojenych
% intervalu (napr. postupne segmentujeme slovo na jednotlive navazujici
% hlasky), protoze kdyz napr. vlozime intervaly 1 az 2.1 a 2.1 az 3,
% kde obe hodnoty 2.1 byly vypocteny samostatne a diky zaokrouhlovacim chybam
% se zcela presne nerovnaji, ve skutecnosti tim vznikne bud jeste prazdny
% interval 'priblizne' 2.1 az 2.1, coz nechceme, a nebo naopak funkce skonci
% s chybou, ze tStart je vetsi nez tEnd, pokud zaokrouhleni dopadlo opacne.
% Pokud vsak hranice byla spoctena jen jednou a ulozena do promenne, ktera
% byla pouzita jako konecna hranice predchazejiciho intervalu, a zaroven jako
% pocatecni hranice noveho intervalu, nemel by byt problem a novy interval
% se vytvori jako napojeni bez vlozeneho 'mikrointervalu'.
% Kazdopadne, bezpecnejsi pro takove ucely je zpusob, jak se postupuje
% v Praatu, tedy vlozit hranici se  zacatkem prvni hlasky pomoci
% tgInsertBoundary(cas, labelHlasky), pak stejne casy zacatku a labely vsech
% nasledujicich hlasek, a nakonec vlozit jeste konecnou hranici posledni hlasky
% (tedy jiz bez labelu) pomoci tgInsertBoundary(cas).
%
% v1.0, Tomas Boril, borilt@gmail.com

if nargin < 4 || nargin > 5
    error('Wrong number of arguments.')
end
if nargin == 4
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

if tStart >= tEnd
    error(['tStart [' num2str(tStart) '] must be lower than tEnd [' num2str(tEnd) ']']);
end
% pozn. diky teto podmince nemohou nastat nektere situace podchycene nize
% (tStart == tEnd), leccos se tim zjednodusuje a Praat stejne nedovoluje
% mit dve hranice ve stejnem case, takze je to alespon kompatibilni.

% tgNew = tg;

nint = length(tg.tier{tierInd}.T1);
if nint == 0
    % Zvlastni situace, tier nema ani jeden interval.
    tgNew = tg;
    tgNew.tier{tierInd}.T1 = tStart;
    tgNew.tier{tierInd}.T2 = tEnd;
    tgNew.tier{tierInd}.Label{1} = label;
    tgNew.tmin = min(tgNew.tmin, tStart);
    tgNew.tmax = max(tgNew.tmax, tEnd);
    return
end

tgNalevo = tg.tier{tierInd}.T1(1);
tgNapravo = tg.tier{tierInd}.T2(end);
if tStart < tgNalevo && tEnd < tgNalevo
%     disp('vkladam uplne nalevo + prazdny interval jako vypln')
    tgNew = tgInsertBoundary(tg, tierInd, tEnd);
    tgNew = tgInsertBoundary(tgNew, tierInd, tStart, label);
    return
elseif tStart <= tgNalevo && tEnd == tgNalevo
%     disp('vkladam uplne nalevo, plynule navazuji')
    tgNew = tgInsertBoundary(tg, tierInd, tStart, label);
    return
elseif tStart < tgNalevo && tEnd > tgNalevo
    error(['intersection of new interval (' num2str(tStart) ' to ' num2str(tEnd) ' sec, ''' label ''') and several others already existing (region outside ''left'' and the first interval) is forbidden'])
elseif tStart > tgNapravo && tEnd > tgNapravo %%
%     disp('vkladam uplne napravo + prazdny interval jako vypln')
    tgNew = tgInsertBoundary(tg, tierInd, tEnd);
    tgNew = tgInsertBoundary(tgNew, tierInd, tStart, label);
    return
elseif tStart == tgNapravo && tEnd >= tgNapravo
%     disp('vkladam uplne napravo, plynule navazuji')
    tgNew = tgInsertBoundary(tg, tierInd, tEnd, label);
    return
elseif tStart < tgNapravo && tEnd > tgNapravo
    error(['intersection of new interval (' num2str(tStart) ' to ' num2str(tEnd) ' sec, ''' label ''') and several others already existing (the last interval and region outside ''right'') is forbidden'])
elseif tStart >= tgNalevo && tEnd <= tgNapravo
    % disp('vkladani nekam do jiz existujici oblasti, nutna kontrola stejneho a prazdneho intervalu')
    % nalezeni vsech intervalu, kam casy spadaji - pokud se trefime na
    % hranici, muze totiz cas nalezet dvema intervalum
    iStart = [];
    iEnd = [];
    for I = 1: nint
        if tStart >= tg.tier{tierInd}.T1(I) && tStart <= tg.tier{tierInd}.T2(I)
            iStart = [iStart I];
        end
        if tEnd >= tg.tier{tierInd}.T1(I) && tEnd <= tg.tier{tierInd}.T2(I)
            iEnd = [iEnd I];
        end
    end
    if ~(length(iStart) == 1 && length(iEnd) == 1)
        prunik = intersect(iStart, iEnd); % nalezeni spolecneho intervalu z vice moznych variant
        if isempty(prunik)
            % je to chyba, ale ta bude zachycena dale podminkou 'if iStart == iEnd'
            iStart = iStart(end);
            iEnd = iEnd(1);
        else
            iStart = prunik(1);
            iEnd = prunik(1);
            if length(prunik) > 1 % pokus o nalezeni prvniho vhodneho kandidata
                for I = 1: length(prunik)
                    if isempty(tg.tier{tierInd}.Label{prunik(I)})
                        iStart = prunik(I);
                        iEnd = prunik(I);
                        break;
                    end
                end
            end
        end
    end
    if iStart == iEnd
        if isempty(tg.tier{tierInd}.Label{iStart})
%             disp('vkladam dovnitr intervalu, otazka, zda napojit ci ne')
            t1 = tg.tier{tierInd}.T1(iStart);
            t2 = tg.tier{tierInd}.T2(iStart);
            if tStart == t1 && tEnd == t2
%                 disp('jenom nastavim jiz existujicimu prazdnemu intervalu label');
                tgNew = tg;
                tgNew.tier{tierInd}.Label{iStart} = label;
                return
%             elseif tStart == t1 && tEnd == t1
%                 disp('puvodnimu intervalu nastavim label a vlozim jednu hranici do t1, tim vznikne novy nulovy interval na zacatku s novym labelem a cely puvodni interval bude stale prazdny')
%             elseif tStart == t2 && tEnd == t2
%                 disp('vlozim jednu hranici do t2 s novym labelem, tim zustane puvodni cely prazdny interval a vznikne novy nulovy interval na konci s novym labelem')
            elseif tStart == t1 && tEnd < t2
%                 disp('puvodnimu intervalu nastavim label a vlozim jednu hranici do tEnd, tim se puvodni interval rozdeli na dve casti, prvni bude mit novy label, druha zustane prazdna')
                tgNew = tg;
                tgNew.tier{tierInd}.Label{iStart} = label;
                tgNew = tgInsertBoundary(tgNew, tierInd, tEnd);
                return
            elseif tStart > t1 && tEnd == t2
%                 disp('vlozim jednu hranici do tStart s novym labelem, tim se puvodni interval rozdeli na dve casti, prvni zustane prazdna a druha bude mit novy label')
                tgNew = tgInsertBoundary(tg, tierInd, tStart, label);
                return
            elseif tStart > t1 && tEnd < t2
%                 disp('vlozim hranici do tEnd s prazdnym labelem, a pak vlozim hranici do tStart s novym labelem, tim se puvodni interval rozdeli na tri casti, prvni a posledni budou prazdne, prostredni bude mit novy label')
                tgNew = tgInsertBoundary(tg, tierInd, tEnd);
                tgNew = tgInsertBoundary(tgNew, tierInd, tStart, label);
            else
                error('Logical error in this function, this situation must not happened. Contact author, but please, be kind, he is really sorry this happened.')
            end
        else
            error(['Cannot insert new interval (' num2str(tStart) ' to ' num2str(tEnd) ' sec, ''' label ''') into the interval with a non-empty label (' num2str(tg.tier{tierInd}.T1(iStart)) ' to ' num2str(tg.tier{tierInd}.T2(iStart)) ' sec, ''' tg.tier{tierInd}.Label{iStart} '''), it is forbidden.'])
        end
    else
        error(['intersection of new interval (' num2str(tStart) ' to ' num2str(tEnd) ' sec, ''' label ''') and several others already existing (indices ' num2str(iStart) ' to ' num2str(iEnd) ') is forbidden'])
    end
else
    error('Logical error in this function, this situation must not happened. Contact author, but please, be kind, he is really sorry this happened.')
end

return
