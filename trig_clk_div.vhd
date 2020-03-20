LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.all;
USE IEEE.STD_LOGIC_UNSIGNED.ALL;

ENTITY trig_clk_div IS
PORT(inClk :in std_logic ;
		outClk :out std_logic);
END trig_clk_div;

ARCHITECTURE behave OF trig_clk_div IS 
SIGNAL count :INTEGER:=0;
signal clko:std_logic:='0';
begin
PROCESS
BEGIN

WAIT UNTIL inClk='1';

if(count=2499999) THEN
clko<=not clko; count<=0;
ELSE
count<=count+1;
END IF;

END PROCESS;
outClk<=clko;

END behave;