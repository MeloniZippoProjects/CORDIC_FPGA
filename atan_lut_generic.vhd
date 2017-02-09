library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;
use IEEE.math_real.all;

library cordic;
use cordic.util.all;

-- LUT which stores the value of atan(2^(-i)) at address i for i = 0 ... N_iterations

entity atan_lut_generic is
	generic(Kbits : positive := 12; N_iterations : positive := 8);
	port(
		iteration : in std_ulogic_vector(f_log2(N_iterations)-1 downto 0);
		atan : out std_ulogic_vector(Kbits-1 downto 0)
	);
end atan_lut_generic;

architecture atan_lut_generic_struct of atan_lut_generic is
	
	type atantab is array(0 to N_iterations-1) of std_ulogic_vector (Kbits-1 downto 0);
	signal atanrom: atantab;

begin
	genrom: for idx in 0 to N_iterations-1 generate
		constant atan_i : real := arctan(real(2)**(-idx));
	begin
	  atanrom(idx) <= std_ulogic_vector(
	  		to_signed(
	  			integer( atan_i * real( 2**( Kbits-2 ) ) ),
	  			Kbits
  			)
		);  
	end generate;

	atan <= atanrom(to_integer(unsigned(iteration)));
end atan_lut_generic_struct;