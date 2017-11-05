function ok = expect_equal(x, y)
% only for test purposes
ok = true;

if (iscell(x) & ~iscell(y)) | (~iscell(x) & iscell(y))
    error('class mismatch')
end

if ~iscell(x)
    x = {x};
    y = {y};
end

if ~isequal(size(x), size(y))
    error('not equal size of x and y')
end

n = numel(x);

for I = 1: n
    X = x{I};
    Y = y{I};
    if ~isequal(class(X), class(Y))
        error('class mismatch')
    end
    
    if ~isequal(size(X), size(Y))
        error([num2str(I), ': not equal size of X and Y'])
    end
    
    if ~iscell(X) & isnan(X)
        if isnan(Y)
            ok = true;
            return
        else
            error([num2str(I), ': X ~= Y, NaN'])
        end
    else
        if ~iscell(Y) & isnan(Y)
            error([num2str(I), ': X ~= Y, NaN'])
        end
    end
    
    if isnumeric(X)
        N = numel(X);
        for J = 1: N
            if abs(X(J) - Y(J)) > 1e-6
                error([num2str(I), ': X ~= Y'])
            end
        end
    else
        if ~isequal(X, Y)
            error([num2str(I), ': X ~= Y'])
        end
    end
end
