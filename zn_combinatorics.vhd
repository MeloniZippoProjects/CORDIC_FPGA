library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;
use IEEE.math_real.all;

library cordic;
use cordic.util.all;

entity zn_combinatorics is
	-- Kbits -> number of bits to represent z_in and z_out
	-- N_iterations -> max number of shifts necessary
	generic(Kbits : positive := 12; N_iterations : positive := 8);
	port(
		z_p : in std_ulogic_vector(Kbits-1 downto 0);
		iteration : in std_ulogic_vector(f_log2(N_iterations)-1 downto 0);
		sign_y_p : in std_ulogic;

		z_n : out std_ulogic_vector(Kbits-1 downto 0)
	);
end zn_combinatorics;

architecture zn_combinatorics_struct of zn_combinatorics is

	component Atan_LUT is
		generic(Kbits : positive := 12; N_iterations : positive := 8);
		port(
			iteration : in std_ulogic_vector(f_log2(N_iterations)-1 downto 0);
			atan : out std_ulogic_vector(Kbits-1 downto 0)
		);
	end component;

	signal atan : std_ulogic_vector(Kbits-1 downto 0);
	signal atan_to_add : std_ulogic_vector(Kbits-1 downto 0);

begin
	i_atan_lut : Atan_LUT
		generic map(Kbits => Kbits, N_iterations => N_iterations)
		port map(iteration => iteration, atan => atan);
	
	atan_to_add <= std_ulogic_vector(0 - signed(atan)) when sign_y_p = '1'
		else atan;

	z_n <= std_ulogic_vector(signed(z_p) + signed(atan_to_add));
end zn_combinatorics_struct;