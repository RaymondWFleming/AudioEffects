LIBRARY ieee; 
USE ieee.std_logic_1164.all;
USE ieee.std_logic_unsigned.all;
USE ieee.numeric_std.all;

--Author: Raymond Fleming
--Purpose: Soft clipping of input signal for an overdrive effect

ENTITY Overdrive IS
	Port ( Input  : IN STD_LOGIC_VECTOR(23 downto 0);
	       NumIn  : IN STD_LOGIC_VECTOR(9 downto 0);
	       Output : OUT STD_LOGIC_VECTOR(23 downto 0));
			 
	End Overdrive;
	
Architecture Behavior Of Overdrive IS
SIGNAL InInt 	 : Integer;
SIGNAL OutInt	 : Integer;
SIGNAL MinInt	 : Integer := -8388608;
SIGNAL MaxInt	 : Integer := 8388607;
SIGNAL cutoffpos : Integer := 5000000;
SIGNAL cutoffneg : Integer := -5000000;
signal maxoutpos : Integer := 8000000;
signal maxoutneg : Integer := -8000000;



BEGIN


InInt<=to_integer(signed(Input));


--Soft clipping effect.  If above max output, output max output.
--If between cutoff and max, output average of input signal and cutoff.
--If below cutoff, output input signal

OutInt<= maxoutpos when InInt > maxoutpos else

	 cutoffpos+(InInt-cutoffpos)/2 when InInt > cutoffpos AND NumIn(0)='1' else
			
	 InInt when InInt > 0 AND NumIn(0)='1' else
			
	 0 when InInt = 0 AND NumIn(0)='1' else
			
	 InInt when InInt < cutoffneg AND NumIn(0)='1' else
	
	 cutoffneg+(InInt-cutoffneg)/2 when InInt < cutoffneg AND NumIn(0)='1' else
			
	 maxoutneg when InInt<maxoutneg AND NumIn(0)='1' else
		 
	 InInt;


Output<= std_logic_vector(to_signed(OutInt,24));

End Behavior;
		
