library IEEE;
use IEEE.std_logic_1164.all;

-- n = 3 bit, h = 12 bit, k = 10 bit
entity cordic is
	port (
		den		: in std_ulogic_vector(11 downto 0);
		num		: in std_ulogic_vector(11 downto 0);
		clk 	: in std_ulogic;
		ris 	: out std_ulogic_vector(9 downto 0);
		reset 	: in std_ulogic -- active high
	);
end cordic;


architecture cordic_beh of cordic is 
begin

	-- component LUT_atan
	-- component LUT_iteration
	-- component shifter_param
	-- component rca
	-- component direction_picker (?)

	-- two possible states for the machine: waiting and computing
	type state_type IS (read_state, compute_state);
	
	-- p_state is present state, n_state is next state
	signal p_state, n_state : state_type;
	
	-- signals to keep temp values for computations
	signal x_p, x_n : std_ulogic_vector(11 downto 0);
	signal y_p, y_n : std_ulogic_vector(11 downto 0);
	signal z_p, z_n : std_ulogic_vector(11 downto 0);
	signal iteration: std_ulogic_vector( 2 downto 0);
	
	cordic_process: process(den,num,clk,reset,ris)
	begin
		-- clocked computations
		if( reset = '1' ) then
			p_state <= read_state;
			z_p <= (others => '0');
		elsif (clk'event and clk = '1') then
				p_state <= n_state;
		end if;
		
		-- combinatorial computations
		
		case p_state is
			when read_state =>
				x_p <= den;
				y_p <= num;
				ris <= z_p;
				iteration <= 0;
				n_state <= compute_state;
			when compute_state =>
				if( iteration = "111") -- computation complete
					n_state <= read_state; 
					x_p <= x_n;
					y_p <= y_n;
					z_p <= z_n;
				else
					n_state <= p_state;
					x_p <= x_n;
					y_p <= y_n;
					z_p <= z_n;
				end if;
		end case;
	end process;
		
end cordic_beh;


