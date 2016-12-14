library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

library cordic;
use cordic.util.all;

-- External interface of the device. Exposes input and output connection, together with clock and reset pins.
-- Registries update at positive front of the clock, the reset is asynchronous and active high

-- All the network components are generics with configurable bit resolutions:
	-- Hbits -> bit resolution of inputs, interpreted as signed integers in 2 complement
	-- Kbits -> bit resolution of output, to be interpreted as a signed fixed point real number, with 1 bit for sign, 1 for integer part and Kbits-2 fractional bits
	-- N_iterations -> number of iterations of the CORDIC algorithm to execute. The bit resoulution to store it is computed with f_log2 from cordic.util
-- Combinatoric networks internally use 2 bits more for inputs, to prevent overflow errors. 

-- To reduce computation errors due to truncation, inputs should be the biggest numbers representable with the defined resolution that give the desired ratio
-- As an example, to compute arctan(1/2) with 8 bits input resolution num: 0010 0000 and den: 0100 0000 are the best suited inputs

entity cordic_atan is
	generic(Hbits : positive := 12; Kbits :positive := 12; N_iterations : positive := 8);
	port (
		den		: in std_ulogic_vector(Hbits-1 downto 0);
		num		: in std_ulogic_vector(Hbits-1 downto 0);
		ris 	: out std_ulogic_vector(Kbits-1 downto 0);

		clk 	: in std_ulogic;
		reset 	: in std_ulogic
	);
end cordic_atan;

architecture cordic_beh of cordic_atan is 
	-- Combinatorics components
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

	-- Three possible states for the machine: reading inputs for a new computation, computing, writing the outputs
		type state_type IS (read_state, compute_state, write_state);
	
	-- state is the synchronous network status
		signal state : state_type;
	
	-- signals to store values for computations
	-- p ones are registries, while n ones are the next values computed by combinatorics networks
		signal x_p, x_n : std_ulogic_vector(Hbits+1 downto 0);
		signal y_p, y_n : std_ulogic_vector(Hbits+1 downto 0);
		signal z_p, z_n : std_ulogic_vector(Kbits-1 downto 0);
	
	-- registry to keep track of the step of the ongoing computation
		signal iteration: std_ulogic_vector(f_log2(N_iterations)-1 downto 0);
	
	-- registry to hold the last computed output
		signal to_ris : std_ulogic_vector(Kbits-1 downto 0);

begin

	-- Mappings
		ris <= to_ris;

		i_xn_combinatorics : xn_combinatorics
			generic map(Hbits => Hbits+2, N_iterations => N_iterations)
			port map(
				x_p => x_p,
				y_p => y_p,
				iteration => iteration,
				x_n => x_n
			);

		i_yn_combinatorics : yn_combinatorics
			generic map(Hbits => Hbits+2, N_iterations => N_iterations)
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


	-- Synchronous network description

		cordic_process: process(den,num,clk,reset,to_ris)
		begin
			if( reset = '1' ) then
				-- Reset values
				state <= read_state;
				to_ris <= (others => '0');
			elsif (clk'event and clk = '1') then
				-- State processing to determine the registries' next value
				case state is

					when read_state =>
						-- Inputs are collected and sign changed to the desired format (x positive, y either negative or positive)
						-- State registries for the computation are reset
						if(signed(den) < 0) then
							y_p <= std_ulogic_vector(resize(-signed(num), Hbits+2));
							x_p <= std_ulogic_vector(resize(-signed(den), Hbits+2));
						else
							y_p <= std_ulogic_vector(resize(signed(num), Hbits +2));
							x_p <= std_ulogic_vector(resize(signed(den), Hbits +2));
						end if;

						z_p <= (others => '0');
						iteration <= (others => '0');
						state <= compute_state;

					when compute_state =>
						-- Registries are updated with the next values coming from the combinatorics networks	
							x_p <= x_n;
							y_p <= y_n;
							z_p <= z_n;

						-- At the last iteration, the write state is set as next state. Otherwise, continue the computation and increase the step
							if( unsigned(iteration) = N_iterations-1) then
								state <= write_state; 
							else
								iteration <= std_ulogic_vector(unsigned(iteration) + 1);
							end if;

					when write_state =>
						-- The computed result is set as new output and the device prepares to read new inputs
							to_ris <= z_p;
							state <= read_state;

				end case;
			end if;
		end process;
		
end cordic_beh;