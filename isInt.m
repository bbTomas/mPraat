function b = isInt(a)
% function b = isInt(a)
% returns true if a is integer, false otherwise 
% v1.0, Tomas Boril, borilt@gmail.com

if ~isequal(size(a), [1, 1])
    b = false;
    return
end

b = (fix(a) == a);
