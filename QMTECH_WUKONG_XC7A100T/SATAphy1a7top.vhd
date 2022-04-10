----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    07:25:36 04/08/2022 
-- Design Name: 
-- Module Name:    SATAphy1a7top - Behavioral 
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

entity SATAphy1a7top is
port(
   clkg : in STD_LOGIC;  --System Clk
   SATACLK_QO_N : in std_logic;
   SATACLK_QO_P : in std_logic;
   LEDS : out STD_LOGIC_VECTOR(1 DOWNTO 0);
   KEY  : in  STD_LOGIC;
	LED : out std_logic_vector(7 downto 0)
	);
end SATAphy1a7top;

architecture Behavioral of SATAphy1a7top is

  signal tied_to_ground_i: std_logic;
  signal clk_150mhz_s: std_logic;
  signal clk_75mhz_s: std_logic;
  signal gtx_refclk: std_logic;
  signal gtx_refclk_div2: std_logic;
  signal clk_res: std_logic;
--  signal clk_sel: std_logic;

  SIGNAL clk1, CLK2 : std_logic;                                       

begin
    tied_to_ground_i <= '0';
	 LEDS <= KEY&clkg;
--	 clk_sel <= not KEY;

--    tile0_refclk_ibufds_i : IBUFDS
--    port map
--    (
--        O => clk_150mhz_s,
--        I => SATACLK_QO_P,  -- Connect to package pin F6
--        IB => SATACLK_QO_N  -- Connect to package pin F5
--    );

    gtx_refclk_ibufds_i : IBUFDS_GTE2
    port map
    (
        O => gtx_refclk,
        ODIV2 => gtx_refclk_div2,
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
    gtx_refclkdiv2_bufg_i : BUFG
    port map
    (
        I => gtx_refclk_div2,
        O => clk_75mhz_s
    );

--BufGMux_l : BUFGMUX
--    port map
--    (
--        O       => clk_res,
--        I0      => gtx_refclk,
--        I1      => gtx_refclk_div2,
--        S       => clk_sel
--    );
--BufGCtrlMux_l : BUFGCTRL
--  generic map (
--    INIT_OUT     => 0,
--    PRESELECT_I0 => FALSE,
--    PRESELECT_I1 => FALSE)
--  port map (
--    O       => clk_res,
--    CE0     => not clk_sel,
--    CE1     => clk_sel,
--    I0      => clk_150mhz_s,
--    I1      => clk_75mhz_s,
--    IGNORE0 => '0',
--    IGNORE1 => '0',
--    S0      => '1', -- Clock select0 input
--    S1      => '1' -- Clock select1 input
--  );

--p_mux : process (clk_75mhz_s, clk_150mhz_s, clk_sel)
--begin
--  case clk_sel is
--    when '0' => clk_res <= clk_75mhz_s;
--	 when '1' => clk_res <= clk_150mhz_s;
--	 when others => clk_res <= clk_75mhz_s;
--  end case;
--end process p_mux;

clk_res <= clk_75mhz_s;

P1:PROCESS(clk_res)
VARIABLE count:INTEGER RANGE 0 TO 9999999;
BEGIN                                                                
    IF clk_res'EVENT AND clk_res='1' THEN
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
			WHEN 0 => LED <= "11111110";                      --
			WHEN 1 => LED <= "11111101";                      -- 
			WHEN 2 => LED <= "11111011";                      --
			WHEN 3 => LED <= "11110111";                 	  --
			WHEN 4 => LED <= "11101111";                  	  --
			WHEN 5 => LED <= "11011111";                  	  --
			WHEN 6 => LED <= "10111111";                  	  --
			WHEN 7 => LED <= "01111111";                  	  --
			WHEN 8 => LED <= "11111111";
			WHEN OTHERS=> LED <= "11111111";              
      END CASE;
      count1 := count1 + 1;
    end if;
end if;
end process;                              


end Behavioral;

