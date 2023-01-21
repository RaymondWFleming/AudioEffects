LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.std_logic_signed.all;
USE ieee.numeric_std.all;

ENTITY part1 IS
   PORT ( CLOCK_50, CLOCK2_50, AUD_DACLRCK   : IN    STD_LOGIC;
          AUD_ADCLRCK, AUD_BCLK, AUD_ADCDAT  : IN    STD_LOGIC;
          KEY                                : IN    STD_LOGIC_VECTOR(0 DOWNTO 0);
          FPGA_I2C_SDAT                      : INOUT STD_LOGIC;
          FPGA_I2C_SCLK, AUD_DACDAT, AUD_XCK : OUT   STD_LOGIC;
			 
			 NumIn										: IN STD_LOGIC_VECTOR(9 downto 0);
			 
			 OutCode										: OUT STD_LOGIC_VECTOR(1 to 7);
			 countread									: out std_logic_vector(1 to 7);
			 countwrite									: out std_logic_vector(1 to 7);
			 LEDOut1										: OUT STD_LOGIC;
			 LEDOut2										: OUT STD_LOGIC;
			 LEDOut3										: OUT STD_LOGIC);

END part1;

ARCHITECTURE Behavior OF part1 IS
   COMPONENT clock_generator
      PORT( CLOCK_50 : IN STD_LOGIC;
            reset    : IN STD_LOGIC;
            AUD_XCK  : OUT STD_LOGIC);
   END COMPONENT;

   COMPONENT audio_and_video_config
      PORT( CLOCK_50, reset : IN    STD_LOGIC;
            I2C_SDAT        : INOUT STD_LOGIC;
            I2C_SCLK        : OUT   STD_LOGIC);
   END COMPONENT;   

   COMPONENT audio_codec
      PORT( CLOCK_50, reset, read_s, write_s               : IN  STD_LOGIC;
            writedata_left, writedata_right                : IN  STD_LOGIC_VECTOR(23 DOWNTO 0);
            AUD_ADCDAT, AUD_BCLK, AUD_ADCLRCK, AUD_DACLRCK : IN  STD_LOGIC;
            read_ready, write_ready                        : OUT STD_LOGIC;
            readdata_left, readdata_right                  : OUT STD_LOGIC_VECTOR(23 DOWNTO 0);
            AUD_DACDAT                                     : OUT STD_LOGIC);
   END COMPONENT;
	
	COMPONENT SevSegHex
	Port ( InCode	: IN STD_LOGIC_VECTOR(0 to 3);
			 OutCode : OUT STD_LOGIC_VECTOR(1 to 7));
			 
	End COMPONENT;
	
	COMPONENT Octaver IS
	Port ( Input		  : IN STD_LOGIC_VECTOR(23 downto 0);
			 NumIn		  : IN STD_LOGIC_VECTOR(9 downto 0);
			 Output		  : OUT STD_LOGIC_VECTOR(23 downto 0));
			 
	End COMPONENT;
	
	component Volume IS
	Port ( Input		  : IN STD_LOGIC_VECTOR(23 downto 0);
			 NumIn		  : IN STD_LOGIC_VECTOR(9 downto 0);

			 Output		  : OUT STD_LOGIC_VECTOR(23 downto 0));
			 
	End component;
	
	component overdrive IS
	Port ( Input		  : IN STD_LOGIC_VECTOR(23 downto 0);
			 NumIn		  : IN STD_LOGIC_VECTOR(9 downto 0);
			 Output		  : OUT STD_LOGIC_VECTOR(23 downto 0));
	End component;
	
	component Fuzz IS
	Port ( Input		  : IN STD_LOGIC_VECTOR(23 downto 0);
			 NumIn		  : IN STD_LOGIC_VECTOR(9 downto 0);
			 Output		  : OUT STD_LOGIC_VECTOR(23 downto 0));
	End component;
			 
	

   SIGNAL read_ready, write_ready, read_s, write_s : STD_LOGIC;
   SIGNAL readdata_left, readdata_right            : STD_LOGIC_VECTOR(23 DOWNTO 0);
   SIGNAL writedata_left, writedata_right          : STD_LOGIC_VECTOR(23 DOWNTO 0);   
   SIGNAL reset                                    : STD_LOGIC;

	signal count												: STD_LOGIC_VECTOR(31 downto 0);
	SIGNAL dataleft											: STD_LOGIC_VECTOR(23 downto 0) :=X"000000";
	SIGNAL dataright											: std_logic_vector(23 downto 0) :=X"000000";
	signal readcount											: std_logic_vector(31 downto 0);
	signal writecount											: std_logic_vector(31 downto 0);
	signal noiseremovedrght								   : std_logic_vector(23 downto 0);
	signal noiseremovedleft									: std_logic_vector(23 downto 0);
	signal driveleft											: std_logic_vector(23 downto 0);
	signal driveright											: std_logic_vector(23 downto 0);
	signal volumeright										: std_logic_vector(23 downto 0);
	signal volumeleft										   : std_logic_vector(23 downto 0);
	Signal OctaveLeft										   : std_logic_vector(23 downto 0);
	signal fuzzleft											: std_logic_vector(23 downto 0);
	signal volleft											   : std_logic_vector(23 downto 0);
	
	signal in1													: Integer;
	signal in2													: Integer;
	signal in3													: Integer;
	signal in4													: Integer;
	signal in5													: Integer;
	signal in6													: Integer;
	signal in7													: Integer;
	signal in8													: Integer;
	signal in9													: Integer;
	signal in10													: Integer;
	signal in11													: Integer;
	signal in12													: Integer;
	signal in13													: Integer;
	signal in14													: Integer;
	signal in15													: Integer;
	signal in16													: Integer;
	signal in17													: Integer;
	signal in18													: Integer;
	signal in19													: Integer;
	signal in20													: Integer;
	signal in21													: Integer;
	signal in22													: Integer;
	signal in23													: Integer;
	signal in24													: Integer;
	signal in25													: Integer;
	signal in26													: Integer;
	signal in27													: Integer;
	signal in28													: Integer;
	signal in29													: Integer;
	signal in30													: Integer;
	signal in31													: Integer;
	signal in32													: Integer;
	
	signal samplecount										: std_logic_vector (4 downto 0) := "00000";
	
	signal dataint														: Integer;
	
	
 
BEGIN
   reset <= NOT(KEY(0));
	read_s<='1';
	
	
	process(clock_50)
	begin
			if(write_ready='1') then
				case samplecount is 
					when "00000" => in1 <=to_integer(signed(readdata_left));
					when "00001" => in2 <=to_integer(signed(readdata_left));
					when "00010" => in3 <=to_integer(signed(readdata_left));
					when "00011" => in4 <=to_integer(signed(readdata_left));
					when "00100" => in5 <=to_integer(signed(readdata_left));
					when "00101" => in6 <=to_integer(signed(readdata_left));
					when "00110" => in7 <=to_integer(signed(readdata_left));
					when "00111" => in8 <=to_integer(signed(readdata_left));
					when "01000" => in9 <=to_integer(signed(readdata_left));
					when "01001" => in10 <=to_integer(signed(readdata_left));
					when "01010" => in11 <=to_integer(signed(readdata_left));
					when "01011" => in12 <=to_integer(signed(readdata_left));
					when "01100" => in13 <=to_integer(signed(readdata_left));
					when "01101" => in14 <=to_integer(signed(readdata_left));
					when "01110" => in15 <=to_integer(signed(readdata_left));
					when "01111" => in16 <=to_integer(signed(readdata_left));
					when "10000" => in17 <=to_integer(signed(readdata_left));
					when "10001" => in18 <=to_integer(signed(readdata_left));
					when "10010" => in19 <=to_integer(signed(readdata_left));
					when "10011" => in20 <=to_integer(signed(readdata_left));
					when "10100" => in21 <=to_integer(signed(readdata_left));
					when "10101" => in22 <=to_integer(signed(readdata_left));
					when "10110" => in23 <=to_integer(signed(readdata_left));
					when "10111" => in24 <=to_integer(signed(readdata_left));
					when "11000" => in25 <=to_integer(signed(readdata_left));
					when "11001" => in26 <=to_integer(signed(readdata_left));
					when "11010" => in27 <=to_integer(signed(readdata_left));
					when "11011" => in28 <=to_integer(signed(readdata_left));
					when "11100" => in29 <=to_integer(signed(readdata_left));
					when "11101" => in30 <=to_integer(signed(readdata_left));
					when "11110" => in31 <=to_integer(signed(readdata_left));
					when "11111" => in32 <=to_integer(signed(readdata_left));
				dataright<=readdata_right;
				readcount<=readcount+1;
				samplecount <= samplecount+1;
			end case;
			count<=count+1;
		   end if;
	end process;
	
	process (write_ready,clock_50)
	begin
		if (write_ready = '1') then
			write_s<='1';
			writecount<=writecount+1;
		else write_s<='0';
		end if;
	end process;
	
	dataint<=in1/32+in2/32+in3/32+in4/32+in5/32+in6/32+in7/32+in8/32+in9/32+in10/32+in11/32+in12/32+in13/32+in14/32+in15/32+in16/32+in17/32+in18/32+in19/32+in20/32+in21/32+in22/32+in23/32+in24/32+in25/32+in26/32+in27/32+in28/32+in29/32+in30/32+in31/32+in32/32;
	
	dataleft<=std_logic_vector(to_signed(dataint,24));
	writedata_left <=Octaveleft;
	writedata_right<=Octaveleft;


	
   vol 	: volume PORT MAP (dataleft, NumIn,VolLeft);       -- 3
	
	drvlft  : overdrive PORT MAP (Volleft, NumIn,driveleft); -- 0
	
	fuzzlft:fuzz PORT MAP (driveleft, NumIn, FuzzLeft);      -- 1
	
	Octave  : Octaver PORT MAP (Fuzzleft,NumIn, OctaveLeft); -- 2
	
	
   my_clock_gen: clock_generator PORT MAP (CLOCK_50, reset, AUD_XCK);
   cfg: audio_and_video_config PORT MAP (CLOCK_50, reset, FPGA_I2C_SDAT, FPGA_I2C_SCLK);
   codec: audio_codec PORT MAP (CLOCK_50, reset, read_s, write_s, writedata_left, 
	                             writedata_right, AUD_ADCDAT, AUD_BCLK, AUD_ADCLRCK,
										  AUD_DACLRCK, read_ready, write_ready, readdata_left, 
										  readdata_right, AUD_DACDAT);
END Behavior;
