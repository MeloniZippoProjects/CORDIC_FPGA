library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

library cordic;
use cordic.util.all;

-- Applies the iterative formula
-- x(i+1) = x(i) - d(i)*y(i)*2^(-i)
-- Where d(i) = 1 if y(i) < 0, -1 otherwise

-- x(0) is supposed to be positive

entity xn_combinatorial is
	generic(Hbits : positive := 12; N_iterations : positive := 8);
	port(
		x_p 		: in std_ulogic_vector(Hbits-1 downto 0);
		y_p			: in std_ulogic_vector(Hbits-1 downto 0);
		iteration	: in std_ulogic_vector(f_log2(N_iterations)-1 downto 0);

		x_n		: out std_ulogic_vector(Hbits-1 downto 0)
	);
end xn_combinatorial;

architecture xn_combinatorial_struct of xn_combinatorial is

	signal y_preshift : signed(Hbits-1 downto 0);
	signal y_postshift : signed(Hbits-1 downto 0);

begin
	y_preshift <= (0 - signed(y_p)) when y_p(Hbits-1) = '1'
		else signed(y_p);

	y_postshift <= shift_right(signed(y_preshift), to_integer(unsigned(iteration)));
	x_n <= std_ulogic_vector(signed(x_p) + y_postshift);

end xn_combinatorial_struct;