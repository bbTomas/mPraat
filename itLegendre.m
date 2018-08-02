function c = itLegendre(it, npoints, npolynomials)
% function c = itLegendre(it, npoints, npolynomials)
%
% Interpolate the IntensityTier in 'npoints' equidistant points and approximate it by Legendre polynomials.
% Returns row vector of Legendre polynomials coefficients.
%
% it           ... IntensityTier object
% npoints      ... [optional] Number of points of IntensityTier interpolation (default: 1000)
% npolynomials ... [optional] Number of polynomials to be used for Legendre modelling (default: 4)
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

if nargin < 1 || nargin > 3
    error('Wrong number of arguments.')
end

if nargin == 1
    npoints = 1000; npolynomials = 4;
elseif nargin == 2;
    npolynomials = 4;
end

if ~isInt(npoints) || npoints < 0
    error('npoints must be integer >= 0.')
end

if ~isInt(npolynomials) || npolynomials <= 0
    error('npolynomials must be integer > 0.')
end

if npoints == 1
    it = itInterpolate(it, it.tmin);
else
    it = itInterpolate(it, linspace(it.tmin, it.tmax, npoints));
end

y = it.i;


lP = npoints;  % poèet vzorkù polynomu
nP = npolynomials;

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

c = zeros(1, nP);
for I = 1: nP
    c(1, I) = y * B(I, :).' / lP * ((I-1)*2+1);
    % koeficient ((I-1)*2+1) odpovídá výkonùm komponent, které lze spoèítat i takto: mean((P.^2).')
end
