LIBRARY ieee; 
USE ieee.std_logic_1164.all;
USE ieee.std_logic_unsigned.all;
USE ieee.numeric_std.all;

ENTITY Octaver IS
	Port ( Input		  : IN STD_LOGIC_VECTOR(23 downto 0);
			 NumIn		  : IN STD_LOGIC_VECTOR(9 downto 0);

			 Output		  : OUT STD_LOGIC_VECTOR(23 downto 0));
			 
	End Octaver;
	
Architecture Behavior Of Octaver IS
SIGNAL InInt 			  : Integer;
SIGNAL OctInt			  : Integer;
SIGNAL OutInt			  : Integer;
SIGNAL MinInt			  : Integer := -8388608;
SIGNAL MaxInt			  : Integer :=  8388607;

SIGNAL GateHi			  : Integer :=  250000;
SIGNAL GateLo			  : Integer := -25000;



BEGIN


InInt<=to_integer(signed(Input));

OctInt<=(InInt) when (InInt>0)else 
		   0 when InInt = 0 else
			-(InInt) when (InInt<0);
			


OutInt<=(OctInt+InInt)/2 when NumIn(2)='1' else InInt;

Output<= std_logic_vector(to_signed(OutInt,24));

End Behavior;
		