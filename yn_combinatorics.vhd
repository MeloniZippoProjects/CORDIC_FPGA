library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

library cordic;
use cordic.util.all;

-- Applies the iterative formula
-- y(i+1) = y(i) + d(i)*x(i)*2^(-i)
-- Where d(i) = 1 if y(i) < 0, -1 otherwise

entity yn_combinatorics is
	generic(Hbits : positive := 12; N_iterations : positive := 8);
	port(
		x_p 		: in std_ulogic_vector(Hbits-1 downto 0);
		y_p			: in std_ulogic_vector(Hbits-1 downto 0);
		iteration	: in std_ulogic_vector(f_log2(N_iterations)-1 downto 0);

		y_n		: out std_ulogic_vector(Hbits-1 downto 0)
	);
end yn_combinatorics;

architecture yn_combinatorics_struct of yn_combinatorics is
	
	signal x_preshift : signed(Hbits-1 downto 0);
	signal x_postshift : signed(Hbits-1 downto 0);

begin
	x_preshift <= signed(x_p) when y_p(Hbits-1) = '1'
		else (0 - signed(x_p));

	x_postshift <= shift_right(x_preshift, to_integer(unsigned(iteration)));
	y_n <= std_ulogic_vector(signed(y_p) + x_postshift);

end yn_combinatorics_struct;