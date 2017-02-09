library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

library cordic;
use cordic.util.all;

-- Hbits : positive := 32;
-- constant Kbits : positive := 32;
-- constant N_iterations : positive := 15;



entity cordic_wrapper is
	port(
		den		: in std_ulogic_vector(31 downto 0);
		num		: in std_ulogic_vector(31 downto 0);
		ris 	: out std_ulogic_vector(31 downto 0);

		clk 	: in std_ulogic;
		reset 	: in std_ulogic
	);	
end cordic_wrapper;

architecture cordic_wrapper_struct of cordic_wrapper is

	
	
	component cordic_atan is
		generic(Hbits : positive := 12; Kbits :positive := 12; N_iterations : positive := 8);
		port (
			den		: in std_ulogic_vector(Hbits-1 downto 0);
			num		: in std_ulogic_vector(Hbits-1 downto 0);
			ris 	: out std_ulogic_vector(Kbits-1 downto 0);

			atan_lut_idx	: out std_ulogic_vector(f_log2(N_iterations)-1 downto 0);
			atan_lut_data	: in std_ulogic_vector(Kbits-1 downto 0);

			clk 	: in std_ulogic;
			reset 	: in std_ulogic
		);
	end component;

	component atan_lut_15x32
		port(
			iteration : in std_ulogic_vector(f_log2(15)-1 downto 0);
			atan : out std_ulogic_vector(31 downto 0)
		);
	end component;

	component atan_lut_generic is
		generic(Kbits : positive := 12; N_iterations : positive := 8);
		port(
			iteration : in std_ulogic_vector(f_log2(N_iterations)-1 downto 0);
			atan : out std_ulogic_vector(Kbits-1 downto 0)
		);
	end component;


	signal atan_lut_idx : std_ulogic_vector(f_log2(15)-1 downto 0);
	signal atan_lut_data : std_ulogic_vector(31 downto 0);

	signal real_atan : real;	

begin

	real_atan <= real(to_integer(signed(atan_lut_data))) * real(2)**(-(32 - 2));

	i_cordic : cordic_atan
		generic map(Hbits => 32, Kbits => 32, N_iterations => 15)
		port map(
			den => den,
			num => num,
			ris => ris,

			atan_lut_idx => atan_lut_idx,
			atan_lut_data => atan_lut_data,

			clk => clk,
			reset => reset
		);

	i_lut : atan_lut_15x32
		port map(
			iteration => atan_lut_idx,
			atan => atan_lut_data
		);

	--i_lut : atan_lut_generic
	--	generic map(Kbits => 32, N_iterations => 15)
	--	port map(
	--		iteration => atan_lut_idx,
	--		atan => atan_lut_data
	--	);

end cordic_wrapper_struct;