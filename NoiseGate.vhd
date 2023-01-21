LIBRARY ieee; 
USE ieee.std_logic_1164.all;
USE ieee.std_logic_unsigned.all;
USE ieee.numeric_std.all;

ENTITY NoiseGate IS
	Port ( Input		  : IN STD_LOGIC_VECTOR(23 downto 0);


			 Output		  : OUT STD_LOGIC_VECTOR(23 downto 0));
			 
	End NoiseGate;
	
Architecture Behavior Of NoiseGate IS
SIGNAL InInt 			  : Integer;
SIGNAL OutInt			  : Integer;
SIGNAL MinInt			  : Integer := -8388608;
SIGNAL MaxInt			  : Integer :=  8388607;

SIGNAL GateHi			  : Integer :=  250000;
SIGNAL GateLo			  : Integer := -25000;



BEGIN


InInt<=to_integer(signed(Input));

OutInt<=InInt when (InInt>GateHi OR InInt < GateLo) else 0;

Output<= std_logic_vector(to_signed(OutInt,24));

End Behavior;
		