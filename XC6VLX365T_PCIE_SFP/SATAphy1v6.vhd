----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    10:02:50 04/07/2022 
-- Design Name: 
-- Module Name:    SATAphy1v6 - Behavioral 
-- Project Name: 
-- Target Devices: 
-- Tool versions: 
-- Description: 
--
-- Dependencies: 
--
-- Revision: 
-- Revision 0.01 - File Created
-- Additional Comments: 
--
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

library UNISIM;
use UNISIM.VComponents.all;

entity SATAphy1v6 is
port(
--	clk : in std_logic;
   SATACLK_QO_N : in std_logic;
   SATACLK_QO_P : in std_logic;
	led : out std_logic_vector(7 downto 0)
	);
end SATAphy1v6;

architecture Behavioral of SATAphy1v6 is

  signal tied_to_ground_i: std_logic;
  signal clk_150mhz_s: std_logic;
  signal gtx_refclk: std_logic;

  SIGNAL clk1, CLK2 : std_logic;                                       


begin
    tied_to_ground_i <= '0';
    -- Generate clock from clock differential pair.
--    tile0_refclk_ibufds_i : IBUFDS
--    port map
--    (
--        O => clk_150mhz_s,
--        I => SATACLK_QO_P,  -- Connect to package pin F6
--        IB => SATACLK_QO_N  -- Connect to package pin F5
--    );

    gtx_refclk_ibufds_i : IBUFDS_GTXE1 
    port map
    (
        O => gtx_refclk,
        ODIV2 => open,
        CEB => tied_to_ground_i,
        I => SATACLK_QO_P,  -- Connect to package pin F6
        IB => SATACLK_QO_N  -- Connect to package pin F5
    );

 
    gtx_refclk_bufg_i : BUFG
    port map
    (
        I => gtx_refclk,
        O => clk_150mhz_s
    );


P1:PROCESS(clk_150mhz_s)
VARIABLE count:INTEGER RANGE 0 TO 9999999;
BEGIN                                                                
    IF clk_150mhz_s'EVENT AND clk_150mhz_s='1' THEN
       IF count<=4999999 THEN                           
          clk1 <= '0';
          count := count + 1;                          
        ELSIF count >= 4999999 AND count <= 9999999 THEN
          clk1 <= '1';
          count := count + 1;
        ELSE 
		    count := 0;
        END IF;                                                      
     END IF;                                          
END PROCESS;

P3:PROCESS(CLK1)   
begin
    IF clk1'event AND clk1='1' THEN  
       clk2 <= not clk2;
    END IF; 
END PROCESS P3;     

P2:PROCESS(clk2)                                              
variable count1:INTEGER RANGE 0 TO 16;
BEGIN
IF clk2'event AND clk2='1' THEN
   if count1 <= 9 then
      if count1 = 9 then
         count1 := 0;
      end if;
      CASE count1 IS
			WHEN 0 => led <= "11111110";                      --
			WHEN 1 => led <= "11111101";                      -- 
			WHEN 2 => led <= "11111011";                      --
			WHEN 3 => led <= "11101111";                 	  --
			WHEN 4 => led <= "11110111";                  	  --
			WHEN 5 => led <= "11011111";                  	  --
			WHEN 6 => led <= "10111111";                  	  --
			WHEN 7 => led <= "01111111";                  	  --
			WHEN 8 => led <= "11111111";
			WHEN OTHERS=> led <= "11111111";              
      END CASE;
      count1 := count1 + 1;
    end if;
end if;
end process;                              


end Behavioral;

