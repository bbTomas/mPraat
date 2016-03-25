function tgNew = tgInsertInterval(tg, tierInd, tStart, tEnd, label)
% function tgNew = tgInsertInterval(tg, tierInd, tStart, tEnd, label)
% Vloží nový interval do prázdného místa v IntervalTier, tedy
% a) Do již existujícího intervalu (musí mít prázdný label):
%    Nejèastìjší pøípad, protože samotná nová vrstva IntervalTier je celá
%    jeden prázdný interval od zaèátku do konce.
% b) Mimo existující intervaly nalevo èi napravo, vzniklá mezera bude
%    zaplnìna prázdným intervalem.
% Intervalu tStart až tEnd je pøiøazen label (nepovinný parametr) èi zùstane
% s prázdným labelem.
%
% Tato funkce je ve vìtšinì pøípadù totéž, jako 1. tgInsertBoundary(tEnd)
% a 2. tgInsertBoundary(tStart, nový label). Ale navíc je provádìna kontrola,
% a) zda tStart a tEnd náležejí do stejného pùvodního prázdného intervalu,
% b) nebo jsou oba mimo existující intervaly nalevo èi napravo.
%
% Prùniky nového intervalu s více již existujícími i prázdnými intervaly
% nedávají smysl a jsou zakázány.
%
% Je tøeba si uvìdomit, že ve skuteènosti tato funkce èasto
% vytváøí více intervalù. Napø. máme zcela novou IntervalTier s jedním prázdným
% intervalem 0 až 5 sec. Vložíme interval 1 až 2 sec s labelem 'øekl'.
% Výsledkem jsou tøi intervaly: 0-1 '', 1-2 'øekl', 2-5 ''.
% Pak znovu vložíme touto funkcí interval 7 až 8 sec s labelem 'jí',
% výsledkem bude pìt intervalù: 0-1 '', 1-2 'øekl', 2-5 '', 5-7 '' (vkládá se
% jako výplò, protože jsme mimo rozsah pùvodní vrstvy), 7-8 'jí'.
% Pokud však nyní vložíme interval pøesnì 2 až 3 'to', pøidá se ve
% skuteènosti jen jeden interval, kde se vytvoøí pravá hranice intervalu a
% levá se jen napojí na již existující, výsledkem bude šest intervalù:
% 0-1 '', 1-2 'øekl', 2-3 'to', 3-5 '', 5-7 '', 7-8 'jí'.
% Mùže také nastat situace, kdy nevytvoøí žádný nový interval, napø. když
% do pøedchozího vložíme interval 3 až 5 'asi'. Tím se pouze pùvodnì prázdnému
% intervalu 3-5 nastaví label na 'asi', výsledkem bude opìt jen šest intervalù:
% 0-1 '', 1-2 'øekl', 2-3 'to', 3-5 'asi', 5-7 '', 7-8 'jí'.
%
% Tato funkce v Praatu není, zde je navíc a je vhodná pro situace,
% kdy chceme napø. do prázdné IntervalTier pøidat nìkolik oddìlených intervalù
% (napø. intervaly detekované øeèové aktivity).
% Naopak není zcela vhodná pro pøidávání na sebe pøímo napojených
% intervalù (napø. postupnì segmentujeme slovo na jednotlivé navazující
% hlásky), protože když napø. vložíme intervaly 1 až 2.1 a 2.1 až 3,
% kde obì hodnoty 2.1 byly vypoèteny samostatnì a díky zaokrouhlovacím chybám
% se zcela pøesnì nerovnají, ve skuteènosti tím vznikne buï ještì prázdný
% interval 'pøibližnì' 2.1 až 2.1, což nechceme, a nebo naopak funkce skonèí
% s chybou, že tStart je vìtší než tEnd, pokud zaokrouhlení dopadlo opaènì.
% Pokud však hranice byla spoètena jen jednou a uložena do promìnné, která
% byla použita jako koneèná hranice pøedcházejícího intervalu, a zároveò jako
% poèáteèní hranice nového intervalu, nemìl by být problém a nový interval
% se vytvoøí jako napojení bez vloženého 'mikrointervalu'.
% Každopádnì, bezpeènìjší pro takové úèely je zpùsob, jak se postupuje
% v Praatu, tedy vložit hranici se  zaèátkem první hlásky pomocí
% tgInsertBoundary(èas, labelHlásky), pak stejnì èasy zaèátkù a labely všech
% následujících hlásek, a nakonec vložit ještì koneènou hranici poslední hlásky
% (tedy již bez labelu) pomocí tgInsertBoundary(èas).
%
% v1.0, Tomáš Boøil, borilt@gmail.com

if nargin < 4 || nargin > 5
    error('Wrong number of arguments.')
end
if nargin == 4
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

if tStart >= tEnd
    error(['tStart [' num2str(tStart) '] must be lower than tEnd [' num2str(tEnd) ']']);
end
% pozn. díky této podmínce nemohou nastat nìkteré situace podchycené níže
% (tStart == tEnd), leccos se tím zjednodušuje a Praat stejnì nedovoluje
% mít dvì hranice ve stejném èase, takže je to alespoò kompatibilní.

% tgNew = tg;

nint = length(tg.tier{tierInd}.T1);
if nint == 0
    % Zvláštní situace, tier nemá ani jeden interval.
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
%     disp('vkládám úplnì nalevo + prázdný interval jako výplò')
    tgNew = tgInsertBoundary(tg, tierInd, tEnd);
    tgNew = tgInsertBoundary(tgNew, tierInd, tStart, label);
    return
elseif tStart <= tgNalevo && tEnd == tgNalevo
%     disp('vkládám úplnì nalevo, plynule navazuji')
    tgNew = tgInsertBoundary(tg, tierInd, tStart, label);
    return
elseif tStart < tgNalevo && tEnd > tgNalevo
    error(['intersection of new interval (' num2str(tStart) ' to ' num2str(tEnd) ' sec, ''' label ''') and several others already existing (region outside ''left'' and the first interval) is forbidden'])
elseif tStart > tgNapravo && tEnd > tgNapravo %%
%     disp('vkládám úplnì napravo + prázdný interval jako výplò')
    tgNew = tgInsertBoundary(tg, tierInd, tEnd);
    tgNew = tgInsertBoundary(tgNew, tierInd, tStart, label);
    return
elseif tStart == tgNapravo && tEnd >= tgNapravo
%     disp('vkládám úplnì napravo, plynule navazuji')
    tgNew = tgInsertBoundary(tg, tierInd, tEnd, label);
    return
elseif tStart < tgNapravo && tEnd > tgNapravo
    error(['intersection of new interval (' num2str(tStart) ' to ' num2str(tEnd) ' sec, ''' label ''') and several others already existing (the last interval and region outside ''right'') is forbidden'])
elseif tStart >= tgNalevo && tEnd <= tgNapravo
    % disp('vkládání nìkam do již existující oblasti, nutná kontrola stejného a prázdného intervalu')
    % nalezení všech intervalù, kam èasy spadají - pokud se trefíme na
    % hranici, mùže totiž èas náležet dvìma intervalùm
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
        prunik = intersect(iStart, iEnd); % nalezení spoleèného intervalu z více možných variant
        if isempty(prunik)
            % je to chyba, ale ta bude zachycena dále podmínkou 'if iStart == iEnd'
            iStart = iStart(end);
            iEnd = iEnd(1);
        else
            iStart = prunik(1);
            iEnd = prunik(1);
            if length(prunik) > 1 % pokus o nalezení prvního vhodného kandidáta
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
%             disp('vkládám dovnitø intervalu, otázka, zda napojit èi ne')
            t1 = tg.tier{tierInd}.T1(iStart);
            t2 = tg.tier{tierInd}.T2(iStart);
            if tStart == t1 && tEnd == t2
%                 disp('jenom nastavím již existujícímu prázdnému intervalu label');
                tgNew = tg;
                tgNew.tier{tierInd}.Label{iStart} = label;
                return
%             elseif tStart == t1 && tEnd == t1
%                 disp('pùvodnímu intervalu nastavím label a vložím jednu hranici do t1, tím vznikne nový nulový interval na zaèátku s novým labelem a celý pùvodní interval bude stále prázdný')
%             elseif tStart == t2 && tEnd == t2
%                 disp('vložím jednu hranici do t2 s novým labelem, tím zùstane pùvodní celý prázdný interval a vznikne nový nulový interval na konci s novým labelem')
            elseif tStart == t1 && tEnd < t2
%                 disp('pùvodnímu intervalu nastavím label a vložím jednu hranici do tEnd, tím se pùvodní interval rozdìlí na dvì èásti, první bude mít nový label, druhá zùstane prázdná')
                tgNew = tg;
                tgNew.tier{tierInd}.Label{iStart} = label;
                tgNew = tgInsertBoundary(tgNew, tierInd, tEnd);
                return
            elseif tStart > t1 && tEnd == t2
%                 disp('vložím jednu hranici do tStart s novým labelem, tím se pùvodní interval rozdìlí na dvì èásti, první zùstane prázdná a druhá bude mít nový label')
                tgNew = tgInsertBoundary(tg, tierInd, tStart, label);
                return
            elseif tStart > t1 && tEnd < t2
%                 disp('vložím hranici do tEnd s prázdným labelem, a pak vložím hranici do tStart s novým labelem, tím se pùvodní interval rozdìlí na tøi èásti, první a poslední budou prázdné, prostøední bude mít nový label')
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
