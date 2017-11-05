function ok = expect_error(statement)
% only for test purposes

ok = false;

try
    out = eval(statement);
    ok = false;
catch ME
    ok = true;
%     disp(ME)
end

if ok ~= true
    error('expecting error but nothing exceptional happened')
end

end

