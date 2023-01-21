LIBRARY ieee; 
USE ieee.std_logic_1164.all;
USE ieee.std_logic_unsigned.all;
USE ieee.numeric_std.all;

-- Author Raymond Fleming
-- Purpose: Perform audio compression on a live audio signal

ENTITY Compressor IS
	Port ( 		 Input	     : IN STD_LOGIC_VECTOR(23 downto 0);
			 AverageSig  : IN STD_LOGIC_VECTOR(23 downto 0);
			 MaxSig	     : IN STD_LOGIC_VECTOR(23 downto 0);
			 Output	     : OUT STD_LOGIC_VECTOR(23 downto 0));
			 
	End Compressor;
	
Architecture Behavior Of Compressor IS
SIGNAL InInt 	: Integer;
SIGNAL OutInt   : Integer;
SIGNAL MinInt   : Integer := -8388608;
SIGNAL MaxInt	: Integer := 8388607;
Signal Average	: Integer;
Signal Max	: Integer;


BEGIN


InInt<=to_integer(signed(Input));
Average<=to_integer(signed(AverageSig));
Max<=to_integer(signed(MaxSig));

--do nothing to signal when the average is below threshold, if it is above threshold then allow signal to go above threshold, but only half its initial value
--if threshold is 10, but signal is 20 then the compressor will output 15. However, if the signal is 5 and threshold is 10, it will output 5
OutInt<= (InInt + Average) when ((Max<(MaxInt-Average / 2) AND InInt>0)) else
			(InInt - Average) when ((Max>(MinInt+Average / 2) AND InInt<0)) else
			InInt;
Output<= std_logic_vector(to_signed(OutInt,24));

End Behavior;
		
