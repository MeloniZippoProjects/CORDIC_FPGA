library IEEE;
use IEEE.std_logic_1164.all;

entity RighShifter_base is
	port(
		x_in 		: in std_ulogic_vector(11 downto 0);
		pilot 		: in std_ulogic;
		x_out		: out std_ulogic_vector(11 downto 0)
	);
end RighShifter_base;


architecture RightShifter_base_struct of RightShifter_base is
begin
	case pilot is
		when '0' =>
			x_out <= x_in;
		when '1' =>
			x_out(11) <= x_in(11);
			x_out(10 downto 0) <= x_in(11 downto 1);
	end case;
end RightShifter_base_struct;