library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

library cordic;

use cordic.util.all;

entity atan_lut_8x12 is
	port (
		iteration	: in	std_ulogic_vector (f_log2(8)-1 downto 0);
		atan		: out	std_ulogic_vector (11 downto 0)
	);
end atan_lut_8x12;

architecture rtl of atan_lut_8x12 is

	signal addr_int 	: integer range 0 to 7;
	type lut_t is array (0 to 7) of std_ulogic_vector (11 downto 0);
	constant lut : lut_t :=
	("001100100100", "000111011010", "000011111010", "000001111111", 
	"000000111111", "000000011111", "000000001111", "000000000111"
	);

	
begin
	addr_int <= TO_INTEGER(unsigned(iteration));
	atan <= lut(addr_int);
end rtl;