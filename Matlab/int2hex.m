function [ hex ] = int2hex( x, resolution)
    if x >= 0
        X = x;
    else
        X = 2^resolution + x;
    end

    hex = dec2hex(X, resolution/4);
end

