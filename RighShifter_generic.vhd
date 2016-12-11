library IEEE;
use IEEE.std_logic_1164.all;


entity RighShifter_generic is
	-- Nbit -> number of bits to represent x_in and x_out
	-- Nshift -> max number of shifts necessary
	generic(Nbit : positive := 12; Nshift : positive := 8);
	port(
		x_in : in std_ulogic_vector(Nbit-1 downto 0);
		pilot : in std_ulogic_vector(Nshift-1 downto 0);
		x_out : out std_ulogic_vector(Nbit-1 downto 0)
	);
end RighShifter_generic;


architecture RighShifter_generic_struct of RighShifter_generic is
	
	component shifter_base 
		port(
			x_in 		: in std_ulogic_vector(11 downto 0);
			pilot 		: in std_ulogic;
			x_out		: out std_ulogic_vector(11 downto 0)
		);
	end component;
	
	begin
	
		type signal_array is array(0 to Nshift) of std_ulogic_vector(Nbit-1 to 0);
		signal my_signal_array : signal_array;
		
		my_signal_array(0) <= x_in;
		
		shifter_gen: for i in 0 to Nshift-1 generate
			x_Shifter : shifter_base
				port map(
					x_in => my_signal_array(i);
					pilot => pilot(i);
					x_out => my_signal_array(i+1)
				)
		end generate;
		
		x_out <= my_signal_array(Nshift);
		
	end RighShifter_generic_struct;