function ptPlot(pt)
% function ptPlot(pt)
% Vykreslí PitchTier.
% v1.0, Tomáš Boøil, borilt@gmail.com

if nargin  ~= 1
    error('nesprávný poèet argumentù')
end

plot(pt.t, pt.f, 'ok', 'MarkerSize', 2)

if isfield(pt, 'tmin') && isfield(pt, 'tmax')
    xlim([pt.tmin pt.tmax])
end

ylim([min(pt.f)*0.95 max(pt.f)*1.05])
