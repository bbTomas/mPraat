% Estimated Time to Achieve
%   Tomas Boril v1.1
%
% Example of use:
%   before cycle
%     etaTB('start');
%
%   the last part of the cycle  for I = 1: N
%     etaTB('show', I, N, ['optional text'])
%
%   after the cycle
%     etaTB('stop');

function etaTB(par1, par2, par3, par4)
persistent lprubeh cas;

if strcmp(par1, 'start') == true && nargin == 1
    % start
    lprubeh = 0; cas = 0;
    
elseif strcmp(par1, 'show') == true && (nargin == 3 || nargin == 4)
    % zobrazeni progress baru
    I = par2;
    N = par3;
    if I == 1
        tic;
    end
    if I == 2
        cas = toc*(N-2);
        if nargin == 4
            fprintf([par4 ', estimated end time: ']);
        else
            fprintf('estimated end time: ');
        end
        fprintf(datestr(now+cas/24/60/60));
        fprintf('\n0       20        40        60        80       100\n');
    end
    if cas > 0
        prubeh = fix(I/(N)*50);
        if prubeh > lprubeh
            for prubtec=1:prubeh-lprubeh
                fprintf('.'); %, prubeh);
            end
            lprubeh = prubeh;
        end
    end
elseif strcmp(par1, 'stop') == true && nargin == 1
    fprintf('\n');
    clear lprubeh cas;
else
    ME = MException('etaTB:wrong_parameters', 'etaTB: wrong parameters');
    throw(ME);
end