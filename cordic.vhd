library IEEE;
use IEEE.std_logic_1164.all;

function f_log2 (x : positive) return natural is
  variable i : natural;
begin
  i := 0;  
  while (2**i < x) and i < 31 loop
     i := i + 1;
  end loop;
  return i;
end function;

entity cordic is
	generic(Hbits : positive := 12; Kbits :positive := 12; N_iterations : positive := 8)
	port (
		den		: in std_ulogic_vector(Hbits-1 downto 0);
		num		: in std_ulogic_vector(Hbits-1 downto 0);
		clk 	: in std_ulogic;
		ris 	: out std_ulogic_vector(Kbits-1 downto 0);
		reset 	: in std_ulogic -- active high
	);
end cordic;


architecture cordic_beh of cordic is 
begin

	component xn_combinatorics is
		generic(Hbits : positive := 12; N_iterations : positive := 8);
		port(
			x_p 		: in std_ulogic_vector(Hbits-1 downto 0);
			y_p			: in std_ulogic_vector(Hbits-1 downto 0);
			iteration	: in std_ulogic_vector(f_log2(N_iterations)-1 downto 0);

			x_n		: out std_ulogic_vector(Hbits-1 downto 0)
		);
	end component;

	component yn_combinatorics is
		generic(Hbits : positive := 12; N_iterations : positive := 8);
		port(
			x_p 		: in std_ulogic_vector(Hbits-1 downto 0);
			y_p			: in std_ulogic_vector(Hbits-1 downto 0);
			iteration	: in std_ulogic_vector(f_log2(N_iterations)-1 downto 0);

			y_n		: out std_ulogic_vector(Hbits-1 downto 0)
		);
	end component;

	-- component zn_combinatorics
	-- component LUT_atan

	-- two possible states for the machine: waiting and computing
	type state_type IS (read_state, compute_state);
	
	-- p_state is present state, n_state is next state
	signal p_state, n_state : state_type;
	
	-- signals to keep temp values for computations
	signal x_p, x_n : std_ulogic_vector(Hbits-1 downto 0);
	signal y_p, y_n : std_ulogic_vector(Hbits-1 downto 0);
	signal z_p, z_n : std_ulogic_vector(Kbits-1 downto 0);
	signal iteration: std_ulogic_vector(f_log2(N_iterations)-1 downto 0);
	
	cordic_process: process(den,num,clk,reset,ris)
	begin
	-- combinatorics mapping
		i_xn_combinatorics : xn_combinatorics
			generic map(Hbits => Hbits; N_iterations => N_iterations)
			port map(
				x_p => x_p;
				y_p => y_p;
				iteration => iteration;
				x_n => x_n;
			);

		i_yn_combinatorics : yn_combinatorics
			generic map(Hbits => Hbits; N_iterations => N_iterations)
			port map(
				x_p => x_p;
				y_p => y_p;
				iteration => iteration;
				y_n => y_n;
			);

	-- reset and state update
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