library IEEE;
use IEEE.std_logic_1164.all;

entity reg is
	generic (Nbit : positive := 8);
	port(
		clk		: in std_ulogic;
		reset	: in std_ulogic;
		d		: in std_ulogic_vector(Nbit-1 downto 0);
		q 		: out std_ulogic_vector(Nbit-1 downto 0)
	);
end reg;


architecture DataFlow_reg of reg is 
begin 
	update: process (d,clk,reset)
	begin
		if ( reset = '1' ) then
			q <= (others => '0');
		else
			if ( clk'event and clk = '1') then
				q <= d;
			end if;
		end if;
	end process;
end DataFlow_reg;