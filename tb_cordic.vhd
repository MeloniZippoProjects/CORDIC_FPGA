library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity tb_cordic is
end tb_cordic;

architecture beh_tb_cordic of tb_cordic is

	component cordic
		generic(Hbits : positive := 12; Kbits :positive := 12; N_iterations : positive := 8);
		port (
			den		: in std_ulogic_vector(Hbits-1 downto 0);
			num		: in std_ulogic_vector(Hbits-1 downto 0);
			clk 	: in std_ulogic;
			ris 	: out std_ulogic_vector(Kbits-1 downto 0);
			reset 	: in std_ulogic -- active high
		);
	end component;
	
	signal clk : std_ulogic := '0';
	signal reset : std_ulogic;
	
	constant Hbits : positive := 32;
	constant Kbits : positive := 32;
	constant N_iterations : positive := 32;

	signal den		: std_ulogic_vector(Hbits-1 downto 0);
	signal num		: std_ulogic_vector(Hbits-1 downto 0);
	signal ris 		: std_ulogic_vector(Kbits-1 downto 0);
begin

	clk <= not clk after 50 ns;
	
	i_cordic : cordic
		generic map(Hbits => Hbits, Kbits => Kbits, N_iterations => N_iterations)
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
		num <= x"1000_0000";
		den <= x"1000_0000";
		wait;
	end process;
end beh_tb_cordic;