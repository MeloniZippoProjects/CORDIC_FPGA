library IEEE;
use IEEE.std_logic_1164.all;

entity FA is
	port(
		a 		: in std_ulogic;
		b 		: in std_ulogic;
		cin 	: in std_ulogic;
		s 		: out std_ulogic;
		cout 	: out std_ulogic 
	);
end FA;

architecture FA_architecture of FA is
begin 
	s <= a xor b xor cin;
	cout <= (a and b) or (a and cin) or (b and cin);
end FA_architecture;
