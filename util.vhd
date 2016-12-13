package util is
	function f_log2 (x : in positive) return natural;
end package;

package body util is
	function f_log2 (x : in positive) return natural is
	  variable i : natural;
	begin
	  i := 0;  
	  while (2**i < x) and i < 31 loop
	     i := i + 1;
	  end loop;
	  return i;
	end f_log2;
end package body;