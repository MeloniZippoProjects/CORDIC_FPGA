tests = 20;
h = 32;

testpl = zeros(tests, 3); %le colonne sono x, y e risultato atteso

for idx = 1 : tests
   x = floor( rand * (2^h - 1) );
   y = floor( rand * (2^h - 1) );
   
   
   disp([dec2hex(x, h/4), ' % ', dec2hex(y, h/4), ' = ', string(atan(y/x)).char]);
end