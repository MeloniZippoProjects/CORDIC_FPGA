N = 8;
K = 12;

final_str = '';

for i = 0 : N-1
    real_val = atan( 2^(-i) ) * 2^(K-2);
    bin_vec = dec2bin( real_val, K );
    final_str = [final_str ', "' bin_vec, '"'];
end;

final_str = final_str(3 : length(final_str));

disp(final_str);