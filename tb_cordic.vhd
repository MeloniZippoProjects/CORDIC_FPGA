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

	signal den		: std_ulogic_vector(11 downto 0);
	signal num		: std_ulogic_vector(11 downto 0);
	signal ris 		: std_ulogic_vector(11 downto 0);
begin

	clk <= not clk after 50 ns;
	
	i_cordic : cordic
		generic map(Hbits => 12, Kbits => 12, N_iterations => 12)
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
		num <= x"001";
		den <= x"001";
		wait for 320000 ns;
		den <= x"002";
		wait;
	end process;
end beh_tb_cordic;