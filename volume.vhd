LIBRARY ieee; 
USE ieee.std_logic_1164.all;
USE ieee.std_logic_unsigned.all;
USE ieee.numeric_std.all;

--Author: Raymond Fleming
--Purpose: Adjust volume of incoming audio signal

ENTITY Volume IS
	Port ( Input  : IN STD_LOGIC_VECTOR(23 downto 0);

	       NumIn  : IN STD_LOGIC_VECTOR(9 downto 0);
	       Output : OUT STD_LOGIC_VECTOR(23 downto 0));
			 
	End Volume;
	
Architecture Behavior Of Volume IS
SIGNAL InInt  : Integer;
SIGNAL OutInt : Integer;
SIGNAL MinInt : Integer := -8388608;
SIGNAL MaxInt : Integer :=  8388607;
signal volint : Integer;
SIGNAL GateHi : Integer :=  1500000;
SIGNAL GateLo : Integer := -1500000;
signal numint : Integer;


BEGIN

InInt<=to_integer(signed(Input));
volint<=to_integer(unsigned(NumIn(9 downto 4)&'1'));

--Take binary input from switches and output adjusted signal based on switch value
OutInt<=InInt*volint when InInt>0 AND NumIn(3)='1' else
		  InInt*volInt when InInt<0 AND NumIn(3)='1' else
		  InInt when InInt = 0 AND NumIn(3)='1' else
		  InInt;
		  
Output<= std_logic_vector(to_signed((OutInt),24));

End Behavior;
		
