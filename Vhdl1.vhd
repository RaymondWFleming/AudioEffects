LIBRARY ieee; 
USE ieee.std_logic_1164.all;
USE ieee.std_logic_unsigned.all;
USE ieee.numeric_std.all;

ENTITY SevSeg IS
	Port ( InCode	: IN STD_LOGIC_VECTOR(0 to 3);
			 OutCode : OUT STD_LOGIC_VECTOR(1 to 7));
			
			 
	End SevSeg;
	
Architecture Behavior Of SevSeg IS
BEGIN

OutCode    <=  "0000001" when InCode = X"0" else
				   "1001111" when InCode = X"1" else
				   "0010010" when InCode = X"2" else
				   "0000110" when InCode = X"3" else
				   "1001100" when InCode = X"4" else
				   "0100100" when InCode = X"5" else
				   "0100000" when InCode = X"6" else
				   "0001111" when InCode = X"7" else
				   "0000000" when InCode = X"8" else
				   "0001100" when InCode = X"9" else
				   "0001000" when InCode = X"A" else
				   "1100000" when InCode = X"B" else
				   "0110001" when InCode = X"C" else
				   "1000010" when InCode = X"D" else
				   "0110000" when InCode = X"E" else
				   "0111000" when InCode = X"F" ;
					
End Behavior;