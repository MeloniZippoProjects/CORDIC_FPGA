library IEEE;
use IEEE.std_logic_1164.all;
use IEE.numeric_std.all;

function f_log2 (x : positive) return natural is
  variable i : natural;
begin
  i := 0;  
  while (2**i < x) and i < 31 loop
     i := i + 1;
  end loop;
  return i;
end function;

entity yn_combinatorics is
	-- Hbits -> number of bits to represent x_in and x_out
	-- N_iterations -> max number of shifts necessary
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
	case( y_p(Hbits-1) ) is
		when '1' =>
			x_preshift <= to_signed(x_p);
		
		when '0' =>
			x_preshift <= 0 - to_signed(x_p);
	end case ;

	x_postshift <= shift_right(x_preshift, to_unsigned(iteration));
	y_n <= to_stdlogicvector(to_signed(y_p) + x_postshift);

end xn_combinatorics_struct;