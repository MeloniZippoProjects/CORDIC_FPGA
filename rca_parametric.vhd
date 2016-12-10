library IEEE;
use IEEE.std_logic_1164.all;

entity RCA_p is
	generic (Nbit : positive := 8);
	port(
		a		: in std_ulogic_vector(Nbit-1 downto 0);
		b		: in std_ulogic_vector(Nbit-1 downto 0);
		cin		: in std_ulogic;
		s		: out std_ulogic_vector(Nbit-1 downto 0);
		cout	: out std_ulogic
	);
end RCA_p;

architecture struct of RCA_p is
	--component declaration
	
	component FA
		port (
			a		: in std_ulogic;
			b 		: in std_ulogic;
			cin		: in std_ulogic;
			s		: out std_ulogic;
			cout	: out std_ulogic
		);
	end component;
	
	
	--signal declaration
	signal c : std_ulogic_vector (Nbit downto 0);
	
	--arch description
	begin
		c(0) <= cin;
		
		rca_gen: for i in 0 to Nbit-1 generate 
			x_FA : FA 
				port map (
					a => a(i),
					b => b(i),
					cin => c(i),
					s => s(i),
					cout => c(i+1)
				);
		end generate;
		
		cout <= c(Nbit);
			
	
			
			
	end struct;
