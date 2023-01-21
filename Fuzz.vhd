LIBRARY ieee; 
USE ieee.std_logic_1164.all;
USE ieee.std_logic_unsigned.all;
USE ieee.numeric_std.all;

ENTITY Fuzz IS
	Port ( Input		  : IN STD_LOGIC_VECTOR(23 downto 0);
			 NumIn		  : IN STD_LOGIC_VECTOR(9 downto 0);
			 Output		  : OUT STD_LOGIC_VECTOR(23 downto 0));
	End Fuzz;
	
Architecture Behavior Of Fuzz IS
SIGNAL InInt 			  : Integer;
SIGNAL OutInt			  : Integer;
SIGNAL MinInt			  : Integer := -8388608;
SIGNAL MaxInt			  : Integer := 8388607;
signal cutoffpos       : Integer := 2917504;
signal cutoffneg		  : Integer := -2917504;


BEGIN


InInt<=to_integer(signed(Input));

OutInt<= cutoffpos when InInt>cutoffpos AND NumIn(1)='1'else
			InInt when InInt>0 AND NumIn(1)='1'else
			0 when InInt = 0 AND NumIn(1)='1'else
			InInt when InInt>cutoffneg AND NumIn(1)='1'else
			cutoffneg when InInt<cutoffneg AND NumIn(1)='1' else
			InInt;


Output<= std_logic_vector(to_signed((OutInt),24));

End Behavior;
		