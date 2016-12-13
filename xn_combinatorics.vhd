library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

library cordic;
use cordic.util.all;

entity xn_combinatorics is
	-- Hbits -> number of bits to represent x_in and x_out
	-- N_iterations -> max number of shifts necessary
	generic(Hbits : positive := 12; N_iterations : positive := 8);
	port(
		x_p 		: in std_ulogic_vector(Hbits-1 downto 0);
		y_p			: in std_ulogic_vector(Hbits-1 downto 0);
		iteration	: in std_ulogic_vector(f_log2(N_iterations)-1 downto 0);

		x_n		: out std_ulogic_vector(Hbits-1 downto 0)
	);
end xn_combinatorics;

architecture xn_combinatorics_struct of xn_combinatorics is

	signal y_preshift : signed(Hbits-1 downto 0);
	signal y_postshift : signed(Hbits-1 downto 0);

begin
	y_preshift <= (0 - signed(y_p)) when y_p(Hbits-1) = '1'
		else signed(y_p);

	y_postshift <= shift_right(signed(y_preshift), to_integer(unsigned(iteration)));
	x_n <= std_ulogic_vector(signed(x_p) + y_postshift);

end xn_combinatorics_struct;