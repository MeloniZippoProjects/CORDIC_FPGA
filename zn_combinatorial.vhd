library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

library cordic;
use cordic.util.all;

-- Applies the iterative formula
-- z(i+1) = z(i) - d(i)*atan(2^(-i))
-- Where d(i) = 1 if y(i) < 0, -1 otherwise

-- atan(2^(-i)) is computed via a LUT which is supposed to store the value at address i
-- z(0) is supposed to be set to 0

entity zn_combinatorial is
	generic(Kbits : positive := 12; N_iterations : positive := 8);
	port(
		z_p : in std_ulogic_vector(Kbits-1 downto 0);
		atan_lut_data	: in std_ulogic_vector(Kbits-1 downto 0);
		sign_y_p : in std_ulogic;

		z_n : out std_ulogic_vector(Kbits-1 downto 0)
	);
end zn_combinatorial;

architecture zn_combinatorial_DataFlow of zn_combinatorial is

	signal atan_to_add : std_ulogic_vector(Kbits-1 downto 0);

begin	
	atan_to_add <= std_ulogic_vector(0 - signed(atan_lut_data)) when sign_y_p = '1'
		else atan_lut_data;

	z_n <= std_ulogic_vector(signed(z_p) + signed(atan_to_add));
end zn_combinatorial_DataFlow;