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

	component cordic_wrapper is 
		port( 
		den: in 	std_ulogic_vector(Hbits-1 downto 0); 
		num: in	 	std_ulogic_vector(Hbits-1 downto 0); 
		ris: out	std_ulogic_vector(Kbits-1 downto 0);  

		clk 	: in std_ulogic;
		reset 	: in std_ulogic
		);	
	end component;
	
	signal clk : std_ulogic := '0';
	signal reset : std_ulogic;

	signal den		: std_ulogic_vector(Hbits-1 downto 0);
	signal num		: std_ulogic_vector(Hbits-1 downto 0);
	signal ris 		: std_ulogic_vector(Kbits-1 downto 0);

	signal real_ris : real;

begin

	clk <= not clk after 50 ns;
	
	real_ris <= real(to_integer(signed(ris))) * real(2)**(-(Kbits - 2));

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
			wait until rising_edge(clk);
			reset <= '0';
			wait on ris;
				num <= x"F05"; den <= x"E1B";
			 wait on ris;
				num <= x"43F"; den <= x"4B8";
			 wait on ris;
				num <= x"AFE"; den <= x"FD6";
			 wait on ris;
				num <= x"F21"; den <= x"257";
			 wait on ris;
				num <= x"359"; den <= x"412";
			 wait on ris;
				num <= x"C6B"; den <= x"2DF";
			 wait on ris;
				num <= x"27A"; den <= x"A9A";
			 wait on ris;
				num <= x"9E8"; den <= x"FF9";
			 wait on ris;
				num <= x"75A"; den <= x"D72";
			 wait on ris;
				num <= x"15D"; den <= x"B95";
			 wait on ris;
				num <= x"404"; den <= x"C15";
			 wait on ris;
				num <= x"018"; den <= x"32F";
			 wait on ris;
				num <= x"640"; den <= x"758";
			 wait on ris;
				num <= x"0C1"; den <= x"A38";
			 wait on ris;
				num <= x"A64"; den <= x"C1F";
			 wait on ris;
				num <= x"572"; den <= x"C12";
			 wait on ris;
				num <= x"506"; den <= x"BE5";
			 wait on ris;
				num <= x"6DD"; den <= x"D99";
			 wait on ris;
				num <= x"B25"; den <= x"C04";
			 wait on ris;
				num <= x"1DB"; den <= x"F92";
			 
			wait;
	end process;
end beh_tb_cordic;