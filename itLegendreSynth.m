function y = itLegendreSynth(c, npoints)
% function y = itLegendreSynth(c, npoints)
%
% Synthetize the contour from vector of Legendre polynomials 'c' in 'npoints' equidistant points.
% Returns row vector of values of synthetized contour.
%
% c            ... Row vector of Legendre polynomials coefficients
% npoints      ... [optional] Number of points of PitchTier interpolation (default: 1000)
% 
% v1.0, Tomas Boril, borilt@gmail.com
%
% Example
%   it = itRead('demo/maminka.IntensityTier');
%   it = itCut(it, 0.2, 0.4);  % cut IntensityTier and preserve time
%   c = itLegendre(it)
%   leg = itLegendreSynth(c);
%   itLeg = it;
%   itLeg.t = linspace(itLeg.tmin, itLeg.tmax, length(leg));
%   itLeg.i = leg;
%   plot(it.t, it.i, 'ko')
%   xlabel('Time (sec)'); ylabel('Intensity (dB)')
%   hold on; plot(itLeg.t, itLeg.i, 'b')


if nargin < 1 || nargin > 2
    error('Wrong number of arguments.')
end

if nargin == 1
    npoints = 1000;
end

if ~isInt(npoints) || npoints < 0
    error('npoints must be integer >= 0.')
end

if size(c, 1) ~= 1
    error('c must be a row vector.');
end


lP = npoints; % poèet vzorkù polynomu
nP = length(c);

B = zeros(nP, lP);  % báze
if (lP == 1)
    x = -1;
else
    x = linspace(-1, 1, lP);
end

for I = 1: nP
    n = I - 1;
    p = zeros(1, lP);
    for k = 0: n
        p = p + x.^k*binomcoeff2(n, k)*binomcoeff2((n+k-1)/2, n);
    end
    p = p*2.^n;

    B(I, :) = p;
end


if nP > 0
    y = c * B;
else
    y = NaN*ones(1, npoints);
end

