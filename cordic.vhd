library IEEE;
use IEEE.std_logic_1164.all;

library cordic;
use cordic.util.all;

entity cordic is
	generic(Hbits : positive := 12; Kbits :positive := 12; N_iterations : positive := 8);
	port (
		den		: in std_ulogic_vector(Hbits-1 downto 0);
		num		: in std_ulogic_vector(Hbits-1 downto 0);
		clk 	: in std_ulogic;
		ris 	: out std_ulogic_vector(Kbits-1 downto 0);
		reset 	: in std_ulogic -- active high
	);
end cordic;


architecture cordic_beh of cordic is 
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

	component zn_combinatorics
		generic(Kbits : positive := 12; N_iterations : positive := 8);
		port(
			z_p : in std_ulogic_vector(Kbits-1 downto 0);
			iteration : in std_ulogic_vector(f_log2(N_iterations)-1 downto 0);
			sign_y_p : in std_ulogic;

			z_n : out std_ulogic_vector(Kbits-1 downto 0)
		);
	end component;

	-- two possible states for the machine: waiting and computing
	type state_type IS (read_state, compute_state);
	
	-- p_state is present state, n_state is next state
	signal p_state, n_state : state_type;
	
	-- signals to keep temp values for computations
	signal x_p, x_n : std_ulogic_vector(Hbits-1 downto 0);
	signal y_p, y_n : std_ulogic_vector(Hbits-1 downto 0);
	signal z_p, z_n : std_ulogic_vector(Kbits-1 downto 0);
	signal iteration: std_ulogic_vector(f_log2(N_iterations)-1 downto 0);
	
	signal to_ris : std_ulogic_vector(Kbits-1 downto 0);

begin
	ris <= to_ris;

	-- combinatorics mapping
		i_xn_combinatorics : xn_combinatorics
			generic map(Hbits => Hbits, N_iterations => N_iterations)
			port map(
				x_p => x_p,
				y_p => y_p,
				iteration => iteration,
				x_n => x_n
			);

		i_yn_combinatorics : yn_combinatorics
			generic map(Hbits => Hbits, N_iterations => N_iterations)
			port map(
				x_p => x_p,
				y_p => y_p,
				iteration => iteration,
				y_n => y_n
			);

		i_zn_combinatorics : zn_combinatorics
			generic map(Kbits => Kbits, N_iterations => N_iterations)
			port map(
				z_p => z_p,
				iteration => iteration,
				sign_y_p => y_p(Hbits-1),
				z_n => z_n
			);

	cordic_process: process(den,num,clk,reset,to_ris)
	begin
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
				to_ris <= z_p;
				iteration <= (others => '0');
				n_state <= compute_state;
			when compute_state =>
				if( iteration = "111") then -- computation complete
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