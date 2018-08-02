function itNew = itInterpolate(it, t)
% function itNew = itInterpolate(it, t)
%
% Interpolates IntensityTier contour in given time instances.
%
%
%  a) If t < min(it.t) (or t > max(it.t)), returns the first (or the last) value of it.i
%  b) If t is existing point in it.t, returns the respective it.i.
%  c) If t is Between two existing points, returns linear interpolation of these two points.
%
% it ... IntensityTier object
% t  ... vector of time instances of interest
% 
% v1.0, Tomas Boril, borilt@gmail.com
%
% Example
%   it = itRead('demo/maminka.IntensityTier');
%   it2 = itInterpolate(it, it.t(1): 0.001: it.t(end));
%   subplot(2,1,1)
%   itPlot(it);
%   subplot(2,1,2)
%   itPlot(it2)

if nargin ~= 2
    error('Wrong number of arguments.')
end

if length(it.t) ~= length(it.i)
    error('IntensityTier does not have equal length vectors .t and .i')
end

if length(it.t) < 1
    itNew = NaN;
    return
end
    

if ~isequal(sort(it.t), it.t)
    error('time instances .t in IntensityTier are not increasingly sorted')
end

if ~isequal(unique(it.t), it.t)
    error('duplicated time instances in .t vector of the IntensityTier')
end

itNew = it;
itNew.t = t;

i = zeros(1, length(t));
for I = 1: length(t)
    if length(it.t) == 1
        i(I) = it.i(1);
    elseif t(I) < it.t(1)   % a)
        i(I) = it.i(1);
    elseif t(I) > it.t(end)   % a)
        i(I) = it.i(end);
    else
        % b)
        ind = find(it.t == t(I));
        if length(ind) == 1
            i(I) = it.i(ind);
        else
            % c)
            ind2 = find(it.t > t(I)); ind2 = ind2(1);
            ind1 = ind2 - 1;
            % y = ax + b;  a = (y2-y1)/(x2-x1);  b = y1 - ax1
            a = (it.i(ind2) - it.i(ind1)) / (it.t(ind2) - it.t(ind1));
            b = it.i(ind1) - a*it.t(ind1);
            i(I) = a*t(I) + b;
        end
    end
end

itNew.i = i;
