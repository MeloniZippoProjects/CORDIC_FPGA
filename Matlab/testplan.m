tests = 20;

input_resolution = 12;
output_resolution = 12;
iteration_number = 8;


testpl = zeros(tests, 3); %le colonne sono x, y e risultato atteso


vhd = fopen('add_to_vhd.txt', 'w');
expected = fopen('expected_values.txt', 'w');

for idx = 1 : tests
   x = floor( (rand - 0.5) * (2^input_resolution - 2) );
   y = floor( (rand - 0.5) * (2^input_resolution - 2) );
   
   %disp([int2hex(x, input_resolution), ' % ', int2hex(y, input_resolution), ' = ', string(atan(y/x)).char]);

   
   vhd_str = ['num <= "' int2hex(x, input_resolution) '"; den <= "' int2hex(y, input_resolution) '";'];

   
   fprintf(vhd, 'wait on ris;\n\t%s\n ', vhd_str);
   
   
   
   [~, ~, z] = cordic_atan_simulation(x, y, iteration_number);
   
   
   expected_val_str = ['num = ' int2hex(x, input_resolution) '; den = ' int2hex(y, input_resolution) '; z_bin = ' fxp2hex(z(iteration_number), output_resolution) '; z_dec = ' string(z(iteration_number)).char]; 

   fprintf(expected, '%s\n\n', expected_val_str);
   disp(expected_val_str);

end