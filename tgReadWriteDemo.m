% this is a demonstration of the extended functions tgRead and tgWrite 

% % load a collection textgrid, modify it and save it again as a collection
% tg = tgRead(['demo', filesep, 'collection.TextGrid'], 'collection');
% tg.tier{1}.name = 'word'; % rename a Tier; you can apply all kinds of changes
% tgWrite(tg, ['demo', filesep, 'collection_new.TextGrid'], 'collection');


% load a tg in long format and save it as short
tg = tgRead(['demo', filesep, 'H_plain.TextGrid']);
tgPlot(tg);
tgWrite(tg, ['demo', filesep, 'H_short.TextGrid']);

% now the other way around
tg = tgRead(['demo', filesep, 'H_short.TextGrid']);
tgPlot(tg);
tgWrite(tg, ['demo', filesep, 'H_long.TextGrid'], 'long');