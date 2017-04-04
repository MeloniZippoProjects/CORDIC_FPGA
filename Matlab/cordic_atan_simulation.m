function [x, y, z] = cordic_atan_simulation(x_0, y_0, iteration_number)
    x = zeros(1,iteration_number);
    y = zeros(1,iteration_number);
    z = zeros(1,iteration_number);

    x(1) = x_0;
    y(1) = y_0;
    z(1) = 0;

    for i = 1:(iteration_number - 1)
        if(y(i) < 0)
            d = 1;
        else
            d = -1;
        end

        x(i+1) = x(i) - floor(y(i) * d * 2^(-(i-1)));
        y(i+1) = y(i) + floor(x(i) * d * 2^(-(i-1)));
        z(i+1) = z(i) - d * atan(2^(-(i-1)));
    end    
end