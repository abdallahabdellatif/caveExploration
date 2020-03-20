library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity DSDProject1 is
    Port ( clk        : in  STD_LOGIC;
           sonar_trig : out STD_LOGIC;
           sonar_echo : in  STD_LOGIC;
			  reset: in std_logic;
			  btn: in std_logic;
			  ldrin:in std_logic;
			  led :out std_logic;
			  output1: out std_logic;
			  output2: out std_logic;
           segments   : out STD_LOGIC_VECTOR (6 downto 0);
			  segments2   : out STD_LOGIC_VECTOR (6 downto 0);
			  ldrout: out std_logic);
end DSDProject1;

architecture Behavioral of DSDProject1 is
    signal count            : unsigned(16 downto 0) := (others => '0');
    signal centimeters      : unsigned(15 downto 0) := (others => '0');
    signal centimeters_ones : unsigned(3 downto 0)  := (others => '0');
    signal centimeters_tens : unsigned(3 downto 0)  := (others => '0');
    signal output_ones      : unsigned(3 downto 0)  := (others => '0');
    signal output_tens      : unsigned(3 downto 0)  := (others => '0');
    signal digit            : unsigned(3 downto 0)  := (others => '0');
    signal echo_last        : std_logic := '0';
    signal echo_synced      : std_logic := '0';
    signal echo_unsynced    : std_logic := '0';
    signal waiting          : std_logic := '0'; 
    signal seven_seg_count  : unsigned(15 downto 0) := (others => '0');
	 SIGNAL digit2 : unsigned(3 downto 0)  := (others => '0');
	 signal c1,c2,ct: integer:=0;
	 signal newClk:std_logic;
	 signal o1,o2:std_logic:='0';
	 TYPE statetype is (down,up,stillD,stillU);
	 signal currentstate:statetype:=stillD;
	 signal nextstate:statetype:=stillD;
	 
	 Component trig_clk_div IS
	 port(inClk:in std_logic;outClk:out std_logic);
	 end component;
begin
ldrout<='1';

decode: process(digit)
    begin
        case digit is 
           when "0001" => segments <= "1111001";c1<=1;
           when "0010" => segments <= "0100100";c1<=2;
           when "0011" => segments <= "0110000";c1<=3;
           when "0100" => segments <= "0011001";c1<=4;
           when "0101" => segments <= "0010010";c1<=5;
           when "0110" => segments <= "0000010";c1<=6;
           when "0111" => segments <= "1111000";c1<=7;
           when "1000" => segments <= "0000000";c1<=8;
           when "1001" => segments <= "0010000";c1<=9;
           when others => segments <= "1000000";c1<=0;
        end case;
    end process;
decode2: process(digit2)
    begin
        case digit2 is 
           when "0001" => segments2 <= "1111001";c2<=1;
           when "0010" => segments2 <= "0100100";c2<=2;
           when "0011" => segments2 <= "0110000";c2<=3;
           when "0100" => segments2 <= "0011001";c2<=4;
           when "0101" => segments2 <= "0010010";c2<=5;
           when "0110" => segments2 <= "0000010";c2<=6;
           when "0111" => segments2 <= "1111000";c2<=7;
           when "1000" => segments2 <= "0000000";c2<=8;
           when "1001" => segments2 <= "0010000";c2<=9;
           when others => segments2 <= "1000000";c2<=0;
        end case;
    end process;

seven_seg: process(clk)
    begin
        if rising_edge(clk) then
            if seven_seg_count(seven_seg_count'high) = '1' then
                digit <= output_ones;
            else
                digit2 <= output_tens;
            end if;        
            seven_seg_count <= seven_seg_count +1; 
        end if;
    end process;
    
process(clk)
    begin
        if rising_edge(clk) then
            if waiting = '0' then
                if count = 500 then
                   sonar_trig <= '0';
                   waiting    <= '1';
                   count       <= (others => '0');
                else
                   sonar_trig <= '1';
                   count <= count+1;
                end if;
            elsif echo_last = '0' and echo_synced = '1' then
                count       <= (others => '0');
                centimeters <= (others => '0');
                centimeters_ones <= (others => '0');
                centimeters_tens <= (others => '0');
            elsif echo_last = '1' and echo_synced = '0' then
                output_ones <= centimeters_ones; 
                output_tens <= centimeters_tens; 
            elsif count = 2900 -1 then
                if centimeters_ones = 9 then
                    centimeters_ones <= (others => '0');
                    centimeters_tens <= centimeters_tens + 1;
                else
                    centimeters_ones <= centimeters_ones + 1;
                end if;
                centimeters <= centimeters + 1;
                count <= (others => '0');
                if centimeters = 3448 then
                    waiting <= '0';
                end if;
            else
                count <= count + 1;                
            end if;

            echo_last     <= echo_synced;
            echo_synced   <= echo_unsynced;
            echo_unsynced <= sonar_echo;
        end if;
		  end process;
		  
		  
		  ct<=(c2*10)+c1;
		  
		  motor2:process(currentstate,btn,ct)
		  begin
	      CASE currentstate IS
			WHEN stillD => o1<='0';o2<='0';
				IF (btn='1') then nextstate<=down;end if;
			when down=> o1<='0';o2<='1';
					  if(btn='1' and ct>=45) then nextstate<=up;
				elsif(btn='0' and ct<45) then nextstate<=stillD;end if;
			when up => o1<='1';o2<='0';
			     if(btn='1' and ct<=10) then nextstate<=stillU;
					elsif(btn='0' and ct>10) then nextstate<=stillU;end if;
			when stillU => o1<='0';o2<='0';
			      if(ct<=10) then nextstate<=stillD;
					elsif(btn='1' and ct>10) then nextstate<=up;end if;
			end case;

		  end process;
		  
		  clkconvert: trig_clk_div port map(clk,newClk);
		  proc: process(newClk)
		  begin
		  if(newClk'event) and (newClk='1') then currentstate<=nextstate;
		  end if;
		  end process;
		  
		  ldr: process(ldrin,newclk)
		  begin
		  if(newclk'EVENT and newclk = '1')
		  then
			if(ldrin='1' or ldrin='H')then led<='0';
			else led<='1';end if;
		  end if;
		  end process;
		  
		  output1<=o1;
		  output2<=o2;
        

end Behavioral;