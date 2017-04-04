library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

library cordic;
use cordic.util.all;

-- Testbench for the cordic_atan network
-- Instantiates the generic parameters, and performs various computation tests:
	-- atan(1/2) = 0.463648
	-- atan(1) = 0.785398
	-- atan(3) = 1.249046
-- This are expected values, obtainable with lower errors as bit resolution increases

entity tb_cordic is
end tb_cordic;

architecture beh_tb_cordic of tb_cordic is
	constant Hbits : positive := 12;
	constant Kbits : positive := 12;
	constant N_iterations : positive := 8;

	component cordic_wrapper is port( den: in std_ulogic_vector(Hbits-1 downto
	0); num: in std_ulogic_vector(Hbits-1 downto 0); ris : out
	std_ulogic_vector(Kbits-1 downto 0);  

			clk 	: in std_ulogic;
			reset 	: in std_ulogic
		);	
	end component;
	
	signal clk : std_ulogic := '0';
	signal reset : std_ulogic;

	

	signal den		: std_ulogic_vector(Hbits-1 downto 0);
	signal num		: std_ulogic_vector(Hbits-1 downto 0);
	signal ris 		: std_ulogic_vector(Kbits-1 downto 0);

	signal atan_lut_idx : std_ulogic_vector(f_log2(N_iterations)-1 downto 0);
	signal atan_lut_data : std_ulogic_vector(Kbits-1 downto 0);

	signal real_ris : real;

begin

	clk <= not clk after 50 ns;
	
	real_ris <= real(to_integer(signed(ris))) * real(2)**(-(32 - 2));

	i_wrapper : cordic_wrapper
		port map(
				den => den,
				num => num,
				ris => ris,

				clk => clk, 
				reset => reset
			);

	drive_p : process
	begin
			reset <= '1';
			num <= x"100";
			den <= x"100";
			wait until rising_edge(clk);
			reset <= '0';
		wait on ris;
			num <= x"200";
			den <= x"400";	
		wait on ris;
			num <= x"600";
			den <= x"200";
		wait;
	end process;
end beh_tb_cordic;