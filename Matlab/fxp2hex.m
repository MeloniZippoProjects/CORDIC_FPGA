function [ hex ] = fxp2hex( z, resolution )
% k is assumed to be 2
    k = 2;

    if(z < 0)
       nat_z = (-z) * 2^(resolution - k) + 2^(resolution - 1);
    else
       nat_z = z * 2^(resolution - k);
    end

    hex = dec2hex(floor(nat_z), resolution/4);
end

