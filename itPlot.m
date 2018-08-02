function itPlot(it)
% function itPlot(it)
%
% Plots IntensityTier.
% 
% v1.0, Tomas Boril, borilt@gmail.com
%
% Example
%   it = itRead('demo/maminka.IntensityTier');
%   itPlot(it);
%
%   figure
%   tg = tgRead('demo/maminka.TextGrid');
%   tgPlot(tg, 2);
%   subplot(tgGetNumberOfTiers(tg)+1, 1, 1);
%   itPlot(it);


if nargin  ~= 1
    error('Wrong number of arguments.')
end

plot(it.t, it.i, 'ok', 'MarkerSize', 2)

if isfield(it, 'tmin') && isfield(it, 'tmax')
    xlim([it.tmin it.tmax])
end

ylim([min(it.i)*0.95 max(it.i)*1.05])
